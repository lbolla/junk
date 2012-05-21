# Given a list of sorted, disjoint itervals and an interval, merge the given
# interval with the list so as to mantain the invariant.


def merge(lst, s):
    # TODO
    pass


print merge([(0, 1), (3, 5), (7, 9)], (-1, 2))  # [(-1, 2), (3, 5), (7, 9)]
print merge([(0, 1), (3, 5), (7, 9)], (-1, 4))  # [(-1, 5), (7, 9)]
