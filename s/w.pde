
/*
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;
*/
//
float x = 300;
PImage taikukann;
PImage goru;
PImage tama;
PImage sakragi;
PImage taikukann2 ;
PImage gori;
float suteizi1 ;
float y = 0;
float ball_x_s = 10;
float ball_y_s = -10;
float adjust = 0.2;
//float xs;
float ys = 450;
float gy = 420;

int jumpTimer = 0;
int jumpTimergori;
int shoot = 0;
float speed = 5;
float reiup;
float syuut2 = 590;
float syuut = 580;
int goal = 0;
int clear = 0;
float xs = 0;
int sc = 0;
float gx = 610;
float upgx = 650;
float udgx = 690;
float tk = 10;
float ggov = 0;



//import ddf.minim.*;
//Minim mnm;
//AudioPlayer bgm;
//AudioPlayer bomb;



void setup() {
  size(800, 600);

  //mnm  = new Minim(this);


  //bomb = mnm.loadFile("cancel1.mp3");
  //bgm = mnm.loadFile("basket-shoot1.mp3");



  //taikukann = loadImage("taikukann.jpg");
  goru = loadImage("goru.png");
  tama = loadImage("tama.png");
  sakragi = loadImage("sakuragi.png");
  taikukann2 = loadImage("taikukann2.jpg");
  // gori = loadImage("gori.jpg");
  //minim = new
} 

void draw() {
  background(255);
  fill(0);
  text(sc, 100, 100);
  textSize(50);
  fill(255);
  if (clear == 0) {
    game();
  }
  // if (clear == 1) {

  // sc +=1;
  //}
  if (sc == 6) {
    cclear();
  }
}

void game() {
  // xs += 5;
  xs += speed;
  if (xs > width) {
    speed = -5;
  }
  if (xs < 0) {
    speed = 5;
  }
  image(goru, gx, 100, 80, 80);
  
  if(sc == 0){
    stage00();
  }
  if(sc ==1 ){
    stage01();
  }
  if(sc == 2){
    stage02();
  }
  if(sc == 3 ){
    stage03();
  }
  if(sc == 4 ){
    stage04();
  }
  if(sc == +1){
    tk = 10;
  }
  if(tk == 0){
    ggov = 1;
  }
  if(ggov == 1){
    gov();
  }
    
    
  
  
    
}

