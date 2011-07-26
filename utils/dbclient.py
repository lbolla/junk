#!/usr/bin/env python
import sys
import pprint
import traceback
from sqlalchemy.ext.sqlsoup import SqlSoup


prompt = '$> '


def fmt_col(c, w):
    return c[:w].ljust(w)


def print_result(res, line_width=80):
    keys = res.keys()
    col_width = line_width / len(keys)
    fmt = lambda c: fmt_col(c, col_width)

    print '\t'.join(map(fmt, keys))
    for r in res:
        print '\t'.join(map(fmt, map(str, r)))


def main():
    db_name = sys.argv[1]
    db = SqlSoup(db_name)
    while True:
        try:
            sql = raw_input(prompt)
            res = db.execute(sql)
            print_result(res)
        except (SystemExit, KeyboardInterrupt, EOFError):
            print '\nBye!\n'
            return 0
        except Exception:
            traceback.print_exc()


if __name__ == '__main__':
    main()
