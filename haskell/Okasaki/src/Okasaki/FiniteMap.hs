module Okasaki.FiniteMap where

import Prelude hiding (lookup)
import Test.Framework (Test)
import Test.Framework.Providers.HUnit (testCase)
import Test.Framework.Providers.QuickCheck2 (testProperty)
import Test.HUnit (assert, Assertion)

import Data.Maybe (isNothing, isJust)

-- Exercise 2.6
class FiniteMap m where
    empty :: m k v
    bind :: Ord k => k -> v -> m k v -> m k v
    lookup :: Ord k => k -> m k v -> Maybe v

data KVTree k v = E | T (KVTree k v) (k, v) (KVTree k v) deriving Show

instance FiniteMap KVTree where
    empty = E
    bind k v E = T E (k, v) E
    bind k v t@(T l e r)
        | k < fst e = T (bind k v l) e r
        | k > fst e = T l e (bind k v r)
        | otherwise = t
    lookup _ E = Nothing
    lookup k (T l e r)
        | k < fst e = lookup k l
        | k > fst e = lookup k r
        | otherwise = Just $ snd e

fromList :: Ord k => [(k, v)] -> KVTree k v
fromList = foldr (uncurry bind) empty

-------------------------------------------------------------------------------
-- TESTS

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
