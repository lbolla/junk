module Okasaki.Queue (
     Queue
   , empty
   , isEmpty
   , snoc
   , hd
   , tl
   , fromList
) where

import Data.List (foldl')

data Queue a = Queue [a] [a] deriving Show

empty :: Queue a
empty = Queue [] []

isEmpty :: Queue a -> Bool
isEmpty (Queue [] _) = True
isEmpty _ = False

checkf :: [a] -> [a] -> Queue a
checkf [] b = Queue (reverse b) []
checkf f b = Queue f b

snoc :: a -> Queue a -> Queue a
snoc x (Queue f b) = checkf f (x:b)

hd :: Queue a -> a
hd (Queue [] _) = error "Empty queue"
hd (Queue f _) = head f

tl :: Queue a -> Queue a
tl (Queue [] _) = error "Empty queue"
tl (Queue f b) = checkf (tail f) b

fromList :: [a] -> Queue a
fromList = foldl' (flip snoc) empty
