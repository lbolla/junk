{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module Supply (
          Supply
        , runSupply
        , nextS
        ) where

import Control.Monad.State

newtype Supply s a = S (State [s] a) deriving (Monad)

runSupply (S s) = runState s

nextS :: Supply s (Maybe s)
nextS = S $ do st <- get
               case st of
                    [] -> return Nothing
                    (x:xs) -> do put xs
                                 return (Just x)
