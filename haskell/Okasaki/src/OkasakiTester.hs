module Main where

import Test.Framework (defaultMain, testGroup)
import Test.Framework.Providers.HUnit
import Test.Framework.Providers.QuickCheck2 (testProperty)
import Test.QuickCheck
import Test.HUnit

import Heap
import LeftistHeap

main :: IO ()
main = defaultMain tests

tests = [
        testGroup "Heap" [
                         testCase "Empty Heap" emptyHeap
                       , testCase "non-Empty Heap" nonEmptyHeap
                       , testProperty "Empty Heap" prop_emptyHeap
        ]
    ]

emptyHeap = assert $ isEmpty E

nonEmptyHeap = assert $ not . isEmpty $ T 1

prop_emptyHeap xs = (xs :: [Int]) == xs
