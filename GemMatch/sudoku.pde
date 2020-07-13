class Box{
  public int x;
  public int y;
}
class Stone{
  public int x;
  public int y;
  public int number;
}
class PreStone{
  public int x;
  public int y;
  public int number;
}
class GameData{
  public boolean isPre;
  public int select_number;
}

ArrayList<Box> boxList = new ArrayList<Box>();
ArrayList<Stone> stoneList = new ArrayList<Stone>();
ArrayList<PreStone> preStoneList = new ArrayList<PreStone>();
GameData gameData;
void setup(){
  size(320, 480);
  rectMode(CENTER);
  gameInit();
}
void draw(){
  background(200); 
  for(int i=0; i<boxList.size(); i++){
    Box b = boxList.get(i);
    strokeWeight(1);
    fill(255);
    int group_id = getGroupId(b.x, b.y);
    ArrayList<Stone> groupStoneList = findStoneByGroup(stoneList, group_id);
    for(int j=0; j<groupStoneList.size(); j++){
      Stone stone = groupStoneList.get(j);
      if(stone.number == gameData.select_number){
        fill(100, 255, 255);
        if(stone.x == b.x && stone.y == b.y){
          fill(255, 255, 100);
          break;
        }
      }
    }
    
    PVector pos = toWorldPosition(b.x, b.y);
    rect(pos.x, pos.y, 30, 30);
    // 太枠
    if(b.x % 3 == 1 && b.y % 3 == 1){
      noFill();
      strokeWeight(2);
      rect(pos.x, pos.y, 30*3, 30*3);
    }
  }
  for(int i=0; i<boxList.size(); i++){
    Box b = boxList.get(i);
    // 太枠
    if(b.x % 3 == 1 && b.y % 3 == 1){
      PVector pos = toWorldPosition(b.x, b.y);
      noFill();
      strokeWeight(2);
      rect(pos.x, pos.y, 30*3, 30*3);
    }
  }
  for(int i=0; i<boxList.size(); i++){
    Box b = boxList.get(i);
    boolean hasStone = false;
    for(int j=0; j<stoneList.size(); j++){
      Stone stone = stoneList.get(j);
      if(b.x == stone.x && b.y == stone.y){
        PVector pos = toWorldPosition(stone.x, stone.y);
        textAlign(CENTER, CENTER);
        textSize(24);
        fill(100);
        if(stone.number > 0){
          hasStone = true;
          text(stone.number, pos.x, pos.y);
        }
        break;
      }
    }
    if(!hasStone){
      for(int j=0; j<preStoneList.size(); j++){
        PreStone preStone = preStoneList.get(j);
        if(b.x == preStone.x && b.y == preStone.y){
          PVector pos = toWorldPosition(preStone.x, preStone.y);
          pos.x += (preStone.number - 1) % 3 * 10 - 10;
          pos.y += (int)((preStone.number - 1) / 3) * 10 - 10;
          textAlign(CENTER, CENTER);
          textSize(10);
          fill(50);
          if(preStone.number == gameData.select_number){
            fill(255, 100, 100);
          }
          // 仮置きとして成り立つ？
          if(!canPre(stoneList, preStone.x, preStone.y, preStone.number)){
            preStoneList.remove(preStone);
            j--;
          }
          
          text(preStone.number, pos.x, pos.y);
        }
      }
    }
  }
  
  textAlign(CENTER, CENTER);
  fill(100);
  if(gameData.isPre){
    fill(255);
  }
  rect(270, 50, 50, 20);
  textSize(12);
  fill(0);
  text("PRE", 270, 50); 
  
  for(int index=1; index<10; index++){
    float _x = index * 30 + 10;
    float _y = 430;
    fill(255);
    if(index == gameData.select_number){
      fill(255, 255, 100);
    }
    int count = 0;
    for(int i=0; i<stoneList.size(); i++){
      Stone stone = stoneList.get(i) ;
      if(stone.number == index)  count += 1;
    }
    if(count >= 9){
      fill(100);
    }
    rect(_x, _y, 30, 30);
    textSize(16);
    fill(0);
    text(index, _x, _y);
  }
}
void mousePressed(){
  Box targetBox = null;
  for(int i=0; i<boxList.size(); i++){
    Box b = boxList.get(i);
    PVector pos = toWorldPosition(b.x, b.y);
    float _dist = dist(mouseX, mouseY, pos.x, pos.y);
    if(_dist < 15){
      targetBox = b;
      break;
    }
  }
  if(targetBox != null){
    if(!gameData.isPre){
      putStone(targetBox.x, targetBox.y, gameData.select_number);
    }
    if(gameData.isPre){
      putPreStone(targetBox.x, targetBox.y, gameData.select_number);
    }
  }

  if(dist(mouseX, mouseY, 270, 50) < 30){
    gameData.isPre = !gameData.isPre; 
  }
  
  for(int index=1; index<10; index++){
    float _x = index * 30 + 10;
    float _y = 430;
    if(dist(mouseX, mouseY, _x, _y) < 20){
      gameData.select_number = index; 
    }
  }
}
void putStone(int x, int y, int number){
  for(int i=0; i<stoneList.size(); i++){
    Stone stone = stoneList.get(i);
    if(stone.x == x && stone.y == y){
      boolean isOK = false;
      if(stone.number < 0){
        if(abs(stone.number) == number){
          isOK = true;
        }
      }
      if(isOK){
        stone.number = number;
      }
      return;
    }
  }
  Stone stone = new Stone();
  stone.x = x;
  stone.y = y;
  stone.number = number;
  stoneList.add(stone);
}
void putPreStone(int x, int y, int number){
  for(int i=0; i<preStoneList.size(); i++){
    PreStone preStone = preStoneList.get(i);
    if(preStone.x == x && preStone.y == y && preStone.number == number){
      preStoneList.remove(i);
      return;
    }
  }
  PreStone preStone = new PreStone();
  preStone.x = x;
  preStone.y = y;
  preStone.number = number;
  preStoneList.add(preStone);
}
void gameInit(){
  gameData = new GameData();
  gameData.select_number = 1;
  boxList = new ArrayList<Box>();
  for(int x=0; x<9; x++){
    for(int y=0; y<9; y++){
      Box box = new Box();
      box.x = x;
      box.y = y;
      boxList.add(box);
    }
  }
  stoneList = new ArrayList<Stone>();
  int[][] s = getStage();
  for(int x=0; x<9; x++){
    for(int y=0; y<9; y++){
      if(s[x][y] != 0){
        Stone stone = new Stone(); 
        stone.x = x;
        stone.y = y;
        stone.number = s[x][y];
        stoneList.add(stone);
      }
    }
  }
}

