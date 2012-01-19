module Main where

import Data.Char (toLower)
import Data.Maybe (catMaybes)

char2Digit :: Char -> Maybe Char
char2Digit c
        | cc `elem` "e" = Just '0'
        | cc `elem` "jnp" = Just '1'
        | cc `elem` "rwx" = Just '2'
        | cc `elem` "dsy" = Just '3'
        | cc `elem` "ft" = Just '4'
        | cc `elem` "am" = Just '5'
        | cc `elem` "civ" = Just '6'
        | cc `elem` "bku" = Just '7'
        | cc `elem` "lop" = Just '8'
        | cc `elem` "ghz" = Just '9'
        | otherwise = Nothing
        where cc = toLower c

word2Number :: String -> String
word2Number = catMaybes . map char2Digit

readNumber :: String -> String
readNumber = filter (`elem` "0123456789")

main :: IO ()
main = putStrLn . show $ word2Number "lorenzo-"
