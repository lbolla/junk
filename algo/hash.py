import hashlib

class HashTable(object):

	def __init__(self, size, hashfunc=hash):
		self._size = size
		self._data = [None] * size
		self._hash = hashfunc

	def __str__(self):
		return str(self._data)

	def _get_idx(self, k):
		return self._hash(k) % self._size

	def set(self, k, v):
		idx = self._get_idx(k)
		if self._data[idx] is None:
			self._data[idx] = [(k,v)]
		else:
			for i, (_k,_v) in enumerate(self._data[idx]):
				if k == _k:
					self._data[idx][i] = (k,v)
					break
			else:
				self._data[idx].append((k,v))

	def get(self, k):
		idx = self._get_idx(k)
		if self._data[idx] is None:
			raise KeyError(k)
		else:
			for _k,_v in self._data[idx]:
				if k == _k:
					return _v
			raise KeyError(k)
			
def cryptohash(cryptof):
	def helper(x):
		return int(cryptof(x).hexdigest(), 16)
	return helper

def main():
	# h = HashTable(10)
	# h = HashTable(10, hashfunc=id)
	# h = HashTable(10, hashfunc=cryptohash(hashlib.sha1))
	h = HashTable(10, hashfunc=cryptohash(hashlib.md5))

	h.set('one', 1)
	h.set('two', 2)
	h.set('three', 3)
	h.set('three', 4)
	h.set('four', 4)
	print(h)
	print(h.get('one'))
	print(h.get('two'))
	print(h.get('three'))
	print(h.get('four'))

if __name__ == '__main__':
	main()
