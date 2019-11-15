int x;
int y;
int turn=0;
int bx=170;
int rx=350;
int lx=170;
int sx=50;
int ex=340;
int count=0;
int max = 10;

// 0は進行中、1はplayer1の勝ち、2はplayer2の勝ち
int status = 0;
void setup() {
  size(600, 600);
  max = (int)random(30, 51);
}
void draw() {
  background(0);
  if (x > max) {
    x=max;
  }
  //image(bomb, 200, 180, 200, 200);
  textSize(40);
  fill(255);
  noFill();
  stroke(255);
  rect(230, 240, 100, 100);
  text(max - x, 260, 300);

  text("P1", lx, 200);
  text("P2", rx, 200);
  text("S push", sx, 120);
  text("DOWN push", ex, 120);

  // 1個め
  if (count > 0 ) {
    fill(255);
  } else {
    noFill();
  }
  ellipse(230, 60, 25, 25);

  // 2個め
  if (count > 1 ) {
    fill(255);
  } else {
    noFill();
  }
  ellipse(260, 60, 25, 25);
  // 3個め
  if (count > 2 ) {
    fill(255);
  } else {
    noFill();
  }
  ellipse(290, 60, 25, 25);
  if (count > 3 ) {
    fill(255);
  } else {
    noFill();
  }
  ellipse(320, 60, 25, 25);
  if (count > 4 ) {
    fill(255);
  } else {
    noFill();
  }
  ellipse(350, 60, 25, 25);
  //if(turn == 1){
  /// }
  // if(turn == 2){
  //   ellipse(350, 260, 10, 10);
  //// }

  if (turn==1) {
    if (max==0) {
      status = 2;
    }
  }
  if (turn==2) {
    if (max==0) {
      status = 1;
    }
  }


  if (status == 1) {
    fill(0, 0, 0, 200);
    rect(0, 0, width, height);

    fill(255);
    textAlign(CENTER, CENTER);
    text("Player1win", width/2, height/2);
  }
  if (status == 2) {
    fill(0, 0, 0, 200);
    rect(0, 0, width, height);
    fill(255);
    textAlign(CENTER, CENTER);
    text("Player2win", width/2, height/2);
  }
}
void keyPressed() {
  if (status > 0) {
    return;
  }
  if (count<5) {
    if (turn==2) {
      if ( keyCode == DOWN) {
        max-=1;
        count += 1;
      }
    }
  }
  if (count<5) {
    if (turn==1) {
      if (key=='s') {
        max-=1;
        count += 1;
      }
    }
  }

  // ENTERがおされてturnが1のとき

  if (keyCode ==ENTER) {
    if (turn == 0) {
      rx+=500;
      ex+=500;
      turn = 1;
    } else if (turn== 1 && count > 0) {
      bx+=50;
      turn=2;
      count=0;
      sx-=500;
      ex-=500;
      rx-=500;
      lx-=500;
    } else if (turn == 2 && count > 0) {
      bx-=50;
      turn=1;
      count=0;
      sx+=500;
      ex+=500;
      lx+=500;
      rx+=500;
    }
  }
}
