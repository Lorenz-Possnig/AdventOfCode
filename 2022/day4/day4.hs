import Data.List
import Data.List.Split

(|>) = flip ($)

fullyContains :: [Int] -> [Int] -> Bool
fullyContains left right =
    head left >= head right && last left <= last right

overlaps :: [Int] -> [Int] -> Bool
overlaps left right =
    last left >= head right && head left <= last right

toInt :: String -> Int
toInt = read

main :: IO()
main = do
    x <- readFile "day4.txt"
    let ranges = splitOn "\n" x
            |> map (splitOn ",")
            |> map (map (splitOn "-"))
            |> map (map (map toInt))
            |> map (map (\[a, b] -> [a..b]))
    
    putStr "Part 1: "
    ranges
        |> filter (\[a, b] -> a `fullyContains` b || b `fullyContains` a)
        |> length
        |> print
        
    putStr "Part 2: "
    ranges
        |> filter (\[a, b] -> a `overlaps` b)
        |> length
        |> print