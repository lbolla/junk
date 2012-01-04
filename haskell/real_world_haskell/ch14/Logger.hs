module Main where

hello :: String -> String
hello name = "hello " ++ name

type Log = [String]
data Logger a = Logger { runLogger :: (a, Log) } deriving (Show)

record :: String -> Logger ()
record s = Logger ((), [s])

instance Monad Logger where
        return x = Logger (x, [])
        l >>= f = Logger (newVal, oldLog ++ newLog)
                where (oldVal, oldLog) = runLogger l
                      (newVal, newLog) = runLogger $ f oldVal
