data BookInfo = Book Int String [String] deriving (Show)
data BookReview = BookReview BookInfo CustomerID ReviewBody
type CustomerID = Int
type ReviewBody = String

myInfo :: BookInfo
myInfo = Book 9780135072455 "Algebra of Programming"["Richard Bird", "Oege de Moor"]

bookID :: BookInfo -> Int
bookID (Book bookId _ _) = bookId

main :: IO()
main = putStrLn . show . bookID $ myInfo
