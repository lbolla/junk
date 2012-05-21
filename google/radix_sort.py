import random


def num_digits(x):
    d = 0
    while x > 0:
        x /= 10
        d += 1
    return d


def get_digit(x, n):
    x /= 10**(n - 1)
    return x % 10


def counting_sort(a, n, k, key):
    c = [0] * k
    b = [0] * n
    for i in a:
        c[key(i)] += 1
    for i in xrange(1, len(c)):
        c[i] += c[i - 1]
    for i in xrange(len(a) - 1, -1, -1):
        b[c[key(a[i])] - 1] = a[i]
        c[key(a[i])] -= 1
    return b


def radix_sort(v):
    if not v:
        return v
    ds = num_digits(max(v))
    for d in xrange(ds):
        v = counting_sort(v, len(v), 10, lambda x: get_digit(x, d + 1))
    return v


# v = [23, 123, 452, 175, 176, 177, 2, 12345]
for _ in xrange(10):
    v = [random.randint(0, 1000) for _ in xrange(20)]
    assert radix_sort(v) == sorted(v)
