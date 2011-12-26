module Main where

type SimpleState s a = s -> (a, s)

returnSt :: a -> SimpleState s a
returnSt a = \s -> (a, s)

bindSt :: SimpleState s a -> (a -> SimpleState s b) -> SimpleState s b
bindSt m k = \s -> let (oldState, value) = m s
                       in k oldState value

getSt :: SimpleState s s
getSt = \s -> (s, s)

putSt :: s -> SimpleState s ()
putSt s = \_ -> ((), s)
