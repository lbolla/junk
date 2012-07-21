module Okasaki.Stack (Stack(..)) where

class Stack s where
    empty :: s a
    isEmpty :: s a -> Bool
    cons :: a -> s a -> s a
    hd :: s a -> a
    tl :: s a -> s a
