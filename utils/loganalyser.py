#!/usr/bin/env python2.6

from pprint import pprint
import re
import sys
from collections import defaultdict
from operator import itemgetter

def field_map(dictseq, name, func):
    for d in dictseq:
        d[name] = func(d[name])
        yield d

# 
# Reports
#

class TableReport(object):

    excluded_keys = ()
    order_by = None

    def __init__(self, data):
        self._data = data
        self._nrows = 30

    def fmt(self, x, n=10):
        if isinstance(x, (float, )):
            return ('%%%d.4f' % n) % x
        if isinstance(x, (int, long)):
            return ('%%%dd' % n) % x
        else:
            return ('%%-%ds' % n) % str(x)[:n]

    def toString(self):
        header_set = False
        buffer = ['*** %s (%d rows) ***' % (self.__class__.__name__, self._nrows)]
        if len(self._data) == 0:
            buffer.append('Nothing to report.')
        else:
            keys = sorted([k for k in self._data.itervalues().next().keys() if k not in self.excluded_keys])
            if not header_set:
                header = ' | '.join([self.fmt('action', 30)] + map(self.fmt, keys))
                buffer.append(header)
                buffer.append('-' * len(header))
                header_set = True

            if self.order_by:
                if self.order_by[0] == 'action':
                    key = lambda x: x
                else:
                    key=lambda k: self._data[k][self.order_by[0]]
                sorted_keys = sorted(self._data.iterkeys(), key=key, reverse=self.order_by[1])
            else:
                sorted_keys = self._data.iterkeys()

            for key in sorted_keys[:self._nrows]:
                item = self._data[key]
                values = (item[k] for k in keys if k not in self.excluded_keys)
                msg = ' | '.join([self.fmt(key, 30)] + map(self.fmt, values))
                buffer.append(msg)

        return '\n'.join(buffer)
    
class ErrorReport(TableReport):

    excluded_keys = ()

    order_by = ('action', False)

class RequestReport(TableReport):

    excluded_keys = (
            'max_time_token', 'min_time_token',
            )

    order_by = ('tot_time', True)

class QueryReport(TableReport):

    excluded_keys = (
            'max_cputime_token', 'max_walltime_token', 
            'min_cputime', 'min_walltime',
            'max_cputime', 'avg_cputime', 'tot_cputime',
            )

    order_by = ('tot_walltime', True)

class MemcachedReport(TableReport):

    excluded_keys = ()

    order_by = ('count', True)

# 
# Analysers
#

class Analyser(object):
    """Base class."""

    line_re = re.compile('')
    line_cols = ()

    def __init__(self, stream):
        self._pipeline = self.getPipeline(stream)

    def getPipeline(self, stream):
        raise NotImplementedError('base class')

    def analyse(self):
        raise NotImplementedError('base class')

class ErrorAnalyser(Analyser):
    """Analyse log entries like:
    2011-03-17 12:08:48,020 INFO       [root ] MEMCACHE: GET_412af704425380e4ea57aec0c0ee31c5 FOUND
    """

    ReportType = ErrorReport
    line_re = re.compile('^(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2},\d{3}) (\w+)\ +\[.+\] (.+)')
    line_cols = ('date', 'loglevel', 'msg')

    def getPipeline(self, stream):
        groups = (self.line_re.match(line) for line in stream)
        data = (dict(zip(self.line_cols, g.groups())) for g in groups if g)
        return data

    def analyse(self):

        default_item = {
                'count': 0,
                }

        data = defaultdict(lambda: default_item.copy())

        for token in self._pipeline:
            item = data[token['loglevel']]
            item['count'] += 1

        return self.ReportType(dict(data))

class RequestAnalyser(Analyser):
    """Analyse log entries like:
    2011-03-17 12:40:33,126 INFO       [root ] 304 GET /searchDeals?name=petsmart&label=clearance&n=2 (127.0.0.1) 15.03ms
    """

    ReportType = RequestReport
    line_re = re.compile('^(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2},\d{3}).*\[.+\] (\d{3}) (\w+) (.+) \(([0-9\.]+)\) (.+)ms$')
    line_cols = ('date', 'code', 'type', 'url', 'ip', 'time')

    def getPipeline(self, stream):
        groups = (self.line_re.match(line) for line in stream)
        data = (dict(zip(self.line_cols, g.groups())) for g in groups if g)
        data = field_map(data, 'code', int)
        data = field_map(data, 'time', lambda x: float(x) / 1000) # millisecs to secs
        return data

    def analyse(self):

        default_item = {
                'count': 0,
                'tot_time': 0,
                'max_time': -999999,
                'min_time':  999999,
                }

        data = defaultdict(lambda: default_item.copy())

        for token in self._pipeline:
            item = data[token['url']]

            item['count'] += 1
            item['tot_time'] += token['time']
            
            if token['time'] > item['max_time']:
                item['max_time'] = token['time']
                item['max_time_token'] = token

            if token['time'] < item['min_time']:
                item['min_time'] = token['time']
                item['min_time_token'] = token

        tot_time = sum(map(itemgetter('tot_time'), data.itervalues()))

        for item in data.itervalues():
            item['avg_time'] = item['tot_time'] / item['count']
            item['time_%'] = item['tot_time'] / tot_time * 100

        return self.ReportType(dict(data))

