module Main where

import Test.Framework (defaultMain, testGroup)

import qualified Heap
import qualified Stack
import qualified Set

main :: IO ()
main = defaultMain tests

tests = [
        testGroup "Stack" Stack.tests
      , testGroup "Heap" Heap.tests
      , testGroup "Set" Set.tests
    ]
