{-# LANGUAGE OverloadedStrings #-}

module Haste.Graphics.WebGL.Rasterization where

import Haste.DOM
import Haste.Foreign
import Haste.Prim

import Haste.Graphics.WebGL.Types

data FaceDirection = CW | CCW

instance Enum FaceDirection where
  fromEnum CW = 0x900
  fromEnum CCW = 0x901

  toEnum 0x900 = CW
  toEnum 0x901 = CCW
  toEnum _ = undefined

instance FromAny FaceDirection where
  fromAny = toEnum . fromAny

instance ToAny FaceDirection where
  toAny = toAny . fromEnum

cullFace::Context->StencilFace->IO ()
cullFace = ffi "(function(ctx, mode) {ctx.cullFace(mode);})"

frontFace::Context->FaceDirection->IO ()
frontFace = ffi "(function(ctx, mode) {ctx.frontFace(mode);})"

lineWidth::Context->Double->IO ()
lineWidth = ffi "(function(ctx, width) {ctx.lineWidth(width);})"

polygonOffset::Context->Double->Double->IO ()
polygonOffset = ffi "(function(ctx, factor, units) {ctx.polygonOffset(factor, units);})"
