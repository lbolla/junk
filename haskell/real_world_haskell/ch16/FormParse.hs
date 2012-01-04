import Text.ParserCombinators.Parsec
import Control.Monad (liftM2)

type KeyVal = (String, Maybe String)

query :: CharParser () [KeyVal]
query = sepBy pair (char '&')

pair :: CharParser () KeyVal
--  pair = do
--          key <- many1 alphaNum
--          value <- optionMaybe (char '=' >> many alphaNum)
--          return (key, value)
pair = liftM2 (,) (many1 alphaNum) (optionMaybe (char '=' >> many alphaNum))
