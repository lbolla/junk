import Data.Monoid

data G = G [Int] deriving (Show)

instance Monoid G where
        mempty = G []
        mappend (G a) (G b) = G $ a ++ b
