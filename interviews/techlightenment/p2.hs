module Main where

import System.Environment (getArgs)

onesIn :: Char -> Int
onesIn '0' = 0
onesIn '1' = 1
onesIn '2' = 1
onesIn '3' = 2
onesIn '4' = 1
onesIn '5' = 2
onesIn '6' = 2
onesIn '7' = 3
onesIn '8' = 1
onesIn '9' = 2
onesIn 'a' = 2
onesIn 'b' = 3
onesIn 'c' = 2
onesIn 'd' = 3
onesIn 'e' = 3
onesIn 'f' = 4
onesIn _ = error "invalid hex number"

hex_bitcount :: String -> Int
hex_bitcount s = sum $ map onesIn s

main :: IO ()
main = do
        args <- getArgs
        print $ hex_bitcount $ head args
