var collisionCounterOn;   // boolean
var state, score, interval, intervalCounter;  // int
var w, h, ow, oh, rw, rh; // float
var barWidth, barHeight, speedX, speedXDelta, speedY, gravity, ascentSpeed; // float
var player;
var Bars = [];
var BkObjs = [];
var Coins = [];
var Gems = [];
var Boulders = [];

// images
var coinImage, gemImage;

function preload() {
    coinImage = loadImage('./coin.png');
    gemImage = loadImage('./emerald.png');
}

function setup() {
    createCanvas(480, 480);
    frameRate(30);
    w = width;
    h = width;
    ow = 480;
    oh = 480;
    rw = w / 480;
    rh = h / 480;
    Manager.setupEnvironment();
    Manager.setupBackgroundObjects();
    Manager.setupBars();
    Manager.setupPlayer();
    Manager.setupPickups();
}

function draw() {
    if (frameCount % 360 === 0)
        Manager.changeAscent(floor(random(100) + 1));
    if (frameCount % 30 === 0) {
        if (abs(speedX - speedXDelta) > 1) {
            speedXDelta = speedX;
            Manager.realign();
        }
    }
    Manager.manageBackgrounds();
    Manager.manageBars();
    Manager.managePlayer();
    Manager.managePickups();
}

var Manager = {
    pickupcounter: 0,

    setupEnvironment: function () {
        background('#000028');
        speedX = speedXDelta = 4 * rw;
        speedY = 1 * rh;
        gravity = 0.4 * rh;
        ascentSpeed = 0;
        interval = round(random(1, 4) * w / speedX);
        intervalCounter = 0;
        collisionCounter = false;
        state = 0;
        score = 0;
        //titleText =  load image text
        //zerovelo =  create font
    },

    setupBars: function () {
        barWidth = w / 20;
        barHeight = h - h / 6;
        for (var i = 0; i < 22; i++) {
            Bars[i] = new Bar(i * barWidth, barHeight, speedX);
        }
        console.log("Bars setup.");
        for (var i = 0; i < Bars.length; i++) {
            console.log(Bars[i]);
        }
    },

    setupBackgroundObjects: function () {
        for (var i = 0; i < 4; i++) {
            BkObjs[i] = new BkObj(floor(random(3)), i * 200 * rw + floor(random(200)), h);
        }
        for (var i = 4; i < 7; i++) {
            BkObjs[i] = new BkObj(floor(random(3, 6)), i * 200 * rw + floor(random(200)), h);
        }
    },

    setupPlayer: function () {
        player = new Player(w / 6, h - h / 6);
    },

    setupPickups: function () {
        for (let i=0; i<2; i++) {
            Coins.push(new Coin(i*480*rw + random(480)*rw, random(h)));
            Gems.push(new Gem(i*480*rw + random(480)*rw, random(h)));
        }
    },

    manageBars: function () {
        for (var i = 0; i < Bars.length; i++) {
            if (Bars[i].xpos < -2 * barWidth) {
                barHeight = random(mouseY, h);
                Bars[i].xpos = w;
            }
            Bars[i].update(mouseX, mouseY, speedX, ascentSpeed);
            Bars[i].display();
        }
    },

    manageBackgrounds: function () {
        background('#000028');
        for (var i = 0; i < BkObjs.length; i++) {
            if (BkObjs[i].xpos < 0 - BkObjs[i].maxObjWidth) {
                BkObjs[i].xpos = w + random(50);
            }
            BkObjs[i].update(speedX, ascentSpeed);
            BkObjs[i].display();
        }
    },

    managePlayer: function () {
        player.update();
        player.display();
    },

    managePickups: function () {
        for (let i=0; i<Coins.length; i++) {
            Coins[i].update(speedX, ascentSpeed);
            Gems[i].update(speedX, ascentSpeed);
            Coins[i].display();
            Gems[i].display();
        }
    },

    realign: function () {
        Bars[0].xpos = round(Bars[0].xpos);
        for (var i = 1; i < 22; i++) {
            if (Bars[i].xpos > Bars[0].xpos)
                Bars[i].xpos = Bars[0].xpos + i * barWidth;
            else
                Bars[i].xpos = Bars[0].xpos - (22 - i) * barWidth;
        }
    },

    changeAscent: function (change) {
        if (change < 76)
            ascentSpeed = h / oh * random(0, 2.5);
        else
            ascentSpeed = -h / oh * random(0, 2.5);
    }
};

