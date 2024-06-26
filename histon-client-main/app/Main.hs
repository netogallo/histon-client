module Main where

import Reflex.Dom (mainWidget, text) 

main :: IO ()
main = do
  print "my widget"
  mainWidget $ text "hello" 
