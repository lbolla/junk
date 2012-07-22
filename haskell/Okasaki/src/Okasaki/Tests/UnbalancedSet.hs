module Okasaki.Tests.UnbalancedSet (tests) where

import Test.Framework (Test)
import Test.Framework.Providers.HUnit (testCase)
import Test.Framework.Providers.QuickCheck2 (testProperty)
import Test.HUnit (assert, Assertion)
import Test.QuickCheck ((==>), Property)

import Okasaki.UnbalancedSet

root :: UnbalancedSet a -> a
root E = error "Empty set"
root (T _ x _) = x

isBST :: Ord a => UnbalancedSet a -> Bool
isBST E = True
isBST (T E _ E) = True
isBST (T l x E) = root l <= x && isBST l
isBST (T E x r) = x < root r && isBST r
isBST (T l x r) = (root l <= x) && (x <  root r) && isBST l && isBST r

test1 :: Assertion
test1 = assert . member 1 $ fromList [1 :: Integer]

test2 :: Assertion
test2 = assert . member' 1 $ fromList [1 :: Integer]

test3 :: Assertion
test3 = assert . member 1 $ complete (1 :: Integer) 1

test4 :: Assertion
test4 = assert . not . member 1 $ create (1 :: Integer) 0

propFromList :: [Integer] -> Bool
propFromList = isBST . fromList

propMember :: [Integer] -> Bool
propMember xs = let t = fromList xs in all (`member` t) xs

propComplete :: Integer -> Bool
propComplete n = isComplete $ complete n (1 :: Integer)

isComplete :: UnbalancedSet a -> Bool
isComplete E = True
isComplete (T E _ E) = True
isComplete (T _ _ E) = False
isComplete (T E _ _) = False
isComplete (T l _ r) = isComplete l && isComplete r

propCreate :: Integer -> Property
propCreate n = (n > 0) ==> size (create (1 :: Integer) n) == n

size :: UnbalancedSet a -> Integer
size E = 0
size (T l _ r) = size l + 1 + size r

tests :: [Test]
tests = [
        testCase "test1" test1
      , testCase "test2" test2
      , testCase "test3" test3
      , testCase "test4" test4
      , testProperty "fromList" propFromList
      , testProperty "member" propMember
      , testProperty "complete" propComplete
      , testProperty "create" propCreate
    ]


