import Data.Char
import Data.List
import Data.Maybe

stringToInt :: String -> Maybe Int
stringToInt s = if (null digits)
                   then Nothing
                   else Just $ foldl' (\x y -> 10 * x + y) 0 digits
           where digits = catMaybes $ map charToInt s

charToInt :: Char -> Maybe Int
charToInt c = if c `elem` ['0'..'9']
                 then Just $ ord(c) - ord('0')
                 else Nothing
