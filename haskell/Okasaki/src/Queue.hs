module Queue (Queue(..)) where

class Queue q where
    empty :: q
    isEmpty :: q -> Bool
