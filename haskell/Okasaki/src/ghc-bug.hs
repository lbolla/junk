{-# LANGUAGE Rank2Types #-}

class Set s where
    insert :: Ord a => a -> s a -> s a

data UnbalancedSet a = E | T (UnbalancedSet a) a (UnbalancedSet a)

instance Ord a => forall a . Set (UnbalancedSet a) where
    insert = undefined
