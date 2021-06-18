class Tama {
  public float x;
  public float y;
  public float dx;
  public float dy;
  public float anan;
  public float unko;
  public float inko;
  public float anko;
  public float time;
}

class TamaManager{
  ArrayList<Tama> tamaList = new ArrayList<Tama>();
  public void createTama(float x, float y,int team){
    for (int i=0; i<10; i++) {
      Tama t = new Tama();
      t.x=x;
      t.y=y;
      t.anan=1;
      if(team == 1){
      t.unko=random(200, 255);
      t.inko=0;
      t.anko=0;
      }
      if (team == 2) {
        t.unko=0;
        t.inko=0;
        t.anko=random(200, 255);
      }
      
      t.dy=random(-3, 3);
      t.dx=random(-3, 3);
      tamaList.add(t);
    }
  }
  public void update(){
    for (int i=0; i<tamaList.size(); i++) {
      Tama t = tamaList.get(i);
      fill(t.unko, t.inko, t.anko, 150 - t.time);
  
      t.y+=t.dy;
      t.x+=t.dx;
      t.time+=4;
      if (t.time<150) {
        rect(t.x, t.y, 8, 8);
      }
    }
  }
}


TamaManager manager;
class Player { 
  public float x;
  public float y;
  public float speed=0;
  public float movex;
  public int playerid;
}
class Raser {
  public float x;
  public float y;
  public int status = 0;
}
class Kabe {
  public float y;
  public float x;
  public float dy;
}
class Switch {
  public float x;
}
int ready=0;
int y=-50;
int ay=-100;
ArrayList<Player> playerList = new ArrayList<Player>();
ArrayList<Raser> raserList = new ArrayList<Raser>();
ArrayList<Kabe> kabeList = new ArrayList<Kabe>();
ArrayList<Switch> switchList = new ArrayList<Switch>();
void setup() {
  size(900, 200);
  manager = new TamaManager();
  Player p = new Player();
  p.x=30;
  p.y=180;
  p.movex=0;
  p.playerid=1;
  playerList.add(p);
  Player p02 = new Player();
  p02.x = 30;
  p02.y = 180;
  p02.movex = 0;
  p02.playerid=2;
  playerList.add(p02);
  // スイッチ１
  Switch s = new Switch();
  s.x=470;
  switchList.add(s);
  //スイッチ２
  Switch s2 = new Switch();
  s2.x=170;
  switchList.add(s2);
  // レーザー１
  Raser r = new Raser();
  r.x=150;
  raserList.add(r);

  // レーザー２
  Raser r2 = new Raser();
  r2.x=500;
  raserList.add(r2);

  // レーザー3
  Raser r3 = new Raser();
  r3.x=830;
  raserList.add(r3);
  //壁１
  Kabe k = new Kabe();
  kabeList.add(k);
  k.x=300;
  k.y=0;
  k.dy=-4;
  //壁2
  Kabe k2 = new Kabe();
  kabeList.add(k2);
  k2.x=450;
  k2.y=0;
  k2.dy=-3;
  //壁3
  Kabe k3 = new Kabe();
  kabeList.add(k3);
  k3.x=100;
  k3.y=0;
  k3.dy-=3;
  //壁４
  Kabe k4 = new Kabe();
  kabeList.add(k4);
  k4.x=575;
  k4.y=0;
  k4.dy-=4;
  //壁5
  Kabe k5 = new Kabe();
  kabeList.add(k5);
  k5.x=670;
  k5.y=-0;
  k5.dy=-5;
  //壁６
  Kabe k6 = new Kabe();
  kabeList.add(k6);
  k6.x=770;
  k6.y=0;
  k6.dy=-6;
}

