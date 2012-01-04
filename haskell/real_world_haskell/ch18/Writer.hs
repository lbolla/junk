module Writer where

import Control.Monad.Writer
import Control.Monad.Reader

goW :: Writer [String] Int
goW = do
        tell ["hello"]
        tell ["world"]
        return 1

goR :: Reader String Int
goR = do
        cfg <- ask
        return $ length cfg

goWR :: WriterT [String] (Reader String) Int
goWR = do
        cfg <- ask
        tell [cfg]
        return $ length cfg

runWR app cfg = runReader (runWriterT app) cfg
--  runWR = runReader . runWriterT

goRW :: ReaderT String (Writer [String]) Int
goRW = do
        cfg <- ask
        tell [cfg]
        return $ length cfg

runRW app cfg = runWriter (runReaderT app cfg)
