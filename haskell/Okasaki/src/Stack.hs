module Stack (Stack(..)) where

class Stack s where
    empty :: s a
    isEmpty :: s a -> Bool
    cons :: a -> s a -> s a
    hd :: s a -> a
    tl :: s a -> s a

data ListStack a = ListStack [a]

instance Stack ListStack where
    empty = ListStack []
    isEmpty (ListStack s) = null s
    cons a (ListStack s) = ListStack $ a:s
    hd (ListStack s) = head s
    tl (ListStack s) = ListStack $ tail s

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
