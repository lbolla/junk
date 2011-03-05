import random

def qsort_naive(x):
	'''Quicksort -- O(n log n), O(n) space.
	http://en.wikipedia.org/wiki/Quicksort#Simple_version
	'''

	def partition(x):
		p = x[-1]
		left = []
		right = []
		for item in x[:-1]:
			if item <= p:
				left.append(item)
			else:
				right.append(item)
		return left, right, p

	if len(x) < 2:
		return x
	left, right, p = partition(x)
	return qsort_naive(left) + [p] + qsort_naive(right)

def qsort(x, left, right):
	'''Inplay quicksort -- O(n log n), O(log n) space.
	http://en.wikipedia.org/wiki/Quicksort#Complex_version
	'''

	def swap(x, i, j):
		x[i], x[j] = x[j], x[i]

	def partition(x, left, right, p_idx):
		p_val = x[p_idx]
		swap(x, p_idx, right) # pivot out of the way
		s_idx = left
		for i in xrange(left, right):
			if x[i] <= p_val:
				swap(x, i, s_idx) # put lesser value in store
				s_idx += 1 # advance store
		swap(x, s_idx, right)
		return s_idx

	if right > left:
		p_idx = left + (right - left) / 2 # no overflow
		p_new_idx = partition(x, left, right, p_idx)
		qsort(x, left, p_new_idx - 1)
		qsort(x, p_new_idx + 1, right)


n = 100
big = range(n)
random.shuffle(big)

for a in [
		[],
		[1],
		[1,2],
		[11,1,1,2,3,3,32,2,2,3,3,3,3,3,3],
		big,
		]:
	b = qsort_naive(a)
	assert b == sorted(a)

	a2 = a[:]
	qsort(a2, 0, len(a2) - 1)
	assert a2 == b

print 'ok!'
