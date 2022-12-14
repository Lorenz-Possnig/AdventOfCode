import Data.List
import Data.List.Split

(|>) :: a -> (a -> b) -> b
(|>) = flip ($)

countCharsUntilDistinct :: Int -> String -> Int
countCharsUntilDistinct len str = let
  go s n = let
    check = take len s
    in if length check == (length $ nub check) then n else go (tail s) (n + 1)
  in go str len

countCharsUntil4Distinct :: String -> Int
countCharsUntil4Distinct = countCharsUntilDistinct 4

countCharsUntil14Distinct :: String -> Int
countCharsUntil14Distinct = countCharsUntilDistinct 14

main :: IO()
main = do
    x <- readFile "day6.txt"
    let result f = x |> f |> show |> putStrLn

    putStr "Part 1: "
    result countCharsUntil4Distinct

    putStr "Part 2: "
    result countCharsUntil14Distinct
