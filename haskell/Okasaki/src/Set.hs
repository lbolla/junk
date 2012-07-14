module Set (Set(..)
          , UnbalancedSet
) where

class Set s where
    empty :: s a
    insert :: Ord a => a -> s a -> s a
    member :: Ord a => a -> s a -> Bool

data UnbalancedSet a = E | T (UnbalancedSet a) a (UnbalancedSet a) deriving Show

instance Set UnbalancedSet where
    empty = E
    member _ E = False
    member x (T a y b)
        | x < y = member x a
        | x > y = member x b
        | otherwise = True
    insert x E = T E x E
    insert x t@(T a y b)
        | x < y = T (insert x a) y b
        | x > y = T a y (insert x b)
        | otherwise = t

fromList :: Ord a => [a] -> UnbalancedSet a
fromList = foldr insert empty

-- Exercise 2.2
member' :: Ord a => a -> UnbalancedSet a -> Bool
member' z t = member'' z Nothing t
    where member'' :: Ord a => a -> Maybe a -> UnbalancedSet a -> Bool
          member'' _ Nothing E = False
          member'' x (Just c) E = x == c
          member'' x c (T a y b)
              | x < y = member'' x c a
              | otherwise = member'' x (Just y) b

-- Exercise 2.5a
complete :: Ord a => a -> Integer -> UnbalancedSet a
complete _ 0 = E
complete x 1 = T E x E
complete x d = let a = complete x (d - 1) in T a x a

-- Exercise 2.5b
create :: Ord a => a -> Integer -> UnbalancedSet a
create _ 0 = E
create x n
    | (n - 1) `rem` 2 == 0 = let a = create x (n `div` 2) in T a x a
    | otherwise = let
        m = (n - 1) `div` 2
        a = create x m
        b = create x (m + 1)
        in T a x b
