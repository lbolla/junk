instance Monad [] where
        return x = [x]
        xs >>= f = concat (map f xs)
