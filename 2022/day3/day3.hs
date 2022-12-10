import Data.List
import Data.List.Split
import Data.Set (Set)
import qualified Data.Set as Set

(|>) = flip ($)

priority :: Char -> Int
priority c =
    let go :: Char -> [(Char, Int)] -> Int
        go _ [] = 0
        go ch ((key, value):t)
            | c == key = value
            | otherwise = go ch t
    in go c (zip (['a'..'z'] ++ ['A'..'Z']) [1..])

presentInBoth :: String -> String -> Char
presentInBoth (h:t) right
    | h `elem` right = h
    | otherwise = presentInBoth t right

    
presentInAllThree :: String -> String -> String -> Char
presentInAllThree left middle right = let
    chars = Set.fromList (left ++ middle ++ right) |> Set.toList
    go :: String -> String -> String -> String -> Char
    go (h:t) l m r
        | h `elem` l && h `elem` m && h `elem` r = h
        | otherwise = go t l m r
    in go chars left middle right
    

main :: IO()
main = do
    x <- readFile "day3.txt"
    putStr "Part 1: "
    splitOn "\n" x
        |> map (\l -> splitAt ((length l + 1) `div` 2) l)
        |> map (uncurry presentInBoth)
        |> map priority
        |> sum
        |> print
    putStr "Part 2: "
    splitOn "\n" x
        |> chunksOf 3
        |> map (\[a, b, c] -> presentInAllThree a b c)
        |> map priority
        |> sum
        |> print