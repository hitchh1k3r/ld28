part of ld28;

abstract class ICollisionShape
{

  static bool AABBvAABB(AABB first, AABB second)
  {
    return (first.getLeft() < second.getRight() && first.getRight() > second.getLeft() &&
        first.getTop() < second.getBottom() && first.getBottom() > second.getTop());
  }

  static bool CirclevCircle(Circle first, Circle second)
  {
    return (first.origin - second.origin).sqMagnitude() <= (first.radius+second.radius) * (first.radius+second.radius);
  }

  static bool AABBvCircle(AABB first, Circle second)
  {
    return (second.origin.x > first.getLeft() && second.origin.y > first.getTop() && second.origin.x < first.getRight() && second.origin.y < first.getBottom()) ||
           LinevCircle(first.getAB(), second) ||
           LinevCircle(first.getBD(), second) ||
           LinevCircle(first.getAC(), second) ||
           LinevCircle(first.getCD(), second);
  }

  static bool LinevLine(Line first, Line second)
  {
    Vec2D s1 = first.B-first.A;
    Vec2D s2 = second.B-second.A;
    double s = (-s1.y * (first.A.x - second.A.x) + s1.x * (first.A.y - second.A.y)) / (-s2.x * s1.y + s1.x * s2.y);
    double t = ( s2.x * (first.A.y - second.A.y) - s2.y * (first.A.x - second.A.x)) / (-s2.x * s1.y + s1.x * s2.y);
    return (s >= 0 && s <= 1 && t >= 0 && t <= 1);
  }

  static bool AABBvLine(AABB first, Line second)
  {
    return LinevLine(first.getAB(), second) || LinevLine(first.getBD(), second) || LinevLine(first.getAC(), second) || LinevLine(first.getCD(), second);
  }

  static bool LinevCircle(Line first, Circle second)
  {
    Vec2D AC = second.origin - first.A;
    Vec2D AB = first.B - first.A;
    Vec2D AD = AB.scale(AC.dot(AC));
    Vec2D D = first.A + AD;
    return (D - second.origin).sqMagnitude() <= second.radius * second.radius;
  }

  bool checkCollision(ICollisionShape other)
  {
    if(this is AABB)
    {
      if(other is AABB)
      {
        return AABBvAABB(this, other);
      }
      else if(other is Circle)
      {
        return AABBvCircle(this, other);
      }
      else if(other is Line)
      {
        return AABBvLine(this, other);
      }
    }
    else if(this is Circle)
    {
      if(other is AABB)
      {
        return AABBvCircle(other, this);
      }
      else if(other is Circle)
      {
        return CirclevCircle(this, other);
      }
      else if(other is Line)
      {
        return LinevCircle(other, this);
      }
    }
    else if(this is Line)
    {
      if(other is AABB)
      {
        return AABBvLine(other, this);
      }
      else if(other is Circle)
      {
        return LinevCircle(this, other);
      }
      else if(other is Line)
      {
        return LinevLine(this, other);
      }
    }
    return false;
  }

}