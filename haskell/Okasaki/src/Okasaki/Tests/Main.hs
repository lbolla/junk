module Main where

import Test.Framework (defaultMain, testGroup, Test)

import qualified Okasaki.Tests.ConsStack
import qualified Okasaki.Tests.ListStack
import qualified Okasaki.Tests.UnbalancedSet
import qualified Okasaki.Tests.LeftistHeap
import qualified Okasaki.Tests.KVTree
import qualified Okasaki.Tests.BinomialHeap
import qualified Okasaki.Tests.RBTree
import qualified Okasaki.Tests.Queue

main :: IO ()
main = defaultMain tests

tests :: [Test]
tests = [
        testGroup "ConsStack" Okasaki.Tests.ConsStack.tests
      , testGroup "ListStack" Okasaki.Tests.ListStack.tests
      , testGroup "UnbalancedSet" Okasaki.Tests.UnbalancedSet.tests
      , testGroup "LeftistHeap" Okasaki.Tests.LeftistHeap.tests
      , testGroup "FiniteMap" Okasaki.Tests.KVTree.tests
      , testGroup "BinomialHeap" Okasaki.Tests.BinomialHeap.tests
      , testGroup "RBTree" Okasaki.Tests.RBTree.tests
      , testGroup "Queue" Okasaki.Tests.Queue.tests
    ]
