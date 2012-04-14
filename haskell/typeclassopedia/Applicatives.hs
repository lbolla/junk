import Control.Applicative

data MyMaybe a = MyNothing | MyJust a deriving (Show)

instance Functor MyMaybe where
        fmap g (MyJust x) = MyJust (g x)
        fmap _ _ = MyNothing

instance Applicative MyMaybe where
        pure = MyJust
        MyJust g <*> MyJust x = MyJust (g x)
        _ <*> _ = MyNothing
