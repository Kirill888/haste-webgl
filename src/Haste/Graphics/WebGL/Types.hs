{-# LANGUAGE OverloadedStrings, GeneralizedNewtypeDeriving #-}

module Haste.Graphics.WebGL.Types where

import Haste.DOM
import Haste.Foreign
import Haste.Prim

data StencilFace = Front | Back | FrontAndBack

instance Enum StencilFace where
  fromEnum Front = 0x404
  fromEnum Back = 0x405
  fromEnum FrontAndBack = 0x408

  toEnum 0x404 = Front
  toEnum 0x405 = Back
  toEnum 0x408 = FrontAndBack

instance FromAny StencilFace where
  fromAny = toEnum . fromAny

instance ToAny StencilFace where
  toAny = toAny . fromEnum

newtype Context = Context JSAny deriving (FromAny, ToAny)

data DrawMode = Points | LineStrip | LineLoop | Lines |
                TriangleStrip | TriangleFan | Triangles

instance Enum DrawMode where
  fromEnum Points = 0x0
  fromEnum LineStrip = 0x3
  fromEnum LineLoop = 0x2
  fromEnum Lines = 0x1
  fromEnum TriangleStrip = 0x5
  fromEnum TriangleFan = 0x6
  fromEnum Triangles = 0x4

  toEnum 0x0 = Points
  toEnum 0x3 = LineStrip
  toEnum 0x2 = LineLoop
  toEnum 0x1 = Lines
  toEnum 0x5 = TriangleStrip
  toEnum 0x6 = TriangleFan
  toEnum 0x4 = Triangles
  toEnum _ = undefined

instance FromAny DrawMode where
  fromAny = toEnum . fromAny

instance ToAny DrawMode where
  toAny = toAny . fromEnum

data ElementType = EltUnsignedByte | EltUnsignedShort

instance Enum ElementType where
  fromEnum EltUnsignedByte = 0x1401
  fromEnum EltUnsignedShort = 0x1403

  toEnum 0x1401 = EltUnsignedByte
  toEnum 0x1403 = EltUnsignedShort
  toEnum _ = undefined

instance FromAny ElementType where
  fromAny = toEnum . fromAny

instance ToAny ElementType where
  toAny = toAny . fromEnum
