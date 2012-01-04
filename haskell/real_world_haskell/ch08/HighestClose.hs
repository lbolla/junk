import qualified Data.ByteString.Lazy.Char8 as L

readPrice :: L.ByteString -> Maybe Int
--  readPrice s = L.readInt s
readPrice s = undefined

closing :: L.ByteString -> Maybe Int
closing = readPrice . (!! 4) . L.split ','

highestClose :: L.ByteString -> Maybe Int
highestClose = maximum . (Nothing:) . map closing . L.lines

highestCloseFrom :: FilePath -> IO ()
highestCloseFrom path = do
        contents <- L.readFile path
        print $ highestClose contents
