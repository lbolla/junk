# Binary Trees
# Possible representations:
# - array
# - nested lists

# Operations
# insert, search, delete, inorder


import random


class NodeL(object):

    def __init__(self, value, parent, ltree, rtree):
        self.value = value
        self.parent = parent
        self.ltree = ltree
        self.rtree = rtree

    def is_leaf(self):
        return self.ltree.is_empty() and self.rtree.is_empty()

    def __str__(self):
        return '(%s, %s, %s)' % (self.value, self.ltree, self.rtree)


class BTreeL(object):

    def __init__(self):
        self.root = None  # Empty tree

    def is_empty(self):
        return self.root is None

    def insert(self, x, parent=None):
        if self.is_empty():
            self.root = NodeL(x, parent, BTreeL(), BTreeL())
        else:
            if x < self.root.value:
                self.root.ltree.insert(x, self)
            else:
                self.root.rtree.insert(x, self)

    def search(self, x):
        if self.is_empty():
            return None
        if x == self.root.value:
            return self.root
        if x < self.root.value:
            return self.root.ltree.search(x)
        return self.root.rtree.search(x)

    def replace_node_in_parent(self, node, new_value):
        if node.parent:
            if node is node.parent.root.ltree.root:
                node.parent.root.ltree = new_value
            else:
                node.parent.root.rtree = new_value
        # new_value.root.parent = self.root.parent

    def find_left_most(self):
        if self.root is None:
            return None
        if self.root.ltree.is_empty():
            return self.root
        return self.root.ltree.find_left_most()

    def remove(self, x):
        node = self.search(x)
        if node is None:
            return

        if node.is_leaf():
            # node has no children
            # just remove it
            self.replace_node_in_parent(node, BTreeL())

        elif node.ltree.is_empty():
            # node has 1 children
            # substitute to parent and delete
            self.replace_node_in_parent(node, node.rtree)

        elif node.rtree.is_empty():
            # node has 1 children
            # substitute to parent and delete
            self.replace_node_in_parent(node, node.ltree)

        else:
            # node has 2 children
            # find successor (or predecessor) "in order" and substitute
            successor = self.root.rtree.find_left_most()
            node.value = successor.value
            successor.parent.root.ltree.replace_node_in_parent(successor, successor.rtree)

    def __str__(self):
        if self.root is None:
            return '()'
        else:
            return str(self.root)


if __name__ == '__main__':

    # items = range(10)
    # random.shuffle(items)
    # t = BTreeL()
    # for item in items:
    #     t.insert(item)

    # print t
    # print t.search(3)
    # print t.search(33)

    # t.remove(66)
    # t.remove(3)
    # print t

    t = BTreeL()
    for item in [3, 2, 1, 5, 6, 4]:
        t.insert(item)

    print t
    t.remove(3)
    print t
