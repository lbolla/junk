-- TODO: do not catch exception!
-- catch can only be done in the IO monad
-- use retry on Either types, instead.

module Retry where

import Control.Exception
import Prelude hiding (catch)
import System.Random

retryHandler :: IO a -> SomeException -> IO a
retryHandler action = \e -> do
        putStrLn $ show e ++ ": retrying"
        action

randomBit :: IO Int
randomBit = getStdRandom $ randomR (0, 1)

data Retry a = R { runRetry :: a }

instance Monad Retry where
        return a = R $ do
                a `catch` (retryHandler a)
        m >>= f = R res
                where m' = runRetry m
                      res = runRetry (f m')

--  test :: Retry (IO ())
--  test = R $ do
--          bit <- randomBit
--          if bit == 0 then
--             error "nooo"
--          else
--             putStrLn "ok"
--          `catch` (retryHandler $ runRetry test)

test :: IO ()
test = do
        bit <- randomBit
        if bit == 0 then
           error "nooo"
        else
           putStrLn "ok"
