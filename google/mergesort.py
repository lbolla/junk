def mergesort(A):
    n = len(A)
    if n <= 1:
        return A
    l = mergesort(A[:n/2])
    h = mergesort(A[n/2:])
    return merge(l, h)


def merge(A, B):
    if not A:
        return B
    if not B:
        return A

    i = j = k = 0
    n = len(A)
    m = len(B)
    C = [None] * (n + m)
    while i < n and j < m:
        if A[i] < B[j]:
            C[k] = A[i]
            i += 1
        else:
            C[k] = B[j]
            j += 1
        k += 1

    if i < n:
        C[k:] = A[i:]
    elif j < m:
        C[k:] = B[j:]

    return C


# if __name__ == '__main__':
#     print mergesort([4,3,6,5,2,7,5])
