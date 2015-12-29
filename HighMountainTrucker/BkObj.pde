class BkObj
{
  int type;
  float xpos, ypos, xend;
  float increment, segmentWidth, maxObjWidth;
  color c1, c2;
  
  BkObj(int type, float xpos, float ypos)
  {
    this.type = type;
    this.xpos = xpos;
    this.ypos = ypos;
    if(type < 3)
    {
      this.increment = 3*h/58;
      this.segmentWidth = w/58;
      this.c1 = color(#001400);
      this.c2 = color(#3F1900);
    }
    else
    {
      this.increment = 3*h/64;
      this.segmentWidth = w/64;
      this.c2 = color(#001400);
      this.c1 = color(#3F1900);      
    }    
    switch(type)
    {
      case 0:
        this.xend = 28*segmentWidth;
        break;
      case 1:
        this.xend = 40*segmentWidth;
        break;
      case 2:
        this.xend = 42*segmentWidth;
        break;
      case 3:
        this.xend = 28*segmentWidth;
        break;
      case 4:
        this.xend = 40*segmentWidth;
        break;
      case 5:
        this.xend = 42*segmentWidth;
        break;        
    }
    maxObjWidth = 42*segmentWidth;
  }
  
  void update(float speed, float ascent)
  {
    if(type < 3)
    {
      xpos -= 0.05*speed;
      ypos += 0.01*ascent;     
    }
    else
    {
      xpos -= 0.25*speed;
      ypos += 0.05*ascent;        
    }

  }
  
  void display()
  {
    switch(type)
    {
      case 0:
        drawMountainA(xpos, ypos);
        break;
      case 1:
        drawMountainB(xpos, ypos);
        break;
      case 2:
        drawMountainC(xpos, ypos);
        break;
      case 3:
        drawMountainA(xpos, ypos);
        break;
      case 4:
        drawMountainB(xpos, ypos);
        break;
      case 5:
        drawMountainC(xpos, ypos);
        break;        
    }
  }
  
  void drawMountainA(float x, float y)
  {
    stroke(c1);
    fill(c1);
    for(int i=0; i<29; i++)
    {
      if(i<=14)
        rect(x+i*segmentWidth, y, segmentWidth, -i*increment);
      else
        rect(x+i*segmentWidth, y, segmentWidth, -(14*increment - (i-14)*increment));
    }
    stroke(c2);
    fill(c2);
    for(int i=1; i<27; i++)
    {
      if(i<=13)
        rect(x+segmentWidth+i*segmentWidth, y, segmentWidth, -i*increment);
      else
        rect(x+segmentWidth+i*segmentWidth, y, segmentWidth, -(13*increment - (i-13)*increment));
    }  
  }
  
  void drawMountainB(float x, float y)
  {
    stroke(c1);
    fill(c1);
    for(int i=0; i<41; i++)
    {
      if(i<=14)
        rect(x+i*segmentWidth, y, segmentWidth, -i*increment);
      else if(14<i && i<=24)
      {
        rect(x+i*segmentWidth, y, segmentWidth, -14*increment);      
      }
      else
        rect(x+i*segmentWidth, y, segmentWidth, -(14*increment - (i-24)*increment));
    }
    stroke(c2);
    fill(c2);
    for(int i=1; i<39; i++)
    {
      if(i<=13)
        rect(x+segmentWidth+i*segmentWidth, y, segmentWidth, -i*increment);
      else if(13<i && i<=23)
      {
        rect(x+segmentWidth+i*segmentWidth, y, segmentWidth, -13*increment);
      }
      else
        rect(x+segmentWidth+i*segmentWidth, y, segmentWidth, -(13*increment - (i-23)*increment));
    }  
  }
  
  void drawMountainC(float x, float y)
  {
    // peak 1
    stroke(c1);
    fill(c1);
    for(int i=0; i<29; i++)
    {
      if(i<=14)
        rect(x+i*segmentWidth, y, segmentWidth, -i*increment);
      else
        rect(x+i*segmentWidth, y, segmentWidth, -(14*increment - (i-14)*increment));
    }
    stroke(c2);
    fill(c2);
    for(int i=1; i<27; i++)
    {
      if(i<=13)
        rect(x+segmentWidth+i*segmentWidth, y, segmentWidth, -i*increment);
      else
        rect(x+segmentWidth+i*segmentWidth, y, segmentWidth, -(13*increment - (i-13)*increment));
    }  
    
    // peak 2
    x = x + 14*segmentWidth;
    y = y + 3*increment;
    stroke(c1);
    fill(c1);
    for(int i=0; i<29; i++)
    {
      if(i<=14)
        rect(x+i*segmentWidth, y, segmentWidth, -i*increment);
      else
        rect(x+i*segmentWidth, y, segmentWidth, -(14*increment - (i-14)*increment));
    }
    stroke(c2);
    fill(c2);
    for(int i=1; i<27; i++)
    {
      if(i<=13)
        rect(x+segmentWidth+i*segmentWidth, y, segmentWidth, -i*increment);
      else
        rect(x+segmentWidth+i*segmentWidth, y, segmentWidth, -(13*increment - (i-13)*increment));
    }  
  }  
}