# HEAP DATA STRUCTURE


from math import ceil


def left(i):
    return ((i + 1) << 1) - 1


def right(i):
    return (i + 1) << 1


def parent(i):
    return i >> 1


def heapify(h, i, hsize):
    '''Given a binary tree h, where left(i) and right(i) are heaps, make it a
    heap, too.'''

    l = left(i)
    r = right(i)
    largest = i
    if l < hsize and h[l] > h[i]:
        largest = l
    if r < hsize and h[r] > h[largest]:
        largest = r

    if i == largest:
        return

    h[i], h[largest] = h[largest], h[i]
    heapify(h, largest, hsize)


def build_heap(h):
    '''Given an unsorted array, build a heap.'''
    hsize = len(h)
    l = int(ceil(hsize / 2))

    for i in xrange(hsize - l - 1, -1, -1):
        heapify(h, i, hsize)


def extract_max(h, hsize):
    m = h[0]
    h[0] = h[hsize - 1]
    hsize -= 1
    heapify(h, 0, hsize)
    return m, hsize


def insert(h, hsize, x):
    assert len(h) > hsize
    i = hsize
    hsize += 1
    while True:
        if h[parent(i)] < x:
            h[i] = h[parent(i)]
            i = parent(i)
            if i == 0:
                break
        else:
            break
    h[i] = x


def assert_heap(h, hsize=None, i=0):

    hsize = hsize or len(h)

    l = left(i)
    if l < hsize:
        if h[i] < h[l]:
            print h, hsize, i, l
            assert False
        assert_heap(h, hsize, l)

    r = right(i)
    if r < hsize:
        if h[i] < h[r]:
            print h, hsize, i, r
            assert False
        assert_heap(h, hsize, r)


h = [0, 6, 5, 4, 3, 2, 1]
heapify(h, 0, len(h))
print h
assert_heap(h)

h = [1, 2, 3, 4, 5, 6]
build_heap(h)
print h
print extract_max(h, len(h)), h
assert_heap(h)

h = [6, 5, 4, 3, 2, None]
insert(h, len(h) - 1, 10)
print h
assert_heap(h)

h = [-1] * 6
for i in xrange(6):
    insert(h, i, i)
print h
assert_heap(h)

hh = range(6)
build_heap(hh)
print hh
assert_heap(hh)

hsize = len(hh)
while hsize > 0:
    m, hsize = extract_max(hh, hsize)
    print m