void draw() {
  if (ready==0) {
    background(255);
    y+=3;
    ay+=3;
    fill(255,0,0);
    rect(455,y,7,7);
    fill(0,0,255);
    rect(475,ay,7,7);
    fill(#FF74E6);
    textSize(65);
    text("friends", 380, 100); 
    //面白い
    fill(0, ay / 50f * 255);
    textSize(25);
    text(" ''ENTER'' ", 420, 150);
    if(y>50){
      y=50;
    }
    if(ay>50){
      ay=50;
    }
  }
  if (ready==1) {
      background(#EBF2ED);
    //Switch
    //Player 1 
    for (int w=0; w<playerList.size(); w++) {
      Player p = playerList.get(w);
      p.speed= p.speed+0.5;
      p.y=p.y+p.speed;
      // レーザーとの当たり判定をしたい
      for (int i=0; i<raserList.size(); i++) {
        Raser r = raserList.get(i);
        if (r.status == 0) {
          continue;
        }
        int death = Tento.isHit(p.x, p.y, 20, 20, r.x, -10, 5, 310);
        if (death>0) {
            manager.createTama(p.x, p.y,p.playerid);
          p.x=30;
          p.speed=0;
          death=0;
        }
      }

      if (p.movex==2) {
        p.x+=2;
      }
      if (p.movex==1) {
        p.x-=2;
      }
      if (p.x<0) {
        p.x=0;
      }
      if (p.y>180) {
        p.y=180;
        p.speed=0;
      }
      if (p.y<0) {
        p.y=0;
      }
      if (p.playerid==1) {
        fill(255, 0, 0);
        if (p.x>850) {
          rect(0, 0, 900, 500);
        }
      }
      if (p.playerid == 2) {
        fill(0, 0, 255);
        if (p.x>850) {
          println("GOAL");
        }
      }
      rect(p.x, p.y, 20, 20);
    }

    int hit = 0;
    for (int w=0; w<playerList.size(); w++) {
      // スイッチとの当たり判定
      Player p = playerList.get(w);
      for (int q =0; q<switchList.size(); q++) {
        Switch s = switchList.get(q);
        rect(s.x, 195, 10, 5);
        int subhit = Tento.isHit(p.x, p.y, 20, 20, s.x, 195, 10, 5);
        if (subhit == 1) {
          hit = 1;
        }
      }
    }


    // プレイヤーが壁と当たっているのかチェック
    // プレイヤーすべてをチェック
    // 壁すべてをチェック
    // すべてのプレイヤーとすべての壁を総当たりでチェック
    for (int w=0; w<playerList.size(); w++) {
      // スイッチとの当たり判定
      Player p = playerList.get(w);
      for (int i =0; i<kabeList.size(); i++) {
        Kabe k = kabeList.get(i);
        int blockhit = Tento.isHit(p.x, p.y, 20, 20, k.x, k.y, 20, 200);
        if (blockhit==1) {
          manager.createTama(p.x, p.y,p.playerid);
          
          p.x=30;
          p.speed=0;
          blockhit=0;
        }
      }
    }
    //kabe
    for (int i=0; i<kabeList.size(); i++) {
      Kabe k = kabeList.get(i);
      k.y+=k.dy;
      fill(255);
      rect(k.x, k.y, 20, 200);
      if (k.y>-3) {
        k.dy*=-1;
      }
      if (k.y<-100) {
        k.dy*=-1;
      }
    }
    for (int j=0; j<raserList.size(); j++) {
      Raser r = raserList.get(j);
      r.status = hit;
    }
    //biem
    for (int i=0; i<raserList.size(); i++) {
      Raser r = raserList.get(i);
      if (r.status == 1) {
        fill(#6E02BC);
        rect(r.x, -10, 5, 310);
      }
    }
    //}
    //kazariaa
    fill(#3F006C);
    rect(148, 0, 9, 3);
    rect(148, 197, 9, 3);
    rect(498, 0, 9, 3);
    rect(498, 197, 9, 3);
    rect(828, 0, 9, 3);
    rect(828, 197, 9, 3);
    //GOAL
    fill(#41F071);
    rect(850, 150, 40, 50);
    for (int w=0; w<playerList.size(); w++) {
      Player p = playerList.get(w);
      if (p.playerid==1) {
        if (p.x>850) {
          p.x=860;
          fill(255);
          rect(0, 0, 900, 300);
          fill(255, 0, 0);
          textSize(100);
          rect(440, 40, 20, 20);
          text("WlN", 350, 150);
        }
      }
      if (p.playerid==2) {
        if (p.x>850) {
          p.x=860;
          fill(255);
          rect(0, 0, 900, 300);
          fill(0, 0, 255);
          textSize(100);
          rect(440, 40, 20, 20);
          text("WlN", 350, 150);
        }
      }
    }
      manager.update();
  }
}
void keyPressed() {
  if (keyCode==ENTER) {
    ready=1;
  }
  //P1 move
  Player p = playerList.get(0);
  if (key=='d') {
    p.movex=2;
  }
  if (key=='a') {
    p.movex=1;
  }
  if (key=='w') {
    if (p.speed==0) {
      p.speed-=10;
    }
  }
  //P2 move
  Player a = playerList.get(1);
  if (keyCode == RIGHT) {
    a.movex=2;
  }
  if (keyCode == LEFT) {
    a.movex=1;
  }
  if (keyCode == UP) {
    if (a.speed==0) {
      a.speed-=10;
    }
  }
}
