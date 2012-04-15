import Control.Monad.State

mySum :: (MonadState s m, Num s) => [s] -> m s
mySum [] = get
mySum (x:xs) = do
        so_far <- get
        put (so_far + x)
        mySum xs

main :: IO ()
main = print $ runState (mySum [1,2,3]) 0
