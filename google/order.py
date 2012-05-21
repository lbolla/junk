# from qsort import random_partition as partition
from qsort import partition as partition


def order(A, p, r, i):
    '''Return the i-th smallest element of A[p:r+1].'''
    q = partition(A, p, r)
    k = q - p + 1

    # TODO
    if i == 0:
        return A[p]

    if i < k:
        return order(A, p, q, i)
    else:
        return order(A, q + 1, r, i - k)


A = [4,6,5,2,1,3,4,5]
print sorted(A)
# print order(A, 0, len(A) - 1, 2)  # 2
# print order(A, 0, len(A) - 1, 1)  # 1
print order(A, 0, len(A) - 1, 3)  # 3
