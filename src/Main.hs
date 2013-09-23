--------------------------------------------------------------------------------
-- | Incidental Detail, a library for generating details of the incidental kind.
-- |
-- | Victoria University of Welling, ECS
-- |    Richard Roberts
-- |    Timothy Jones
-- |    John Lewis

module Main where

-- | Standard
import Text.Printf

-- | Source
import Maya
import Generator
import Types
import Hastwix
import Vectwix
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
-- | Prints out a triple.
showTriple :: Point -> IO ()
showTriple p = putStrLn $ printf "x:%2.2f, y:%2.2f, z:%2.2f" (px p) (py p) (pz p)

--------------------------------------------------------------------------------
-- | Writes a python script based on the generated pattern.
main :: IO ()
main = do
    -- Make the first branch of the pattern.
    let org = Polygon PolySphere (tMtx (10, 0, 0)) (sMtx (0.1, 1,1))
    let b1 = Branch org Empty []

    -- Give the recursion instructions
    let struct = [[(1, PolyCylinder, (0.3, 0.3, 0.3), (2, 0.1, 2))],
                  [(2, PolySphere, (0.3, 0.3, 0.3), (1, 1, 1))],
                  [(0, PolyCube, (0.3, 0.3, 0.3), (1, 1, 1))]]

    -- Recusrively expand it.
    let pSet = map (\b -> (node b)) (recur struct b1)

    -- Write the python script
    let title = "basic"
    let cmds = polySetToCmds pSet
    writeFile (title ++ ".py") $ (preamble title ++ cmds)

    return ()

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------