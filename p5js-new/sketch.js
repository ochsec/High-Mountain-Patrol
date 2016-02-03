var collisionCounterOn;   // boolean
var state, score, interval, intervalCounter;  // int
var w, h, ow, oh, rw, rh; // float
var barWidth, barHeight, speedX, speedXDelta, speedY, gravity, ascentSpeed; // float
var Bars = [];
var BkObjs = [];
var Coins = [];
var Gems = [];
var Boulders = [];

function setup() {
  createCanvas(480, 480);
  frameRate(30);
  w = width;
  h = width;
  ow = 480;
  oh = 480;
  rw = w/480;
  rh = h/480;
  Manager.setupEnvironment();
  Manager.setupBars();
}

function draw() {
  background('#000028');
  Manager.manageBars();
}

var Manager = {
  pickupcounter: 0,
  
  setupEnvironment: function () {
    background('#000028');
    speedX = speedXDelta = 4*rw;
    speedY = 1*rh;
    gravity = 0.4*rh;
    ascentSpeed = 0;
    interval = round(random(1, 4) * w/speedX);
    intervalCounter = 0;
    collisionCounter = false;
    state = 0;
    score = 0;
    //titleText =  load image text
    //zerovelo =  create font
  },
  
  setupBars: function () {
    barWidth = w/20;
    barHeight = h - h/6;
    for (var i=0; i<22; i++) {
      Bars[i] = new Bar(i*barWidth, barHeight, speedX);
    }
    console.log("Bars setup.");
    for (var i=0; i<Bars.length; i++) {
      console.log(Bars[i]);
    }
  },
  
  manageBars: function () {
    for (var i=0; i<Bars.length; i++) {
      if (Bars[i].xpos < -2 * barWidth) {
        barHeight = random(mouseY, h);
        Bars[i].xpos = w;
      }
      Bars[i].update(mouseX, mouseY, speedX, ascentSpeed);
      Bars[i].display();
    }
  }
}

function Bar (x, y, s) {
  this.xpos = x;
  this.ypos = y;
  this.speed = s;
  this.ascent = 0;
  this.barWidth = w/20;
  this.barHalfWidth = barWidth/2;
  this.barHeight = 0;
  this.mousePosX = 0;
  this.mousePosY = w/6;
  
  this.update = function (x, y, s, asc) {
    this.speed = s;
    this.ascent = asc;
    this.xpos -= this.speed;
    this.ypos += this.ascent;
    this.mousePosX = x;
    if ((this.xpos > this.mousePosX - this.barHalfWidth) && (this.xpos < this.mousePosX + this.barHalfWidth)) {
      this.ypos = y;
    }
    if ((this.xpos < w/6) && (this.xpos > w/6 - w/20)) {
      // player.setPrevBarHeight(ypos);
    }
    if ((this.xpos > w/6) && (this.xpos < w/6 + w/20)) {
      /*
      player.setBarhHeight(ypos);
      player.lastpos = player.ypos;
      if (player.ypos < ypos) {
        player.ypos += speedY;
        speedY += gravity;
      }
      else {
        player.ypos = ypos;
        speedY = 1;
      }
      */
    }
  };
  
  this.display = function () {
    rectMode(CORNER);
    stroke(0);
    strokeWeight(1);
    fill('#5CE200');
    rect(this.xpos - this.barHalfWidth, this.ypos, this.barWidth, h - this.ypos);
    console.log("xpos: " + this.xpos);
  }
}
