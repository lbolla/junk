# Given a list of rectangles, return all the pairs that overlap.
# A rectangle is represented as a 2-tuple of (x, y) coordinates.
#
# TODO: better solution using BSTs

import itertools


def overlap(r1, r2):
    # check if r1 and r2 overlap
    r1A, r1B = r1
    r2A, r2B = r2
    overlap_x = (r2A[0] <= r1A[0] <= r2B[0]) or (r2A[0] <= r1B[0] <= r2B[0])
    overlap_y = (r2A[1] <= r1A[1] <= r2B[1]) or (r2A[1] <= r1B[1] <= r2B[1])
    return overlap_x and overlap_y


def overlap_pairs(rs):
    # brute force: foreach combination of 2 rectangles, filter using
    # `overlap`.
    return filter(lambda p: overlap(*p), itertools.combinations(rs, 2))


print overlap_pairs([
    ((0, 0), (1, 1)),
    ((.5, .5), (1, 1)),
    # ((0, 0), (.5, .5)),
    # ((1, 1), (1.5, 1.5)),
    ])
