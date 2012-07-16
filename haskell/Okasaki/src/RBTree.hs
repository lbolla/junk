module RBTree where

data Color = Red | Black deriving Show

data RBTree a = E | T Color (RBTree a) a (RBTree a) deriving Show

insert :: Ord a => a -> RBTree a -> RBTree a
insert z t = T Black l' y' r'
    where
        insert' x E = T Red E x E
        insert' x (T c l y r)
            | x < y = balance c (insert' x l) y r
            | x > y = balance c l y (insert' x r)
            | otherwise = t
        (T _ l' y' r') = insert' z t

balance :: Color -> RBTree a -> a -> RBTree a -> RBTree a
balance Black (T Red (T Red a x b) y c) z d = T Red (T Black a x b) y (T Black c z d)
balance Black (T Red a x (T Red b y c)) z d = T Red (T Black a x b) y (T Black c z d)
balance Black a z (T Red (T Red b y c) x d) = T Red (T Black a x b) y (T Black c z d)
balance Black a z (T Red b y (T Red c x d)) = T Red (T Black a x b) y (T Black c z d)
balance c l x r = T c l x r

fromList :: Ord a => [a] -> RBTree a
fromList = foldr insert E

leftSpine :: RBTree a -> Integer
leftSpine E = 0
leftSpine (T _ l _ _) = 1 + leftSpine l
