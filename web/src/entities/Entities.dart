part of ld28p;

abstract class Entity
{

  static Entity pirate = new Pirate();

  bool tick();

  void draw(double partialTime);

}

class Pirate extends Entity
{

  bool tick()
  {
    
  }

  void draw(double partialTick)
  {
    
  }

}