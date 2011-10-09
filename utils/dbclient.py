#!/usr/bin/env python

import os
import re
import sys
import pprint
import traceback
from sqlalchemy.ext.sqlsoup import SqlSoup


prompt = '$> '


def fmt_col(c, w):
    return c[:w].ljust(w)


def get_terminal_size():
    return map(int, os.popen('stty size', 'r').read().split())


def print_result(res):
    rows, cols = get_terminal_size()
    try:
        keys = res.keys()
        colsep = '    '
        col_width = (cols - len(colsep)*(len(keys) - 1)) / len(keys)
        fmt = lambda c: fmt_col(c, col_width)

        headers = colsep.join(map(fmt, keys))
        head = '\n%s\n%s' % (headers, '_' * len(headers))

        for ir, r in enumerate(res):
            if ir%rows == 0:
                print head
            print '    '.join(map(fmt, map(str, r)))
        print '\n%d row(s) found.\n' % res.rowcount

    except:
        pass


COMMAND_ALIASES = {
        'show locks': {
            'postgresql': 'select pg_class.relname, pg_locks.mode, pg_locks.granted as "g", substr(pg_stat_activity.current_query,1,30), pg_stat_activity.query_start, age(now(),pg_stat_activity.query_start) as "age", pg_stat_activity.procpid from pg_stat_activity,pg_locks left outer join pg_class on (pg_locks.relation = pg_class.oid) where pg_locks.pid=pg_stat_activity.procpid order by query_start;',
            },
        'show tables': {
            'postgresql': 'select table_name from information_schema.tables where table_schema = \'public\' order by table_name;'
            },
        }


COMMAND_REGEX = {
        (re.compile('^desc (\w+)$'), ('table_name', ), 'desc <table>'): {
                'postgresql': 'select column_name, data_type, column_default, is_nullable from information_schema.columns where table_name = \'%(table_name)s\' order by ordinal_position;'
            },
        }


def get_sql(cmd, dbname):

    cmd = cmd.strip().rstrip(';')

    if COMMAND_ALIASES.has_key(cmd):
        return COMMAND_ALIASES[cmd].get(dbname)

    for k, v in COMMAND_REGEX.iteritems():
        regex, paramnames, docstring = k
        match = regex.match(cmd)
        if match:
            if v.has_key(dbname):
                params = dict(zip(paramnames, match.groups()))
                return v[dbname] % params

    return None


def show_help():
    print 'DB agnostic client.'
    print
    print 'Type SQL statements or commands. No need to end with ;'
    print
    print 'Available commands per DB type:'
    for k, v in COMMAND_ALIASES.iteritems():
        print '    %-20s: %s' % (k, ','.join(v.iterkeys()))
    for k, v in COMMAND_REGEX.iteritems():
        regex, paramnames, docstring = k
        print '    %-20s: %s' % (docstring, ','.join(v.iterkeys()))


def main():
    db_name = sys.argv[1]
    db = SqlSoup(db_name)
    while True:
        try:
            cmd = raw_input(prompt)
            if not cmd:
                continue
            if cmd.lower() in ('help', '?'):
                show_help()
                continue
            sql = get_sql(cmd, db.engine.name) or cmd
            res = db.execute(sql)
            print_result(res)
            db.commit()

        except (SystemExit, KeyboardInterrupt, EOFError):
            print '\nBye!\n'
            return 0

        except Exception:
            traceback.print_exc()
            db.rollback()


if __name__ == '__main__':
    main()
