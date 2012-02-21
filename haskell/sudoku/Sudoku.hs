module Main where

import Data.List (nub, concat, findIndices)
import Control.Monad (liftM2, forM, join)
import Data.Maybe (catMaybes, fromMaybe)
import Debug.Trace

type Board = String

main :: IO ()
main = interact $ showBoard . fromMaybe "Solution not found" . solve . parseBoard

solve :: Board -> Maybe Board
--  solve board | trace (showBoard board) False = undefined
solve board = if isObviouslyWrong board
                 then Nothing
                 else go dotIdxs
        where dotIdxs = findIndices (== '.') board
              go [] = Just board
              go dotIdxs = safeHead . catMaybes $ liftM2 (\idx val -> solve (set board idx val)) dotIdxs ['1'..'9']

set :: Board -> Int -> Char -> Board
set board idx val = take idx board ++ [val] ++ drop (idx + 1) board

safeHead :: [a] -> Maybe a
safeHead [] = Nothing
safeHead (x:_) = Just x

blockIdxs :: [[Int]]
blockIdxs = concat [
        [[r * 9 + c | c <- [0..8]] | r <- [0..8]]  -- rows
      , [[r * 9 + c | r <- [0..8]] | c <- [0..8]]  -- cols
      , [[r * 9 + c | r <- [rb..rb + 2], c <- [cb..cb + 2]] | rb <- [0,3..8], cb <- [0,3..8]]  -- blocks
        ]

isObviouslyWrong :: Board -> Bool
isObviouslyWrong board = any (isWrong board) blockIdxs
        where isWrong board blockIdx = nub blockNoDots /= blockNoDots
               where blockNoDots = filter (/= '.') block
                     block = map (board !!) blockIdx

parseBoard :: Board -> Board
parseBoard = filter (`elem` "123456789.")

showBoard :: Board -> String
showBoard board = unlines $ map (showRow board) [0..8]
        where showRow board irow = show $ take 9 $ drop (irow * 9) board

--  board :: String
--  board = parseBoard "4.....8.5.3..........7......2.....6.....8.4......1.......6.3.7.5..2.....1.4......"
--  board = parseBoard "..3.2.6..9..3.5..1..18.64....81.29..7.......8..67.82....26.95..8..2.3..9..5.1.3.."
--  board = parseBoard "483921657967345821251876493548132976729564138136798245372689514814253769695417382"
--  board = parseBoard "483...6..967345....51....93548132976..95641381367982453..689514814253769695417..2"
--  board = parseBoard "..3.2.6..9..3.5..1..18.64....81.29..7.......8..67.82....26.95..8..2.3..9..5.1.3.."
--  other examples: http://norvig.com/top95.txt
