module Main where

import Data.List (sort, sortBy, group)
import Data.Char (toLower)
import Data.Map (toAscList, fromListWith)

data Token = Token { word :: String, count :: Int }

lineWidth = 80 :: Int
invalidChars = ",:;.!?"

clearString :: String -> String
clearString s = map toLower $ filter (`notElem` invalidChars) s

-- Using sort
countTokensSort :: String -> [Token]
countTokensSort s = map 
	(\x -> Token (head x) (length x)) 
	(group . sort $ map clearString $ words s)

-- Using Data.Map
countTokensMap :: String -> [Token]
countTokensMap s = map 
	(uncurry Token)
	(toAscList (fromListWith (+) (zip (map clearString (words s)) (repeat 1))))

countTokens = countTokensMap

printToken :: Int -> Int -> Token -> IO ()
printToken offset maxCount (Token w c) = 
	let lenWord = length w;
		numSpaces = offset - lenWord + 1;
		numHashes = div (lineWidth * c) maxCount - numSpaces - lenWord
	in if numHashes <= 0 then
		return ()
	else
		putStrLn $
		w ++ 
		(concat $ (replicate numSpaces " ") ++ (replicate numHashes "#"))

printTokens :: [Token] -> IO ()
printTokens tokens =
	let offset = maximum $ map (length . word) tokens
	    maxCount = maximum $ map count tokens
	    sortedTokens = sortBy (\t1 t2 -> compare (count t2) (count t1)) tokens
	in mapM_ (printToken offset maxCount) sortedTokens

main = do
	words <- getContents
	printTokens $ countTokens words
