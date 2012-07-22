module Okasaki.FiniteMap(FiniteMap(..)) where

class FiniteMap m where
    empty :: m k v
    bind :: Ord k => k -> v -> m k v -> m k v
    lookup :: Ord k => k -> m k v -> Maybe v
