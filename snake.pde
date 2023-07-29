int framerule = 0; // allows for less input delay and for the game to be rendered at 60fps but the backend to be 5fps.
boolean arewegaming = false; // represents whether we are paused or playing to terminate movement
int[][] snakeanchor = new int[12][2]; // one for each body part plus one head plus one overflow to prevent out of bounds when gamewin. 0 is x, 1 is y for subarray
int[] currentfruit = new int[2]; // 0 is x, 1 is y
int direction; //represents curr moving direction
int fruitcount = 0; //score
void setup() {
  ellipseMode(CORNER);
  size(800, 800); //19*18 grid, 40*40 blocks
  textSize(30);
  frameRate(60);
  background(#006600);
  drawGrid();
  generatescreen(0);
}
void draw() {
  if (framerule == 12) {
    framerule = 0;
    shiftsnake();
    movesnakehead();
  }
  if (arewegaming) {
    drawGrid();
    drawsnakehead();
    drawsnakebody();
    drawFruit(currentfruit[0], currentfruit[1]);
    fruitcheck();
    checkbordercollision();
    checkselfcollision();
    showscore();
  }
  framerule++;
}

void checkselfcollision() {
  boolean collisioncheck = false;
  for (int i = 2; i <= fruitcount; i++) {
    if ((snakeanchor[i][0] == snakeanchor[0][0]) && (snakeanchor[i][1] == snakeanchor[0][1])) {
      collisioncheck = true;
    }
  }
  if (collisioncheck) {
    generatescreen(2);
  }
}

void shiftsnake() {
  for (int i = fruitcount; i > 0; i--) {
    snakeanchor[i][0] = snakeanchor[i-1][0];
    snakeanchor[i][1] = snakeanchor[i-1][1];
  }
}

void drawsnakebody() {
  fill(#0000ff);
  for (int i = 1; i <= fruitcount; i++) {
    circle(20+snakeanchor[i][0]*40, 60+snakeanchor[i][1]*40, 40);
  }
}

void extendsnake() {
  for (int i = fruitcount; i > -1; i--) {
    snakeanchor[i+1][0] = snakeanchor[i][0];
    snakeanchor[i+1][1] = snakeanchor[i][1];
  }
}

void showscore() {
  fill(#000000);
  text("score: " + fruitcount, 30, 30);
  text("47481838 " + "This was 2 ez", 300, 30);
}

void fruitcheck() {
  if ((snakeanchor[0][0] == currentfruit[0]) && (snakeanchor[0][1] == currentfruit[1])) {
    drawFruit(int(random(0, 18)), int(random(0, 17)));
    extendsnake();
    fruitcount++;
    if (fruitcount == 10) {
      generatescreen(3);
    }
  }
}

void drawFruit(float x, float y) {
  fill(#ff0000);
  circle(20+int(x)*40, 60+int(y)*40, 40);
  currentfruit[0] = int(x);
  currentfruit[1] = int(y);
}

void drawsnakehead() {
  fill(#0000ff);
  circle(20+snakeanchor[0][0]*40, 60+snakeanchor[0][1]*40, 40);
  fill(#ffffff);
  circle(30+snakeanchor[0][0]*40, 70+snakeanchor[0][1]*40, 12);
  fill(#000000);
  circle(32.5+snakeanchor[0][0]*40, 72.5+snakeanchor[0][1]*40, 6);
}

void generatescreen(int screeninstance) {
  arewegaming = false;
  fill(#33cccc);
  rect(height*0.25, width*0.25, 400, 400);
  fill(#222222);
  String textdisplay = "oops";
  switch(screeninstance) {
  case 0 :
    textdisplay = "welcome to snake \n game instructions \n ******* \n use UP, LEFT, DOWN, and \n RIGHT to move the snake \n eat 10 fruits to win \n press SHIFT to start";
    break;
  case 1 :
    textdisplay = "boundary collision \n game over \n ********* \n score = " + fruitcount + "\n press shift to restart";
    break;
  case 2 :
    textdisplay = "self collision \n game over \n ********* \n score = " + fruitcount + "\n press shift to restart";
    break;
  case 3 :
    textdisplay = "congrats you won \n you got all 10 fruits \n damn \n you kinda good at this.\n github.com/MrMairey <3 \n shift to restart btw";
  }
  text(textdisplay, width/3, height/3);
}

void movesnakehead() {
  switch(direction) {
  case 1 :
    snakeanchor[0][1]--;
    break;
  case 2 :
    snakeanchor[0][0]++;
    break;
  case 3 :
    snakeanchor[0][1]++;
    break;
  case 4 :
    snakeanchor[0][0]--;
    break;
  }
}

void checkbordercollision() {
  if (snakeanchor[0][0] > 18 || snakeanchor[0][1] > 17 || snakeanchor[0][0] < 0 || snakeanchor[0][1] < 0 ) { //19*18 grid
    generatescreen(1);
  }
}

void keyPressed() {
  switch(keyCode) {
  case SHIFT :
    if (!arewegaming) {
      initalisegame();
    }

    break;
  case UP :
    if (!((direction == 3) && (fruitcount > 0))) {
      direction = 1;
    }
    break;

  case RIGHT :
    if (!((direction == 4) && (fruitcount > 0))) {
      direction = 2;
    }
    break;

  case DOWN :
    if (!((direction == 1) && (fruitcount > 0))) {
      direction = 3;
    }
    break;

  case LEFT :
    if (!((direction == 2) && (fruitcount > 0))) {
      direction = 4;
    }
    break;
  }
}
void drawGrid() {
  background(#006600);
  boolean currgridcolor = false;
  for (int currgridpointy = 60; currgridpointy < 40+18*40; currgridpointy += 40) {
    for (int currgridpointx = 20; currgridpointx < 19*40; currgridpointx += 40) {
      drawCell(currgridpointx, currgridpointy, currgridcolor);
      currgridcolor = !(currgridcolor);
    }
  }
}


void drawCell(float x, float y, boolean colour) {
  if (colour) {
    fill(#33cc33);
  } else {
    fill(#99ff99);
  }
  rect(x, y, 40, 40);
}

void initalisegame() {
  direction = 3;
  snakeanchor[0][0] = 9;
  snakeanchor[0][1] = 4;
  arewegaming = true;
  fruitcount = 0;
  drawFruit(int(random(0, 18)), int(random(0, 17)));
}
