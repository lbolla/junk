module LeftistHeap (LeftistHeap(..)) where

import Heap

data LeftistHeap a = E | T a deriving Show

instance Heap (LeftistHeap a) where
    empty = E
    isEmpty E = True
    isEmpty _ = False
    findMin E = error "Empty Heap"
    findMin _ = undefined
    deleteMin E = error "Empty Heap"
    deleteMin _ = undefined
