boolean collisionCounterOn;
int state, score, interval, intervalCounter;
float w, h, ow, oh, rw, rh;
float barWidth, barHeight, speedX, speedXdelta, speedY, gravity, ascentSpeed;
Player player;
Bar[] Bars;
BkObj[] BkObjs;
Coin[] Coins;
Gem[] Gems;
Manager manager;
Boulder[] Boulders;
PImage titleText;
PFont zerovelo;

void settings()
{
  size(640,640,P2D);  
  w = h = 640;
  ow = oh = 480;
  rw = w/480;
  rh = h/480;
}

void setup()
{
  size(640,640,P2D);  // for Processing v. 2  
  frameRate(30);
  manager = new Manager();  
  manager.setupEnvironment();
  manager.setupBackgroundObjects();
  manager.setupBars();
  manager.setupPlayer();
  manager.setupBoulders();
  manager.setupPickups();
}

void draw()
{
  manager.manageBackgrounds();
  manager.manageBars();
  if(state == 1)
  {
    if(frameCount % 360 == 0)
      manager.changeAscent(int(random(100)));
    if(frameCount % 30 == 0)
      if(abs(speedX - speedXdelta) > 1.0)
      {
        speedXdelta = speedX;
        realign();
      }
    manager.manageBoulders();
    manager.managePickups();
    player.update();
    if(collisionCounterOn == false)
    {
      player.display();
      manager.detectPickups();
    }
    player.explode();
    println("player.ypos: " + player.ypos + " , h: " + h);
  }
  manager.manageFonts();
}

void realign()
{
  Bars[0].xpos = round(Bars[0].xpos);
  for(int i=1; i<22; i++) 
  {
    if(Bars[i].xpos>Bars[0].xpos)
      Bars[i].xpos = Bars[0].xpos + i*barWidth;
    else
      Bars[i].xpos = Bars[0].xpos - (22-i)*barWidth;
  }
} 

void detectCollisions()
{
  for(int i=0; i<Boulders.length; i++)
  {
    if((player.xpos>Boulders[i].xpos && player.xpos<Boulders[i].xend && player.ypos>Boulders[i].ypos && player.ypos<Boulders[i].yend) || player.ypos>h)
    {
      collisionCounterOn = true;
      //speedX = 0;
      break;
    }
  }
}

void mousePressed()
{
  if(state == 0)
    state = 1;
}

