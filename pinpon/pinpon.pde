float y1 = 200;
float y2 = 200;
float s1 = 0;
float s2 = 0;
float x = 0;
float y = 250;
float speed = 15;
float speedy = 0.5;
float s;
int p1;
int p2;
int kekka = 0;
int game_flag = 0;
void setup() { 
  size(600, 500);
  textFont(createFont("Sans-serif", 32));
}
void draw() {
  if (game_flag == 0) {
    title();
  }
  if (game_flag == 1) {
    game();
  }
}
void title() {
  background(0);
  textSize(70);
  text("GAME START", 85, 100);
  text("press space key", 70, 200);
}
void game() {
  background(0);
  // もし結果が１ならプレイヤー１の勝利と表示する
  if (kekka == 1) {
    textSize(50);
    text("プレイヤー1の勝ち!", 300, 225);
  }
  // もし結果が２ならプレイヤー2の勝利と表示する
  if (kekka == 2) {
    textSize(50);
    text("プレイヤー2の勝ち!", 300, 225);
  }
  textAlign(CENTER);
  textSize(100);
  fill(255, 255, 255, 200);
  text(p1, 200, 100);
  text(p2, 400, 100);

  fill(255);

  if (kekka == 0) {
    if (x > 600) {
      p1 += 1;
    }
    if (x < 0) {
      p2 += 1;
    }
    //ball
    ellipse(x, y, 25, 25);
    x += speed;
    y += speedy;
    s += 0.01;
    if (x > width) {
      speed = -15;
    }
    if (x < 0) {
      speed = 15;
    }
    if (y > height) {
      speedy = -s;
    }
    if (y < 0) {
      speedy = s;
    }

    if (Tento.isHit(50, y1, 30, 100, x, y, 25, 25)) {
      speed = 15;
      float hanareteiru = 100/2 + y1 - y;
      speedy = hanareteiru * -1 / 20;
    }
    if (Tento.isHit(520, y2, 30, 100, x, y, 25, 25)) {
      speed = -15;
      float hanareteiru = 100/2 + y2 - y;
      speedy = hanareteiru * -1 / 20;
    }
    //player 1
    rect(50, y1, 30, 100);
    y1 += s1;
    y2 += s2;
    if (y1 < 0) {
      y1 = 0;
    }
    if (y1+100 > 500) {
      y1 = 400;
    }
    //player 2
    rect(520, y2, 30, 100);
    if (y2 < 0) {
      y2 = 0;
    }
    if (y2+100 > 500) {
      y2 = 400;
    }




    if (p1 == 10) {
      kekka = 1;
    }
    if (p2 == 10) {
      kekka = 2;
    }
  }
}
void keyPressed() {
  if (key == 'w') {
    s1 = -10;
  }
  if (key == 's') {
    s1 = 10;
  }
  if (keyCode == UP) {
    s2 = -10;
  }
  if (keyCode == DOWN) {
    s2 = 10;
  }
  if (key == ' ') {
    game_flag = 1;
  }
}


static class Tento {
  public static boolean isHit(float px, float py, float pw, float ph, float ex, float ey, float ew, float eh) {
    if (px < ex + ew && px + pw > ex) {
      if (py < ey + eh && py + ph > ey) {
        return true;
      }
    }
    return false;
  }
}
