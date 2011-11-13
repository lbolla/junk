import Data.List (isPrefixOf)

findDefines :: String -> [String]
findDefines = foldr step [] . lines
        where step l ds
                      | "#define " `isPrefixOf` l = secondWord l : ds
                      | otherwise                 = ds
              secondWord = head . tail . words

main :: IO ()
main = interact $ show . findDefines
