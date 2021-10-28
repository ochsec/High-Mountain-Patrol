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
  size(displayWidth,displayWidth,P2D);  
  w = h = displayWidth;
  ow = oh = 480;
  rw = w/480;
  rh = h/480;
}

void setup()
{
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