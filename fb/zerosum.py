# zerosum subset in a set

import itertools as I


def zerosum(x):
    for i in xrange(len(x), 0, -1):
        for candidate in I.combinations(x, i):
            if sum(candidate) == 0:
                return candidate
    return None


def dynzerosum(x):
    N = sum(xx for xx in x if x < 0)
    P = sum(xx for xx in x if x > 0)
    Q = {}

    for s in xrange(N, P + 1):
        # Q[(0, s)] = x[0] == s
        Q[(0, s)] = (x[0] == s, (0, 1))
    for i in xrange(1, len(x)):
        for s in xrange(N, P + 1):
            # Q[(i, s)] = Q[(i - 1, s)] or (x[i] == s) or Q.get((i - 1, s - x[i]), N <= s - x[i] <= P)
            if Q[(i - 1, s)][0]:
                Q[(i, s)] = Q[(i - 1, s)]
            elif (x[i] == s):
                Q[(i, s)] = (True, (i, i + 1))
            else:
                val = Q.get((i - 1, s - x[i]))
                if val is not None:
                    f, r = val
                    Q[(i, s)] = (f, (r[0], i + 1))
                else:
                    Q[(i, s)] = ((N <= s - x[i] <= P, (i, i + 1)), (r[0], i + 1))

    return Q


x = [1, -3, 2, 4, -1]
# x = [1, 3, 2, 4, 1]
print zerosum(x)
print dynzerosum(x)
# print [k for k, v in dynzerosum(x).iteritems() if v]
# print [k for k, v in dynzerosum(x).iteritems() if v[0]]
# print [k for k, v in dynzerosum(x).iteritems() if v and k[1] == 0]
# print [(i, s, f, r) for (i, s), (f, r) in dynzerosum(x).iteritems() if f and s == 0]
print [x[r[0]:r[1]] for (i, s), (f, r) in dynzerosum(x).iteritems() if f and s == 0]
