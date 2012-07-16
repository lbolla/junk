import Criterion.Main

import qualified Set
import qualified Heap

pseudoRandom :: Integer -> [Integer]
pseudoRandom n = map f [1..n]
    where f :: Integer -> Integer
          f x = truncate $ ((realToFrac x / 7) - fromIntegral (truncate $ realToFrac x / 7)) * 100 * realToFrac x

main = defaultMain [
    bgroup "Set" [ bench "10" $ whnf Set.fromList $ pseudoRandom 10
                 , bench "20" $ whnf Set.fromList $ pseudoRandom 20
                 , bench "100" $ whnf Set.fromList $ pseudoRandom 100
                 ],
    bgroup "Heap" [ bench "10" $ whnf Heap.fromList $ pseudoRandom 10
                  , bench "20" $ whnf Heap.fromList $ pseudoRandom 20
                  , bench "10'" $ whnf Heap.fromList2 $ pseudoRandom 10
                  , bench "20'" $ whnf Heap.fromList2 $ pseudoRandom 20
                  ]
                 ]
