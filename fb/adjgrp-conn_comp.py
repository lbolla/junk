# http://www.glassdoor.com/Interview/Facebook-Interview-RVW1340742.htm
# Sequential algorithm from:
# http://en.wikipedia.org/wiki/Connected-component_labeling

from collections import defaultdict

y = [[0, 1, 1, 0, 1, 1],
     [1, 0, 1, 1, 0, 0],
     [1, 1, 1, 0, 0, 1],
     ]

print y

nrows = len(y)
ncols = len(y[0])

def in_region(x):
    return x == 1

region = 0
regions = {}

# TODO: this should be some kind of disjoint-set data structure supporting
# union-find
eq_regions = {}
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
                wr = regions[(i - 1, j)]
                nr = regions[(i, j - 1)]
                eq_regions[max(wr, nr)] = min(wr, nr)

results = defaultdict(list)
for vv in set(regions.values()):
    real_region = eq_regions.get(vv, vv)
    for k, v in regions.iteritems():
        if v == vv:
            results[real_region].append(k)
print results
print len(results)
