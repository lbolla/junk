module Main where

import Test.Framework (defaultMain, testGroup)

import qualified Heap
import qualified Stack
import qualified Set
import qualified FiniteMap

main :: IO ()
main = defaultMain tests

tests = [
        testGroup "Stack" Stack.tests
      , testGroup "Set" Set.tests
      , testGroup "Heap" Heap.tests
      , testGroup "FiniteMap" FiniteMap.tests
    ]
