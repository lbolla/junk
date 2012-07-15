module Heap (Heap(..), tests) where

import Test.Framework (Test)
import Test.Framework.Providers.HUnit (testCase)
import Test.Framework.Providers.QuickCheck2 (testProperty)
import Test.HUnit (assert, Assertion)

class Heap h where
    empty :: h a
    isEmpty :: h a -> Bool
    merge :: Ord a => h a -> h a -> h a
    insert :: Ord a => a -> h a -> h a
    findMin :: h a -> a
    deleteMin :: Ord a => h a -> h a

data LeftistHeap a = E | T Integer a (LeftistHeap a) (LeftistHeap a)
                   deriving Show

rank :: LeftistHeap h -> Integer
rank E = 0
rank (T r _ _ _) = r

makeT :: a -> LeftistHeap a -> LeftistHeap a -> LeftistHeap a
makeT x a b
    | rank a >= rank b = T (rank b + 1) x a b
    | otherwise = T (rank a + 1) x b a
-- -- Exercise 3.4b
-- makeT x a b
--     | rank a >= rank b = T (rank a + rank b + 1) x a b
--     | otherwise = T (rank a + rank b + 1) x b a

instance Heap LeftistHeap where
    empty = E
    isEmpty E = True
    isEmpty _ = False
    merge h E = h
    merge E h = h
    merge h1@(T _ x a1 b1) h2@(T _ y a2 b2)
        | x < y = makeT x a1 (merge b1 h2)
        | otherwise = makeT y a2 (merge h1 b2)
    insert x = merge (T 1 x E E)
    findMin E = error "Empty Heap"
    findMin (T _ x _ _) = x
    deleteMin E = error "Empty Heap"
    deleteMin (T _ _ a b) = merge a b

fromList :: Ord a => [a] -> LeftistHeap a
fromList = foldr insert empty

-- Exercise 3.3
fromList2 :: Ord a => [a] -> LeftistHeap a
fromList2 [] = E
fromList2 [x] = T 1 x E E
fromList2 xs = merge (fromList2 xs1) (fromList2 xs2)
    where (xs1, xs2) = splitAt (length xs `div` 2) xs

-------------------------------------------------------------------------------
-- TESTS

testEmptyHeap :: Assertion
testEmptyHeap = assert $ isEmpty E

testNonEmptyHeap :: Assertion
testNonEmptyHeap = assert $ not . isEmpty $ fromList [1 :: Integer]

testNonEmptyHeap2 :: Assertion
testNonEmptyHeap2 = assert $ not . isEmpty $ fromList2 [1 :: Integer]

propEmptyHeap :: [Integer] -> Bool
propEmptyHeap xs = (xs :: [Integer]) == xs

tests :: [Test]
tests = [
        testCase "Empty Heap" testEmptyHeap
      , testCase "non-Empty Heap" testNonEmptyHeap
      , testCase "non-Empty Heap 2" testNonEmptyHeap2
      , testProperty "Empty Heap" propEmptyHeap
    ]
