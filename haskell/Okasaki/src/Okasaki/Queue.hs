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

data Queue a = Queue {front :: [a], back :: [a]} deriving Show

empty :: Queue a
empty = Queue [] []

isEmpty :: Queue a -> Bool
isEmpty q = null (front q) && null (back q)

snoc :: a -> Queue a -> Queue a
snoc x q = Queue { front = front q, back = x : back q}

hd :: Queue a -> a
hd q | isEmpty q = error "Empty queue"
hd q = case (front q) of
           [] -> hd $ Queue { front = reverse (back q), back = [] }
           _ -> head $ front q

tl :: Queue a -> Queue a
tl q | isEmpty q = error "Empty queue"
tl q = case (front q) of
           [] -> tl $ Queue { front = reverse (back q), back = [] }
           _ -> Queue { front = tail (front q) ++ reverse (back q), back = [] }

fromList :: [a] -> Queue a
fromList = foldl' (flip snoc) empty