// test
void keyPressed()
{
  if(key == 'a')
  {
    speedX += 0.2;  
    println("Speed x: " + speedX);
  }
  if(key == 's')
  {
    speedX -= 0.2;
    println("Speed x: " + speedX);
  }
  if(key == 'r')
    realign();
  if(key == '0')
    state = 0;
  if(key == '1')
    state = 1;
}
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
    if(xpos<w/6 && xpos>w/6-w/20)
    {
      player.setPrevBarHeight(ypos);  
    }
    if(xpos>w/6 && xpos<w/6+w/20)
    {
      player.setBarHeight(ypos);
      player.lastypos = player.ypos;
      if(player.ypos<ypos)
      {
        player.ypos += speedY;  
        speedY += gravity;
      }
      else
      {
        player.ypos = ypos;
        speedY = 1;
      }
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
class Boulder
{
  int slices;
  float xpos, ypos, boulderw, boulderh, xend, yend, tl, tr, bl, br, sliceSize;
  color c1, c2;
  PImage img;
  
  Boulder(float _x, float _y, float _w, float _h, float _tl, float _tr, float _bl, float _br)
  {
    xpos = _x;
    ypos = _y;
    boulderw = _w;
    boulderh = _h;
    tl = _tl;
    tr = _tr;
    bl = _bl;
    br = _br;
    xend = xpos + boulderw;
    yend = ypos + boulderh;
    sliceSize = w/20;
    slices = int(w/sliceSize);
    c1 = color(int(random(0, 100)));
    c2 = color(int(random(100, 200)));
    img = loadImage("rock5.png");
  }
  
  void update(float _asc)
  {
    xpos = xpos - speedX; 
    xend = xpos + boulderw;
    ypos = ypos + _asc;
    yend = yend + _asc;
  }
  
  void display()
  {
    imageMode(CORNER);
    image(img, xpos, ypos, boulderw, boulderh);
    noTint();
  }
  
  void reposition()
  {
    xpos = w;
    ypos = random(-10, 3*h/4);
    boulderw = random(width/20, 6*width/20);
    boulderh = random(width/20, 6*width/20);
    xend = xpos + boulderw;
    yend = ypos + boulderh;
    tl = random(50);
    tr = random(50);
    bl = random(50);
    br = random(50);
    c1 = color(int(random(0, 100)));
    c2 = color(int(random(100, 200)));
    sliceSize = w/20;
  }
}
class Coin extends Pickup
{
  boolean expand;
  
  Coin(float _x, float _y)
  {
    super(_x, _y);
    expand = true;
    img = loadImage("coin.png");
  }
  
  void update(float _s, float _asc)
  {
    super.update(_s, _asc);
    if(pickupw>35*rw && expand == true)
    {
      expand = false;
      pickupw -= 2;
    }
    else if(pickupw<5*rw && expand == false)
    {
      expand = true;
      pickupw += 2;
    }
    else if(expand == true)
      pickupw += 2;
    else
      pickupw -= 2;  
  }
  
  void display()
  {
    stroke(200);
    noFill();
    rectMode(CORNER);
    imageMode(CENTER);   
    image(img, xpos+pickupw/2, ypos+pickuph/2, pickupw, pickuph);
    // rect(xpos, ypos, pickupw, pickuph);
  }
}
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
class Manager
{
  
  int pickupcounter = 0;
  
  void setupEnvironment()
  {
    w = h = 640;
    ow = oh = 480;
    rw = w/480;
    rh = h/480;    
    background(#000028);
    speedX = speedXdelta = 4*rw;
    speedY = 1*rh;
    gravity = 0.4*rh;
    ascentSpeed = 0;
    interval = int(random(w/speedX, 4*w/speedX));
    intervalCounter = 0;
    collisionCounterOn = false;
    state = 0;
    score = 0;
    titleText = loadImage("TitleText.png");
    zerovelo = createFont("zerovelo.ttf", h/24);
  }
  
  void setupBars()
  {
    barWidth=w/20;
    barHeight = h-h/6;
    Bars = new Bar[22];
    for(int i=0; i<22; i++) 
    {
      Bars[i] = new Bar(i*barWidth, barHeight, speedX);  
    }    
  }
  
  void setupBackgroundObjects()
  {
    BkObjs = new BkObj[7];
    for(int i=0; i<4; i++)
    {
      BkObjs[i] = new BkObj(int(random(3)), i*200*rw + random(200), h);  
    }
    for(int i=4; i<7; i++)
    {
      BkObjs[i] = new BkObj(int(random(3, 6)), i*200*rw + random(200), h);  
    }      
  }
  
  void setupPlayer()
  {
    player = new Player(w/6, h-h/6);
  }
  
  void setupBoulders()
  {
    Boulders = new Boulder[2];
    for(int i=0; i<Boulders.length; i++)    
      Boulders[i] = new Boulder(w, random(-10, 3*h/4), random(width/20, 6*width/20), random(width/20, 6*width/20), random(50), random(50), random(50), random(50));
  }
  
  void setupPickups()
  {
    Coins = new Coin[2];
    for(int i=0; i<Coins.length; i++)
      Coins[i] = new Coin(i*480*rw + random(480)*rw, random(h));
    Gems = new Gem[2];
    for(int i=0; i<Coins.length; i++)
      Gems[i] = new Gem(i*480*rw + random(480)*rw, random(h));
  }
  
  void managePickups()
  {
    for(int i=0; i<Coins.length; i++)
    {
      Coins[i].update(speedX, ascentSpeed);
      Gems[i].update(speedX, ascentSpeed);
      Coins[i].display();
      Coins[i].captureEffect();
      Gems[i].display();    
      Gems[i].captureEffect();
    }
  }
  
  void detectPickups()
  {
    for(int i=0; i<Coins.length; i++)
    {    
      if(player.xpos>Coins[i].xpos && player.xpos<Coins[i].xend && 
        ((player.ypos-player.yoffset>Coins[i].ypos && player.ypos-player.yoffset<Coins[i].yend) || (player.ypos>Coins[i].ypos && player.ypos<Coins[i].yend)))
      {
        speedX += 5*rw;  
        pickupcounter += 1;
        score += 25;
        Coins[i].effectxpos = Coins[i].xpos;
        Coins[i].effectypos = Coins[i].ypos;        
        Coins[i].xpos = w + random(200);   
        Coins[i].ypos = random(h);
        Coins[i].counterOn = true;
        println("Overlapped: " + pickupcounter);
      }
      if(player.xpos>Gems[i].xpos && player.xpos<Gems[i].xend && 
        ((player.ypos-player.yoffset>Gems[i].ypos && player.ypos-player.yoffset<Gems[i].yend) || (player.ypos>Gems[i].ypos && player.ypos<Gems[i].yend)))
      {
        speedX += 5*rw;  
        pickupcounter += 1;
        score += 50;
        Gems[i].xpos = w + random(200);   
        Gems[i].ypos = random(h);
        Gems[i].counterOn = true;
        println("Overlapped: " + pickupcounter);
      }      
    }       
  }    
  
  void manageBackgrounds()
  {
    background(#000028);
    for(int i=0; i<BkObjs.length; i++)
    {
      if(BkObjs[i].xpos < 0-BkObjs[i].maxObjWidth)
      {
        BkObjs[i].xpos = w + random(50);
      }
    BkObjs[i].update(speedX, ascentSpeed);
    BkObjs[i].display();
    }  
  }
  
  void manageBars()
  {
    for(int i=0; i<Bars.length; i++)
    {
      if(Bars[i].xpos<0-2*barWidth)
      {
        barHeight = random(mouseY, h);
        Bars[i].xpos = w;
      }
      Bars[i].update(mouseX, mouseY, speedX, ascentSpeed);
      Bars[i].display(); 
    }     
  }
  
  void manageFonts()
  {
    if(state == 0)
    {
      rectMode(CENTER);
      image(titleText,0,h/4,w,titleText.height*rh);
    }
    if(state == 1)
    {
      fill(255,0,0);
      textFont(zerovelo);
      text("Score: " + score, w/30, h/20);  
    }
  }
  
  void manageBoulders()
  {
    for(int i=0; i<Boulders.length; i++)
    {
      if(Boulders[i].xend<0-2*barWidth)
      {
        Boulders[i].reposition();  
      }
      else 
      {
        Boulders[i].update(ascentSpeed);      
        //println("Boulder xpos: " + Boulders.get(i).xpos + " Boulder ypos: " + Boulders.get(i).ypos + " Boulder xend: " + Boulders.get(i).xend + " Boulder yend: " + Boulders.get(i).yend);
        Boulders[i].display();      
      }
      detectCollisions();
    }
  }

  void changeAscent(int change)
  {
    if(change<76)
      ascentSpeed = h/oh*random(0, 2.5);
    else
      ascentSpeed = -h/oh*random(0, 2.5);
  }  
  
  public class colorSets
  { // player1 (body), player2 (wheels), background1 (bars), background2 (background obj), background3 (background obj), background4 (sky), obstacle1 (rock), obstacle2 (tree)
    color[] set1 = {};
    color[] set2 = {color(#7fb7be), color(#dacc3e), color(#5CE200),  color(#bc2c1a), color(#7d1538), color(#000028)};
    color[] set3 = {};
  }  
}
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
class Player
{
  boolean snapshot, exploding;
  int cellSize, columns, rows, counter;
  float xpos, ypos, lastypos, xoffset, yoffset;
  float avg0, avg1;
  float barHeight, prevBarHeight;
  float[] trpos;
  float[][] pxdir, pydir, pSizes, pScaling;
  color c1, c2, c3;
  PImage img;
  
  Player(float x, float y)
  {
    xpos = x;
    ypos = lastypos = y;
    xoffset = 48*rw;
    yoffset = 30*rh;
    trpos = new float[4];
    for(int i=0; i<4; i++)
      trpos[i] = y;
    
    // explosion method attributes
    snapshot = false;
    exploding = false;
    counter = 0;
    cellSize = 8;
    columns = int(xoffset / cellSize);
    rows = int(yoffset / cellSize);
    pxdir = new float[columns][rows];
    pydir = new float[columns][rows];
    pSizes = new float[columns][rows];
    pScaling = new float[columns][rows];  
    
    // initialization of arrays for explosion
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
  
  void update()
  {
    if(exploding == false)
    { 
      trpos[3] = trpos[2];
      trpos[2] = trpos[1];      
      trpos[1] = trpos[0]; 
      trpos[0] = ypos;           
    }
    avg0 = (trpos[0] + trpos[1] + trpos[2])/3;
    avg1 = (trpos[1] + trpos[2] + trpos[3])/3;
    // speed conditions
    // 1. cap speed at 30
    // 2. speed cannot be negative (speedX >0)
    // 3. going uphill slows you down
    // 4. going downhill or straight speeds you up
    if(prevBarHeight - barHeight > yoffset)
      speedX -= 0.01*(prevBarHeight-barHeight);
    else if(prevBarHeight <= barHeight)
      speedX += 0.03 + 0.01*(barHeight-prevBarHeight);
    if(speedX < 0)
      speedX = 0;
    if(speedX > 20*rw)
      speedX = 20*rw;
    rectMode(CORNER);
    stroke(200);
    noFill();
    // rect(xpos, ypos-yoffset, xoffset, yoffset);
  }
  
  void display()
  {
    pushMatrix();
    translate(xpos, ypos);
    if(ypos > lastypos)
      rotate(-2*PI/(ypos/lastypos));
    else
      rotate(-2*PI/(avg0/avg1));
    drawRover();
    popMatrix();
    if(snapshot == false)
      getImage();
  }
    
    void drawRover()
    {
      c1 = color(#7FB7BE);
      c2 = color(#DACC3E);
      c3 = color(#D3F3EE);
      stroke(c1);
      fill(c1);
      rectMode(CORNER);
      rect(rw*10, -yoffset+rw*6, rw*32, rw*14);
      rect(rw*0, -yoffset+rw*6, rw*10, rw*10);
      rect(rw*10, -yoffset+rw*0, rw*20, rw*6);
      rect(rw*10, -yoffset+rw*2, rw*22, rw*4);
      stroke(c3);
      fill(c3);
      rect(rw*18, -yoffset+rw*2, rw*10, rw*4);
      stroke(c2);
      fill(c2);
      ellipseMode(CORNER);
      ellipse(rw*4, -yoffset+rw*10, rw*20, rw*20);
      ellipse(rw*28, -yoffset+rw*10, rw*20, rw*20);    
    }    
    
    void getImage()
    {
      img = get(int(xpos), int(ypos-yoffset), int(xoffset), int(yoffset));  
      snapshot = true;
    }    
    
    void setBarHeight(float y)
    {
      barHeight = y;  
    }    
    
    void setPrevBarHeight(float y)
    {
      prevBarHeight = y;  
    }
    
  void explode()
  {
    if(collisionCounterOn && counter<frameRate/2)
    {
      for(int i=0; i<columns; i++)
      {
        for(int j=0; j<rows; j++)
        {
          float x = i*cellSize+cellSize/2;
          float y = j*cellSize+cellSize/2;
          float loc = x+y*img.width;
          color c = img.pixels[int(loc)];
          if(counter<frameRate/4)
            pSizes[i][j] = pSizes[i][j] + 3*pScaling[i][j];
          else
            pSizes[i][j] = pSizes[i][j] - 3*pScaling[i][j];
          pushMatrix();
          translate(x+pxdir[i][j], y+pydir[i][j]);
          fill(c, 204);
          rectMode(CENTER);
          rect(xpos-img.width/2, ypos-img.height/2, pSizes[i][j], pSizes[i][j]);
          popMatrix();
          //text("Game Over", w/2, h/2);
          pxdir[i][j] = pxdir[i][j] + 0.1*pxdir[i][j];
          pydir[i][j] = pydir[i][j] + 0.1*pydir[i][j];        
        }
      }
      counter++;
    }
    else if(collisionCounterOn)
    {
      collisionCounterOn = false;
      exploding = false;
      counter = 0;
      cellSize = 4;
      for(int i=0; i<columns; i++)
      {
        //println();
        for(int j=0; j<rows; j++)
        {
          pxdir[i][j] = random(-10,10);
          pydir[i][j] = random(-10,10);
          pSizes[i][j] = cellSize;
        }
      }
      manager.setupEnvironment();
      manager.setupBoulders();
      /*
      state = 0;
      speedX = speedXdelta = 4*rw;
      speedY = 1*rh;
      gravity = 0.4*rh;
      ascentSpeed = 0;
      heightCount = 1;
      lastHeight = h-h/6;
      heightSum = 1;
      momentum = 1;
      score = 0;
      */
    }  
  }       
}