void stage00(){


    if (shoot == 1) {
      ball_y_s += 2;
      x += ball_x_s * adjust;
      y += ball_y_s * adjust;
    }
    if (shoot == 1) {
      //image(tama, x, y);
      ellipse(x, y, 40, 40);
    }
    // x += speed;

    // image(sakragi, xs, ys, 400,200);

    strokeWeight(5);
    fill(255);
    rect(xs, ys, 50, 50);

    jumpTimer += 1;
    if (jumpTimer > 60) {
      ys = 450;
    }


    // if(x < 0){
    // speed = 5;//
    //

    if (x > width) {
      ball_x_s *= -1;
    }

    // ゴール上
    if (Tento.isHit(x, y, 90, 40, upgx, 130, 20, 20)) {
      // 当たってた時の処理
      //fill(255, 0, 0);
      goal = 1;
    }
    //rect(670, 130, 30, 20);
    


    // 本物ゴール
    if (Tento.isHit(x, y, 90, 40, udgx, 180, 20, 20)) {

      if (goal == 1) {
        //clear = 1;
        sc += 1;
        goal = 0;

        // bgm.play();
       // bomb.rewind();
      } 
      if (sc == 5) {
        clear = 1;
        //bgm.play();
      }
    } 
}
void stage01(){
   if ( sc == 1) {
    gx += 5;
    upgx += 5;
    udgx +=5;
  }
  if (  sc == 1) {
    
    if (shoot == 1) {
      ball_y_s += 2;
      x += ball_x_s * adjust;
      y += ball_y_s * adjust;
    }
    if (shoot == 1) {
      //image(tama, x, y);
      ellipse(x, y, 40, 40);
    }
    // x += speed;

    // image(sakragi, xs, ys, 400,200);

    strokeWeight(5);
    fill(255);
    rect(xs, ys, 50, 50);

    jumpTimer += 1;
    if (jumpTimer > 60) {
      ys = 450;
    }


    // if(x < 0){
    // speed = 5;//
    //

    if (x > width) {
      ball_x_s *= -1;
    }

    // ゴール上
    if (Tento.isHit(x, y, 90, 40, upgx, 130, 20, 20)) {
      // 当たってた時の処理
      //fill(255, 0, 0);
      goal = 1;
    }
    //rect(670, 130, 30, 20);


    // 本物ゴール
    if (Tento.isHit(x, y, 90, 40, udgx, 180, 20, 20)) {

      if (goal == 1) {
        //clear = 1;
        sc += 1;
        goal = 0;

        // bgm.play();
        //bomb.rewind();
      } 
      if (sc == 5) {
        clear = 1;
        //bgm.play();
      }
    } 

     
    
    if (gx > width)
      gx = 0;
    if (upgx > width)    
      upgx = 0;
    if ( udgx > width)
      udgx = 0;
  }
}
void stage02(){
     if ( sc == 2) {
    gx += 10;
    upgx += 10;
    udgx +=10;
  }
  if (  sc == 2) {
    
    if (shoot == 1) {
      ball_y_s += 2;
      x += ball_x_s * adjust;
      y += ball_y_s * adjust;
    }
    if (shoot == 1) {
      //image(tama, x, y);
      ellipse(x, y, 40, 40);
    }
    // x += speed;

    // image(sakragi, xs, ys, 400,200);

    strokeWeight(5);
    fill(255);
    rect(xs, ys, 50, 50);

    jumpTimer += 1;
    if (jumpTimer > 60) {
      ys = 450;
    }


    // if(x < 0){
    // speed = 5;//
    //

    if (x > width) {
      ball_x_s *= -1;
    }

    // ゴール上
    if (Tento.isHit(x, y, 90, 40, upgx, 130, 20, 20)) {
      // 当たってた時の処理
      //fill(255, 0, 0);
      goal = 1;
    }
    //rect(670, 130, 30, 20);


    // 本物ゴール
    if (Tento.isHit(x, y, 90, 40, udgx, 180, 20, 20)) {

      if (goal == 1) {
        //clear = 1;
        sc += 1;
        goal = 0;

        // bgm.play();
        //bomb.rewind();
      } 
      if (sc == 5) {
        clear = 1;
        //bgm.play();
      }
    } 

     
    
    if (gx > width)
      gx = 0;
    if (upgx > width)    
      upgx = 0;
    if ( udgx > width)
      udgx = 0;
  }
}
void stage03(){
     if ( sc == 3) {
    gx += 15;
    upgx += 15;
    udgx +=15;
  }
  if (  sc == 3) {
    
    if (shoot == 1) {
      ball_y_s += 2;
      x += ball_x_s * adjust;
      y += ball_y_s * adjust;
    }
    if (shoot == 1) {
      //image(tama, x, y);
      ellipse(x, y, 40, 40);
    }
    // x += speed;

    // image(sakragi, xs, ys, 400,200);

    strokeWeight(5);
    fill(255);
    rect(xs, ys, 50, 50);

    jumpTimer += 1;
    if (jumpTimer > 60) {
      ys = 450;
    }


    // if(x < 0){
    // speed = 5;//
    //

    if (x > width) {
      ball_x_s *= -1;
    }

    // ゴール上
    if (Tento.isHit(x, y, 90, 40, upgx, 130, 20, 20)) {
      // 当たってた時の処理
      //fill(255, 0, 0);
      goal = 1;
    }
    //rect(670, 130, 30, 20);


    // 本物ゴール
    if (Tento.isHit(x, y, 90, 40, udgx, 180, 20, 20)) {

      if (goal == 1) {
        //clear = 1;
        sc += 1;
        goal = 0;

        // bgm.play();
       //bomb.rewind();
      } 
      if (sc == 5) {
        clear = 1;
        //bgm.play();
      }
    } 

     
    
    if (gx > width)
      gx = 0;
    if (upgx > width)    
      upgx = 0;
    if ( udgx > width)
      udgx = 0;
  }
}void stage04(){
     if ( sc == 4) {
    gx += 20;
    upgx += 20;
    udgx +=20;
  }
  if (  sc == 4) {
    
    if (shoot == 1) {
      ball_y_s += 2;
      x += ball_x_s * adjust;
      y += ball_y_s * adjust;
    }
    if (shoot == 1) {
      //image(tama, x, y);
      ellipse(x, y, 40, 40);
    }
    // x += speed;

    // image(sakragi, xs, ys, 400,200);

    strokeWeight(5);
    fill(255);
    rect(xs, ys, 50, 50);

    jumpTimer += 1;
    if (jumpTimer > 60) {
      ys = 450;
    }


    // if(x < 0){
    // speed = 5;//
    //

    if (x > width) {
      ball_x_s *= -1;
    }

    // ゴール上
    if (Tento.isHit(x, y, 90, 40, upgx, 130, 20, 20)) {
      // 当たってた時の処理
      //fill(255, 0, 0);
      goal = 1;
    }
    //rect(670, 130, 30, 20);


    // 本物ゴール
    if (Tento.isHit(x, y, 90, 40, udgx, 180, 20, 20)) {

      if (goal == 1) {
        //clear = 1;
        sc += 1;
        goal = 0;

        // bgm.play();
        //bomb.rewind();
      } 
      if (sc == 5) {
        clear = 1;
        //bgm.play();
      }
    } 

     
    
    if (gx > width)
      gx = 0;
    if (upgx > width)    
      upgx = 0;
    if ( udgx > width)
      udgx = 0;
  }
}


  



  
    
  


