module Okasaki.Tests.ConsStack (tests) where

import Test.Framework (Test)
import Test.Framework.Providers.HUnit (testCase)
import Test.HUnit (assert, Assertion)

import Okasaki.ConsStack

testHead :: Assertion
testHead = assert $ hd (Cons 1 empty) == (1 :: Integer)

testEmptyStack :: Assertion
testEmptyStack = assert $ isEmpty (empty :: ConsStack Int)

testCons :: Assertion
testCons = assert . not . isEmpty $ Cons (1 :: Integer) empty

testTail :: Assertion
testTail = assert . isEmpty . tl $ Cons (1 :: Integer) empty

tests :: [Test]
tests = [
        testCase "Head" testHead
      , testCase "Tail" testTail
      , testCase "Empty Stack" testEmptyStack
      , testCase "Cons" testCons
    ]
