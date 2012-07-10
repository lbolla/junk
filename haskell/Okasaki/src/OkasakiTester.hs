module Main where

import Test.Framework (defaultMain, testGroup)
import Test.Framework.Providers.HUnit
import Test.Framework.Providers.QuickCheck2 (testProperty)
import Test.QuickCheck
import Test.HUnit

import Data.Maybe (isNothing, fromJust)

import Prelude hiding (head, tail)
import Heap
import LeftistHeap
import List
import ConsList

main :: IO ()
main = defaultMain tests

tests = [
        testGroup "Heap" [
                         testCase "Empty Heap" test_emptyHeap
                       , testCase "non-Empty Heap" test_nonEmptyHeap
--                        , testProperty "Empty Heap" prop_emptyHeap
        ],
        testGroup "List" [
                         testCase "Empty List" test_emptyList
                       , testCase "non-Empty List" test_nonEmptyList
        ]
    ]

test_emptyHeap = assert $ isEmpty E

test_nonEmptyHeap = assert $ not . isEmpty $ T 1

-- prop_emptyHeap xs = (xs :: [Int]) == xs

test_emptyList = assert $ isNothing (head Nil)

test_nonEmptyList = assert $ fromJust (head $ Cons 1 Nil) == 1
