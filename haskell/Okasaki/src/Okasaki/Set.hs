module Okasaki.Set (Set(..)
          , UnbalancedSet
          , fromList
          , tests
) where

import Test.Framework (Test)
import Test.Framework.Providers.HUnit (testCase)
import Test.Framework.Providers.QuickCheck2 (testProperty)
import Test.HUnit (assert, Assertion)
import Test.QuickCheck ((==>), Property)

class Set s where
    empty :: s a
    insert :: Ord a => a -> s a -> s a
    member :: Ord a => a -> s a -> Bool

data UnbalancedSet a = E | T (UnbalancedSet a) a (UnbalancedSet a) deriving Show

instance Set UnbalancedSet where
    empty = E
    member _ E = False
    member x (T a y b)
        | x < y = member x a
        | x > y = member x b
        | otherwise = True
    insert x E = T E x E
    insert x t@(T a y b)
        | x < y = T (insert x a) y b
        | x > y = T a y (insert x b)
        | otherwise = t

fromList :: Ord a => [a] -> UnbalancedSet a
fromList = foldr insert empty

-- Exercise 2.2
member' :: Ord a => a -> UnbalancedSet a -> Bool
member' z t = member'' z Nothing t
    where member'' :: Ord a => a -> Maybe a -> UnbalancedSet a -> Bool
          member'' _ Nothing E = False
          member'' x (Just c) E = x == c
          member'' x c (T a y b)
              | x < y = member'' x c a
              | otherwise = member'' x (Just y) b

-- Exercise 2.5a
complete :: Ord a => a -> Integer -> UnbalancedSet a
complete _ 0 = E
complete x 1 = T E x E
complete x d = let a = complete x (d - 1) in T a x a

-- Exercise 2.5b
create :: Ord a => a -> Integer -> UnbalancedSet a
create _ 0 = E
create x n
    | (n - 1) `rem` 2 == 0 = let a = create x (n `div` 2) in T a x a
    | otherwise = let
        m = (n - 1) `div` 2
        a = create x m
        b = create x (m + 1)
        in T a x b

-------------------------------------------------------------------------------
-- TESTS

root :: UnbalancedSet a -> a
root E = error "Empty set"
root (T _ x _) = x

isBST :: Ord a => UnbalancedSet a -> Bool
isBST E = True
isBST (T E _ E) = True
isBST (T l x E) = root l <= x && isBST l
isBST (T E x r) = x < root r && isBST r
isBST (T l x r) = (root l <= x) && (x <  root r) && isBST l && isBST r

test1 :: Assertion
test1 = assert . member 1 $ fromList [1 :: Integer]

test2 :: Assertion
test2 = assert . member' 1 $ fromList [1 :: Integer]

test3 :: Assertion
test3 = assert . member 1 $ complete (1 :: Integer) 1

test4 :: Assertion
test4 = assert . not . member 1 $ create (1 :: Integer) 0

propFromList :: [Integer] -> Bool
propFromList = isBST . fromList

propMember :: [Integer] -> Bool
propMember xs = let t = fromList xs in all (`member` t) xs

propComplete :: Integer -> Bool
propComplete n = isComplete $ complete n (1 :: Integer)

isComplete :: UnbalancedSet a -> Bool
isComplete E = True
isComplete (T E _ E) = True
isComplete (T _ _ E) = False
isComplete (T E _ _) = False
isComplete (T l _ r) = isComplete l && isComplete r

propCreate :: Integer -> Property
propCreate n = (n > 0) ==> size (create (1 :: Integer) n) == n

size :: UnbalancedSet a -> Integer
size E = 0
size (T l _ r) = size l + 1 + size r

tests :: [Test]
tests = [
        testCase "test1" test1
      , testCase "test2" test2
      , testCase "test3" test3
      , testCase "test4" test4
      , testProperty "fromList" propFromList
      , testProperty "member" propMember
      , testProperty "complete" propComplete
      , testProperty "create" propCreate
    ]
