float Fx = 50;
float Fy = 230;
float Dx = 250;
float Dy = 0;
float Dx2 = 450;
float Dy2 = 0;
float Bx = 100;
float By = 0;
float BFY = 0;
float speed = 30;
float speed2= 30;
float speed3G= 30;
float DFflag = 0;
float Gx = 700;
float Gy = 10;
float Bxflag = 0;
float angle = 0.0;
float AS = 0;


int flag = 0;
int flagGA = 0;
int ishitcol = 0;
int ishitcol2 = 0;
int ishitcol3 = 0;
int ishitcol4 = 0;
int score = 0;
int gamen = 1;

float FW;
float FD;

//Ballの初期位置を指定
float bx = 100;
float by = 250;

//Playerの初期位置を指定
float px = 50;
float py = 200;

//重力用の変数
float g;

//PlayerとGoalの角度用の変数
float rad;

//Ballの向き用の変数
float vx;
float vy;

//Ballを蹴る強さ用の変数
float pwr = 7;

//制限時間
int timeLimit = 20;
int countDown;


void setup() {
  size(900, 500);
}


void draw() {
  if (gamen == 1) {
    title();
  }
  if (gamen == 2) {
    game();
  }
}

void title() {
  //タイトル画面
  background(0);
  textAlign(CENTER);
  textSize(80);
  fill(127, 255, 0);
  text("SOCCER GAME", width/2, height/2);

  textSize(40);
  fill(255);
  text("START WITH ENTER", 450, 420);
}


void game() {
  fill(255, 250);
  rect(0, 0, width, height);
  background(0);

  int ms = millis()/1000;


  //BALL

  if (Bxflag == 1) {
    //Ballの位置を計算
    bx += vx;
    by += vy;

    vy += g;  
    println(Bxflag);
  }




  // 残像

  for (int i=0; i<10; i++) {
    fill(255, 255, 255, 100 - i * 10);
    if (Bxflag == 1) {
      ellipse(Bx - 5 * i, Fy+20, 20, 20);
    }
  }
  fill(255, 255, 255);

  ellipse(bx, by, 20, 20);

  angle+=0.1;


  //当たり判定

  ishitcol = isHit(bx, by, 20, 20, Dx, Dy, 20, 70);
  if (ishitcol==1) {
    flag = 1;
  }

  ishitcol2 = isHit(bx, by, 20, 20, Dx2, Dy2, 20, 70);
  if (ishitcol2==1) {
    flag = 1;
  }

  ishitcol3 = isHit(bx, by, 20, 20, Gx, Gy, 55, 130);
  if (ishitcol3==1) {
    flag = 1;
  }

  ishitcol4 = isHit(bx, by, 20, 20, 850, 150, 50, 190 );
  if (ishitcol4==1) {
    flagGA = 1;
  }

  //FW

  if (flag==1) {
    fill(255, 0, 0); 
    //flag = 0;
    background(0);
    Bx = 100000;
    textSize(90);
    fill(255, 0, 0);
    text("GAME OVER", width/2, height/2);

    textSize(35);
    fill(255, 0, 0);
    text("Restart with space bar", 685, 460);
  } else {
    fill(255, 255, 255);
  }
  fill(0, 255, 255);
  rect(Fx, Fy+FW+FD, 40, 40);



  if (FW>=0) {
    FW=FW*0.1;
  }

  if (abs(FD)>=0) {
    FD=FD*0.1;
  }


  //GALL

  //スコアを表示
  fill(255);
  textAlign(CENTER);
  textSize(48);
  text(score, 800, 100);

  if (flagGA==1) {
    //fill(255, 0, 0);
    score = score + 1;
    flagGA = 0;
    bx = 100000;
  } else {
    fill(255, 255, 255);
  }
  rect(850, 150, 50, 190);

  //制限時間
  countDown = timeLimit - ms;
  if (countDown > 0) {
    textSize(27);

    if (countDown <= 10) {
      textSize(27);
    }
    text("COUNT DOWN : "+countDown, 130, 40);
  } else {
    textSize(90);
    fill(255, 0, 0);
    text("TIME OVER", width/2, height/2);
    noLoop();
  }


  //DF1

  fill(127, 255, 0);
  rect(Dx, Dy, 20, 70);
  if (Dy > 430) {
    speed = random(-5, -1);
  }
  if (Dy < 0) {
    speed = random(5, 1);
  }
  Dy = Dy + speed;


  //DF2
  rect(Dx2, Dy2, 20, 70);


  if (Dy2 > 430) {
    speed2 = random(-5, -1);
  }
  if (Dy2 < 0) {
    speed2 = random(5, 1);
  }
  Dy2 = Dy2 + speed2;




  //GK 
  rect(Gx, Gy, 55, 130);
  if (Gy > 370) {
    speed3G = random(-10, -1);
  }
  if (Gy < 0) {
    speed3G = random(10, 1);
  }
  Gy = Gy + speed3G;
}

void keyPressed() {
  //シュート
  if (key == 'a') {
    if (Bx ==100) {
      //Ball をPlayer の前にセット
      bx = Fx + 40;
      by = Fy + 20; 

      //重力を設定
      g = -(by - height/2)/3500;

      //コメント
      //Player 中心から離れるほど、重力が働くようになっています。

      //Player とGoal の角度を計算しています。
      //Player とGoal を対角線で結んだ直角三角形の高さと底辺を指定。
      rad = atan2(by - height/2, width - bx+80);//◇

      //Ball を蹴りだす方向と、強さを設定しています。
      vx = cos(rad) * pwr;
      vy = sin(rad) * pwr;

      //フラグの値を変更することでボールが移動します。
      Bxflag = 1;
    }
  }

  //セット
  if (key == ' ') {
    if (Bx > 900) {
      Bxflag = 0;
      Bx = 100;
      By = 250;
    }
  }


  if (key == ' ') {
    if (flag == 1) {
      init();
    }
  }
  if (key == CODED) {
    if (keyCode == UP) {
      Fy -= 10;
      FW = 5;
    }

    if (keyCode == DOWN) {
      Fy += 10;
      FD =-5;
    }
  }

  if (keyCode == ENTER) {
    gamen = 2;
  }
}

void init() {
  score = 0;
  flag = 0;
  flagGA = 0;
  speed = 30;
  speed2= 30;
  speed3G= 30;
  DFflag = 0;
}
int isHit(float px, float py, float pw, float ph, float ex, float ey, float Ax, float Ay) {

  if (px < ex + Ax && px + pw > ex) {
    if (py < ey + Ay && py + ph > ey) {
      return 1;
    }
  }
  return 0;
}
