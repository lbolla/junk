module RBTree(tests) where

import Test.Framework (Test)
import Test.Framework.Providers.HUnit (testCase)
import Test.Framework.Providers.QuickCheck2 (testProperty)
import Test.HUnit (assert, Assertion)
import Test.QuickCheck ((==>), Property)

import Data.List (nub)

data Color = Red | Black deriving Show

data RBTree a = E | T Color (RBTree a) a (RBTree a) deriving Show

insert :: Ord a => a -> RBTree a -> RBTree a
insert z t = T Black l' y' r'
    where
        insert' x E = T Red E x E
        insert' x s@(T c l y r)
            | x < y = balance c (insert' x l) y r
            | x > y = balance c l y (insert' x r)
            | otherwise = s
        (T _ l' y' r') = insert' z t

balance :: Color -> RBTree a -> a -> RBTree a -> RBTree a
balance Black (T Red (T Red a x b) y c) z d = T Red (T Black a x b) y (T Black c z d)
balance Black (T Red a x (T Red b y c)) z d = T Red (T Black a x b) y (T Black c z d)
balance Black a x (T Red (T Red b y c) z d) = T Red (T Black a x b) y (T Black c z d)
balance Black a x (T Red b y (T Red c z d)) = T Red (T Black a x b) y (T Black c z d)
balance c l x r = T c l x r

member :: Ord a => a -> RBTree a -> Bool
member _ E = False
member x (T _ l y r)
    | x < y = member x l
    | x > y = member x r
    | otherwise = True

fromList :: Ord a => [a] -> RBTree a
fromList = foldr insert E

minMaxDepth :: RBTree a -> (Integer, Integer)
minMaxDepth q = let d = depths 0 q in (minimum d, maximum d)
    where
        depths _ E = []
        depths n (T _ E _ E) = [n]
        depths n (T _ E _ r) = [n] ++ depths (n + 1) r
        depths n (T _ l _ E) = depths (n + 1) l ++ [n]
        depths n (T _ l _ r) = depths (n + 1) l ++ depths (n + 1) r

-------------------------------------------------------------------------------
-- TESTS

testInsert :: Assertion
testInsert = let t = fromList [25,1,26,24,24,-1,27,28,-2,0,-3,-4,2,0]
                 in assert $ member (1 :: Integer) t

propMember :: [Integer] -> Bool
propMember xs = let t = fromList xs in all (`member` t) xs

propDepth :: [Integer] -> Property
propDepth xs = not (null xs) && (length xs < 10) ==>
               let (m, mm) = minMaxDepth $ fromList xs
                   n = fromIntegral (length (nub xs)) :: Float
                   d = floor $ log n / log 2.0
                in m <= d && d <= mm

tests :: [Test]
tests = [
        testCase "Insert" testInsert
      , testProperty "Member" propMember
      , testProperty "Depth" propDepth
    ]
