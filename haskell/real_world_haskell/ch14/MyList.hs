module Main where

newtype MyList a = L [a] deriving (Show)

unwrap (L a) = a

instance Monad MyList where
        return = L . return
        --  return x = L [x, x]
        --  return x = L []
        --  return = L . repeat
        m >>= f = L $ unwrap m >>= unwrap . f
