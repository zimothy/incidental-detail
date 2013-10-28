------------------------------------------------------------------------------
module Transform
  (
  -- * Vectors
  Vec3,
  vx,
  vy,
  vz,

  -- * Builders
    translate
  , rotateX
  , rotateY
  , rotateZ
  , rotate
  , scale

  -- * Operations
  , dotM
  ) where


import Data.Matrix


--------------------------------------------------------------------------------
mtxToArr :: Matrix Double -> [Double]
mtxToArr m = [ getElem 1 1 m, getElem 1 2 m, getElem 1 3 m, getElem 1 4 m,
               getElem 2 1 m, getElem 2 2 m, getElem 2 3 m, getElem 2 4 m,
               getElem 3 1 m, getElem 3 2 m, getElem 3 3 m, getElem 3 4 m,
               getElem 4 1 m, getElem 4 2 m, getElem 4 3 m, getElem 4 4 m ]


--------------------------------------------------------------------------------
multByScalar :: Double -> Matrix Double -> Matrix Double
multByScalar s m = fromList 4 4 arr
  where arr = map (*s) m

--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
type Vec3 = (Double, Double, Double)


--------------------------------------------------------------------------------
vx :: Vec3 -> Double
vx (x, _, _) = x


--------------------------------------------------------------------------------
vy :: Vec3 -> Double
vy (_, y, _) = y


--------------------------------------------------------------------------------
vz :: Vec3 -> Double
vz (_, _, z) = z


--------------------------------------------------------------------------------
cross :: Vec3 -> Vec3 -> Vec3
cross a b = (x, y, z)
  where x = (vy a) * (vz b) - (vy b) * (vz a)
        y = (vx b) * (vz a) - (vx a) * (vz b)
        z = (vx a) * (vy b) - (vy a) * (vx b)


--------------------------------------------------------------------------------
dotV :: Vec3 -> Vec3 -> Double
dotV a b = (px a) * (px b) + (vy a) * (vy b) + (vz a) * (vz b)


--------------------------------------------------------------------------------
mag :: Vec3 -> Double
mag v = sqrt $ px v ** 2 + vy v ** 2 + vz v ** 2


--------------------------------------------------------------------------------
norm :: Vec3 -> Vec3
norm v = (x, y, z)
  where x = (vx v) / m
        y = (vy v) / m
        z = (vz v) / m
        m = mag v

--------------------------------------------------------------------------------
angleBetween :: Vec3 -> Vec3 -> Double 
angleBetween vA vB = acos $ dotV (norm vA) (norm vB)


--------------------------------------------------------------------------------
axisBetween :: Vec3 -> Vec3 -> Vec3
axisBetween vA vB
    | (cross vA vB) == (0, 0, 0) = (0, 0, 1)
    | otherwise = norm $ cross vA vB

--------------------------------------------------------------------------------
skewAxis :: Point -> Matrix Double
skewAxis a = fromArr 4 4 [ 0,     -vz a, vy a,  0,
                           vz a,  0,     -px a, 0,
                           -vy a, px a,  0,     0
                           0,     0,     0,     1 ]

--------------------------------------------------------------------------------
rotBetween :: Vec3 -> Vec3 -> Matrix Double
rotBetween a b = eye + (sinM + cosM)
  where eye    = (identity 4)
        sinM   = multByScalar (sin angle) skewed
        cosM   = multByScalar (1 - (cos angle)) (skewed * skewed)
        skewed = skewAxis (axisBetween a b)
        angle  = angleBetween a b


------------------------------------------------------------------------------
translate :: Double -> Double -> Double -> Matrix Double
translate x y z = fromList 4 4 arr
  where arr = [ 1, 0, 0, x,
                0, 1, 0, y,
                0, 0, 1, z,
                0, 0, 0, 1 ]


------------------------------------------------------------------------------
rotateX :: Double -> Matrix Double
rotateX v = fromList 4 4 arr
  where arr = [ 1,      0,     0,      0,
                0,      cos v, -sin v, 0,
                0,      sin v, cos v,  0,
                0,      0,     0,      1 ]


------------------------------------------------------------------------------
rotateY :: Double -> Matrix Double
rotateY v = fromList 4 4 arr
  where arr = [ cos v,  0, sin v,      0,
                0,      1,     0,      0,
                -sin v, 0, cos v,      0,
                0,      0,     0,      1 ]


------------------------------------------------------------------------------
rotateZ :: Double -> Matrix Double
rotateZ v = fromList 4 4 arr
  where arr = [ cos v,  -sin v, 0,     0,
                sin v,  cos v,  0,     0,
                0,      0,      1,     0,
                0,      0,      0,     1 ]


------------------------------------------------------------------------------
rotate :: Int -> Double -> Matrix Double
rotate 0 v = rotateX v
rotate 1 v = rotateY v
rotate 2 v = rotateZ v


------------------------------------------------------------------------------
scale :: Double -> Double -> Double -> Matrix Double
scale x y z = fromList 4 4 arr
  where arr = [ x, 0, 0, 0,
                0, y, 0, 0,
                0, 0, z, 0,
                0, 0, 0, 1 ]


------------------------------------------------------------------------------
dotM :: Matrix Double -> Matrix Double -> Matrix Double
dotM = multStd


