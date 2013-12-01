part of ld28p;

class MyMath
{

  static double radToDeg(double angle)
  {
    return angle * 180.0 / PI;
  }

  static double degTorad(double angle)
  {
    return angle * PI / 180.0;
  }

  static double pointToAngle(double deltaX, double deltaY)
  {
    double angle = atan2(deltaY, deltaX);
    if(angle < 0)
      angle = (2 * PI) + angle;
    return angle;
  }

  static num easeIn(num time, num length, num start, num end)
  {
    time /= length;
    return (end - start) * time * time + start;
  }

  static num easeOut(num time, num length, num start, num end)
  {
    time /= length;
    return (start - end) * time * (time-2) + start;
  }

  static num ease(num time, num length, num start, num end)
  {
    if(time / length > 0.5)
    {
      return easeOut(time, length, start, end);
    }
    else
    {
      return easeIn(time, length, start, end);
    }
  }

}