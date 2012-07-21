module Okasaki.ListStack (
     ListStack(..)
   , empty
   , isEmpty
   , cons
   , hd
   , tl
) where

import Okasaki.Stack

data ListStack a = ListStack [a]

instance Stack ListStack where
    empty = ListStack []
    isEmpty (ListStack s) = null s
    cons a (ListStack s) = ListStack $ a:s
    hd (ListStack s) = head s
    tl (ListStack s) = ListStack $ tail s
