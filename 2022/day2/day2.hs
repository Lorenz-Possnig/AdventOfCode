import Data.Char
import Data.String
import Data.List.Split

data Play = Rock | Paper | Scissors deriving Show

data Result = Win | Draw | Lose deriving Show

(|>) = flip ($)

pFromString :: String -> Play
pFromString "A" = Rock
pFromString "X" = Rock
pFromString "B" = Paper
pFromString "Y" = Paper
pFromString "Z" = Scissors
pFromString "C" = Scissors

fromPlay :: Play -> Int
fromPlay Rock = 1
fromPlay Paper = 2
fromPlay Scissors = 3

--         opponent  self   score
playScore :: Play -> Play -> Int
playScore Rock Rock = 4
playScore Rock Paper = 8
playScore Scissors Scissors = 6
playScore Scissors Rock = 7
playScore Paper Paper = 5
playScore Paper Scissors = 9
playScore _ self = fromPlay self

rFromString :: String -> Result
rFromString "X" = Lose
rFromString "Y" = Draw
rFromString "Z" = Win

fromResult :: Result -> Int
fromResult Win = 6
fromResult Draw = 3
fromResult _ = 0

getPlay :: Play -> Result -> Play
getPlay play Draw = play
getPlay Paper Win = Scissors
getPlay Rock Win = Paper
getPlay Scissors Win = Rock
getPlay Paper Lose = Rock
getPlay Rock Lose = Scissors
getPlay Scissors Lose = Paper

main :: IO()
main = do
    x <- readFile "day2.txt"
    putStr "Part 1: "
    splitOn "\n" x
        |> map (splitOn " ")
        |> map (map pFromString)
        |> map (\[a, b] -> playScore a b)
        |> sum
        |> print
    putStr "Part 2: "
    splitOn "\n" x
        |> map (splitOn " ")
        |> map (\[a, b] -> (pFromString a, rFromString b))
        |> map (\(a, b) -> (fromPlay $ getPlay a b) + (fromResult b))
        |> sum
        |> print