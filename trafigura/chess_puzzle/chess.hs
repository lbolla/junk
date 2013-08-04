import Control.Monad (forM_)
import Data.List (permutations)

data Piece = K | Q | R | N | B deriving (Show)
type Position = (Int, Int)
type Cell = (Position, Piece)
data Board = Board Int Int [Cell] deriving (Show)

printBoard :: Board -> IO ()
printBoard (Board n m cells) = do
        forM_ [0..n-1] $ \i -> do
            forM_ [0..m-1] $ \j -> do
                case lookup (i, j) cells of
                    Just piece -> putStr $ show piece
                    Nothing -> putStr "."
            putStrLn ""

influencedPositions :: Board -> Cell -> [Position]
influencedPositions (Board n m _) ((i, j), piece) =
        case piece of
            K -> trim [(i - 1, j - 1), (i, j - 1), (i + 1, j - 1),
                       (i - 1, j    ),             (i + 1, j    ),
                       (i - 1, j + 1), (i, j + 1), (i + 1, j + 1)]
            R -> trim $ filter (/= (i, j)) $
                    [(i + ii, j) | ii <- [-n..n]] ++ [(i, j + jj) | jj <- [-m..m]]
    where
        trim :: [Position] -> [Position]
        trim ps = [p | p@(i, j) <- ps, 0 <= i && i <= n && 0 <= j && j <= m]

allInfluencedPositions :: Board -> [Position]
allInfluencedPositions board@(Board _ _ cells) =
        concatMap (influencedPositions board) cells

isValid :: Board -> Bool
isValid board@(Board _ _ cells) =
        all (not . attacked) cells
    where
        attacked cell = (fst cell) `elem` allInfluencedPositions board

--  validBoards :: Int -> Int -> [Piece] -> [Board]
--  validBoards n m ps = filter isValid [Board n m cells | cells <- allCells]
    --  where allCells :: [Cell]
          --  allCells = 

main :: IO ()
main = do
        printBoard board
        print $ influencedPositions board ((0, 0), R)
        print $ allInfluencedPositions board
        print $ isValid board
    where
        board = Board 3 3 [((0, 0), K), ((2, 2), R)]
