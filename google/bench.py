import random
import time
from math import log

from insertion_sort import insertion_sort
from qsort import qsort
from counting_sort import counting_sort


def csort(v):
    return counting_sort(v, len(v), max(v) + 1 if v else None)


def main():
    ls = [50 * n for n in xrange(50)]
    algo = [
            ('insertionsort', insertion_sort, True),
            ('qsort', lambda v: qsort(v, 0, len(v) - 1), True),
            ('counting_sort', csort, False),
            ]

    res = {}
    for algo_name, algo_f, in_place in algo:
        print algo_name
        res[algo_name] = []
        for l in ls:
            print l
            v = [random.randint(0, 100) for _ in xrange(l)]
            nrep = 3
            tot = []
            for _ in xrange(nrep):
                if in_place:
                    w = v[:]
                    t1 = time.time()
                    algo_f(w)
                    t2 = time.time()
                else:
                    t1 = time.time()
                    w = algo_f(v)
                    t2 = time.time()
                assert w == sorted(v)
                tot.append(t2 - t1)
            res[algo_name].append((l, min(tot)))

    # references
    res['n'] = [(l, l) for l in ls]
    res['n_log_n'] = [(l, l * log(l + .1)) for l in ls]
    res['n2'] = [(l, l * l) for l in ls]
    return res


if __name__ == '__main__':
    res = main()
    for k, v in res.iteritems():
        with open(k + '.csv', 'w') as fid:
            m = max([t for _, t in v])
            for l, t in v:
                fid.write('%d,%g\n' % (l, 1. * t / m))