function Bar(x, y, s) {
    this.xpos = x;
    this.ypos = y;
    this.speed = s;
    this.ascent = 0;
    this.barWidth = w / 20;
    this.barHalfWidth = barWidth / 2;
    this.barHeight = 0;
    this.mousePosX = 0;
    this.mousePosY = w / 6;

    this.update = function (x, y, s, asc) {
        this.speed = s;
        this.ascent = asc;
        this.xpos -= this.speed;
        this.ypos += this.ascent;
        this.mousePosX = x;
        if ((this.xpos > this.mousePosX - this.barHalfWidth) && (this.xpos < this.mousePosX + this.barHalfWidth)) {
            this.ypos = y;
        }
        if ((this.xpos < w / 6) && (this.xpos > w / 6 - w / 20)) {
            player.setPrevBarHeight(this.ypos);
        }
        if ((this.xpos > w / 6) && (this.xpos < w / 6 + w / 20)) {
            // set player.barHeight
            player.setBarhHeight(this.ypos);
            // move y pos to last ypos
            player.lastypos = player.ypos;
            // if player is higher than bar height
            if (player.ypos < this.ypos) {
                // add speedY to player's ypos
                player.ypos += speedY;
                speedY += gravity;
            }
                // else make sure player height is bar height
            else {
                player.ypos = this.ypos;
                // reset speedY
                speedY = 1;
            }
        }
    };

    this.display = function () {
        rectMode(CORNER);
        stroke(0);
        strokeWeight(1);
        fill('#5CE200');
        rect(this.xpos - this.barHalfWidth, this.ypos, this.barWidth, h - this.ypos);
    }
}

function Player(x, y) {
    // positional properties
    this.xpos = x;               // initial x
    this.ypos = y;               // initial y
    this.lastypos = this.y;   // y from last frame
    this.xoffset = 48 * rw;     // offset for drawing
    this.yoffset = 30 * rh;     // offset for drawing
    this.barHeight = y;       // keep track of bar height under truck
    this.prevBarHeight = y;   // bar height from last frame
    this.avg0 = this.y;       // average y velocity 1
    this.avg1 = this.y;       // average y velocity 2
    this.trpos = [];          // array of y positions to calculate average change in y
    for (var i = 0; i < 4; i++)
        this.trpos.push(this.y);

    // colors
    this.c1 = color('#7FB7BE');
    this.c2 = color('#DACC3E');
    this.c3 = color('#D3F3EE');

    // explosion effect properties
    this.snapshot = false;    // is there a pixel array of player image?
    this.exploding = false;   // is the player in an exploding state?

    this.update = function () {
        if (this.exploding === false) {
            this.trpos[0] = this.ypos;
            this.trpos[1] = this.trpos[0];
            this.trpos[2] = this.trpos[1];
            this.trpos[3] = this.trpos[2];
        }
        this.avg0 = (this.trpos[0] + this.trpos[1] + this.trpos[2]) / 3;
        this.avg1 = (this.trpos[1] + this.trpos[2] + this.trpos[3]) / 3;
        // speed conditions:
        // 1. cap speed at 30
        // 2. speed cannot be negative (speedX > 0)
        // 3. going uphill slows you down
        // 4. going downhill or straight speeds you up
        if (this.prevBarHeight - this.barHeight > this.yoffset)       // decrease speed when going uphill
            speedX -= 0.01 * (this.prevBarHeight - this.barHeight);
        else if (this.prevBarHeight <= this.barHeight)
            speedX += 0.03 + 0.01 * (this.barHeight - this.prevBarHeight);  // increase speed when not going uphill
        if (speedX < 0)
            speedX = 0;       // prevent speedX from being negative
        if (speedX > 20 * rw)
            speedX = 20 * rw;   // cap speedX at 20 pixels x relative width
        /* Show collision boundary
         * rectMode(CORNER);
         * stroke(200);
         * noFill();
         * rect(xpos, ypos - yoffset, xoffset, yoffset);
         */
    };

    this.display = function () {
        push();
        translate(this.xpos, this.ypos);
        if (this.ypos > this.lastypos)
            rotate(-2 * PI / (this.ypos / this.lastypos));
        else
            rotate(-2 * PI / (this.avg0 / this.avg1));
        this.drawRover();
        pop();
        if (this.snapshot === false)
            this.getImage();
    };

    this.drawRover = function () {
        stroke(this.c1);
        fill(this.c1);
        rectMode(CORNER);
        rect(rw * 10, -this.yoffset + rw * 6, rw * 32, rw * 14);
        rect(rw * 0, -this.yoffset + rw * 6, rw * 10, rw * 10);
        rect(rw * 10, -this.yoffset + rw * 0, rw * 20, rw * 6);
        rect(rw * 10, -this.yoffset + rw * 2, rw * 22, rw * 4);
        stroke(this.c3);
        fill(this.c3);
        rect(rw * 18, -this.yoffset + rw * 2, rw * 10, rw * 4);
        stroke(this.c2);
        fill(this.c2);
        ellipseMode(CORNER);
        ellipse(rw * 4, -this.yoffset + rw * 10, rw * 20, rw * 20);
        ellipse(rw * 28, -this.yoffset + rw * 10, rw * 20, rw * 20);
    };

    this.getImage = function () {
        this.img = get(int(this.xpos), int(this.ypos - this.yoffset), int(this.xoffset), int(this.yoffset));
        this.snapshot = true;
    };

    this.setBarhHeight = function (y) {
        this.barHeight = y;
    };

    this.setPrevBarHeight = function (y) {
        this.prevBarHeight = y;
    };
}

