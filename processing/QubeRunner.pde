class Player {
  public float x;
  public float y;
  public float w = 20;
  public float h = 20;
  public float speed = 3;
  public float v = 0;
  public int jumpCount = 0;
  
  public float angle;
}
class Block {
  public float x;
  public float y;
  public float w = 50;
  public float h;
  public int status = 1;
  public int id;
  public color c;
}
class Camera {
  public float x;
  public float y;
  public float getX(float x) {
    return x - this.x;
  }
  public float getY(float y) {
    return y - this.y;
  }
  public float speed = 3;
}
class HistoryData{
  public float x;
  public float y;
  public float angle;
}
class Data {
  public int level;
  public  int gameStatus = 1;
  public float score;
}
static class Input {
  public static boolean right;
  public static boolean left;
  public static float horizontal() {
    if (right)  return 1;
    if (left) return -1;
    return 0;
  }
  public static boolean jump;
}

PImage blockImage;
Player player;
ArrayList<Block> blockList = new ArrayList<Block>();
Camera camera;
Data data;

ArrayList<PVector> historyList = new ArrayList<PVector>();

void setup() {
  size(320, 480);
  gameInit();
}

int titleTime;
void title() {
  float a = 255;
  if (data.gameStatus == 9) {
    a = 0;
    titleTime += 1;
    a += titleTime * 10;

    fill(0, 0, 0, min(a, 200));
    rect(0, 0, width, height);
    
    textAlign(CENTER, CENTER);
    fill(255, 255, 255, a);
    
    textSize(24);
    text("GAME OVER", width/2, 50);

    textSize(42);
    text(getRank((int)data.score/10), width/2, 150);
    text((int)data.score/10 + " m", width/2, 200);
    textSize(24);
    text("TAP TO RESTART", width/2, 300);
  }

  if (data.gameStatus == 10) {
    a = 0;
    titleTime += 1;
    a += titleTime * 5;
    fill(255, 255, 255, a);
    rect(0, 0, width, height);

    if (titleTime > 60) {
      gameInit();
    }
  }

  if (data.gameStatus == 2) {
    titleTime += 1; 
    a -= titleTime * 5;
  }
  if (data.gameStatus == 1 || data.gameStatus == 2) {
    textSize(42);
    textAlign(CENTER, CENTER);
    fill(255, 255, 255, a);
    text("QUBE RUNNER", width/2, 200);
    textSize(24);
    text("TAP TO START", width/2, 300);
  }
}
void draw() {
  background(0);
  println(camera.speed);
  if (data.gameStatus == 2) {
    data.score += camera.speed / 3;
  }
  if (data.gameStatus != 9) {
    float attachSpeed = 0;
    if (camera.getX(player.x) < 50) {
      attachSpeed = 0.1;
    }
    player.x += camera.speed + attachSpeed;
    player.v += 0.5;
    player.v = min(player.v, 10);
    player.y += player.v;
  }

  if (isGround()) {
    player.jumpCount = 0;
    player.angle = 0;
  } else {
    player.angle += 10 * player.jumpCount;
    if (player.jumpCount == 0) {
      player.jumpCount = 1;
    }
  }
  if (player.jumpCount < 2) {
    if (Input.jump) {
      player.jumpCount += 1;
      player.v = -10;
      player.v = max(player.v, -15);
      Input.jump = false;
    }
  }else{
   if(Input.jump){
     Input.jump = false;
   }
  }
  for (int i=0; i<blockList.size(); i++) {
    Block b = blockList.get(i);
    if(camera.getX(b.x) < b.w *-1 ){
      blockList.remove(i);
      i --;
      continue;
    }
    if (b.status == 1) {
      if (Tento.isHit(player.x, player.y, player.w, player.h, b.x, b.y, b.w, b.h)) {
        if (b.y > player.y) {
          player.y = b.y - player.h;
        } else if (b.x > player.x) {
          player.x = b.x - player.w;
        } else if (b.x < player.x ) {
          player.x = b.x + b.w;
        }
      }
      renderBlock(b);
    }
  }

  if (camera.getX(player.x) > width - player.w) {
    player.x = camera.x + width - player.w;
  }
  if (camera.getX(player.x + player.w) < 0) {

    gameOver();
  }
  if (camera.getY(player.y) > height) {
    gameOver();
  }
  shadow();
  drawPlayer();


  createBlocks();
  if (data.gameStatus != 9) {
    camera.x += camera.speed;
    player.speed = camera.speed + 2;
    if(data.gameStatus == 2){
    camera.speed += 1.0 / 60 / 30;
    }
  }

  if (data.gameStatus > 1) {
    score();
  }
  title();
}
void score() {
  fill(255, 255, 255);
  textAlign(LEFT, TOP);
  textSize(24);
  text((int)data.score / 10 + " m", 10, 10);
}

