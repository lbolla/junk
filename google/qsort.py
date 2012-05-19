import random


def _qsort(v, p, r, part_func):
    if p < r:
        q = part_func(v, p, r)
        _qsort(v, p, q, part_func)
        _qsort(v, q + 1, r, part_func)


def _qsort_tail_rec(v, p, r, part_func):
    while p < r:
        q = part_func(v, p, r)
        _qsort(v, p, q, part_func)
        p = q + 1


def qsort(v, p, r):
    _qsort_tail_rec(v, p, r, partition)


def random_qsort(v, p, r):
    _qsort_tail_rec(v, p, r, random_partition)


def partition(v, p, r):
    x = v[p]
    i = p - 1
    j = r + 1

    while True:

        j -= 1
        while v[j] > x:
            j -= 1

        i += 1
        while v[i] < x:
            i += 1

        if i < j:
            v[i], v[j] = v[j], v[i]
        else:
            return j


def random_partition(v, p, r):
    i = random.randint(p, r)
    v[p], v[i] = v[i], v[p]
    return partition(v, p, r)


# v = [3, 5, 4, 2, 5, 6, 1]
# print v

# qsort(v, 0, len(v) - 1)
# print v

v = range(9999)
# random.shuffle(v)
qsort(v, 0, len(v) - 1)
# random_qsort(v, 0, len(v) - 1)
assert v == sorted(v)
