import random

class Heap(object):

	def __init__(self):
		self._heap = []

	def __str__(self):
		return str(self._heap)

	def swap(self, i, j):
		self._heap[i], self._heap[j] = self._heap[j], self._heap[i]

	def empty(self):
		return len(self._heap) == 0

	def rootIdx(self):
		return 0

	def leftIdx(self, idx):
		return 2 * idx + 1
	def left(self, idx):
		try:
			return self._heap[self.leftIdx(idx)]
		except IndexError:
			return None

	def rightIdx(self, idx):
		return 2 * idx + 2
	def right(self, idx):
		try:
			return self._heap[self.rightIdx(idx)]
		except IndexError:
			return None

	def parentIdx(self, idx):
		return (idx - 1) / 2 if idx > 0 else 0
	
	def insert(self, val):
		self._heap.append(val)
		idx = len(self._heap) - 1
		p_idx = self.parentIdx(idx)
		while idx > 0 and (val > self._heap[p_idx]):
			self.swap(idx, p_idx)
			idx = p_idx
			p_idx = self.parentIdx(idx)

	def pop(self):
		retval = self._heap[0]
		self._heap[0] = self._heap[-1]
		self._heap = self._heap[:-1]
		if self.empty():
			return retval

		idx = 0
		val = self._heap[idx]
		left = self.left(idx)
		right = self.right(idx)
		while True:
			if left is None and right is None:
				# leaf
				break

			if (right is None and val >= left) or \
			   (left  is None and val >= right) or \
			   (val >= left and val >= right):
				# heap ok
				break
			
			if right is None or left > right:
				new_idx = self.leftIdx(idx)
			else:
				new_idx = self.rightIdx(idx)

			self.swap(idx, new_idx)
			idx = new_idx
			left = self.left(idx)
			right = self.right(idx)

		return retval

def heapsort(lst):
	h = Heap()
	for item in lst:
		h.insert(item)

	sorted_lst = []
	while not h.empty():
		sorted_lst.append(h.pop())
	
	return sorted_lst

def main():
	for n in xrange(100):
		x = range(n)
		random.shuffle(x)
		y = heapsort(x)
		z = sorted(x, reverse=True)
		assert y == z

if __name__ == '__main__':
	main()
