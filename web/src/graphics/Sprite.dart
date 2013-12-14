part of ld28;

class Sprite
{

  static Sprite coin = new Sprite.static(1024, 1024, 'img/chrome.png');
  static Sprite block = new Sprite.static(128, 128, 'img/ogg.png');

  ITextureing texture;
  AABB box;

  Sprite(this.box, this.texture);
  Sprite.static(num width, num height, String url)
  {
    texture = gameInstance.textureCache.loadTexture(url);
    box = new AABB(0, 0, width, height);
  }

  static void init()
  {
    coin.texture;
    block.texture;
  }

  void draw(Vec2D position, double tweenTime)
  {
    gameInstance.renderingHelper.drawTexturedBox(box + position, texture);
  }

}