boolean canPre(ArrayList<Stone> stoneList, int prex, int prey, int number){
  int pre_group_id = getGroupId(prex, prey);
  for(int i=0; i<stoneList.size(); i++){
    Stone stone = stoneList.get(i);
    if(stone.x == prex && stone.number == number){
      return false;
    }
    if(stone.y == prey && stone.number == number){
      return false;
    }
    int group_id = getGroupId(stone.x, stone.y);
    if(group_id == pre_group_id && stone.number == number){
      return false;
    }
  }
  return true;
}

ArrayList<Stone> findStoneByGroup(ArrayList<Stone> stoneList, int group){
  ArrayList<Stone> resultList = new ArrayList<Stone>();
  for(int i=0; i<stoneList.size(); i++){
    Stone stone = stoneList.get(i);
    if(getGroupId(stone.x, stone.y) == group){
      resultList.add(stone); 
    }
  }
  return resultList;
}
int getGroupId(int x, int y){
  int id = (int)(x / 3) + ((int)(y / 3) * 3);
  return id;
}
int[][] getStage(){
  int[][] maps = Sudoku.createDefaultMaps();
  Sudoku.shuffle(this, maps);
  Sudoku.attachBlanks(this, maps);
  return maps;
}
PVector toWorldPosition(int x, int y){
  PVector pos = new PVector(x * 30 + 40, y * 30 + 100);
  return pos;
}


static class Sudoku{
  public static void attachBlanks(PApplet app, int[][] maps){
    for(int group=0; group<9; group++){
      if(group >= 5){
        // 点対象にするため
        continue;
      }
      int dispCount = (int)app.random(3, 5);
      int blankCount = 9 - dispCount;
      int startX = group % 3 * 3;
      int startY = (int)(group / 3) * 3;
      int toX = startX + 3;
      int toY = startY + 3;
      if(group == 4){
        // 中央のグループのため
        dispCount = (int)app.random(0, 3);
        blankCount = 4 - dispCount;
      }
      int count = 0;
      for(int i=0; i<100; i++){
        int rx = (int)app.random(startX, toX);
        int ry = (int)app.random(startY, toY);
        if(group == 4 && rx == 5 && ry >= 5){
          // 点対象にするため。
          continue;
        }
        if(maps[rx][ry] > 0){
          maps[rx][ry] *= -1;
          
          // 点対象を探す
          int _rx = 8 - rx;
          int _ry = 8 - ry;
          maps[_rx][_ry] *= -1;
          
          count += 1;
        }
        if(count >= blankCount){
          break;
        }
      }
    }
  }
  public static void _attachBlanks(PApplet app, int [][] maps){
    for(int group=0; group<1; group++){
      int blankCount = 9 - (int)app.random(3, 5);
      int startX = group % 3 * 3;
      int startY = (int)(group / 3) * 3;
      int toX = startX + 3;
      int toY = startY + 3;
      int count = 0;
      for(int i=0; i<100; i++){
        int rx = (int)app.random(startX, toX);
        int ry = (int)app.random(startY, toY);
        if(maps[rx][ry] > 0){
          maps[rx][ry] *= -1;
          count += 1;
        }
        if(count >= blankCount){
          break;
        }
      }
    }
  }
  public static int[][] createDefaultMaps(){
    int[][] maps = new int[9][9];
    for(int x=0; x<9; x++){
      for(int y=0; y<9; y++){
        int v = y * 3 + (int)(y / 3);
        v = (v + x) % 9 + 1;
        maps[x][y] = v;
      }
    }
    return maps;
  }
  public static void shuffle(PApplet app, int[][] maps){
    for(int i=0; i<999; i++){
      int from = (int)app.random(1, 10);
      int to = (int)app.random(1, 10);
      for(int group=0; group<9; group++){
        int startX = group % 3 * 3;
        int startY = (int)(group / 3) * 3;
        int toX = startX + 3;
        int toY = startY + 3;
        for(int x=startX; x<toX; x++){
          for(int y=startY; y<toY; y++){
             if(maps[x][y] == from){
               maps[x][y] = to;
               continue;
             }
             if(maps[x][y] == to){
               maps[x][y] = from;
               continue;
             }
          }
        }
      }
    }
  }
}
