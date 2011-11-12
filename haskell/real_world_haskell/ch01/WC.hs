import System.Environment (getArgs)

wordCount = show . length . lines
charCount = show . length

--  From stdin
--  main = interact wordCount

--  From file
main = do
        [fname] <- getArgs
        c <- readFile fname
        putStrLn $ wordCount c ++ " " ++ charCount c

--  From file - pipeline
--  main = getArgs >>= return . head >>= readFile >>= return . wordCount >>= putStrLn
--  main = getArgs >>= return . head >>= readFile >>= return . charCount >>= putStrLn