function BkObj(t, x, y) {
    this.type = t;
    this.xpos = x;
    this.ypos = y;
    if (this.type < 3) {
        this.increment = 3 * h / 58;
        this.segmentWidth = w / 58;
        this.c1 = color('#001400');
        this.c2 = color('#3f1900');
    }
    else {
        this.increment = 3 * h / 64;
        this.segmentWidth = w / 64;
        this.c2 = color('#001400');
        this.c1 = color('#3f1900');
    }
    switch (this.type) {
        case 0:
            this.xend = 28 * this.segmentWidth;
            break;
        case 1:
            this.xend = 40 * this.segmentWidth;
            break;
        case 2:
            this.xend = 42 * this.segmentWidth;
            break;
        case 3:
            this.xend = 28 * this.segmentWidth;
            break;
        case 4:
            this.xend = 40 * this.segmentWidth;
            break;
        case 5:
            this.xend = 42 * this.segmentWidth;
            break;
    }
    this.maxObjWidth = 42 * this.segmentWidth;

    this.update = function (speed, ascent) {
        if (this.type < 3) {
            this.xpos -= 0.05 * speed;
            this.ypos += 0.01 * speed;
        }
        else {
            this.xpos -= 0.25 * speed;
            this.ypos += 0.05 * ascent;
        }
    };

    this.display = function () {
        switch (this.type) {
            case 0:
                this.drawMountainA(this.xpos, this.ypos);
                break;
            case 1:
                this.drawMountainB(this.xpos, this.ypos);
                break;
            case 2:
                this.drawMountainC(this.xpos, this.ypos);
                break;
            case 3:
                this.drawMountainA(this.xpos, this.ypos);
                break;
            case 4:
                this.drawMountainB(this.xpos, this.ypos);
                break;
            case 5:
                this.drawMountainC(this.xpos, this.ypos);
                break;
        }
    };

    this.drawMountainA = function (x, y) {
        stroke(this.c1);
        fill(this.c1);
        for (var i = 0; i < 29; i++) {
            if (i <= 14)
                rect(x + i * this.segmentWidth, y, this.segmentWidth, -i * this.increment);
            else
                rect(x + i * this.segmentWidth, y, this.segmentWidth, -(14 * this.increment - (i - 14) * this.increment));
        }
        stroke(this.c2);
        fill(this.c2);
        for (var i = 1; i < 27; i++) {
            if (i <= 13)
                rect(x + this.segmentWidth + i * this.segmentWidth, y, this.segmentWidth, -i * this.increment);
            else {
                rect(x + this.segmentWidth + i * this.segmentWidth, y, this.segmentWidth, -(13 * this.increment - (i - 13) * this.increment));
            }
        }
    }

    this.drawMountainB = function (x, y) {
        stroke(this.c1);
        fill(this.c1);
        for (var i = 0; i < 41; i++) {
            if (i <= 14)
                rect(x + i * this.segmentWidth, y, this.segmentWidth, -i * this.increment);
            else if (14 < i && i <= 24)
                rect(x + i * this.segmentWidth, y, this.segmentWidth, -14 * this.increment);
            else
                rect(x + i * this.segmentWidth, y, this.segmentWidth, -(14 * this.increment - (i - 24) * this.increment));
        }
        stroke(this.c2);
        fill(this.c2);
        for (var i = 1; i < 39; i++) {
            if (i <= 13)
                rect(x + this.segmentWidth + i * this.segmentWidth, y, this.segmentWidth, -i * this.increment);
            else if (13 < i && i <= 23)
                rect(x + this.segmentWidth + i * this.segmentWidth, y, this.segmentWidth, -13 * this.increment);
            else
                rect(x + this.segmentWidth + i * this.segmentWidth, y, this.segmentWidth, -(13 * this.increment - (i - 23) * this.increment));
        }
    };

    this.drawMountainC = function (x, y) {
        // peak 1
        stroke(this.c1);
        fill(this.c1);
        for (var i = 0; i < 29; i++) {
            if (i <= 14)
                rect(x + i * this.segmentWidth, y, this.segmentWidth, -i * this.increment);
            else
                rect(x + i * this.segmentWidth, y, this.segmentWidth, -(14 * this.increment - (i - 14) * this.increment));
        }
        stroke(this.c2);
        fill(this.c2);
        for (var i = 1; i < 27; i++) {
            if (i <= 13)
                rect(x + this.segmentWidth + i * this.segmentWidth, y, this.segmentWidth, -i * this.increment);
            else
                rect(x + this.segmentWidth + i * this.segmentWidth, y, this.segmentWidth, -(13 * this.increment - (i - 13) * this.increment));
        }

        // peak 2
        x = x + 14 * this.segmentWidth;
        y = y + 3 * this.increment;
        stroke(this.c1);
        fill(this.c1);
        for (var i = 0; i < 29; i++) {
            if (i <= 14)
                rect(x + i * this.segmentWidth, y, this.segmentWidth, -i * this.increment);
            else {
                rect(x + i * this.segmentWidth, y, this.segmentWidth, -(14 * this.increment - (i - 14) * this.increment));
            }
        }
        stroke(this.c2);
        fill(this.c2);
        for (var i = 1; i < 27; i++) {
            if (i <= 13)
                rect(x + this.segmentWidth + i * this.segmentWidth, y, this.segmentWidth, -i * this.increment);
            else
                rect(x + this.segmentWidth + i * this.segmentWidth, y, this.segmentWidth, -(13 * this.increment - (i - 13) * this.increment));
        }
    }
}

