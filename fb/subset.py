x = [2,3,5,1,0]
y = [
        [2,3],
        [9,3],
        [],
        [2],
        [22],
        ]

def is_subset_set(y, x):
    return len(set(y) - set(x)) == 0

def is_subset(y, x):
    '''Is y subset of x?'''
    x_ = quicksort(x)
    y_ = quicksort(y)

    lx = len(x_)
    ly = len(y_)
    ix = 0
    iy = 0
    while ix < lx and iy < ly:
        if y_[iy] == x_[ix]:
            iy += 1
        elif y_[iy] < x_[ix]:
            return False
        else: # >
            ix += 1
    if iy == ly:
        return True
    else:
        return False

def quicksort(x):
    if len(x) < 2:
        return x
    return quicksort([xx for xx in x[1:] if xx < x[0]]) + [x[0]] + quicksort([xx for xx in x[1:] if xx > x[0]])

def mergesort(x):
    l = len(x)
    if l < 2:
        return x
    return merge(mergesort(x[:l/2]), mergesort(x[l/2:]))

def merge(x, y):
    assert x == sorted(x), str(x)
    assert y == sorted(y), str(y)
    ix = iy = 0
    lx, ly = len(x), len(y)
    z = []
    while ix < lx and iy < ly:
        if x[ix] <= y[iy]:
            z.append(x[ix])
            ix += 1
        else:
            z.append(y[iy])
            iy += 1
    if ix == lx:
        z += y[iy:]
    else:
        z += x[ix:]
    return z

assert is_subset_set(y[0], x), str(y[0])
assert not is_subset_set(y[1], x), str(y[1])

for y_ in y:
    assert is_subset(y_, x) == is_subset_set(y_, x), str(y_)

print sorted(x)
print quicksort(x)
print mergesort(x)
