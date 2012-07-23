module Okasaki.Tests.RBTree (tests) where

import Test.Framework (Test)
import Test.Framework.Providers.HUnit (testCase)
import Test.Framework.Providers.QuickCheck2 (testProperty)
import Test.HUnit (assert, Assertion)
import Test.QuickCheck ((==>), Property)

import Data.List (nub)

import Okasaki.RBTree

testInsert :: Assertion
testInsert = let t = fromList [25,1,26,24,24,-1,27,28,-2,0,-3,-4,2,0]
                 in assert $ member (1 :: Integer) t

propMember :: [Integer] -> Bool
propMember xs = let t = fromList xs in all (`member` t) xs

propDepth :: [Integer] -> Property
propDepth xs = not (null xs) && (length xs < 10) ==>
               let (m, mm) = minMaxDepth $ fromList xs
                   n = fromIntegral (length (nub xs)) :: Float
                   d = floor $ log n / log 2.0
                in m <= d && d <= mm

tests :: [Test]
tests = [
        testCase "Insert" testInsert
      , testProperty "Member" propMember
      , testProperty "Depth" propDepth
    ]
