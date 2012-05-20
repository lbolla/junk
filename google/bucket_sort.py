import random
from insertion_sort import insertion_sort


def get_bucket(x, nb):
    return int(nb * x)


def bucket_sort(v):
    nb = 10
    b = [[] for _ in xrange(nb)]
    for x in v:
        b[get_bucket(x, nb)].append(x)
    res = []
    for i in b:
        insertion_sort(i)
        res += i
    return res


if __name__ == '__main__':
    for _ in xrange(10):
        v = [random.random() for _ in xrange(20)]
        assert bucket_sort(v) == sorted(v)
