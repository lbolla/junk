module Main where

import Data.List (nubBy, concat, findIndices)
import Control.Monad (liftM2, forM, join, guard)
import Data.Maybe (catMaybes, fromMaybe)
import Debug.Trace

type Board = String

--  Some boards
--  other examples: http://norvig.com/top95.txt
boards :: [Board]
boards = map parseBoard [
        "4.....8.5.3..........7......2.....6.....8.4......1.......6.3.7.5..2.....1.4......",
        "..3.2.6..9..3.5..1..18.64....81.29..7.......8..67.82....26.95..8..2.3..9..5.1.3..",
        "483921657967345821251876493548132976729564138136798245372689514814253769695417382",
        "483...6..967345....51....93548132976..95641381367982453..689514814253769695417..2",
        "..3.2.6..9..3.5..1..18.64....81.29..7.......8..67.82....26.95..8..2.3..9..5.1.3..",
        ".2.4.6..76..2.753...5.8.1.2.5..4.8.9.6159...34.28.3..1216...49.......31.9.8...2.."
        ]

--  The idea is to try all the possibilities by substituting '.' with all
--  possible chars and verifying the constraint at every step. When there are
--  no more dots to try, backtrack.
--  This is done in the List monad.
solve :: Board -> [Board]
--  solve board | trace (showBoard board) False = undefined
solve board = go dotIdxs
        where dotIdxs = findIndices (== '.') board
              go :: [Int] -> [Board]
              go [] = do
                      -- no dots to try: just check constraints
                      guard $ not $ isObviouslyWrong board
                      return board
              --  go dotIdxs | trace (show dotIdxs) False = undefined
              go dotIdxs = do
                      -- in the List monad: try all the possibilities
                      idx <- dotIdxs
                      val <- ['1'..'9']
                      let newBoard = set board idx val
                      -- guard against invalid boards
                      guard $ not $ isObviouslyWrong board
                      -- carry on with the good ones
                      solve newBoard

--  Create a new board setting board[idx] = val
set :: Board -> Int -> Char -> Board
set board idx val = take idx board ++ [val] ++ drop (idx + 1) board

safeHead :: [a] -> Maybe a
safeHead [] = Nothing
safeHead (x:_) = Just x

--  Block of indices where to verify constraints
blockIdxs :: [[Int]]
blockIdxs = concat [
        [[r * 9 + c | c <- [0..8]] | r <- [0..8]]  -- rows
      , [[r * 9 + c | r <- [0..8]] | c <- [0..8]]  -- cols
      , [[r * 9 + c | r <- [rb..rb + 2], c <- [cb..cb + 2]] | rb <- [0,3..8], cb <- [0,3..8]]  -- blocks
        ]

--  Check if constrains hold on grid
--  This means that block defined in blockIdxs does not contain duplicates, a
--  part from '.'
isObviouslyWrong :: Board -> Bool
isObviouslyWrong board = any (isWrong board) blockIdxs
        where isWrong board blockIdx = hasDups $ map (board !!) blockIdx

--  Check if a string has duplicates, a part from '.'
hasDups :: String -> Bool
hasDups s = nubBy (\x y -> x == y && x /= '.') s /= s

--  Filter out spurious chars
parseBoard :: Board -> Board
parseBoard = filter (`elem` "123456789.")

--  Pretty output
showBoard :: Board -> String
showBoard board = unlines $ map (showRow board) [0..8]
        where showRow board irow = show $ take 9 $ drop (irow * 9) board

test :: Maybe Board
test = safeHead . solve $ boards !! 2

main :: IO ()
main = interact $ showBoard . fromMaybe "Solution not found" . safeHead . solve . parseBoard
