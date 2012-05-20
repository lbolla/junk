def insertion_sort(v):
    n = len(v)
    for j in xrange(1, n):
        x = v[j]
        i = j - 1
        while i >= 0 and v[i] > x:
            v[i + 1] = v[i]
            i -= 1
        v[i + 1] = x


v = [1,3,2,6,4,3,3]
insertion_sort(v)
print v
