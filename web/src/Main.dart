library ld28p;

import 'dart:html';
import 'dart:web_gl';
//import 'dart:web_audio';
//import 'dart:typed_data';
//import 'dart:async';
//import 'dart:convert';
import 'dart:math';
//import 'dart:collection';
//import 'dart:js';

part 'entities/Entities.dart';

part 'graphics/Sprite.dart';

part 'math/Math.dart';
part 'math/Vector.dart';
part 'math/Matricies.dart';

CanvasElement canvas;
RenderingContext gl;

void main()
{
  canvas = querySelector("#canvas");
  gl = canvas.getContext3d();
  gl.enable(CULL_FACE);
  gl.frontFace(CCW);
  gl.cullFace(BACK);
  gl.clearColor(0, 0, 0, 0);
  gl.blendFunc(SRC_ALPHA, ONE_MINUS_SRC_ALPHA);
}

