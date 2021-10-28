abstract class Pickup
{
  boolean counterOn;
  int value;
  float xpos, ypos, pickupw, pickuph, xend, yend;
  float speed, ascent;
  color cyellow, cblue;
  PImage img;
  
  // special effect
  int counter, cellSize, rows, columns;
  float effectxpos, effectypos;
  float[][] pxdir, pydir, pSizes, pScaling;
  
  Pickup(float _x, float _y)
  {
    xpos = _x;
    ypos = _y;
    pickupw = w/22;
    pickuph = w/20;
    xend = xpos + pickupw;
    yend = ypos + pickuph;
    
    // special effect
    counterOn = false;
    counter = 0;
    cellSize = 8;
    columns = int(pickupw / cellSize);
    rows = int(pickuph / cellSize);
    pxdir = new float[columns][rows];
    pydir = new float[columns][rows];
    pSizes = new float[columns][rows];
    pScaling = new float[columns][rows];    
    cyellow = 224;
    cblue = 0;
    
    for(int i=0; i<columns; i++)
    {
      for(int j=0; j<rows; j++)
      {
        pxdir[i][j] = random(-10,10);
        pydir[i][j] = random(-10,10);
        pSizes[i][j] = cellSize;
        pScaling[i][j] = random(1);
      }
    }     
  }
  
  void update(float _s, float _asc)
  {
    speed = _s;
    ascent = _asc;
    xpos = xpos - speed;
    xend = xpos + pickupw;  
    ypos = ypos + ascent;
    yend = ypos + pickuph;
    if(xpos < -50*rw)  
    {
      xpos = w + random(480)*rw;   
      ypos = random(h) + ascent;
    }
  }
  
  void display()
  {
    stroke(200);
    fill(200);
    rectMode(CORNER);
    image(img, xpos, ypos, pickupw, pickuph);
  }
  
  void captureEffect()
  {
    if(counter < frameRate && counterOn == true)
    {
      color c = color(255,cyellow,cblue); //img.pixels[int(loc)];
      fill(c, 204);
      for(int i=0; i<columns; i++)
      {
        for(int j=0; j<rows; j++)
        {
          float x = i*cellSize+cellSize/2;
          float y = j*cellSize+cellSize/2;
          float loc = x+y*img.width;
  
          if(counter<10)
            pSizes[i][j] = pSizes[i][j] + pScaling[i][j];
          else
            pSizes[i][j] = pSizes[i][j] - pScaling[i][j];
          pushMatrix();
          translate(x+pxdir[i][j], y+pydir[i][j]);
          rectMode(CENTER);
          rect(effectxpos, effectypos, pSizes[i][j], pSizes[i][j]);
          popMatrix();
          pxdir[i][j] = pxdir[i][j] + 0.1*pxdir[i][j];
          pydir[i][j] = pydir[i][j] + 0.1*pydir[i][j];        
        }
      }
      counter++;
      cyellow++;
      cblue += 8;
    }    
    else  
    {
      counterOn = false;
      counter = 0;
      cyellow = 224;
      cblue = 0;
      setEffect();
    }
  }
  
  void setEffect()
  {
    for(int i=0; i<columns; i++)
    {
      for(int j=0; j<rows; j++)
      {
        pxdir[i][j] = -80;
        pydir[i][j] = random(-80, -5);
        pSizes[i][j] = cellSize;
        pScaling[i][j] = random(1);
      }
    }    
  }  
}