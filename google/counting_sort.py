import random


def counting_sort(a, n, k):
    c = [0] * k
    b = [0] * n
    for i in a:
        c[i] += 1
    for i in xrange(1, len(c)):
        c[i] += c[i - 1]
    for i in xrange(len(a) - 1, -1, -1):
        b[c[a[i]] - 1] = a[i]
        c[a[i]] -= 1
    return b


k = 300
n = 4000
for _ in xrange(100):
    v = [random.randrange(0, k) for _ in xrange(n)]
    assert counting_sort(v, n, k) == sorted(v)