void gameOver() {
  if (data.gameStatus < 9) {
    data.gameStatus = 9; 
    titleTime = 0;
  }
}
void gameInit() {
  player = new Player();
  player.x = 50;
  player.y = 300;

  blockList = new ArrayList<Block>();
  Block b = new Block();
  b.x = 0;
  b.y = 350;
  b.h = height - b.y;
  blockList.add(b);

  camera = new Camera();

  data = new Data();

  createBlocks();

  titleTime = 0;
}

void drawPlayer(){
  fill(255);
  noStroke();
  
  rectMode(CENTER);
  pushMatrix();
  translate(camera.getX(player.x) + player.w/2, camera.getY(player.y) + player.h/2);
  rotate(radians(player.angle));
  rect(0, 0, player.w, player.h);
  // fill(0);
  // rect(-3, -2, 1, 1);
  // rect(3, -2, 1, 1);
  popMatrix();

  rectMode(CORNER);
  // rect(camera.getX(player.x), camera.getY(player.y), player.w, player.h);
 
}
void shadow() {
  noStroke();
  historyList.add(new PVector(player.x, player.y));
  if (historyList.size() >= 20) {
    historyList.remove(0);
  }
  for (int i=0; i<historyList.size(); i++) {
    PVector pos = historyList.get(i);
    fill(255, 255, 255, i * 5);
    rect(camera.getX(pos.x), camera.getY(pos.y), player.w, player.h);
  }
}
boolean isGround() {
  for (int i=0; i<blockList.size(); i++) {
    Block b = blockList.get(i);
    if (b.status == 1) {
      if (Tento.isHit(player.x, player.y, player.w, player.h, b.x, b.y, b.w, b.h)) {
        if (b.y > player.y) {
          return true;
        }
      }
    }
  }
  return false;
}
void mousePressed() {
  if (data.gameStatus == 1) {
    data.gameStatus = 2;
  }
  if(data.gameStatus < 9){
    Input.jump = true;
  }
  if (data.gameStatus == 9) {
      data.gameStatus = 10;
      titleTime = 0;
  }
}

void renderBlock(Block b) {
  stroke(200, 200, 200);
  for (int y=(int)b.y; y<height; y+=b.w) {
    fill(255);
    if(b.id > 1)  fill(255, 0, 0);
    rect(camera.getX(b.x), camera.getY(y), b.w, b.w);
  }
}
void createBlocks() {
  for (int i=0; i<100; i++) {
    Block lastB =  blockList.get(blockList.size() - 1);
    if (camera.getX(lastB.x) > width + 100) {
      break;
    }
    float lastX = lastB.x;
    float lastY = lastB.y;
    Block b = new Block();
    b.x = lastX + b.w;
    b.y = lastY;
    b.id = 1;
    if(data.score > 6000){
      b.id = 2;
    }
    if (data.gameStatus != 1) {
      float r = random(0, 10);
      if (r > 6) {
        b.y -= 50;
      } else if (r > 4) {
        b.y += 50;
      }
      if (b.y < 100 || b.y > height - 100) {
        b.y = lastY;
      }
      if (lastB.status == 1) {
        float r2 = random(0, 10);
        if (r > 8) {
          b.status = 0; 
          b.y = lastY;
        }
      }
    }
    b.h = height - b.y;
    blockList.add(b);
  }
}

String getRank(float score){
  String rank = "C";
  if(score > 50){
    rank = "B"; 
  }
  if(score > 100){
    rank = "B+";
  }
  if(score > 200){
    rank = "B++";
  }
  if(score > 300){
    rank = "A";
  }
  if(score > 400){
    rank = "A+";
  }
  if(score > 500){
    rank = "A++";
  }
  if(score > 600){
    rank = "S";
  }
  if(score > 800){
    rank = "S+";
  }
  if(score > 1000){
    rank = "S++";
  }
  if(score > 1500){
    rank = "MASTER";
  }
  return rank;
}

static class Tento{
  public static boolean isHit(float px, float py, float pw, float ph, float ex, float ey, float ew, float eh){
    if(px < ex + ew && px + pw > ex){
     if(py < ey + eh && py + ph > ey){
      return true; 
     }
    }
    return false;
  }
}