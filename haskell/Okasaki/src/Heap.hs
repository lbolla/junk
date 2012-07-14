module Heap (Heap(..)) where

class Heap h where
    empty :: h
    isEmpty :: h -> Bool
    findMin :: h -> a
    deleteMin :: h -> h

data LeftistHeap a = E | T a deriving Show

instance Heap (LeftistHeap a) where
    empty = E
    isEmpty E = True
    isEmpty _ = False
    findMin E = error "Empty Heap"
    findMin _ = undefined
    deleteMin E = error "Empty Heap"
    deleteMin _ = undefined
