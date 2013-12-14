part of ld28;

class SubTexture implements ITextureing
{

  TextureUnit parent;
  AABB uvs;
  static List<TextureUnit> texUnits = new List<TextureUnit>();
  static TextureUnit smoothTex;
  static TextureUnit nearestTex;
  RenderingContext context;
  Buffer uvBuffer;

  SubTexture(String url, this.context, [bool smooth = false])
  {
    gameInstance.assetsToLoad += 1;
    prepTextures(smooth);
    uvBuffer = context.createBuffer();
    ImageElement img = new ImageElement();
    img.onLoad.listen((e)
      {
        print('image loaded');
        Vec2D topLeft = parent.addImage(img);
        if(topLeft == null)
        {
          prepTextures(smooth);
          topLeft = parent.addImage(img);
        }
        print(topLeft.x.toString() + ', ' + topLeft.y.toString());
        if(topLeft != null)
        {
          uvs = new AABB(topLeft.x, topLeft.y, img.width/TextureUnit.TEXTURE_SIZE, img.height/TextureUnit.TEXTURE_SIZE);
          context.bindBuffer(ARRAY_BUFFER, uvBuffer);
//          context.bufferDataTyped(ARRAY_BUFFER, new Float32List.fromList([uvs.getLeft(), uvs.getBottom(), uvs.getRight(), uvs.getTop(), uvs.getLeft(), uvs.getTop(),
//                                                                          uvs.getLeft(), uvs.getBottom(), uvs.getRight(), uvs.getBottom(), uvs.getRight(), uvs.getTop()]), STATIC_DRAW);
          context.bufferDataTyped(ARRAY_BUFFER, new Float32List.fromList([0.0, 1.0, 1.0, 0.0, 0.0, 0.0,
                                                                          0.0, 1.0, 1.0, 1.0, 1.0, 0.0]), STATIC_DRAW);
        }
        --gameInstance.assetsToLoad;
      });
    img.src = url;
  }

  void prepTextures(bool smooth)
  {
    if(smooth)
    {
      if(smoothTex == null)
      {
        smoothTex = new TextureUnit(context, smooth);
        texUnits.add(smoothTex);
      }
    }
    else
    {
      if(nearestTex == null)
      {
        nearestTex = new TextureUnit(context, smooth);
        texUnits.add(nearestTex);
      }
    }
    parent = (smooth ? smoothTex : nearestTex);
  }

  Texture getTexture()
  {
    return parent.tex;
  }

  Buffer getUVBuffer()
  {
    return uvBuffer;
  }

}

class TextureUnit
{

  Texture tex;
  int cX = 0;
  int cY = 0;
  int cMax = 0;
  RenderingContext context;
  static final int TEXTURE_SIZE = 1024;

  TextureUnit(this.context, [bool smooth = false])
  {
    tex = context.createTexture();
    context.bindTexture(TEXTURE_2D, tex);
    context.texImage2D(TEXTURE_2D, 0, RGBA, 1024, 1024, 0, RGBA, UNSIGNED_BYTE, new Uint8List(1024 * 1024 * 4));
    context.texParameteri(TEXTURE_2D, TEXTURE_MAG_FILTER, smooth ? LINEAR : NEAREST);
    context.texParameteri(TEXTURE_2D, TEXTURE_MIN_FILTER, smooth ? LINEAR : NEAREST);
    context.bindTexture(TEXTURE_2D, null);
  }

  Vec2D addImage(ImageElement image)
  {
    Vec2D location = findSpace(image.width, image.height);
    if(location == null)
    {
      return null;
    }
    cMax = max(image.height, cMax);
    context.bindTexture(TEXTURE_2D, tex);
    print('putting image at: ' + location.x.toString() + ', ' + location.y.toString());
    context.texSubImage2DImage(TEXTURE_2D, 0, location.x, location.y, RGBA, UNSIGNED_BYTE, image);
    context.bindTexture(TEXTURE_2D, null);
    return location/TEXTURE_SIZE;
  }

  Vec2D findSpace(int width, int height)
  {
    if((cX += width) > TEXTURE_SIZE)
    {
      cX = 0;
      cY += cMax;
      if(cY > TEXTURE_SIZE)
      {
        return null;
      }
    }
    return new Vec2D(cX, cY);
  }

}

class TextureCache
{

  RenderingContext context;

  TextureCache(this.context);

  Map<String, SubTexture> cache = new Map<String, SubTexture>();

  SubTexture loadTexture(String url, [bool smooth = false])
  {
    if(cache.containsKey(url))
    {
      return cache[url];
    }
    SubTexture result = new SubTexture(url, context, smooth);
    cache[url] = result;
    return result;
  }

}