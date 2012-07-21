module Main where

import Test.Framework (defaultMain, testGroup, Test)

import qualified Okasaki.Tests.ConsStack
import qualified Okasaki.Tests.ListStack
import qualified Okasaki.Set
import qualified Okasaki.Heap
import qualified Okasaki.FiniteMap
import qualified Okasaki.BinomialHeap
import qualified Okasaki.RBTree
import qualified Okasaki.Queue

main :: IO ()
main = defaultMain tests

tests :: [Test]
tests = [
        testGroup "ConsStack" Okasaki.Tests.ConsStack.tests
      , testGroup "ListStack" Okasaki.Tests.ListStack.tests
      , testGroup "Set" Okasaki.Set.tests
      , testGroup "Heap" Okasaki.Heap.tests
      , testGroup "FiniteMap" Okasaki.FiniteMap.tests
      , testGroup "BinomialHeap" Okasaki.BinomialHeap.tests
      , testGroup "RBTree" Okasaki.RBTree.tests
      , testGroup "Queue" Okasaki.Queue.tests
    ]
