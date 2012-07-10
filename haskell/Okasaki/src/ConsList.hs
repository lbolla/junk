module ConsList (ConsList(..)) where

import Prelude hiding (head, tail)
import List

data ConsList a = Nil | Cons a (ConsList a)

instance List ConsList where
    head Nil = Nothing
    head (Cons h _) = Just h
    tail Nil = Nothing
    tail (Cons _ t) = Just t
