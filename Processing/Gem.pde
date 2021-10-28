class Gem extends Pickup
{
  
  Gem(float _x, float _y)
  {
    super(_x, _y);
    img = loadImage("emerald.png");
  }
  
  void update(float _s, float _asc)
  {
    super.update(_s, _asc);
  }
  
  void display()
  {
    imageMode(CORNER);
    image(img, xpos, ypos, pickupw, pickuph);
  }
}