class QueryAnalyser(Analyser):
    """Analyse log entries like:
    2011-03-17 12:08:54,969 INFO       [root ] EXECUTE_TIME search_deals CPU 0.0004 secs, WALL 0.0117 secs, 1 rows
    or
    2011-03-18 09:54:15,993 INFO       [DLSu ] CALLPROC_TIME fm2c_insert_coupon CPU 0.0002 secs, WALL 0.0009 secs
    """

    ReportType = QueryReport
    line_re = re.compile('^(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2},\d{3}).*_TIME (.+) CPU ([0-9\.]+) secs, WALL ([0-9\.]+) secs(?:, ([0-9\.]+) rows)?')
    line_cols = ('date', 'qryname', 'cputime', 'walltime', 'nrows')

    def getPipeline(self, stream):
        groups = (self.line_re.match(line) for line in stream)
        data = (dict(zip(self.line_cols, g.groups())) for g in groups if g)
        data = field_map(data, 'cputime', float)
        data = field_map(data, 'walltime', float)
        data = field_map(data, 'nrows', lambda x: 0 if x is None else int(x))
        return data

    def analyse(self):

        default_item = {
                'count': 0,
                'tot_nrows': 0,
                'tot_cputime': 0,
                'tot_walltime': 0,
                'max_cputime': -999999,
                'min_cputime':  999999,
                'max_walltime': -999999,
                'min_walltime':  999999,
                }

        data = defaultdict(lambda: default_item.copy())

        for token in self._pipeline:
            item = data[token['qryname']]

            item['count'] += 1
            item['tot_nrows'] += token['nrows']
            item['tot_cputime'] += token['cputime']
            item['tot_walltime'] += token['walltime']
            
            if token['cputime'] > item['max_cputime']:
                item['max_cputime'] = token['cputime']
                item['max_cputime_token'] = token

            if token['cputime'] < item['min_cputime']:
                item['min_cputime'] = token['cputime']

            if token['walltime'] > item['max_walltime']:
                item['max_walltime'] = token['walltime']
                item['max_walltime_token'] = token

            if token['walltime'] < item['min_walltime']:
                item['min_walltime'] = token['walltime']

        tot_walltime = sum(map(itemgetter('tot_walltime'), data.itervalues()))
        tot_cputime = sum(map(itemgetter('tot_cputime'), data.itervalues()))

        for item in data.itervalues():
            item['avg_cputime'] = item['tot_cputime'] / item['count']
            item['avg_walltime'] = item['tot_walltime'] / item['count']
            item['cputime_%'] = 100. * item['tot_cputime'] / tot_cputime if tot_cputime > 0 else 'n/a'
            item['walltime_%'] = 100. * item['tot_walltime'] / tot_walltime if tot_walltime > 0 else 'n/a'

        return self.ReportType(dict(data))

class MemcachedAnalyser(Analyser):
    """Analyse log entries like:
    2011-03-17 12:08:48,020 INFO       [root ] MEMCACHE: GET_412af704425380e4ea57aec0c0ee31c5 FOUND
    """

    ReportType = MemcachedReport
    line_re = re.compile('^(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2},\d{3}).*MEMCACHED?: (.+) (.*)FOUND')
    line_cols = ('date', 'key', 'found')

    def getPipeline(self, stream):
        groups = (self.line_re.match(line) for line in stream)
        data = (dict(zip(self.line_cols, g.groups())) for g in groups if g)
        return data

    def analyse(self):

        default_item = {
                'count': 0,
                'hits': 0,
                'misses': 0,
                }

        data = defaultdict(lambda: default_item.copy())

        for token in self._pipeline:
            item = data[token['key']]

            item['count'] += 1
            if token['found'] == 'NOT_':
                item['misses'] += 1
            else:
                item['hits'] += 1

        data['totals']['count'] = sum(d['count'] for d in data.itervalues())
        data['totals']['hits'] = sum(d['hits'] for d in data.itervalues())
        data['totals']['misses'] = sum(d['misses'] for d in data.itervalues())

        for k, item in data.iteritems():
            item['hits_%'] = 100. * item['hits'] / item['count'] if item['count'] > 0 else 'n/a'

        return self.ReportType(dict(data))

if __name__ == '__main__':
    if len(sys.argv) < 2:
        stream = sys.stdin
    else:
        stream = open(sys.argv[1])

    # need to duplicate the stream if we have more than 1 analyser
    stream = list(stream)
    for a in [
            ErrorAnalyser(stream),
            QueryAnalyser(stream),
            RequestAnalyser(stream),
            MemcachedAnalyser(stream),
            ]:
        report = a.analyse()
        print report.toString()
        print
