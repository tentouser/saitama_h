// float playerX = 310/2;
// float playerY = 400/2;

int RplayerX = 0;
int RplayerY = 0;
int BplayerX = 8;
int BplayerY = 10;
PVector[] botslist = new PVector[100];
float[] botsXlist = new float[100];
float[] botsYlist = new float[100];
int map[][] = new int[8][10];
int nowtile = 0;
float timer = 30;
int p1score=0;
int p2score=0;
float stage = 0;
float light = 0;
float finish = 0;

void setup() {
  size(320, 400);
}
void draw() {
  background(0);
  if (stage == 0) {
    title();
  }

  /*
rect(playerX,playerY,40,40);
   //playerX = mouseX;
   //playerY = mouseY;
   for (int i=0; i<5; i++) {
   botsYlist[i] = 999;
   botsXlist[i] = 999;
   botslist[i] = new PVector(0, 0);
   }*/
  if (stage == 1) {

    for (int x = 0; x<8; x++) {
      for (int y=0; y<10; y++) {
        strokeWeight(1);
        stroke(255);
        if (map[x][y] == 0) {
          fill(0);
        }
        if (map[x][y] == 1) {
          fill(255, 0, 0);
        }
        if (map[x][y] == 2) {
          fill(0, 0, 255);
        }
        if (x == RplayerX && y == RplayerY) {
          strokeWeight(5);
          fill(200, 0, 0);
        }
        if (x == BplayerX && y == BplayerY) {
          strokeWeight(5);
          fill(0, 0, 200);
        }
        rect(x * 40, y * 40, 40, 40);
      }
    }


    //playerX = map[1][1];
    //playerY = map[1][1];


    fill(0);
    //rect(playerX,playerY,40,40);
    //playerX = mouseX;
    //playerY = mouseY;
    /*
for (int i=0; i<5; i++) {
     botsYlist[i] = 999;
     botsXlist[i] = 999;
     botslist[i] = new PVector(0, 0);
     }
     */
    if (RplayerX>7) {
      RplayerX = 7;
    }
    if (RplayerX<0) {
      RplayerX = 0;
    }
    if (RplayerY>9) {
      RplayerY = 9;
    }
    if (RplayerY<0) {
      RplayerY = 0;
    }

    if (BplayerX>7) {
      BplayerX = 7;
    }
    if (BplayerX<0) {
      BplayerX = 0;
    }
    if (BplayerY>9) {
      BplayerY = 9;
    }
    if (BplayerY<0) {
      BplayerY = 0;
    }



    timer -= 0.016;

    fill(0, 255, 0, 100);
    textAlign(CENTER);
    textSize(100);
    text(timer, width/2, height/2 );

    _finish();
  }
}



/*
void mousePressed(){
 if(playerX<mouseX){
 playerX += 20;
 }
 if(playerX>mouseX){
 playerX -= 20;
 }
 if(playerY<mouseY){
 playerY += 20;  }
 if(playerY>mouseY){
 playerY -= 20;
 }
 }
 */
void keyPressed() {
  if (key == 'd') {
    RplayerX += 1;
  }
  if (key == 'a') {
    RplayerX -= 1;
  }
  if (key == 'w') {
    RplayerY -= 1;
  }
  if (key == 's') {
    RplayerY += 1;
  }
  if (keyCode == RIGHT) {
    BplayerX += 1;
  }
  if (keyCode == LEFT) {
    BplayerX -= 1;
  }
  if (keyCode == UP) { 
    BplayerY -= 1;
  }
  if (keyCode == DOWN) {
    BplayerY += 1;
  }
  if (keyCode == ' ') {
    stage = 1;
  }
  if (finish == 1) {
    if (keyCode == ' ') {
      title();
      finish = 0;
      init();
    }
  }


  for (int x = 0; x<8; x++) {
    for (int y=0; y<10; y++) {
      if (x == RplayerX && y == RplayerY) {
        map[x][y]=1;
        if (map[x][y] == 1) {
          fill(200, 0, 0);
        }
      }
      if (x == BplayerX && y == BplayerY) {
        map[x][y]=2;
        if (map[x][y] == 2) {
          fill(0, 0, 200);
        }
      }
    }
  }
}

void init(){
 RplayerX = 0;
 RplayerY = 0;
 BplayerX = 8;
 BplayerY = 10;
 botslist = new PVector[100];
 botsXlist = new float[100];
 botsYlist = new float[100];
 map = new int[8][10];
 nowtile = 0;
 timer = 30;
 p1score=0;
 p2score=0;
 stage = 0;
 light = 0;
 finish = 0;
}
void judge() {

  for (int x = 0; x<8; x++) {
    for (int y=0; y<10; y++) {
      if (map[x][y] == 1) {
        fill(255, 0, 0);
        p1score += 1;
      }
      if (map[x][y] == 2) {
        fill(0, 0, 255);
        p2score += 1;
      }
    }
  }
}


void title() {
  light += 1;
  background(0);
  fill(255, 255, 255, light);
  textSize(60);
  textAlign(CENTER);
  text(" olor  iles", width/2, height/2);
  textSize(30);
  textAlign(CENTER);
  text("start is spacekey", width/2, height/2+35);
  textSize(60);
  textAlign(CENTER);
  fill(255, 0, 0, light);
  text("c              ", width/2, height/2);
  fill(0, 0, 255, light);
  text("       t    ", width/2, height/2);
}

void _finish() {
  if (timer<0) {
    timer = 0;
    background(0);
    judge();
    finish = 1;
    fill(255);
    textSize(30);
    textAlign(CENTER);
    text("restart is spacekey",width/2,height/2+35);
    if (p1score<p2score) {
      fill(0, 0, 255);
      textSize(50);
      textAlign(CENTER);
      text("bule is win!", width/2, height/2, light);
    }
    if (p2score<p1score) {
      fill(255, 0, 0);
      textAlign(CENTER);
      textSize(50);
      text("red is win!", width/2, height/2, light);
    }
    if (p2score==p1score) {
      fill(0, 200, 0, 100);
      textAlign(CENTER);
      textSize(50);
      text("draw!", width/2, height/2, light);
    }
  }
}

  /*
void keyPressed(){
   if(keyCode == RIGHT){
   playerX += 20;
   }
   if(keyCode == LEFT){
   playerX -= 20;
   }
   if(keyCode == UP){
   playerY -= 20;
   }
   if(keyCode == DOWN){
   playerY += 20;
   }
   }
   */
