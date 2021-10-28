class Bar
{
  float xpos, ypos, barWidth, barHalfWidth, barHeight, mousePosX, mousePosY, speed, ascent;
  
  Bar(float _x, float _y, float _s)
  {
    xpos = _x;
    ypos = _y;
    speed = _s;
    barWidth = w/20;
    barHalfWidth = barWidth/2;
    barHeight = 0;  // not used?
    mousePosX = 0;
    mousePosY = w/6;
  }
  
  void update(float _x, float _y, float _sX, float _asc)
  {
    speed = _sX;
    ascent = _asc;
    xpos = xpos - speed;
    ypos = ypos + ascent;
    mousePosX = _x;
    if(xpos>mousePosX-barHalfWidth && xpos<mousePosX+barHalfWidth)
    {
      ypos = _y;
    }    
  }
  
  void display()
  {
    rectMode(CORNER);
    stroke(0);
    strokeWeight(1);
    fill(#5CE200);   
    rect(xpos-barHalfWidth, ypos, barWidth, h-ypos);
  }
}