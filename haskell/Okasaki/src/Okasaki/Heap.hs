module Okasaki.Heap (Heap(..)) where

class Heap h where
    empty :: h a
    isEmpty :: h a -> Bool
    merge :: Ord a => h a -> h a -> h a
    insert :: Ord a => a -> h a -> h a
    findMin :: Ord a => h a -> a
    deleteMin :: Ord a => h a -> h a
