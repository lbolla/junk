module Main where

import Criterion.Main

import qualified Okasaki.Set
import qualified Okasaki.Heap

pseudoRandom :: Integer -> [Integer]
pseudoRandom n = map f [1..n]
    where f :: Integer -> Integer
          f x = truncate $ ((realToFrac x / 7) - fromIntegral (truncate $ realToFrac x / 7)) * 100 * realToFrac x

main = defaultMain [
    bgroup "Set" [ bench "10" $ whnf Okasaki.Set.fromList $ pseudoRandom 10
                 , bench "20" $ whnf Okasaki.Set.fromList $ pseudoRandom 20
                 , bench "100" $ whnf Okasaki.Set.fromList $ pseudoRandom 100
                 ],
    bgroup "Heap" [ bench "10" $ whnf Okasaki.Heap.fromList $ pseudoRandom 10
                  , bench "20" $ whnf Okasaki.Heap.fromList $ pseudoRandom 20
                  , bench "10'" $ whnf Okasaki.Heap.fromList2 $ pseudoRandom 10
                  , bench "20'" $ whnf Okasaki.Heap.fromList2 $ pseudoRandom 20
                  ]
                 ]
