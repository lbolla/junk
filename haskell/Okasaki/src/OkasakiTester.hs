module Main where

import Test.Framework (defaultMain, testGroup)

import qualified Stack
import qualified Set
import qualified Heap
import qualified FiniteMap
import qualified BinomialHeap

main :: IO ()
main = defaultMain tests

tests = [
        testGroup "Stack" Stack.tests
      , testGroup "Set" Set.tests
      , testGroup "Heap" Heap.tests
      , testGroup "FiniteMap" FiniteMap.tests
      , testGroup "BinomialHeap" BinomialHeap.tests
    ]
