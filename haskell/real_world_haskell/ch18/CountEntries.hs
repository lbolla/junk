module CountEntries (listDirectory, countEntries) where

import System.Directory (doesDirectoryExist, getDirectoryContents)
import System.FilePath ((</>))
import Control.Monad (forM_, when, liftM)
import Control.Monad.Trans (liftIO)
import Control.Monad.Writer (WriterT, tell)

listDirectory :: FilePath -> IO [String]
listDirectory = liftM (filter notDots) . getDirectoryContents
        where notDots p = p /= "." && p /= ".."

countEntries :: FilePath -> WriterT [(FilePath, Int)] IO ()
countEntries path = do
        contents <- liftIO . listDirectory $ path
        tell [(path, length contents)]
        forM_ contents $ \name -> do
                let newName = path </> name
                isDir <- liftIO . doesDirectoryExist $ newName
                when isDir $ countEntries newName
