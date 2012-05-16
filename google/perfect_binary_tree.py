# Verify that a binary tree is perfect.
# Binary Tree is represented as: None | (Node, <LeftTree>, <RightTree)


INVALID = -1


def perfect_height(t):
    '''Find the height of a binary tree, return -1 if not perfect.'''

    if t is None:
        return 0

    n, l, r = t

    lh = perfect_height(l)
    if lh == INVALID:
        return INVALID

    rh = perfect_height(r)
    if rh == INVALID:
        return INVALID

    if rh != lh:
        return INVALID

    # lh == rh
    return 1 + lh


def is_perfect(t):
    return perfect_height(t) != INVALID


print is_perfect(None)
print is_perfect((1, None, None))
print is_perfect((1, (2, None, None), None))
print is_perfect((1, (2, None, None), (3, None, None)))
print is_perfect((1, (2, None, None), (3, None, (4, None, None))))
