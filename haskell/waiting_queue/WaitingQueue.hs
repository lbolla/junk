import System.Random (randomR, getStdRandom)
import Data.List (sort)
import Control.Applicative ((<$>), liftA2)
import System.Environment (getArgs)
import Control.Monad (forM_)

minWaitingSecs :: Int
minWaitingSecs = 1

maxWaitingSecs :: Int
maxWaitingSecs = 60

waitingSecs :: IO Int
waitingSecs = getStdRandom (randomR (minWaitingSecs, maxWaitingSecs))

waitingSecsList :: Int -> IO [Int]
waitingSecsList n = sequence $ take n $ repeat waitingSecs

waitingTimeExclusive :: Int -> Int -> IO Int
--  waitingTimeExclusive ntills pos = fmap sum $ waitingSecsList avgPos
--          where avgPos = 1 + pos `div` ntills
waitingTimeExclusive ntills pos
        | pos < ntills = return 0
        | otherwise = fmap sum $ waitingSecsList avgPos
                where avgPos = 1 + (pos - ntills) `div` ntills

waitingTimeShared :: Int -> Int -> IO Int
waitingTimeShared ntills pos = waitingTimeShared' ntills pos (waitingSecsList pos) (return 0)

waitingTimeShared' :: Int -> Int -> IO [Int] -> IO Int -> IO Int
waitingTimeShared' ntills pos initTimes acc
        | pos < ntills = acc
        | otherwise = waitingTimeShared' ntills (pos - 1) nextTimes (liftA2 (+) first acc)
                where ret = do
                              initT <- initTimes
                              let (firstGroup, others) = splitAt ntills initT
                              let (first:rest) = sort firstGroup
                              let rest' = map (flip (-) first) rest
                              return (first, rest' ++ others)
                      first = fst <$> ret
                      nextTimes = snd <$> ret

avg :: (Integral b, Fractional a) => [b] -> a
avg xs = fromIntegral (sum xs) / fromIntegral (length xs)

simulate :: Fractional a =>
        Int ->                     -- how many simulations
        (Int -> Int -> IO Int) ->  -- waiting function
        Int ->                     -- number of tills
        Int ->                     -- starting position
        IO a
simulate n waitingFunc ntills pos = fmap avg $ sequence $ take n $ repeat $ waitingFunc ntills pos

main :: IO ()
main = do
        args <- getArgs
        let (ntills:pos:_) = map read args
        forM_ [0..pos] $ \pos -> do
                resE <- simulate 100 waitingTimeExclusive ntills pos
                resS <- simulate 100 waitingTimeShared ntills pos
                putStrLn $ show ntills ++ " " ++ show pos ++ " " ++ show resE ++ " " ++ show resS
