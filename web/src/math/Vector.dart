part of ld28p;

class Vector
{

  double x;
  double y;

  Vector(this.x, this.y);

  operator +(Vector other) => new Vector(x+other.x, y+other.y);

  operator -(Vector other) => new Vector(x-other.x, y-other.y);

  operator *(double scalar) => new Vector(scalar * x, scalar * y);

  double dot(Vector other) => ((x * other.x) + (y * other.y));

  

}