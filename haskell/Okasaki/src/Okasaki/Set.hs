module Okasaki.Set (Set(..)) where

class Set s where
    empty :: s a
    insert :: Ord a => a -> s a -> s a
    member :: Ord a => a -> s a -> Bool
