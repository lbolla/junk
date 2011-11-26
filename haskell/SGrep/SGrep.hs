module Main where

-- TODO
-- less imperative
-- use more of Chunk data struct
-- comments on SO
-- upload on hackage
-- quickcheck
-- usage

import System.Environment (getArgs)
import System.IO
import Data.List (isPrefixOf)
import Data.Maybe (isNothing, fromJust)

isNL :: Char -> Bool
isNL c = c == '\n'

-- Chunk of a file
data Chunk = Chunk Handle Integer Integer

isBOF :: Handle -> IO Bool
isBOF h = do
        pos <- hTell h
        if pos == 0
           then return True
           else return False

-- Go to beginning of line
goToBOL :: Handle -> IO ()
goToBOL h = do
        bof <- isBOF h
        if bof
           then return ()
           else do
                   eof <- hIsEOF h
                   if eof
                      then do
                              hSeek h RelativeSeek (-2)
                              goToBOL h
                      else do
                              c <- hGetChar h
                              if isNL c
                                 then return ()
                                 else do
                                         hSeek h RelativeSeek (-2)
                                         goToBOL h

getCurrentLine :: Handle -> IO String
getCurrentLine h = goToBOL h >> hGetLine h

getPrevLine :: Handle -> IO (Maybe String)
getPrevLine h = do
        goToBOL h
        bof <- isBOF h
        if bof
           then return Nothing
           else do
                   hSeek h RelativeSeek (-2)
                   goToBOL h
                   bof <- isBOF h
                   if bof
                      then return Nothing
                      else do
                              hSeek h RelativeSeek (-2)
                              goToBOL h
                              line <- hGetLine h
                              return $ Just line

goTo :: Handle -> Integer -> IO ()
goTo h i = do
        hSeek h AbsoluteSeek i

search :: Chunk -> String -> IO (Maybe String)
search (Chunk h start end) str
        | start >= end = return Nothing
        | otherwise = do
                if mid == (end - 1)
                   then return Nothing
                   else do
                           goTo h mid
                           midLine <- getCurrentLine h
                           prevLine <- getPrevLine h
                           --  putStrLn $ "*** " ++ show start ++ " " ++ show end ++ " " ++ show mid ++ " " ++ midLine ++ ", " ++ show prevLine
                           if str `isPrefixOf` midLine && ((isNothing prevLine) || not (str `isPrefixOf` (fromJust prevLine)))
                              then return $ Just midLine
                              else if str < midLine
                                      then search (Chunk h start mid) str
                                      else search (Chunk h mid end) str
           where mid = (start + end) `div` 2

run :: Handle -> String -> IO ()
run h s = do
        len <- hFileSize h
        match <- search (Chunk h 0 len) s
        --  putStrLn $ show match
        c <- hGetContents h
        putStrLn . unlines $ takeWhile (isPrefixOf s) (lines c)

main :: IO ()
main = do
        args <- getArgs
        let s = head args
        let fname = head $ tail args
        withFile fname ReadMode (\h -> run h s)
