module Main where

-- TODO
-- less imperative
-- use more of Chunk data struct
-- comments on SO
-- upload on hackage
-- usage

import Prelude hiding (catch)
import Control.Exception (finally)
import Control.Monad (unless)
import Data.List (isPrefixOf)
import Data.Maybe (isNothing, fromJust)
import System.Directory (getTemporaryDirectory, removeFile)
import System.Environment (getArgs)
import System.IO
import System.IO.Error (catch)
import Test.Framework (defaultMain, testGroup)
import Test.Framework.Providers.QuickCheck2 (testProperty)

-- Chunk of a file
data Chunk = Chunk Handle Integer Integer

-- Is char newline?
isNL :: Char -> Bool
isNL c = c == '\n'

prop_isNL :: Char -> Bool
prop_isNL '\n' = isNL '\n'
prop_isNL c = not $ isNL c

-- Are we at the beginning of file?
isBOF :: Handle -> IO Bool
isBOF = fmap (== 0) . hTell

--  prop_isBOF_newFile :: IO Bool
--  prop_isBOF_newFile = withTempFile "prop_isBOF" $ \f h ->
--          isBOF h

-- Go to beginning of line
goToBOL :: Handle -> IO ()
goToBOL h = do
        bof <- isBOF h
        unless bof $
           do eof <- hIsEOF h
              if eof
                 then do hSeek h RelativeSeek (-2)
                         goToBOL h
                 else do c <- hGetChar h
                         unless (isNL c) $
                             do hSeek h RelativeSeek (-2)
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
goTo h = hSeek h AbsoluteSeek

search :: Chunk -> String -> IO (Maybe String)
search (Chunk h start end) str
        | start >= end = return Nothing
        | otherwise = if mid == (end - 1)
                         then return Nothing
                         else do
                                 goTo h mid
                                 midLine <- getCurrentLine h
                                 prevLine <- getPrevLine h
                                 if str `isPrefixOf` midLine && (isNothing prevLine || not (str `isPrefixOf` fromJust prevLine))
                                    then return $ Just midLine
                                    else if str < midLine
                                            then search (Chunk h start mid) str
                                            else search (Chunk h mid end) str
           where mid = (start + end) `div` 2

sgrep :: Handle -> String -> IO ()
sgrep h s = do
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
        withFile fname ReadMode (`sgrep` s)

runTests = defaultMain tests

tests = [
        testGroup "isNL" [
                testProperty "isNL" prop_isNL
                ]--,
        --  testGroup "isBOF" [
        --          testProperty "newFile" prop_isBOF_newFile
        --          ]
        ]

withTempFile :: String -> (FilePath -> Handle -> IO a) -> IO a
withTempFile pattern func = do
        tempdir <- catch getTemporaryDirectory (\_ -> return ".")
        (tempfile, temph) <- openTempFile tempdir pattern
        finally (func tempfile temph)
                (do hClose temph
                    removeFile tempfile)
