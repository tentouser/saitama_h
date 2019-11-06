class Box{
  public int x;
  public int y;
  public boolean isGoal;
}
class Meeple{
  public int playerId;
  public int x;
  public int y;
  public boolean isLeader;
  public PVector worldPosition;
  public int toX;
  public int toY;
  public int status = 1;
}
class GameData{
  public int playerId = 1;
  public int status = 0;
  public Meeple selectedMeeple;
  public ArrayList<Box> movableBoxList;
}
ArrayList<Box> boxList = new ArrayList<Box>();
ArrayList<Meeple> meepleList = new ArrayList<Meeple>();
GameData gameData;
void setup(){
  size(320, 480);
  rectMode(CENTER);
  textAlign(CENTER, CENTER);
  init();
}
void draw(){
  background(255);
  
  // コマを移動
  updateMeepleList();
  
  // マス目を表示
  drawBoxList();
  // コマを表示
  drawMeepleList();
  
  // 選択中のコマがあれば
  if(gameData.selectedMeeple != null){
    drawMovable();
  }
  drawUI();
}
void mousePressed(){
  if(gameData.status == 0){
    // マウスの位置から操作対象のコマを取得
    PVector mousePos = new PVector(mouseX, mouseY);
    PVector pos = Logic.getPosition(mousePos);
    Meeple meeple = Logic.getMeepleFromPosition(meepleList, (int)pos.x, (int)pos.y);
    if(meeple != null){
      if(gameData.selectedMeeple == null){
        // まだ選択してなかったら
        if(meeple.playerId == gameData.playerId){
          ArrayList<Box> movableBoxList = Logic.getMovableBoxList(boxList, meepleList, meeple);
          if(movableBoxList.size() > 0){
            gameData.selectedMeeple = meeple;
            gameData.movableBoxList = movableBoxList;
          }
        }
      }else{
        // 選択解除
        gameData.selectedMeeple = null;
        gameData.movableBoxList = new ArrayList<Box>(); 
      }
    }else{
      // それ以外のところをクリックしたならば
      // コマが選択中ならば
      if(gameData.selectedMeeple != null){ 
        // 移動可能なボックスをクリックしたのか判定
        Box box = Logic.getBoxFromPosition(gameData.movableBoxList, (int)pos.x, (int)pos.y);
        if(box != null){
          // 確定 
          // changePosition(gameData.selectedMeeple, box);
          // changeTurn();
          move(gameData.selectedMeeple, box);
          // ハイライトを消す
          gameData.movableBoxList = new ArrayList<Box>();
        }else{
          // 選択解除
          gameData.selectedMeeple = null;
          gameData.movableBoxList = new ArrayList<Box>(); 
        }
      }
    }
  }
}
void keyPressed(){
  if(gameData.status > 0){
    if(keyCode == ENTER){
      init();
    }
  }
}
void updateMeepleList(){
  for(int i=0; i<meepleList.size(); i++){
    Meeple meeple = meepleList.get(i);
    // 動いている途中なら
    if(meeple.status == 0){
      PVector toPosition = Logic.getWorldPosition(meeple.toX, meeple.toY);
      PVector diff = toPosition.get();
      diff.sub(meeple.worldPosition);
      diff.mult(0.15);
      PVector pos = meeple.worldPosition;
      pos.add(diff);
      meeple.worldPosition = pos;
      float distance = dist(pos.x, pos.y, toPosition.x, toPosition.y);
      if(distance < 1){
        Box targetBox = Logic.getBoxFromPosition(boxList, meeple.toX, meeple.toY);
        fixPosition(meeple, targetBox);
        changeTurn();
      }
    }
  }
}
void drawBoxList(){
  for(int i=0; i<boxList.size(); i++){
    Box box = boxList.get(i);
    PVector pos = Logic.getWorldPosition(box.x, box.y);
    strokeWeight(1);
    stroke(0);
    fill(255);
    rect(pos.x, pos.y, 50, 50);
    if(box.isGoal){
      strokeWeight(1);
      fill(255);
      rect(pos.x, pos.y, 30, 30);
    }
  }
}
void drawMeepleList(){
  for(int i=0; i<meepleList.size(); i++){
    Meeple meeple = meepleList.get(i);
    PVector pos = meeple.worldPosition;
    stroke(20);
    strokeWeight(1);
    if(gameData.playerId == meeple.playerId){
      strokeWeight(3); 
    }
    fill(0, 0, 200);
    if(meeple.playerId == 2){
      fill(200, 0, 0);
    }
    rect(pos.x, pos.y, 40, 40);
    if(meeple.isLeader){
      strokeWeight(2);
      stroke(255);
      rect(pos.x, pos.y, 30, 30); 
    }
  }
}
void drawMovable(){
  // 動かすことが可能な場所を取得
  ArrayList<Box> movableBoxList = gameData.movableBoxList;
  
  // ハイライト
  for(int i=0; i<movableBoxList.size(); i++){
    Box box = movableBoxList.get(i);
    PVector pos = Logic.getWorldPosition(box.x, box.y);
    fill(0, 0, 200, 50);
    if(gameData.selectedMeeple.playerId == 2){
      fill(200, 0, 0, 50); 
    }
    rect(pos.x, pos.y, 40, 40);
  }
}
void drawUI(){
  if(gameData.status == 0){
    fill(0);
    textSize(20);
    if(gameData.playerId == 1){
       text("Player 01", 50, height-50);
    }else{
      text("Player 02", width-50, height-50);
    }
  }
  if(gameData.status > 0){
    String message = "Player 01 Win!";
    if(gameData.status == 2){
      message = "Player 02 Win!";
    }
    noStroke();
    fill(0, 0, 0, 100);
    rect(width/2, height/2, width, height);
    fill(255);
    textSize(32);
    text(message, width/2, 50);
    
    text("Press Enter", width/2, height-50);
  }
}
void init(){
  gameData = new GameData();
  boxList = new ArrayList<Box>();
  meepleList = new ArrayList<Meeple>();
  // マス目を作る
  for(int x=0; x<5; x++){
    for(int y=0; y<5; y++){
      Box box = new Box();
      box.x = x;
      box.y = y;
      if(x == 2 && y == 2){
        box.isGoal = true;
      }
      boxList.add(box);
    }
  }
  // プレイヤー1のコマを作る
  for(int y=0; y<5; y++){
    Meeple meeple = new Meeple();
    meeple.playerId = 1;
    meeple.x = 0;
    meeple.y = y;
    if(y == 2){
      meeple.isLeader = true;
    }
    meeple.worldPosition = Logic.getWorldPosition(meeple.x, meeple.y);
    meepleList.add(meeple);
  }
  // プレイヤー2のコマを作る
  for(int y=0; y<5; y++){
    Meeple meeple = new Meeple();
    meeple.playerId = 2;
    meeple.x = 4;
    meeple.y = y;
    if(y == 2){
      meeple.isLeader = true;
    }
    meeple.worldPosition = Logic.getWorldPosition(meeple.x, meeple.y);
    meepleList.add(meeple);
  }
}
void move(Meeple meeple, Box box){
  meeple.toX = box.x;
  meeple.toY = box.y;
  meeple.worldPosition = Logic.getWorldPosition(meeple.x, meeple.y);
  meeple.status = 0;
}
void fixPosition(Meeple meeple, Box box){
  meeple.x = box.x;
  meeple.y = box.y;
  meeple.status = 1;
  meeple.worldPosition = Logic.getWorldPosition(box.x, box.y);
  if(box.isGoal){
    // 勝利！
    gameData.status = meeple.playerId;
  }
}
void changeTurn(){
  if(gameData.playerId == 1){
    gameData.playerId = 2;
  }else{
    gameData.playerId = 1; 
  }
  gameData.selectedMeeple = null;
  gameData.movableBoxList = new ArrayList<Box>();
}
static class Logic{
  public static PVector getWorldPosition(int x, int y){
    float _x = x * 50 + 60;
    float _y = y * 50 + 150;
    return new PVector(_x, _y);
  }
  public static Box getBoxFromPosition(ArrayList<Box> boxList, int x, int y){
    for(int i=0; i<boxList.size(); i++){
      Box box = boxList.get(i);
      if(box.x == x && box.y == y){
        return box;
      }
    }
    return null;
  }
  public static Meeple getMeepleFromPosition(ArrayList<Meeple> meepleList, int x, int y){
     for(int i=0; i<meepleList.size(); i++){
       Meeple meeple = meepleList.get(i);
       if(meeple.x == x && meeple.y == y){
         return meeple;
       }
     }
     return null;
  }
  public static PVector getPosition(PVector worldPosition){
     for(int x=0; x<5; x++){
       for(int y=0; y<5; y++){
         PVector pos = getWorldPosition(x, y);
         pos.sub(worldPosition);
         if(pos.mag() < 25){
           return new PVector(x, y);
         }
       }
     }
     return new PVector(-99, -99);
  }
  public static ArrayList<Box> getMovableBoxList(ArrayList<Box> boxList, ArrayList<Meeple> meepleList, Meeple meeple){
    ArrayList<Box> movableBoxList = new ArrayList<Box>();
    PVector[] directions = getDirections();
    for(int i=0; i<directions.length; i++){
      PVector dir = directions[i];
      ArrayList<Box> temp = new ArrayList<Box>();
      int index = 1;
      IrSearchMovableBoxList(temp, dir, index, boxList, meepleList, meeple);
      if(temp.size() > 0){
        Box targetBox = temp.get(0);
        if(targetBox.isGoal && !meeple.isLeader){
          continue;
        }
        movableBoxList.add(temp.get(0)); 
      }
    }
    // デバッグ用
    // movableBoxList.add(Logic.getBoxFromPosition(boxList, 2, 2));
    return movableBoxList;
  }
  // 再起処理
  static void IrSearchMovableBoxList(ArrayList<Box> resultList, PVector dir, int index, ArrayList<Box> boxList, ArrayList<Meeple> meepleList, Meeple baseMeeple){
    int x = baseMeeple.x;
    int y = baseMeeple.y;
    x += (int)dir.x * index;
    y += (int)dir.y * index;
    
    // 対象のBoxを探す
    Box targetBox = null;
    for(int i=0; i<boxList.size(); i++){
      Box box = boxList.get(i);
      if(box.x == x && box.y == y){
        targetBox = box;
        break;
      }
    }
    // マスからはみ出しているのでfalse
    if(targetBox == null){
      return;
    }
    
    // マスの上にコマが乗っていないか
    for(int i=0; i<meepleList.size(); i++){
      Meeple meeple = meepleList.get(i);
      if(meeple.x == x && meeple.y == y){
        return;
      }
    }
    
    // さらに奥を探索
    IrSearchMovableBoxList(resultList, dir, index + 1, boxList, meepleList, baseMeeple);
    if(resultList.size() == 0){
      resultList.add(targetBox); 
    }
  }
  static PVector[] getDirections(){
    PVector[] directions = new PVector[]{
      new PVector(0, 1), new PVector(1, 0), new PVector(0, -1), new PVector(-1, 0),
    };
    return directions;
  }
}
