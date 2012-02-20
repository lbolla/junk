# http://www.glassdoor.com/Interview/Facebook-Interview-RVW1340742.htm
# Sequential algorithm from:
# http://en.wikipedia.org/wiki/Connected-component_labeling


from collections import defaultdict


def find_groups(y):
    nrows = len(y)
    ncols = len(y[0])

    def in_region(x):
        return x == 1

    region = 0
    regions = {}

    eq_regions = []
    for i in xrange(nrows):
        for j in xrange(ncols):

            c = y[i][j]

            if not in_region(c):
                continue

            w = y[i][j - 1] if j > 0 else -1
            n = y[i - 1][j] if i > 0 else -1

            if not in_region(w) and not in_region(n):
                regions[(i, j)] = region
                region += 1

            elif in_region(w) and not in_region(n):
                regions[(i, j)] = regions[(i, j - 1)]

            elif in_region(n) and not in_region(w):
                regions[(i, j)] = regions[(i - 1, j)]

            else:
                if regions[(i - 1, j)] == regions[(i, j - 1)]:
                    regions[(i, j)] = regions[(i - 1, j)]
                else:
                    regions[(i, j)] = regions[(i - 1, j)]
                    wr = Set(regions[(i - 1, j)])
                    nr = Set(regions[(i, j - 1)])
                    eq_regions.append(wr)
                    eq_regions.append(nr)
                    union(wr, nr)

    results = defaultdict(list)
    for vv in set(regions.values()):
        for eq_r in eq_regions:
            if eq_r.value == vv:
                real_region = find(eq_r).value
                break
        else:
            real_region = vv
        for k, v in regions.iteritems():
            if v == vv:
                results[real_region].append(k)
    return results


class Set(object):
    # naive union-find
    # http://en.wikipedia.org/wiki/Union_find

    def __init__(self, x):
        self.parent = self
        self.value = x


def find(x):
    if x.parent == x:
        return x
    else:
        return find(x.parent)


def union(x, y):
    xroot = find(x)
    yroot = find(y)
    xroot.parent = yroot
    return xroot


y = [[0, 1, 1, 0, 1, 1],
     [1, 0, 1, 1, 0, 0],
     [1, 1, 1, 0, 0, 1],
     ]
results = find_groups(y)

print y
print results
print len(results)
