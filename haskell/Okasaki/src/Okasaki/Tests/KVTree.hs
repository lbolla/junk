module Okasaki.Tests.KVTree where

import Test.Framework (Test)
import Test.Framework.Providers.HUnit (testCase)
import Test.Framework.Providers.QuickCheck2 (testProperty)
import Test.HUnit (assert, Assertion)

import Prelude hiding (lookup)
import Data.Maybe (isNothing, isJust)

import Okasaki.KVTree

testEmpty :: Assertion
testEmpty = assert . isNothing $ lookup (1 :: Integer) E

testDup :: Assertion
testDup = assert $ lookup (1 :: Integer) m == Just (2 :: Integer)
    where m = fromList ([(1, 0), (1, 2)] :: [(Integer, Integer)])

propLookup :: [(Integer, Integer)] -> Bool
propLookup xs = let m = fromList xs in all (\x -> isJust (lookup (fst x) m)) xs

propBind :: (Integer, String) -> Bool
propBind (k, v) = let m = bind k v (empty :: KVTree Integer String)
                      in lookup k m == Just v

tests :: [Test]
tests = [
        testCase "Empty" testEmpty
      , testCase "Dup" testDup
      , testProperty "Lookup" propLookup
      , testProperty "Bind" propBind
    ]

