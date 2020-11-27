float number;
float nunber;
int target;
float fight;
float stoper;
float stoppp;
float scan;
float acan;
int ready=0;
int ax=200;
int sx=650;
int ay=180;
int sy=180;
int x=100;
int sax=650;
void setup() {
  size(900, 400);
  target = (int) random(7, 14);
}

void draw() {
  //  target-number=scan;
  background(0);
  textSize(40);
  text("PLEASE ENTER", 310, 200);
  if (ready==1) {
    number+=0.016;
    nunber+=0.016;
    fight+=0.016;
    background(255);
    textSize(25);
    fill(0);
    text("Attack: S", 60, 220);
    text("Attack: L", 750, 220);
    //   text(number, 135, 280);
    // text(nunber, 675, 280);
    // text(target, 430, 100);

    float sabun1 = abs(number - target);
    float sabun2 = abs(nunber - target);

    rectMode(CENTER);
    pushMatrix();
    translate(ax, ay);
    if (sabun2<sabun1) {
      rotate(frameCount);
    }
    rect(0, 0, 60, 60);
    popMatrix();

    rectMode(CENTER);
    pushMatrix();
    translate(sx, sy);
    if (sabun1<sabun2) {
      rotate(frameCount);
    }
    rect(0, 0, 60, 60);
    popMatrix();

    // rect(ax, ay, 60, 60);
    rect(sx, sy, 60, 60);

    if (target<fight) {
      fill(0);
      textSize(40);
      text("ATTACK", 350, 100);
    }
    if (stoper==1) {
      number-=0.016;
    }

    if (stoppp==1) {
      nunber-=0.016;
    }


    if (sabun1<sabun2) {
      textSize(10);
      text("p1 WIN", 400, 200);
      sx+=10;
      sy-=5;
    }
    textSize(10);
    if (sabun2<sabun1) {
      text("p2 WIN", 400, 200);
      ax-=10;
      ay-=5;
    }
  }
}

void keyPressed() {
  if (key=='s') {
    stoper=1;
  }
  if (key=='l') {
    stoppp=1;
  }
  if (keyCode==ENTER) {
    ready=1;
  }
}
