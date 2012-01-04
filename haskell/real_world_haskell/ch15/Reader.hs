module Main where

newtype Reader e a = R { runReader :: e -> a }

instance Monad (Reader e) where
        return a = R $ \_ -> a
        m >>= f = R $ \r -> runReader (f (runReader m r)) r

ask :: Reader e e
ask = R id
