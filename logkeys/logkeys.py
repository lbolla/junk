'''Parser for logkeys logs.'''
import sys
import re
from collections import defaultdict


def parse(inp=sys.stdin):
    count = defaultdict(int)
    for line in inp:
        typed = ' '.join(line.split(' ')[3:])
        r = re.compile('<[^<>]+?>')
        keys = r.findall(typed) + list(r.sub('', typed))
        for k in keys:
            count[k] += 1
    return count


def print_count(count):
    for v, k in sorted(((v, k) for k, v in count.iteritems()), reverse=True):
        print '%+10s %d' % (k, v)


def main():
    count = parse()
    print_count(count)


if __name__ == '__main__':
    main()
