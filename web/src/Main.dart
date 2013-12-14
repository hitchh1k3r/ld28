library ld28;

import 'dart:html';
import 'dart:web_gl';
import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:collection';

part 'LD28.dart';

//part 'audio/.dart';

part 'entities/Entity.dart';
part 'entities/properties/IClickable.dart';
part 'entities/properties/ICollidable.dart';
part 'entities/properties/IKeyboardReactive.dart';
part 'entities/properties/IMoving.dart';
part 'entities/EntityBlock.dart';
part 'entities/EntityCoin.dart';
part 'entities/EntityPlayer.dart';

part 'entities/properties/IDrawable.dart';
part 'graphics/ITextureing.dart';
part 'graphics/RenderingHelper.dart';
part 'graphics/Sprite.dart';
part 'graphics/TextureManager.dart';
part 'graphics/ShaderManager.dart';

part 'math/ICollisionShape.dart';
part 'math/2DMath.dart';
part 'math/MatrixMath.dart';

LD28 gameInstance;
final bool DEBUG = true;

void waitForAssets()
{
  if(gameInstance.assetsToLoad == 0)
  {
    gameInstance.setUpGL();
    gameInstance.loop();
  }
  else
  {
    new Future.delayed(new Duration(milliseconds: 200)).then((q) { waitForAssets(); });
  }
}

void main()
{
  gameInstance = new LD28();
  gameInstance.assetsToLoad += 1;
  gameInstance.init();
  waitForAssets();
  --gameInstance.assetsToLoad;
}