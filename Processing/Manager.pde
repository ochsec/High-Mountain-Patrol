class Manager
{
  
  int pickupcounter = 0;
  
  void setupEnvironment()
  {
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