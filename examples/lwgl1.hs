{-# LANGUAGE EmptyDataDecls, OverloadedStrings #-}

import Control.Monad
import Data.Vec
import Haste
import Haste.Foreign
import Haste.DOM
import Haste.Graphics.WebGL

fragmentShaderText = unlines [
  "precision mediump float;",
  "void main(void) {",
  "    gl_FragColor = vec4(0.8, 0.5, 0.5, 0.5);",
  "}"]

vertexShaderText = unlines [
  "attribute vec3 aVertexPosition;",
  "uniform mat4 uMVMatrix;",
  "uniform mat4 uPMatrix;",
  "void main(void) {",
  "  gl_Position = uPMatrix * uMVMatrix * vec4(aVertexPosition, 1.0);",
  "}"]

getShader::Context->ShaderType->String->IO Shader
getShader gl typ src = do
  result <- createShader gl typ
  shaderSource gl result src
  compileShader gl result
  return result

initShaders::Context->IO (UniformLocation, UniformLocation, AttribLocation)
initShaders gl = do
  fragmentShader <- getShader gl FragmentShader fragmentShaderText
  vertexShader <- getShader gl VertexShader vertexShaderText
  shaderProgram <- createProgram gl
  attachShader gl shaderProgram vertexShader
  attachShader gl shaderProgram fragmentShader
  linkProgram gl shaderProgram

  useProgram gl shaderProgram

  vertexAttrib <- getAttribLocation gl shaderProgram "aVertexPosition"
  enableVertexAttribArray gl vertexAttrib

  pmatUniform <- getUniformLocation gl shaderProgram "uPMatrix"
  mvmatUniform <- getUniformLocation gl shaderProgram "uMVMatrix"

  return (pmatUniform, mvmatUniform, vertexAttrib)

setMatrixUniforms::Context->(UniformLocation, UniformLocation)->(Mat44 Float, Mat44 Float)->IO ()
setMatrixUniforms gl (pIdx, mvIdx) (pMat, mvMat) = do
  uniformMatrix4fv gl pIdx pMat
  uniformMatrix4fv gl mvIdx mvMat

initBuffers::Context->IO (Buffer, Buffer)
initBuffers gl = do
  triVerticesBuffer <- createBuffer gl
  bindBuffer gl ArrayBuffer triVerticesBuffer
  let triVertices = [0, -1, 0, -1, 1, 0, 1, 1, 0]::[Float]

  bufferData gl ArrayBuffer triVertices StaticDraw

  sqVerticesBuffer <- createBuffer gl
  bindBuffer gl ArrayBuffer sqVerticesBuffer

  let sqVertices = [1, 1, 0, -1, 1, 0, 1, -1, 0, -1, -1, 0]::[Float]

  bufferData gl ArrayBuffer sqVertices StaticDraw

  return (triVerticesBuffer, sqVerticesBuffer)

drawScene::Context->(UniformLocation, UniformLocation)->(Buffer, Buffer)->AttribLocation->IO ()
drawScene gl (pIdx, mvIdx) (triVerticesBuffer, sqVerticesBuffer) posAttrib = do
  viewport gl 0 0 640 480
  clear gl [ColorBufferBit, DepthBufferBit]

  let pmat =  perspective 0.1 100 (pi/4) (640/480)
      mvmat =  translation (negate 1.5:.0:.negate 20:.())

  bindBuffer gl ArrayBuffer triVerticesBuffer
  vertexAttribPointer gl posAttrib 3 Float False 0 0
  setMatrixUniforms gl (pIdx, mvIdx) (pmat, mvmat)
  drawArrays gl Triangles 0 3

  let mvmat =  translation (5:.negate 4:.negate 20:.())

  bindBuffer gl ArrayBuffer sqVerticesBuffer
  vertexAttribPointer gl posAttrib 3 Float False 0 0
  setMatrixUniforms gl (pIdx, mvIdx) (pmat, mvmat)
  drawArrays gl TriangleStrip 0 4

forever delay m = m >> setTimeout delay (Main.forever delay m)

main = do
  let root = documentBody
  canvas <- newElem "canvas"
  setAttr canvas "width" "640"
  setAttr canvas "height" "480"
  addChild canvas root

  gl <- getContext canvas "webgl"
  (pmUni, mvUni, posAttr) <- initShaders gl
  buffers <- initBuffers gl

  enable gl DepthTest

  Main.forever 500 $ do
    clearColor gl 0 0 0 1
    drawScene gl (pmUni, mvUni) buffers posAttr

  return ()