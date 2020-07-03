int a;
int b;
int x=100;
int y=300;
int ax=400;
int ay=300;
int stop=0;
int decide=0;
int  hit_count =0;
int reset=0;
PImage garasu;
void setup() {
  size(600, 600);
}

void draw() {
  background(255);
  a+=5;
  b+=5;
  textSize(15);
  text("A push", 100, 280);
  text("L push", 400, 280);
  fill(0, 0, 255);
  rect(ax, ay, 30, 30);
  fill(255, 0, 0);
  rect(x, y, 30, 30);
  noFill();
  text(a, 100, 390);
  rect(100, 400, 180, 30);
  fill(0, 0, 255);
  text(b, 400, 210);
  noFill();
  rect(400, 220, 180, 30);
  if (a==100 && stop==0) {
    a=0;
  }
  if (b==100 && decide==0) {
    b=0;
  }
  if (decide==1) {
    b-=5;
  }
  if (stop==1) {
    a-=5;
  }
  if (decide==1 && stop==1) {
    x+=5;
    ax-=5;
  }
  if (a>=10) {
    fill(#95FF03);
    rect(100, 400, 20, 30);
  }
  if (a>=20) {
    fill(#A6FF03);
    rect(120, 400, 20, 30);
  }
  if (a>=30) {
    fill(#E1FF03);
    rect(140, 400, 20, 30);
  }
  if (a>=40) {
    fill(#FAFF03);
    rect(160, 400, 20, 30);
  }
  if (a>=50) {
    fill(#FAFF03);
    rect(180, 400, 20, 30);
  }
  if (a>=60) {
    fill(#FFB803);
    rect(200, 400, 20, 30);
  }
  if (a>=70) {
    fill(#FF8E03);
    rect(220, 400, 20, 30);
  }
  if (a>=80) {
    fill(#FF6803);
    rect(240, 400, 20, 30);
  }
  if (a>=90) {
    fill(#FF3903);
    rect(260, 400, 20, 30);
  }
  if (a==100) {
    fill(#FF0303);
    rect(280, 400, 20, 30);
  }
  if (b>=10) {
    fill(#95FF03);
    rect(400, 220, 20, 30);
  }
  if (b>=20) {
    fill(#A6FF03);
    rect(420, 220, 20, 30);
  }
  if (b>=30) {
    fill(#E1FF03);
    rect(440, 220, 20, 30);
  }
  if (b>=40) {
    fill(#FAFF03);
    rect(460, 220, 20, 30);
  }
  if (b>=50) {
    fill(#FAFF03);
    rect(480, 220, 20, 30);
  }
  if (b>=60) {
    fill(#FFB803);
    rect(500, 220, 20, 30);
  }
  if (b>=70) {
    fill(#FF8E03);
    rect(520, 220, 20, 30);
  }
  if (b>=80) {
    fill(#FF6803);
    rect(540, 220, 20, 30);
  }
  if (b>=90) {
    fill(#FF3903);
    rect(560, 220, 20, 30);
  }
  if (b==100) {
    fill(#FF0303);
    rect(580, 220, 20, 30);
  }
  int hit = Tento.isHit(ax, ay, 30, 30, x, y, 30, 30);
  if (hit == 1) {
    if (a>b) {

      x+=5;
      ax+=50;
    }
  }
  if (hit == 1) {
    if (b>a) {
      ax-=5;
      x-=50;
    }
  }
  if (x<0) {
    background(255);
    reset=1;
    textSize(50);
    text("2P  WIN", 200, 300);
    text("PRESS H TO RESTART", 150, 400);
  }

  if (ax>600) {
    background(255);
    reset=1;
    textSize(50);
    text("1P  WIN", 200, 300);
    text("PRESS H TO RESTART", 150, 400);
  }
}
void keyPressed() {
  if (key=='a') {
    stop=1;
  }
  if (key== 'l') {
    decide=1;
  }
  if (key=='h') {
    reset();
  }
}
void reset() {
  a = 0;
  b = 0;
  x=100;
  y=300;
  ax=400;
  ay=300;
  stop=0;
  decide=0;
  hit_count =0;
  reset=0;
}
static class Tento{
  public static int isHit(float px, float py, float pw, float ph, float ex, float ey, float ew, float eh){
    if(px < ex + ew && px + pw > ex){
     if(py < ey + eh && py + ph > ey){
      return 1; 
     }
    }
    return 0;
  }
}
