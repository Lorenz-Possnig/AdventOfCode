{-# LANGUAGE ViewPatterns #-}
import Data.List (transpose)
import Data.Char (isAlpha)
import Control.Arrow ((>>>))
import qualified Data.Map as Map
import Data.Map (Map, (!))

type Stacks = Map Int String

(|>) :: a -> (a -> b) -> b
(|>) = flip ($)

readDiagram :: [String] -> Stacks
readDiagram =
    transpose
    >>> map (filter isAlpha)
    >>> filter (not . null)
    >>> zip [1..]
    >>> Map.fromList

instruction :: (String -> String) -> Stacks -> String -> Stacks
instruction func stacks (words -> ["move", read -> n, "from", read -> x, "to", read -> y]) =
    let
      (toPush, newX) = splitAt n (stacks ! x)
      newY = (func toPush) ++ stacks ! y
    in Map.insert y newY stacks |> Map.insert x newX

instruction1 :: Stacks -> String -> Stacks
instruction1 = instruction reverse

instruction2 :: Stacks -> String -> Stacks
instruction2 = instruction id

getResult :: Stacks -> [String] -> (Stacks -> String -> Stacks) -> IO()
getResult stacks instructions f =
  foldl f stacks instructions
    |> Map.elems
    |> map head
    |> putStrLn

main :: IO ()
main = do
    x <- readFile "day5.txt"
    let (readDiagram -> stacks, tail -> instructions) = x
            |> lines
            |> break null
    let result = getResult stacks instructions
    putStr "Part 1: "
    result instruction1

    putStr "Part 2: "
    result instruction2
