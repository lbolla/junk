module Okasaki.Tests.ListStack (tests) where

import Test.Framework (Test)
import Test.Framework.Providers.HUnit (testCase)
import Test.HUnit (assert, Assertion)

import Okasaki.ListStack

testHead :: Assertion
testHead = assert $ hd (ListStack [1]) == (1 :: Integer)

testEmptyStack :: Assertion
testEmptyStack = assert $ isEmpty (empty :: ListStack Integer)

testCons :: Assertion
testCons = assert . not . isEmpty $ ListStack [1]

testTail :: Assertion
testTail = assert . isEmpty . tl $ ListStack [1]

tests :: [Test]
tests = [
        testCase "Head" testHead
      , testCase "Tail" testTail
      , testCase "Empty Stack" testEmptyStack
      , testCase "Cons" testCons
    ]

