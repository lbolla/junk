module Main where

import Test.Framework (defaultMain, testGroup, Test)

import qualified Stack
import qualified Set
import qualified Heap
import qualified FiniteMap
import qualified BinomialHeap
import qualified RBTree
import qualified Queue

main :: IO ()
main = defaultMain tests

tests :: [Test]
tests = [
        testGroup "Stack" Stack.tests
      , testGroup "Set" Set.tests
      , testGroup "Heap" Heap.tests
      , testGroup "FiniteMap" FiniteMap.tests
      , testGroup "BinomialHeap" BinomialHeap.tests
      , testGroup "RBTree" RBTree.tests
      , testGroup "Queue" Queue.tests
    ]
