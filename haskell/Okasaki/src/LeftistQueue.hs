module LeftistQueue (LeftistQueue(..)) where

import Queue

data LeftistQueue a = E | Q a deriving Show

instance Queue (LeftistQueue a) where
    empty = E
    isEmpty E = True
    isEmpty _ = False