class Pickup {
    constructor(_x, _y) {
        this.counterOn = false;
        this.xpos = _x;
        this.ypos = _y;
        this.pickupw = w/22;
        this.pickuph = w/20;
        this.xend = this.xpos + this.pickupw;
        this.yend = this.ypos + this.pickuph;
        this.speed = 0;
        this.ascent = 0;
        this.img = null;
        this.cyellow = 224;
        this.cblue = 0;        

        // special effect
        this.counter = 0;
        this.cellSize = 8;
        this.columns = int(this.pickupw / this.cellSize);
        this.rows = int(this.pickuph / this.cellSize);
        this.pxdir = [];
        this.pydir = [];
        this.pSizes = [];
        this.pScaling = [];
        for (let i=0; i<this.columns; i++) {
            this.pxdir.push([]);
            this.pydir.push([]);
            this.pSizes.push([]);
            this.pScaling.push([]);
            for (let j=0; j<this.rows; j++) {
                this.pxdir[i].push(random(-10, 10));
                this.pydir[i].push(random(-10, 10));
                this.pSizes[i].push(this.cellSize);
                this.pScaling[i].push(random(1));
            }
        }        
    }

    update (_s, _asc) {
        this.speed = _s;
        this.ascent = _asc;
        this.xpos = this.xpos - this.speed;
        this.xend = this.xpos + this.pickupw;
        this.ypos = this.ypos + this.ascent;
        this.yend = this.ypos + this.pickuph;
        if (this.xpos < -50*rw) {
            this.xpos = w + random(480)*rw;
            this.ypos = random(h) + this.ascent;
        } 
    }
    
    display () {
        stroke(200);
        fill(200);
        rectMode(CORNER);
        image(this.img, this.xpos, this.ypos, this.pickupw, this.pickuph);
    }    
}

class Coin extends Pickup {
    constructor(_x, _y) {
        super(_x, _y);
        this.expand = true;     // denotes whether the image should expand
    }

    update (_s, _asc) {
        super.update(_s, _asc);
        /**
         *  Conditionals control the change in width of the coin image
         *  to make it appear it's rotating.
         */
        if (this.pickupw > 35*rw && this.expand) {
            this.expand = false;
            this.pickupw = this.pickupw - 2;
        } else if (this.pickupw < 5*rw && !this.expand) {
            this.expand = true;
            this.pickupw = this.pickupw + 2;
        } else if (this.expand) {
            this.pickupw = this.pickupw + 2;
        } else {
            this.pickupw = this.pickupw - 2;
        }
    }

    display () {
        stroke(200);
        noFill();
        noStroke();
        rectMode(CORNER);
        imageMode(CENTER);   
        image(coinImage, this.xpos+this.pickupw/2, this.ypos+this.pickuph/2, this.pickupw, this.pickuph);
        rect(this.xpos, this.ypos, this.pickupw, this.pickuph);        
    }
}

class Gem extends Pickup {
    constructor(_x, _y) {
        super(_x, _y);
    }

    display() {
        imageMode(CORNER);
        image(gemImage, this.xpos, this.ypos, this.pickupw, this.pickuph);
    }
}
