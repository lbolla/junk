module FiniteMap where

import Prelude hiding (lookup)

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
    lookup k E = Nothing
    lookup k (T l e r)
        | k < fst e = lookup k l
        | k > fst e = lookup k r
        | otherwise = Just $ snd e

fromList :: Ord k => [(k, v)] -> KVTree k v
fromList = foldr (uncurry bind) empty
