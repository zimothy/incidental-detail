------------------------------------------------------------------------------
-- | Defines types for selecting points on a model.
module Graphics.DetailGen.PointSelection
    (
    -- * PointSelection
      PointSelection (..)
    , toPoints

    -- * AxisSelection
    , AxisSelection
    , xAxis
    , yAxis
    , zAxis
    ) where

------------------------------------------------------------------------------
import Data.Monoid

------------------------------------------------------------------------------
import Graphics.DetailGen.Point


------------------------------------------------------------------------------
data PointSelection
    = CubeFaces AxisSelection
    | CylinderLoop Int Double
    | SphereLoop Int Double
    | Centre
    | FaceR
    | FaceL
    | FaceU
    | FaceD
    | FaceF
    | FaceB

    deriving (Show)


------------------------------------------------------------------------------
toPoints :: PointSelection -> [Point]
toPoints ps = case ps of
    CubeFaces axes   -> bboxCentroids (isX axes) (isY axes) (isZ axes)
    CylinderLoop c h -> cylinderHLoop h c
    SphereLoop c h   -> sphereLoop h c
    Centre           -> [centroid]
    FaceR            -> [cRight]
    FaceL            -> [cLeft]
    FaceU            -> [cTop]
    FaceD            -> [cBottom]
    FaceF            -> [cFront]
    FaceB            -> [cBack]


------------------------------------------------------------------------------
data AxisSelection = AxisSelection
    { isX :: Bool
    , isY :: Bool
    , isZ :: Bool
    } deriving (Show)

instance Monoid AxisSelection where
    mempty = AxisSelection False False False
    mappend a b = AxisSelection
        { isX = isX a || isX b
        , isY = isY a || isY b
        , isZ = isZ a || isZ b
        }


------------------------------------------------------------------------------
xAxis :: AxisSelection
xAxis = AxisSelection True False False


------------------------------------------------------------------------------
yAxis :: AxisSelection
yAxis = AxisSelection False True False


------------------------------------------------------------------------------
zAxis :: AxisSelection
zAxis = AxisSelection False False True

