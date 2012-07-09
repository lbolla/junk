module Heap (Heap(..)) where

class Heap h where
    empty :: h
    isEmpty :: h -> Bool
    findMin :: h -> a
    deleteMin :: h -> h
