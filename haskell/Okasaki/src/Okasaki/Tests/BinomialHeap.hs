module Okasaki.Tests.BinomialHeap (tests) where

import Test.Framework (Test)
import Test.Framework.Providers.HUnit (testCase)
import Test.Framework.Providers.QuickCheck2 (testProperty)
import Test.HUnit (assert, Assertion)
import Test.QuickCheck ((==>), Property)

import Data.List (sort)

import Okasaki.BinomialHeap

testRank :: Assertion
testRank = assert (rank (singleton (1 :: Integer)) == 0)

testRoot :: Assertion
testRoot = assert (root (singleton (1 :: Integer)) == 1)

propHeap :: [Integer] -> Property
propHeap xs = not (null xs) ==> findMin (fromList xs) == minimum xs

propDeleteMin :: [Integer] -> Property
propDeleteMin xs = length xs > 1 ==>
        let h = fromList xs
            h' = deleteMin h
         in findMin h' == sort xs !! 1

tests :: [Test]
tests = [
        testCase "Rank" testRank
      , testCase "Root" testRoot
      , testProperty "Heap" propHeap
      , testProperty "DeleteMin" propDeleteMin
    ]

