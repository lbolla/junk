module List (List(..)) where

class List l where
    head :: l a -> Maybe a
    tail :: l a -> Maybe (l a)
