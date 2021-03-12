class Camera {
  public float x;
  public float y;
  public float z = 10;
  public float getX(float _x) {
    float newX = _x - x;
    newX /= getZ();
    newX += width/2;
    return newX;
  }
  public float getY(float _y) {
    float newY = _y - y;
    newY /= getZ();
    newY += height/2;
    return newY;
  }
  public float getSize(float _s) {
    float newS =  _s / getZ();
    return newS;
  }
  float getZ() {
    float _z = z / 10;
    if (_z == 0)  return 1;
    return _z;
  }
}
//  銃を撃った時の処理
float sabun_x;
float sabun_y;
float enemy = 5;
//音
float sound;
float music_time;
//ゲーム開始用
int gamestart = 0;
int gamefinish = 1;
float x = 100;
float y = 100;
Camera camera;
float x1 = 400;
float y1 = 355;
float reticleline0 = 45;
int time60 = 0;
int time = 0;
float reticle_zoom = 0;
float reticle_size = 50;
int score=0;
float x1_position;
float y1_position;
float x1_random_under_number = -4;
float x1_random_high_number = 4;
float y1_random_under_number = -4;
float y1_random_high_number = 4;
int score_last;
int kosa_miss = 0;
int kosa_hit = 0;
//float 
void setup() {
  // ground=loadImage("jimen.png");
  // fullScreen();
  size(window.innerWidth, window.innerHeight);
  camera = new Camera();
  camera.x = x;
  camera.y = y;
  camera.z = 10;
  textSize(50);
  score_last = score;
}
int timer;
void draw(){
  //時間調整
  timer+=1;
  if(timer % 5 == 0){
    game();
  }
}
void game() {
  textSize(50);
  //当たりはずれのテキスト濃さ
  kosa_miss -= 5;
  kosa_hit -= 5;
  music_time += 1;
  //タイトル
  if (gamestart == 0)background(0,175,0);
  //ゲーム
  if (gamestart == 1) {
    background(0,175,0);
    //秒数カウント
    if (frameCount % 45 == 0) {
      x1_position += random(x1_random_under_number, x1_random_high_number);
      y1_position += random(y1_random_under_number, y1_random_high_number);
    }
    time60 += 1;
    if (time60 == 15) {
      time60 = 0;
      time += 1;
    }
    //当たりはずれのテキスト
    textSize(100);
    fill(0, 0, 0, kosa_miss);
    text("miss", width / 2, height / 2 - 50);
    fill(0, 0, 0, kosa_hit);
    text("hit", width / 2, height / 2 - 50);
    textSize(50);
    //レティクル線
    reticle();
    //リロードメーター
    fill(255);
    rect(width/2+400, height/2-200, 40, 500);
    fill(255, 0, 0);
    float per = music_time / 30;
    per = min(per, 1);
    if (per >= 1) {
      fill(0, 0, 255);
    }
    rect(width/2+400, height/2-200, 40, 500 * per);    
    //スコープ
    if (reticle_zoom == 1) {
      noFill();
      stroke(0);
      strokeWeight(50);
      ellipse(width/2, height/2, 720, 720);
    }
    strokeWeight(1);
    //残り時間メーター
    fill(255, 0, 0);
    rect(width/2-250, height/2+300, 500, 40);
    fill(255);
    float time_per = time*12.5;
    if (time_per >= 500) {
      fill(255);
    }
    rect(width/2-250, height/2+300, 500-time_per, 40);   
    //視点移動
    camera.x =x + mouseX;
    camera.y =y + mouseY;
    strokeWeight(1);
    stroke(255);
    fill(255);
    strokeWeight(1);
    stroke(0);
    fill(255, 255, 0);
    ellipse(camera.getX(x1 + x1_position), camera.getY(y1 + y1_position), camera.getSize(enemy), camera.getSize(enemy));
    // rect(0, camera.getY(380), 1600, camera.getSize(6000));
    stroke(255, 0, 0);
    fill(255, 0, 0);
    //   rect(camera.getX(x2), camera.getY(y2), camera.getSize(30), camera.getSize(30));
    //ゲーム終了
    if (time >= 40) {
      strokeWeight(1);
      text(score, 510, 350);
      gamestart = 0;
      score_last = score;
    }
/*    
   if (reticle_zoom == 1) {
      noFill();
      stroke(0);
      strokeWeight(50);
      ellipse(width/2, height/2, 720, 720);
    }
*/
    //的座標制限
    if (x1 + x1_position > 595) {
      x1_random_high_number = 0;
      x1_random_under_number = -8;
    }
    if (x1_position + x1 < 595&&x1 + x1_position > 189) {
      x1_random_high_number = 4;
      x1_random_under_number = -4;
    }
    if (y1_position + x1 < 189) {
      x1_random_high_number = 8;
      x1_random_under_number = 0;
    }
    if (y1_position + y1 > 355) {
      y1_random_high_number = 0;
      y1_random_under_number = -8;
    }
    if (y1_position + y1 < 355 && y1 + y1_position > 160) {
      y1_random_high_number = 4;
      y1_random_under_number = -4;
    }
    if (y1_position + y1 < 160) {
      y1_random_high_number = 8;
      y1_random_under_number = 0;
    } 
    //文字の背景の薄い枠
    textSize(50);
    strokeWeight(1);
    noStroke();
    fill(255, 255, 255, 128);
    rect(width/2 + 400, height/2 - 250, 75, 50);
    rect(width/2 + 400, height/2 - 300, 75, 50);
    fill(0);
    //文字
    text(40 - time, width/2 + 400, height/2 - 210);
    text(score, width/2 + 400, height/2 - 260);
    //敵当たった時の処理
    if (enemy > 5) {
      x1 = random(200, 600);
      y1 = random(150, 360);
      score += 1;
      kosa_miss=0;
      kosa_hit=255;
      enemy = 5;
    }                                                   //shoto enemy
    if (music_time > 15 && sound == 1) {
      sound = 9;
    }                                                     //sound
    textSize(50);
    strokeWeight(1);
  } else {
    fill(255);
    text("Push X key", width/2 - 150, height/2 + 75);
    text("Last Scores", width/2 - 150, 300);
    text(score_last, width/2 - 50, 400);
    text("mouse click=shot", width/2 - 200, height/2 + 200);
    text("key_c=zoomin/zoomout", width/2 - 300, height/2 + 300);
  }
}


