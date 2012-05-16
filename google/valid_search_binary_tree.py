# Determine if a binary tree is valid.
#
# Tree represented as: None | (int, LTree, RTree)
# Binary Search Tree: root(LTree) < Node <= root(RTree)


def root(t):
    if t is None:
        return None
    return t[0]


MINUS_INF = float('-inf')
PLUS_INF = float('+inf')


def is_valid(t, m=MINUS_INF, M=PLUS_INF):
    if t is None:
        return True

    n, l, r = t

    if not is_valid(l, m, n) or not is_valid(r, n, M):
        return False

    rl = root(l)
    if rl is not None and not (m < rl < n):
        return False

    rr = root(r)
    if rr is not None and not (n < rr < M):
        return False

    return True


print is_valid(None)
print is_valid((1, None, None))
print is_valid((1, (2, None, None), None))
print is_valid((1, None, (2, None, None)))
print is_valid((1, (0, None, None), (2, None, None)))
print is_valid((1, (0, None, (2, None, None)), (2, None, None)))
