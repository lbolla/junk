module Okasaki.BinomialHeap (
    BinomialHeap
  , rank
  , root
  , singleton
  , findMin
  , insert
  , merge
  , deleteMin
  , fromList
) where

data Tree a = Node Integer a [Tree a] deriving Show

type BinomialHeap a = [Tree a]

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

insert :: Ord a => a -> BinomialHeap a -> BinomialHeap a
insert x = insTree (singleton x)

insTree :: Ord a => Tree a -> BinomialHeap a -> BinomialHeap a
insTree t [] = [t]
insTree t ts@(t':ts')
    | rank t == rank t' = insTree (link t t') ts'
    | rank t < rank t' = t:ts
    | otherwise = error "Wrong ranks!"

merge :: Ord a => BinomialHeap a -> BinomialHeap a -> BinomialHeap a
merge h [] = h
merge [] h = h
merge ts1@(t1:ts1') ts2@(t2:ts2')
    | rank t1 < rank t2 = t1 : merge ts1' ts2
    | rank t1 > rank t2 = t2 : merge ts1 ts2'
    | otherwise = insTree (link t1 t2) (merge ts1' ts2')

findMin :: Ord a => BinomialHeap a -> a
findMin h = let (t, _) = getMin h in root t

getMin :: Ord a => BinomialHeap a -> (Tree a, BinomialHeap a)
getMin [] = error "Empty heap"
getMin [t] = (t, [])
getMin (t:ts) = let (t', ts') = getMin ts in
    if root t < root t' then (t, ts) else (t', t:ts')

deleteMin :: Ord a => BinomialHeap a -> BinomialHeap a
deleteMin [] = error "Empty heap"
deleteMin h = let (Node _ _ ts', ts) = getMin h in merge (reverse ts') ts

fromList :: Ord a => [a] -> BinomialHeap a
fromList = foldr insert []
