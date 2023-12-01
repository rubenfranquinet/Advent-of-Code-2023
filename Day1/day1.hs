import Data.Char (isDigit)

type Line = String

isnewline :: Char -> Bool
isnewline c = c == '\n'

createLines :: String -> String -> [Line]
createLines [] line = [reverse line]
createLines (x:xs) line | isnewline x = (reverse line) : createLines xs []
                        | otherwise = createLines xs (x : line)

getnumbers :: Line -> [Int]
getnumbers [] = []
getnumbers (x : y : z : xs) | [x, y, z] == "one" = 1 : getnumbers (y : z : xs)
                            | [x, y, z] == "two" = 2 : getnumbers (y : z : xs)
                            | [x, y, z] == "six" = 6 : getnumbers (y : z : xs)
getnumbers (w : x : y : z : xs) | [w, x, y, z] == "four" = 4 : getnumbers (w : y : z : xs)
                                | [w, x, y, z] == "five" = 5 : getnumbers (w : y : z : xs)
                                | [w, x, y, z] == "nine" = 9 : getnumbers (w : y : z : xs)
getnumbers (v : w : x : y : z : xs) | [v, w, x, y, z] == "three" = 3 : getnumbers (v : w : y : z : xs)
                                    | [v, w, x, y, z] == "seven" = 7 : getnumbers (v : w : y : z : xs)
                                    | [v, w, x, y, z] == "eight" = 8 : getnumbers (v : w : y : z : xs)
getnumbers (x:xs) | isDigit x = (read [x] :: Int) : getnumbers xs
                  | otherwise = getnumbers xs

firstandlastcombo :: [Int] -> Int
firstandlastcombo xs = (head xs) * 10 + (last xs)

getoutput :: String -> Int
getoutput s = sum (map firstandlastcombo (map getnumbers (createLines s [])))

main :: IO ()
main = do
    contents <- readFile "day1.txt"
    let output = getoutput contents
    print output
