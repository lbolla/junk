module Okasaki.ConsStack (
     ConsStack(..)
   , empty
   , isEmpty
   , cons
   , hd
   , tl
) where

import Okasaki.Stack

data ConsStack a = Nil | Cons a (ConsStack a)

instance Stack ConsStack where
    empty = Nil
    isEmpty Nil = True
    isEmpty _ = False
    cons = Cons
    hd Nil = error "Empty ConsStack"
    hd (Cons h _) = h
    tl Nil = error "Empty ConsStack"
    tl (Cons _ t) = t
