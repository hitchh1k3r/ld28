part of ld28;

class Vec2D
{

  num x, y;

  Vec2D(this.x, this.y);
  Vec2D.from(Vec2D copy)
  {
    x = copy.x;
    y = copy.y;
  }

  operator /(num divisor)
  {
    return new Vec2D(x/divisor, y/divisor);
  }

  operator *(Vec2D other)
  {
    return new Vec2D(x*other.x, y*other.y);
  }

  operator +(Vec2D other)
  {
    return new Vec2D(x+other.x, y+other.y);
  }

  operator -(Vec2D other)
  {
    return new Vec2D(x-other.x, y-other.y);
  }

  num magnitude()
  {
    return sqrt(sqMagnitude());
  }

  num sqMagnitude()
  {
    return x*x + y*y;
  }

  num dot(Vec2D other)
  {
    return (x*other.x) + (y*other.y);
  }

  Vec2D scale(num scale)
  {
    return new Vec2D(scale*x, scale*y);
  }

}

class AABB extends ICollisionShape
{

  Vec2D topLeft;
  Vec2D size;

  AABB(num left, num top, num width, num height)
  {
    topLeft = new Vec2D(left, top);
    size = new Vec2D(width, height);
  }

  AABB.centered(num width, num height)
  {
    topLeft = new Vec2D(-width/2, -height/2);
    size = new Vec2D(width, height);
  }

  num getLeft()
  {
    return topLeft.x;
  }

  num getRight()
  {
    return topLeft.x + size.x;
  }

  num getTop()
  {
    return topLeft.y;
  }

  num getBottom()
  {
    return topLeft.y+size.y;
  }

  // A ---- B
  // |      |
  // C ---- D
  Line getAB()
  {
    return new Line(new Vec2D(topLeft.x, topLeft.y), new Vec2D(topLeft.x+size.x, topLeft.y));
  }
  Line getAC()
  {
    return new Line(new Vec2D(topLeft.x, topLeft.y), new Vec2D(topLeft.x, topLeft.y+size.y));
  }
  Line getBD()
  {
    return new Line(new Vec2D(topLeft.x+size.x, topLeft.y), new Vec2D(topLeft.x+size.x, topLeft.y+size.y));
  }
  Line getCD()
  {
    return new Line(new Vec2D(topLeft.x, topLeft.y+size.y), new Vec2D(topLeft.x+size.x, topLeft.y+size.y));
  }

  operator+ (Vec2D offset)
  {
    return new AABB(topLeft.x + offset.x, topLeft.y + offset.y, size.x, size.y);
  }

}

class Circle extends ICollisionShape
{

  Vec2D origin;
  num radius;

  Circle(this.origin, this.radius);

}

class Line extends ICollisionShape
{

  Vec2D A;
  Vec2D B;

  Line(this.A, this.B);

}