import random
from insertion_sort import insertion_sort


def get_bucket(x, nb):
    return int(nb * x)


def bucket_sort(v):
    if not v:
        return v
    nb = max(10, len(v) / 10)
    b = [[] for _ in xrange(nb)]
    m = max(v) * 1.01
    for x in v:
        b[get_bucket(x / m, nb)].append(x)
    res = []
    # print min([len(x) for x in b]), max([len(x) for x in b])
    for i in b:
        insertion_sort(i)
        res += i
    return res


if __name__ == '__main__':
    for _ in xrange(10):
        v = [random.random() for _ in xrange(2000)]
        assert bucket_sort(v) == sorted(v)
