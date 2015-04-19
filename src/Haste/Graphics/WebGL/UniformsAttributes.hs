{-# LANGUAGE OverloadedStrings, GeneralizedNewtypeDeriving #-}

module Haste.Graphics.WebGL.UniformsAttributes where

import Haste.DOM
import Haste.Foreign
import Haste.Prim

import Haste.JSArray.Typed
import Haste.Graphics.WebGL.Types
import Haste.Graphics.WebGL.ProgramsShaders

newtype AttribInfo = AttribInfo JSAny deriving (FromAny, ToAny)
newtype AttribLocation = AttribLocation JSAny deriving (FromAny, ToAny)

newtype UniformInfo = UniformInfo JSAny deriving (FromAny, ToAny)
newtype UniformLocation = UniformLocation JSAny deriving (FromAny, ToAny)

-- webgl doesn't support fixed
data VertexAttribType = Byte | Short | UnsignedByte | UnsignedShort | FloatVAType

instance Enum VertexAttribType where
  fromEnum Byte = 0x1400
  fromEnum Short = 0x1402
  fromEnum UnsignedByte = 0x1401
  fromEnum UnsignedShort = 0x1403
  fromEnum FloatVAType = 0x1406

  toEnum 0x1400 = Byte
  toEnum 0x1402 = Short
  toEnum 0x1401 = UnsignedByte
  toEnum 0x1403 = UnsignedShort
  toEnum 0x1406 = FloatVAType
  toEnum _ = undefined

instance FromAny VertexAttribType where
  fromAny = toEnum . fromAny

instance ToAny VertexAttribType where
  toAny = toAny . fromEnum

data VertexAttrPName = CurrentVertexAttrib | VertexAttribArrayBufferBinding |
                       VertexAttribArrayEnabled | VertexAttribArraySize |
                       VertexAttribArrayStride | VertexAttribArrayType |
                       VertexAttribArrayNormalized

instance Enum VertexAttrPName where
  fromEnum CurrentVertexAttrib = 0x8626
  fromEnum VertexAttribArrayBufferBinding = 0x889f
  fromEnum VertexAttribArrayEnabled = 0x8622
  fromEnum VertexAttribArraySize = 0x8623
  fromEnum VertexAttribArrayStride = 0x8624
  fromEnum VertexAttribArrayType = 0x8625
  fromEnum VertexAttribArrayNormalized = 0x886a

  toEnum 0x8626 = CurrentVertexAttrib
  toEnum 0x889f = VertexAttribArrayBufferBinding
  toEnum 0x8622 = VertexAttribArrayEnabled
  toEnum 0x8623 = VertexAttribArraySize
  toEnum 0x8624 = VertexAttribArrayStride
  toEnum 0x8625 = VertexAttribArrayType
  toEnum 0x886a = VertexAttribArrayNormalized
  toEnum _ = undefined

instance FromAny VertexAttrPName where
  fromAny = toEnum . fromAny

instance ToAny VertexAttrPName where
  toAny = toAny . fromEnum

disableVertexAttribArray::Context->AttribLocation->IO ()
disableVertexAttribArray = ffi "(function(ctx, index) {ctx.disableVertexAttribArray(index);})"

enableVertexAttribArray::Context->AttribLocation->IO ()
enableVertexAttribArray = ffi "(function(ctx, index) {ctx.enableVertexAttribArray(index);})"

getActiveAttrib::Context->Program->AttribLocation->IO AttribInfo
getActiveAttrib = ffi "(function(ctx, program, index) {return ctx.getActiveAttrib(program, index);})"

getActiveUniform::Context->Program->UniformLocation->IO UniformInfo
getActiveUniform = ffi "(function(ctx, program, index) {return ctx.getActiveUniform(program, index);})"

getAttribLocation::Context->Program->String->IO AttribLocation
getAttribLocation = ffi "(function(ctx, program, name) {return ctx.getAttribLocation(program, name);})"

getUniform::Context->Program->UniformLocation->IO JSAny
getUniform = ffi "(function(ctx, program, index) {return ctx.getUniform(program, index);})"

getUniformLocation::Context->Program->String->IO UniformLocation
getUniformLocation = ffi "(function(ctx, program, name) {return ctx.getUniformLocation(program, name);})"

getVertexAttrib::Context->AttribLocation->VertexAttrPName->IO JSAny
getVertexAttrib = ffi "(function(ctx, index, pname) {return ctx.getVertexAttrib(index, pname);})"

getVertexAttribOffset::Context->AttribLocation->VertexAttrPName->IO Int
getVertexAttribOffset = ffi "(function(ctx, index, pname) {return ctx.getVertexAttribOffset(index, pname);})"

uniform1f::Context->UniformLocation->Double->IO ()
uniform1f = ffi "(function(ctx, uniform, val) {ctx.uniform1f(uniform, val);})"

uniform2f::Context->UniformLocation->Double->Double->IO ()
uniform2f = ffi "(function(ctx, uniform, x, y) {ctx.uniform2f(uniform, x, y);})"

uniform3f::Context->UniformLocation->Double->Double->Double->IO ()
uniform3f = ffi "(function(ctx, uniform, x, y, z) {ctx.uniform3f(uniform, x, y, z);})"

uniform4f::Context->UniformLocation->Double->Double->Double->Double->IO ()
uniform4f = ffi "(function(ctx, uniform, x, y, z, w) {ctx.uniform4f(uniform, x, y, z, w);})"

uniform1i::Context->UniformLocation->Int->IO ()
uniform1i = ffi "(function(ctx, uniform, val) {ctx.uniform1i(uniform, val);})"

uniform2i::Context->UniformLocation->Int->Int->IO ()
uniform2i = ffi "(function(ctx, uniform, x, y) {ctx.uniform2i(uniform, x, y);})"

uniform3i::Context->UniformLocation->Int->Int->Int->IO ()
uniform3i = ffi "(function(ctx, uniform, x, y, z) {ctx.uniform3i(uniform, x, y, z);})"

uniform4i::Context->UniformLocation->Int->Int->Int->Int->IO ()
uniform4i = ffi "(function(ctx, uniform, x, y, z, w) {ctx.uniform4i(uniform, x, y, z, w);})"

uniform1fv::Context->UniformLocation->Float32Array->IO ()
uniform1fv = ffi "(function(ctx, uniform, arr) {ctx.uniform1fv(uniform, arr);})"

uniform2fv::Context->UniformLocation->Float32Array->IO ()
uniform2fv = ffi "(function(ctx, uniform, arr) {ctx.uniform2fv(uniform, arr);})"

uniform3fv::Context->UniformLocation->Float32Array->IO ()
uniform3fv = ffi "(function(ctx, uniform, arr) {ctx.uniform3fv(uniform, arr);})"

uniform4fv::Context->UniformLocation->Float32Array->IO ()
uniform4fv = ffi "(function(ctx, uniform, arr) {ctx.uniform4fv(uniform, arr);})"

uniform1iv::Context->UniformLocation->Int32Array->IO ()
uniform1iv = ffi "(function(ctx, uniform, arr) {ctx.uniform1iv(uniform, arr);})"

uniform2iv::Context->UniformLocation->Int32Array->IO ()
uniform2iv = ffi "(function(ctx, uniform, arr) {ctx.uniform2iv(uniform, arr);})"

uniform3iv::Context->UniformLocation->Int32Array->IO ()
uniform3iv = ffi "(function(ctx, uniform, arr) {ctx.uniform3iv(uniform, arr);})"

uniform4iv::Context->UniformLocation->Int32Array->IO ()
uniform4iv = ffi "(function(ctx, uniform, arr) {ctx.uniform4iv(uniform, arr);})"

uniformMatrix2fv::Context->UniformLocation->Float32Array->IO ()
uniformMatrix2fv = ffi "(function(ctx, uniform, arr) {ctx.uniformMatrix2fv(uniform, ctx.FALSE, arr);})"

uniformMatrix3fv::Context->UniformLocation->Float32Array->IO ()
uniformMatrix3fv = ffi "(function(ctx, uniform, arr) {ctx.uniformMatrix3fv(uniform, ctx.FALSE, arr);})"

uniformMatrix4fv::Context->UniformLocation->Float32Array->IO ()
uniformMatrix4fv = ffi "(function(ctx, uniform, arr) {ctx.uniformMatrix4fv(uniform, ctx.FALSE, arr);})"

vertexAttrib1f::Context->AttribLocation->Double->IO ()
vertexAttrib1f = ffi "(function(ctx, attrib, val) {ctx.vertexAttrib1f(attrib, val);})"

vertexAttrib2f::Context->AttribLocation->Double->Double->IO ()
vertexAttrib2f = ffi "(function(ctx, attrib, x, y) {ctx.vertexAttrib2f(attrib, x, y);})"

vertexAttrib3f::Context->AttribLocation->Double->Double->Double->IO ()
vertexAttrib3f = ffi "(function(ctx, attrib, x, y, z) {ctx.vertexAttrib3f(attrib, x, y, z);})"

vertexAttrib4f::Context->AttribLocation->Double->Double->Double->Double->IO ()
vertexAttrib4f = ffi "(function(ctx, attrib, x, y, z, w) {ctx.vertexAttrib4f(attrib, x, y, z, w);})"

vertexAttrib1fv::Context->AttribLocation->Float32Array->IO ()
vertexAttrib1fv = ffi "(function(ctx, attrib, arr) {ctx.vertexAttrib1fv(attrib, arr);})"

vertexAttrib2fv::Context->AttribLocation->Float32Array->IO ()
vertexAttrib2fv = ffi "(function(ctx, attrib, arr) {ctx.vertexAttrib2fv(attrib, arr);})"

vertexAttrib3fv::Context->AttribLocation->Float32Array->IO ()
vertexAttrib3fv = ffi "(function(ctx, attrib, arr) {ctx.vertexAttrib3fv(attrib, arr);})"

vertexAttrib4fv::Context->AttribLocation->Float32Array->IO ()
vertexAttrib4fv = ffi "(function(ctx, attrib, arr) {ctx.vertexAttrib4fv(attrib, arr);})"

vertexAttribPointer::Context->AttribLocation->Int->VertexAttribType->Bool->Int->Int->IO ()
vertexAttribPointer = ffi "(function(ctx, index, size, type, normalized, stride, offset) {ctx.vertexAttribPointer(index, size, type, normalized, stride, offset);})"
