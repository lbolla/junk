--  Cons
data L a = E | C a (L a) deriving (Show)

instance Functor L where
        fmap g E = E
        fmap g (C a b) = C (g a) (fmap g b)

join :: L (L a) -> L a
join E = E
join (C a b) = conc a (join b)

conc :: L a -> L a -> L a
conc E a = a
conc a E = a
conc (C h E) b = C h b
conc (C h t) b = C h (conc t b)

instance Monad L where
        return a = C a E
        E >>= g = E
        C h t >>= g = join $ C (g h) (fmap g t)
