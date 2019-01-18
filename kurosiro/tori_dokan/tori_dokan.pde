float x = 200;
float y = 10;
float x1= 400;
float x2= 400;
float y1 = 0;
float y2 = 300;
float d1 = 100;
float d2 = 100;
float ss1 = 3;
float ss2 = 3;
float g1 = 50;
float s1 = 0 ;
float s2 = 0 ;
float v = 2;
float p = 0;
float game = 0;
float   ttt = 2;
float   sss = 0;
float   a = 0.012;
void setup() {  
  size (600, 400);
  game = 1;
  PFont font = createFont("Yu Gothic",48,true);
textFont(font);
  textSize(30);
}
void draw() {
  
  background(p);
  rect(x, y, 50, 50);
  d1 = y1 + d1;
  d2 = 400-y2;
  // x = mouseX - 25 ;
  // y = mouseY - 25;
  v += 0.3;
  y += v;
  rect(x1, y1, 50, d1);
  rect(x2, y2, 50, d2);
  text(sss ,180 ,30);
  // rect(x1,340,50,60);
  if (game == 1 ) {
    ttt -= 0.016;
    sss += a;
    
    v += 0.2;
    y += v;
    x1 -= ss1;
    x2 += ss2;
    if (x1 < 0) {
      x1 =600;
      d1 = random(70,100);
      ss1 = random(4,5);
    }
    text(ttt, 30,30);
  }
  if (x2 > 600) {
      x2 = 0;
      d2 = random(70,100);
      y2 = random(200, 350);
      ss2 = random(4,5);
    }
  if (ttt < 0){
    game = 0; 
  }
   if (ttt > 2){
    ttt = 2; 
  }

  if (Tento.isHit(x, y, 50, 50, x1, y1, 50, d1)) {
    game = 0; 
   
  }
   if (Tento.isHit(x, y, 50, 50, x2, y2, 50, d2)) {
    game = 0;
     
  }
  if(game == 0){
    p = 255;
       background(p,0,0);
    textSize(32);
    text("GAMEOVER",30,30);
     p = 0;
    if(sss<10 ){
    
    text("お疲れ様です。",100,100);
  }
  if(sss>11 && sss<21){
    
    text("上手い！",100,100);
  }
  if(sss>30 && sss<31){
    
    text("コングラチュレーション！",100,100);
  }
  p = 0;
  }
}

void mousePressed() {
  if ( game == 1) {
    v = -7;
  }
}   
void keyPressed(){
   if(key == 'd'){
        x += 100;
        ttt += 1;
       
    }
   if(key == 'a'){
        x -= 100;
        ttt += 1;
        
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
