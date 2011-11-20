module Main where

import Data.List (sort)
import System.Environment (getArgs)
import System.TimeIt (timeIt)

equalization_steps :: (Ord a, Fractional a) => [a] -> Int
equalization_steps xs = go xs [] [] 0
        where go xs old_xs veryold_xs n
                | xs == old_xs || xs == veryold_xs = -1
                | all_equal xs = n
                | otherwise = go (step xs) xs old_xs (n + 1)

avg :: (Fractional a) => [a] -> a
avg xs = sum xs / fromIntegral (length xs)

step :: (Ord a, Fractional a) => [a] -> [a]
step xs = zipWith (+) xs deltas
        where deltas = map (\x -> if x < a then 1 else -1) xs
              a = avg xs

all_equal :: (Eq a) => [a] -> Bool
all_equal [] = False
all_equal xs = all (== head xs) (tail xs)

main :: IO ()
main = timeIt $ do
        args <- getArgs
        print $ equalization_steps (read (head args))
