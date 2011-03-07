import random

class Node(object):

	def __init__(self, val=None, parent=None, left=None, right=None):
		self.val = val
		self.parent = parent
		self.left = left
		self.right = right
	
	def __str__(self):
		return '(%s %s P-> %s L-> %s R-> %s)' % (id(self), self.val, id(self.parent), self.left, self.right)

	def insert(self, node):
		if self.val is None:
			self.val = node.val
			self.left = node.left
			self.right = node.right
			self.parent = None
		elif node.val < self.val:
			if self.left is None:
				node.parent = self
				self.left = node
			else:
				self.left.insert(node)
		else:
			if self.right is None:
				node.parent = self
				self.right = node
			else:
				self.right.insert(node)
	
	def inorder(self, callback):
		self.left is not None and self.left.inorder(callback)
		callback(self.val)
		self.right is not None and self.right.inorder(callback)

	def preorder(self, callback):
		callback(self.val)
		self.left is not None and self.left.preorder(callback)
		self.right is not None and self.right.preorder(callback)
		
	def postorder(self, callback):
		self.left is not None and self.left.postorder(callback)
		self.right is not None and self.right.postorder(callback)
		callback(self.val)
		

def BST_sort(x):
	t = Node()
	for item in x:
		t.insert(Node(item))
	y = []
	t.inorder(lambda item: y.append(item))
	return y

def main():
	x = list(range(10))
	random.shuffle(x)
	print(x)
	print(BST_sort(x))

if __name__ == '__main__':
	main()
