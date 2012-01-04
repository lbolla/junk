import Text.ParserCombinators.Parsec

csvFile :: GenParser Char st [[String]]
csvFile = do
        result <- many line
        eof
        return result

line :: GenParser Char st [String]
line = do
        result <- cells
        eol
        return result

cells :: GenParser Char st [String]
cells = do
        first <- cellContent
        next <- remainingCells
        return (first:next)

cellContent :: GenParser Char st String
cellContent = do
        many (noneOf ",\n")

remainingCells :: GenParser Char st [String]
remainingCells = do
        (char ',' >> cells) <|> (return [])

eol :: GenParser Char st Char
eol = char '\n'

parseCSV :: String -> Either ParseError [[String]]
parseCSV input = parse csvFile "(unknown)" input
