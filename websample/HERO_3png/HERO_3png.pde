int start = 0;
float A = 0;
int B = 0;
PImage bim;
PImage HERO;

float x;
float y;
float xa;
float ya;
float mx;
float my;
float by;
float bx;
float[]bX = new float[50];
float[]bY = new float[50];
int t;
int ta;
int c;
void setup() {
  size(320, 480);
  noCursor();
  ta = 0;


  if (start < 1) {
  }
}
void draw() {

  if (start > 1) {
    background(100, 100, 100);
    float diff_x = mx - xa;
    float diff_y = my - ya;

    xa += diff_x * 0.1;
    ya += diff_y * 0.1;
    x = mouseX;
    y = mouseY;
    for (t=0; t<50; t++) {
      rect(bX[t]+10, bY[t], 10, 20);
      bY[t] -=10;
    }


    bim = loadImage("bim.png");
    image(bim, x-14, y-14, 30, 30);
    HERO = loadImage("HERO.png");
    image(HERO, xa, ya, 50, 50);
    if (ta == 49) {
      ta = 0;
    }

    if (c%10 == 0) {
      bX[ta] = xa;
      bY[ta] = ya;
      ta++;
    }

    c++;
  }
}
void mousePressed() {
  start += 1;
  y -= 10;
  mx = mouseX-25;
  my = mouseY-25;
}
