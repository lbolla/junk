module Main where

import Heap
import LeftistHeap

main :: IO ()
main = do
        print $ isEmpty E
        print $ isEmpty $ T (1 :: Integer)
