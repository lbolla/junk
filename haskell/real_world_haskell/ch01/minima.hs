import Data.List(sort)

minima k = take k . sort

main = putStrLn . show $ minima 5 [1,2,4,3,2,1,3,2]
