{-# LANGUAGE DeriveFunctor #-}

module Functors where

instance Functor (Either e) where
        fmap g (Right a) = Right (g a)
        fmap g (Left a) = Left a

data Pair a = Pair a a deriving (Show, Functor)

--  instance Functor Pair where
--          fmap g (Pair a b) = Pair (g a) (g b)


instance Functor ((->) a) where
        fmap g f = g . f

data ITree a = Leaf (Int -> a) | Node [ITree a]

instance Functor ITree where
        fmap g (Leaf f) = Leaf $ fmap g f
        fmap g (Node xs) = Node $ (fmap . fmap) g xs
