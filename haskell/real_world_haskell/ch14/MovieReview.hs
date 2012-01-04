import Control.Monad (join, liftM3, liftM, ap, MonadPlus, mzero, mplus)
import Control.Applicative ((<$>), (<*>))

data MovieReview = MovieReview {
        revTitle :: String
      , revUser :: String
      , revReview :: String
      } deriving (Show)

type AList = [(String, Maybe String)]

alist :: AList
alist = [("name", Just "Attila \"The Hun\""),
         ("user", Just "Me"),
         ("review", Just "Cool!")]

maybeReview :: AList -> Maybe MovieReview

--  maybeReview alist = do
--          revTitle <- join $ lookup "name" alist
--          revUser <- join $ lookup "user" alist
--          revReview <- join $ lookup "review" alist
--          return $ MovieReview revTitle revUser revReview

--  maybeReview alist = liftM3 MovieReview
--          (join $ lookup "name" alist)
--          (join $ lookup "user" alist)
--          (join $ lookup "review" alist)

--  maybeReview alist = MovieReview
--          <$> (join $ lookup "name" alist)
--          <*> (join $ lookup "user" alist)
--          <*> (join $ lookup "review" alist)

maybeReview alist = MovieReview
        `liftM` (join $ lookup "name" alist)
        `ap` (join $ lookup "user" alist)
        `ap` (join $ lookup "review" alist)

lookupM :: (MonadPlus m, Eq a) => a -> [(a, b)] -> m b
lookupM _ [] = mzero
lookupM k ((x,y):xs)
        | x == k = return y `mplus` lookupM k xs
        | otherwise = lookupM k xs