void cclear() {


  // image(taikukann2, 0, 0);
  fill(0);
  textSize(60);
  textAlign(CENTER);
  text("CLEAR", 400, 300);
}

void keyPressed() {
  if (keyCode == ENTER) {
    //bgm.rewind();
    init();
    sc = 0;
  }

  if (keyCode == LEFT) {
    x -= 10;
  }
  if (keyCode ==RIGHT) {
    x += 10;
  }
  if (keyCode ==UP) {
    y -= 5;
  }
  if (keyCode == LEFT) {
    xs -= 10;
  }
  if (keyCode ==RIGHT) {
    xs += 10;
  }
  //if (keyCode ==UP) {
  //;
  //}
  if (key == ' ') {
    ys = 350;
    jumpTimer = 0;
  }
  if (key == ' ') {
    shoot = 1;
    gy = 110;
  }
  if (key == ' ') {
    y = 355;
    x = xs;
    ball_y_s = -90;
    ball_x_s = 25;
  }
  if (key == ' ') {
    goal = 0;
    //bomb.play();
    //bomb.rewind();
    tk =- 1;
  }
  
  //if (keyCode == UP) {
  // if (keyCode == RIGHT) {
  //bomb.play();
  //bomb.rewind();
}

// if (keyCode == LEFT) {
//bomb.play();
//bomb.rewind();

void mousePressed() {
  ys = 350;
    jumpTimer = 0;
     shoot = 1;
    gy = 110;
    y = 355;
    x = xs;
    ball_y_s = -90;
    ball_x_s = 25;
    goal = 0;
    //bomb.play();
    //bomb.rewind();
    tk =- 1;
}
    
void init() {

  x = 300;
  y = 0;
  ball_x_s = 10;
  ball_y_s = -10;
  adjust = 0.2;
  //float xs;
  ys = 450;
  gy = 420;
  jumpTimer = 0;
  shoot = 0;
  speed = 5;
  syuut2 = 590;
  syuut = 580;
  goal = 0;
  clear = 0;
  xs = 0;
  gx = 610;
  upgx = 650;
  udgx = 690;
}
void gov(){
   x = 300;
  y = 0;
  ball_x_s = 10;
  ball_y_s = -10;
  adjust = 0.2;
  //float xs;
  ys = 450;
  gy = 420;
  jumpTimer = 0;
  shoot = 0;
  speed = 5;
  syuut2 = 590;
  syuut = 580;
  goal = 0;
  clear = 0;
  xs = 0;
  gx = 610;
  upgx = 650;
  udgx = 690;
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
