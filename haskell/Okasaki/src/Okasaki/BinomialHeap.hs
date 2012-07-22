module Okasaki.BinomialHeap (
    BinomialHeap(..)
  , rank
  , root
  , singleton
  , findMin
  , insert
  , merge
  , deleteMin
  , fromList
) where

import Okasaki.Heap

data Tree a = Node Integer a [Tree a] deriving Show

newtype BinomialHeap a = BH [Tree a]

instance Heap BinomialHeap where
    empty = BH []

    isEmpty (BH []) = True
    isEmpty _ = False

    merge h (BH []) = h
    merge (BH []) h = h
    merge (BH ts1@(t1:ts1')) (BH ts2@(t2:ts2'))
        | rank t1 < rank t2 = let (BH x) = merge (BH ts1') (BH ts2) in BH $ t1 : x
        | rank t1 > rank t2 = let (BH x) = merge (BH ts1) (BH ts2') in BH $ t2 : x
        | otherwise = insTree (link t1 t2) (merge (BH ts1') (BH ts2'))

    insert x = insTree (singleton x)

    findMin h = let (t, _) = getMin h in root t

    deleteMin (BH []) = error "Empty heap"
    deleteMin h = let (Node _ _ ts', h') = getMin h in merge (BH (reverse ts')) h'

rank :: Tree a -> Integer
rank (Node r _ _) = r

root :: Tree a -> a
root (Node _ x _) = x

singleton :: a -> Tree a
singleton x = Node 0 x []

link :: Ord a => Tree a -> Tree a -> Tree a
link t1@(Node r x ts1) t2@(Node r2 y ts2)
    | r /= r2 = error "Ranks differ"
    | x < y = Node (r + 1) x (t2:ts1)
    | otherwise = Node (r + 1) y (t1:ts2)

insTree :: Ord a => Tree a -> BinomialHeap a -> BinomialHeap a
insTree t (BH []) = BH [t]
insTree t (BH ts@(t':ts'))
    | rank t == rank t' = insTree (link t t') (BH ts')
    | rank t < rank t' = BH $ t:ts
    | otherwise = error "Wrong ranks!"

getMin :: Ord a => BinomialHeap a -> (Tree a, BinomialHeap a)
getMin (BH []) = error "Empty heap"
getMin (BH [t]) = (t, empty)
getMin (BH (t:ts)) = let (t', BH ts') = getMin (BH ts) in
    if root t < root t' then (t, BH ts) else (t', BH (t:ts'))

fromList :: Ord a => [a] -> BinomialHeap a
fromList = foldr insert empty
