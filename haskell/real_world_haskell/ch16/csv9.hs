import Text.ParserCombinators.Parsec

csvFile = endBy line eol
line = sepBy cell (char ',')
cell = quotedCell <|> many (noneOf ",\n")

quotedCell = do
        char '"'
        content <- many quotedChar
        char '"' <?> "quote at end of cell"
        return content

quotedChar = noneOf "\"" <|>
        try (string "\"\"" >> return '"')

eol = try (string "\n\r")
  <|> try (string "\r\n")
  <|> string "\n"
  <|> string "\r"
  <?> "end of line"
