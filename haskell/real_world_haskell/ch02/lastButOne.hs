--  lastButOne :: [a] -> [a]
--  lastButOne [] = []
--  lastButOne [x] = []
--  lastButOne [x,y] = [x]
--  lastButOne (x:xs) = x : lastButOne xs

lastButOne = reverse . tail . reverse
