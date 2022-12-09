import Data.List
import Data.List.Split
import Control.Monad
import Data.Monoid

(|>) = flip ($)

toInt :: String -> Int
toInt "" = 0
toInt s = read s

main :: IO()
main = do
    x <- readFile "day1.txt"
    let caloriesPerElf = splitOn "\n" x
            |> map toInt
            |> splitOn [0]
            |> map sum
    putStr "Part 1: "
    putStrLn $ show $ foldl max 0 caloriesPerElf
    
    let topThreeElvesSum = caloriesPerElf
            |> sortBy (flip compare)
            |> take 3
            |> sum
            
    putStr "Part 1: "
    putStrLn $ show $ topThreeElvesSum