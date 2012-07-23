module Okasaki.Tests.Queue (tests) where

import Test.Framework (Test)
import Test.Framework.Providers.HUnit (testCase)
import Test.Framework.Providers.QuickCheck2 (testProperty)
import Test.HUnit (assert, Assertion)
import Test.QuickCheck ((==>), Property)

import Okasaki.Queue

testEmpty :: Assertion
testEmpty = assert $ isEmpty empty

propHd :: [Integer] -> Property
propHd xs = not (null xs) ==> hd (fromList xs) == head xs

tests :: [Test]
tests = [
        testCase "Empty" testEmpty
      , testProperty "Hd" propHd
    ]
