module Okasaki.Tests.LeftistHeap (tests) where

import Test.Framework (Test)
import Test.Framework.Providers.HUnit (testCase)
import Test.Framework.Providers.QuickCheck2 (testProperty)
import Test.HUnit (assert, Assertion)
import Test.QuickCheck ((==>), Property)

import Okasaki.LeftistHeap

testEmpty :: Assertion
testEmpty = assert $ isEmpty E

testFromList :: Assertion
testFromList = assert $ not . isEmpty $ fromList [1 :: Integer]

testFromList2 :: Assertion
testFromList2 = assert $ not . isEmpty $ fromList2 [1 :: Integer]

propMin :: [Integer] -> Property
propMin xs = not (null xs) ==> findMin (fromList xs) == minimum xs

isLeftist :: LeftistHeap a -> Bool
isLeftist E = True
isLeftist (T r _ a b) = (rank a >= rank b) && (r == rank b + 1)

propLeftist :: [Integer] -> Bool
propLeftist = isLeftist . fromList

checkRank :: LeftistHeap a -> Bool
checkRank E = rank E == 0
checkRank t@(T r _ a b) = (r == lengthRightSpine t) && 
                          (checkRank a) &&
                          (checkRank b)

lengthRightSpine :: LeftistHeap a -> Integer
lengthRightSpine E = 0
lengthRightSpine (T _ _ _ r) = 1 + lengthRightSpine r

propRank :: [Integer] -> Bool
propRank = checkRank . fromList

tests :: [Test]
tests = [
        testCase "Empty" testEmpty
      , testCase "fromList" testFromList
      , testCase "fromList2" testFromList2
      , testProperty "Min" propMin
      , testProperty "Leftist" propLeftist
      , testProperty "Rank" propRank
    ]
