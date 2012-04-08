import itertools as I


def all_subsets(lst):
    yield []
    so_far = [[]]
    for elem in lst:
        to_add = []
        for ss in so_far:
            to_add.append(ss + [elem])
        for ss in to_add:
            yield ss
        so_far += to_add


x = [1, -3, 2, 4]
print sorted(list(all_subsets(x)))
print sorted(map(list, I.chain(*[I.combinations(x, i) for i in xrange(len(x) + 1)])))