void mousePressed() {
  if (music_time>30 && gamestart == 1) {
    sabun_x = abs(camera.getX(x1 + x1_position) - width/2);
    sabun_y = abs(camera.getY(y1 + y1_position) - height/2);
    println(sabun_x + "_" + sabun_y);
    if (reticle_zoom == 1) {
      if (time<41 && sabun_x<23 && sabun_y<23) {
        for (int i = 0; enemy < 10; i++) {
          enemy += i;
        }
      } else {
        kosa_hit=0;
        kosa_miss = 255;
      }
    }
    if (reticle_zoom == 0) {
      if (time < 41 && sabun_x < 3 && sabun_y < 3) {
        for (int i = 0; i < 100; i++) {
          enemy += i;
        }
      } else {
        kosa_hit=0;
        kosa_miss = 255;
      }
    }
    music_time = 0;
    sound = 1;
  }
  println(sabun_x + "_" + sabun_y);
}

void keyPressed() {
//zoom in zoom out
if (key == 'c') {
    if (camera.z == 10) {
      camera.z = 1;
      reticleline0 = 10;
      reticle_zoom = 1;
      reticle_size = 350;
    } else {
      if (camera.z == 1) {
        camera.z = 10;
        reticleline0 = 45;
        reticle_zoom = 0;
        reticle_size = 50;
      }
    }
  }                                                            
//start
  if (key == 'x') {
    if (gamestart == 0) {
      gamestart = 1;
      gamefinish = 0;
      score = 0;
      time = 0;
      time60 = 0;
      camera.z = 10;
      reticleline0 = 45;
      reticle_zoom = 0;
      reticle_size = 50;
    }
  }                                
}
void reticle() {
  noFill();
  stroke(255, 0, 0);
  strokeWeight(1);
  ellipse(width/2, height/2, 2, 2);
  stroke(0);
  line(width/2, height/2 - reticleline0, width/2, height/2 - reticleline0 - reticle_size);
  line(width/2, height/2 + reticleline0, width/2, height/2 + reticleline0 + reticle_size);
  line(width/2 + reticleline0, height/2, width/2 + reticleline0 + reticle_size, height/2);
  line(width/2 - reticleline0, height/2, width/2 - reticleline0 - reticle_size, height/2);
}
