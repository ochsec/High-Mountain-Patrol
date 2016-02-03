var collisionCounterOn;   // boolean
var state, score, interval, intervalCounter;  // int
var w, h, ow, oh, rw, rh; // float
var barWidth, barHeight, speedX, speedXDelta, speedY, gravity, ascentSpeed; // float
var Bar = [];
var BkObj = [];
var Coins = [];
var Gems = [];
var Boulders = [];

function setup() {
  createCanvas(480, 480);
  frameRate(30);
  w, h = width;
  ow, oh = 480;
  rw = w/480;
  rh = h/480;
  
}

function draw() {
  
}

var Manager = {
  pickupcounter: 0,
  
  setupEnvironment: function () {
    background('#000028');
    speedX = speedXDelta = 4*rw;
    speedY = 1*rh;
    gravity = 0.4*rh;
    ascentSpeed = 0;
    interval = Math.round((Math.random() * (4-1) + 1) * w/speedX);
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
    this.xpos = xpos - speed;
    this.ypos = ypos + ascent;
    this.mousePosX = x;
    if ((xpos > mousePosX - barHalfWidth) && (xpos < mousePosX + barHalfWidth)) {
      this.ypos = y;
    }
    if ((xpos < w/6) && (xpos > w/6 - w/20)) {
      // player.setPrevBarHeight(ypos);
    }
    if ((xpos > w/6) && (xpos < w/6 + w/20)) {
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
    rect(xpos - barHalfWidth, ypos, barWidth, h - ypos);
  }
}
