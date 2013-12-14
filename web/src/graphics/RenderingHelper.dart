part of ld28;

class RenderingHelper
{

  static Buffer boxBuffer = gameInstance.renderingHelper.makeBoxBuffer(new AABB(0.0, 0.0, 1.0, 1.0));

  RenderingContext context;

  RenderingHelper(this.context);

  static void init()
  {
    boxBuffer;
  }

  void drawTexturedBox(AABB box, ITextureing texture)
  {
    gameInstance.matrixStack.pushModel();
    gameInstance.matrixStack.modelMatrix = MatrixFactory.translationMatrix(box.getLeft().toDouble(), box.getTop().toDouble(), 0.0);
    gameInstance.matrixStack.modelMatrix.multiply(MatrixFactory.scaleMatrix(box.size.x.toDouble(), box.size.y.toDouble(), 1.0));
    gameInstance.matrixStack.modelMatrix.writeToUniform(context, ShaderManager.standardShaders.uniforms['uMMatrix']);
    context.activeTexture(TEXTURE0);
    context.bindTexture(TEXTURE_2D, texture.getTexture());
    context.uniform1i(ShaderManager.standardShaders.uniforms['uSampler'], 0);

    context.enableVertexAttribArray(ShaderManager.standardShaders.attributes['aVertexPosition']);
    context.bindBuffer(ARRAY_BUFFER, boxBuffer);
    context.vertexAttribPointer(ShaderManager.standardShaders.attributes['aVertexPosition'], 2, FLOAT, false, 0, 0);

    context.enableVertexAttribArray(ShaderManager.standardShaders.attributes['aVertexTextureCoord']);
    context.bindBuffer(ARRAY_BUFFER, texture.getUVBuffer());
    context.vertexAttribPointer(ShaderManager.standardShaders.attributes['aVertexTextureCoord'], 2, FLOAT, false, 0, 0);

    context.drawArrays(TRIANGLES, 0, 6);

    gameInstance.matrixStack.popModel();
  }

  Buffer makeBoxBuffer(AABB bounds)
  {
    Buffer result = context.createBuffer();
    context.bindBuffer(ARRAY_BUFFER, result);
    context.bufferDataTyped(ARRAY_BUFFER, new Float32List.fromList([bounds.getLeft(), bounds.getBottom(), bounds.getRight(), bounds.getTop(), bounds.getLeft(), bounds.getTop(),
                                                                    bounds.getLeft(), bounds.getBottom(), bounds.getRight(), bounds.getBottom(), bounds.getRight(), bounds.getTop()]), STATIC_DRAW);
    return result;
  }
      
}