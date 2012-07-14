module Main where

import Test.Framework (defaultMain, testGroup)
import Test.Framework.Providers.HUnit
import Test.Framework.Providers.QuickCheck2 (testProperty)
import Test.QuickCheck
import Test.HUnit

import Data.Maybe (isNothing, fromJust)

import Heap
import LeftistHeap
import Stack

main :: IO ()
main = defaultMain tests

tests = [
        testGroup "Stack" [
                         testCase "Empty Stack" test_emptyStack
                       , testCase "non-Empty Stack" test_nonEmptyStack
        ]
--         testGroup "Heap" [
--                          testCase "Empty Heap" test_emptyHeap
--                        , testCase "non-Empty Heap" test_nonEmptyHeap
-- --                        , testProperty "Empty Heap" prop_emptyHeap
--         ]
    ]

test_emptyStack = assert $ isNothing (hd Nil)
test_nonEmptyStack = assert $ fromJust (hd $ Cons 1 Nil) == 1

-- test_emptyHeap = assert $ isEmpty E

-- test_nonEmptyHeap = assert $ not . isEmpty $ T 1

-- prop_emptyHeap xs = (xs :: [Int]) == xs
