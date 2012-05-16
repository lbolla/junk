# Given an unsorted array of integers where every item appears twice, a part
# from one, find the lonely one.

import operator


def odd_man_out_awesome(v):
    return reduce(operator.xor, v)


def odd_man_out(v):
    assert len(v) > 0, "at least one element"
    seen = set()
    tot = 0
    for item in v:
        if item in seen:
            tot -= item
        else:
            seen.add(item)
            tot += item
    return tot


# print odd_man_out([])
print odd_man_out_awesome([0, 2, 1, 0, 2])
print odd_man_out_awesome([0, 2, 1, 0, 1])
