part of ld28;

abstract class ICollidable
{

  ICollisionShape getBounds();
  void onCollide(Entity other);

}