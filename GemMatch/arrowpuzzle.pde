class Box{
  public int id;
  public int x;
  public int y;
}
class Panel{
  public int box_id;
  public int type;
  public int value;
  public PVector localPos;
}
// 手札
class Unit{
  public int index;
  public PVector pos;
  public ArrayList<Panel> panelList = new ArrayList<Panel>();
  public int status;
}
class GameData{
  public int score; 
}

class Deck{
  public ArrayList<Integer> directionList = new ArrayList<Integer>();
  public void initialize(){
    directionList = new ArrayList<Integer>();
    for(int i=0; i<10; i++){
      for(int direction=0; direction<4; direction++){
        directionList.add(direction);
      }
    }
    for(int i=0; i<999; i++){
      int from = (int)random(0, directionList.size());
      int to = (int)random(0, directionList.size());
      int temp = directionList.get(from);
      directionList.set(from, directionList.get(to));
      directionList.set(to, temp);
    }
  }
  public int pop(){
    if(directionList.size() == 0){
      initialize(); 
    }
    int v = directionList.get(0);
    directionList.remove(0);
    return v;
  }
}


ArrayList<Box> boxList = new ArrayList<Box>();
ArrayList<Panel> panelList = new ArrayList<Panel>();
ArrayList<Unit> unitList = new ArrayList<Unit>();
Unit selectedUnit;
ArrayList<Panel> roadList = new ArrayList<Panel>();
GameData gameData;
Deck deck;
Logic logic;
void setup(){
  size(320, 480);
  SpriteFinder.initialize(this, "");
  deck = new Deck();
  deck.initialize();
  rectMode(CENTER);
  imageMode(CENTER);
  init();
}
void draw(){
  background(255);
  
  // ユニットを動かす
  if(selectedUnit != null){
    selectedUnit.pos = new PVector(mouseX, mouseY - 50); 
  }
  
  // プレイヤーを動かす
  if(roadList.size() > 0 && frameCount % 20 == 0){
    Panel playerPanel = logic.getPlayerPanel(panelList);
    Box playerBox = logic.getBoxFromId(playerPanel.box_id, boxList);
    Panel nextPanel = roadList.get(0);
    Box nextBox = logic.getBoxFromId(nextPanel.box_id, boxList);
    PVector nextPosition = logic.toWorldPosition(nextBox.x, nextBox.y);
    playerPanel.box_id = nextBox.id;
    if(nextPanel.type == 3){
      // 新しくゴールを作る
      Panel newGoalPanel = logic.createGoalPanel(boxList, panelList);
      panelList.add(newGoalPanel);
    }
    roadList.remove(nextPanel);
    panelList.remove(nextPanel);
    gameData.score += 10;
  }
  
  // ボックス
  for(int i=0; i<boxList.size(); i++){
    Box box = boxList.get(i);
    PVector pos = logic.toWorldPosition(box.x, box.y);
    fill(200);
    rect(pos.x, pos.y, 50, 50);
  }
  
  // パネル
  for(int i=0; i<panelList.size(); i++){
    Panel panel = panelList.get(i);
    Box onBox = logic.getBoxFromId(panel.box_id, boxList);
    PVector pos = logic.toWorldPosition(onBox.x, onBox.y);
    renderPanel(panel, pos);
  }
  
  // ユニット
  for(int i=0; i<unitList.size(); i++){
    Unit unit = unitList.get(i);
    if(unit.status == 1){
      // 定位置へ
      PVector pos = unit.pos.get();
      PVector fixedPosition = logic.toUnitPosition(unit.index);
      PVector diff = new PVector(fixedPosition.x - pos.x, fixedPosition.y - pos.y);
      if(diff.mag() > 1){
        diff.mult(0.1);
        unit.pos.add(diff);
      }else{
        unit.pos = fixedPosition;
      }
    }
    renderUnit(unit);
  }
  
  // UI
  textSize(32);
  text(gameData.score, width/2, 30);
}
void grabUnit(Unit unit){
  unit.status = 11;
  selectedUnit = unit;
}
void releaseUnit(Unit unit){
  boolean canPut = true;
  for(int i=0; i<unit.panelList.size(); i++){
    Panel panel = unit.panelList.get(i);
    PVector pos = unit.pos.get();
    PVector localPos = panel.localPos.get();
    localPos.mult(50);
    pos.add(localPos);
    Box targetBox = logic.getBoxFromWorldPosition(pos, boxList);
    if(targetBox == null){
      canPut = false;
      break;
    }
    
    // 既に他のパネルがいないか確認する
    Panel currentPanel = logic.getPanelFromBoxId(targetBox.id, panelList);
    if(currentPanel != null){
      canPut = false;
      break;
    }
    
    // デッドパネルにならないか
    if(panel.type == 1){
      if(panel.value == 0 && targetBox.y == 0){
        canPut = false;
        break;
      }
      if(panel.value == 1 && targetBox.x == 4){
        canPut = false;
        break;
      }
      if(panel.value == 2 && targetBox.y == 4){
        canPut = false;
        break;
      }
      if(panel.value == 3 && targetBox.x == 0){
        canPut = false;
        break;
      }
    }
  }
  if(canPut){
    for(int i=0; i<unit.panelList.size(); i++){
      Panel panel = unit.panelList.get(i);
      PVector pos = unit.pos.get();
      PVector localPos = panel.localPos.get();
      localPos.mult(50);
      pos.add(localPos);
      Box targetBox = logic.getBoxFromWorldPosition(pos, boxList);
      putPanel(targetBox.id, panel);
    }
    int index = unit.index;
    unitList.remove(unit);
    // 新規に作る
    Unit newUnit = logic.createUnit(index, deck);
    unitList.add(newUnit);
  }
  if(!canPut){
    unit.status = 1; 
  }
  
  // 解放
  selectedUnit = null;
}
void putPanel(int box_id, Panel panel){
  panel.box_id = box_id;
  panelList.add(panel);
  
  checkRoad();
}

void checkRoad(){
  ArrayList<Panel> _roadList = logic.makeRoadPanelList(panelList, boxList);
  if(_roadList.size() > 0){
    // 道ができた状態
    roadList = _roadList;
  }
}


void mousePressed(){
  for(int i=0; i<unitList.size(); i++){
    Unit unit = unitList.get(i);
    if(unit.status == 1){
      float distance = dist(unit.pos.x, unit.pos.y, mouseX, mouseY);
      if(distance < 20){
        grabUnit(unit);
        break;
      }
    }
  }
}
void mouseReleased(){
  if(selectedUnit != null){
    // 設置する
    releaseUnit(selectedUnit);
  }
}
void renderUnit(Unit unit){
  for(int i=0; i<unit.panelList.size(); i++){
    Panel panel = unit.panelList.get(i);
    PVector pos = unit.pos.get();
    PVector localPos = panel.localPos.get();
    localPos.mult(50);
    pos.add(localPos);
    renderPanel(panel, pos);
  }
}
void renderPanel(Panel panel, PVector pos){
  fill(0);
  textSize(32);
  textAlign(CENTER, CENTER);
  String icon = "";
  if(panel.type == 1){
    if(panel.value == 0)  icon = "↑"; 
    if(panel.value == 1)  icon = "→"; 
    if(panel.value == 2)  icon = "↓"; 
    if(panel.value == 3)  icon = "←"; 
  }
  if(panel.type == 2){
    icon = "You";
    fill(255);
    textSize(18);
  }
  if(panel.type == 3){
    icon = "Goal"; 
    fill(100, 255, 200);
    textSize(18);
  }
  
  if(panel.type == 1 && false){
    pushMatrix();
    translate(pos.x, pos.y);
    if(panel.value == 1)  rotate(radians(90));
    if(panel.value == 2)  rotate(radians(90*2));
    if(panel.value == 3)  rotate(radians(90*3));
    
    PImage sprite = SpriteFinder.getSprite("arrow.png");
    if(frameCount / 60 % 2 == 1){
      sprite = SpriteFinder.getSprite("arrow_2.png");
    }
    image(sprite, 0, 0, 30, 30);
    popMatrix();
  }else{
    text(icon, pos.x, pos.y);
  }
}
void init(){
  logic = new Logic();
  gameData = new GameData();
  boxList = new ArrayList<Box>();
  panelList = new ArrayList<Panel>();
  unitList = new ArrayList<Unit>();
  for(int x=0; x<5; x++){
    for(int y=0; y<5; y++){
      Box box = new Box();
      box.id = y * 5 + x;
      box.x = x;
      box.y = y;
      boxList.add(box);
    }
  }
  
  // 初期ユニット
  for(int i=0; i<3; i++){
    Unit unit = logic.createUnit(i, deck);
    unit.pos = logic.toUnitPosition(i);
    unitList.add(unit);
  }
  
  // プレイヤー
  Panel playerPanel = new Panel();
  playerPanel.box_id = 0;
  playerPanel.type = 2;
  panelList.add(playerPanel);
  
  // ゴール
  Panel goalPanel = logic.createGoalPanel(boxList, panelList);
  panelList.add(goalPanel);
}
class Logic{
  public PVector toWorldPosition(int x, int y){
    float _x = x * 50 + 60;
    float _y = y * 50 + 100;
    return new PVector(_x, _y);
  }
  public PVector toUnitPosition(int index){
    float _x = index * 100 + 60;
    float _y = 400;
    return new PVector(_x, _y);
  }
  public Box getBoxFromId(int box_id, ArrayList<Box> boxList){
     for(int i=0; i<boxList.size(); i++){
       Box box = boxList.get(i);
       if(box.id == box_id){
         return box;
       }
     }
     return null;
  }
  public Box getBoxFromGrid(int x, int y, ArrayList<Box> boxList){
     for(int i=0; i<boxList.size(); i++){
       Box box = boxList.get(i);
       if(box.x == x && box.y == y){
         return box;
       }
     }
     return null;
  }
  public Box getBoxFromWorldPosition(PVector pos, ArrayList<Box> boxList){
    for(int i=0; i<boxList.size(); i++){
      Box box = boxList.get(i);
      PVector boxPosition = toWorldPosition(box.x, box.y);
      PVector diff = new PVector(boxPosition.x - pos.x, boxPosition.y - pos.y);
      if(diff.mag() < 10){
        return box;
      }
    }
    return null;
  }
  public Panel getPanelFromBoxId(int box_id, ArrayList<Panel> panelList){
     for(int i=0; i<panelList.size(); i++){
       Panel panel = panelList.get(i);
       if(panel.box_id == box_id){
         return panel;
       }
     }
     return null;
  }
  public Panel getPlayerPanel(ArrayList<Panel> panelList){
    for(int i=0; i<panelList.size(); i++){
      Panel panel = panelList.get(i);
      if(panel.type == 2){
        return panel;
      }
    }
    return null;
  }
  public Panel createGoalPanel(ArrayList<Box> boxList, ArrayList<Panel> panelList){
    Panel panel = new Panel();
    panel.type = 3;
    for(int i=0; i<999; i++){
      int r = (int)random(0, boxList.size());
      Box targetBox = boxList.get(r);
      Panel currentPanel = getPanelFromBoxId(targetBox.id, panelList);
      if(currentPanel == null){
        panel.box_id = targetBox.id;
        return panel;
      }
    }
    return null;
  }
  public Unit createUnit(int index, Deck deck){
    Unit unit = new Unit();
    unit.index = index;
    unit.pos = new PVector(width/2, height);
    unit.status = 1;
    
    if(true){
      Panel panel = new Panel();
      panel.type = 1;
      panel.value = deck.pop();
      panel.localPos = new PVector(0, 0);
      unit.panelList.add(panel);
    }
    
    return unit;
  }
  public ArrayList<Panel> makeRoadPanelList(ArrayList<Panel> panelList, ArrayList<Box> boxList){
    ArrayList<Panel> roadList = new ArrayList<Panel>();
    Panel playerPanel = null;
    Panel goalPanel = null;
    for(int i=0; i<panelList.size(); i++){
      Panel panel = panelList.get(i);
      if(panel.type == 2)  playerPanel = panel;
      if(panel.type == 3)  goalPanel = panel;
    }
    
    // TODO プレイヤーから全方向調べる
    Box playerBox = getBoxFromId(playerPanel.box_id, boxList);
    for(int i=0; i<4; i++){
      int x = playerBox.x;
      int y = playerBox.y;
      if(i == 0)  y -= 1;
      if(i == 1)  x += 1;
      if(i == 2)  y += 1;
      if(i == 3)  x -= 1;
      
      Box nextBox = getBoxFromGrid(x, y, boxList);
      if(nextBox == null){
        continue;
      }
      Panel nextPanel = getPanelFromBoxId(nextBox.id, panelList);
      if(nextPanel == null || nextPanel.type != 1){
        continue;
      }
      ArrayList<Panel> tempRoadList = new ArrayList<Panel>();
      tempRoadList.add(nextPanel);
      IrRoad(tempRoadList, panelList, boxList, nextPanel, goalPanel, 0);
      // チェック。長い方をとる
      if(tempRoadList.size() > 0 && tempRoadList.size() > roadList.size()){
        // ゴールまでの道筋
        roadList = tempRoadList;
      }
    }
    return roadList;
  }
  void IrRoad(ArrayList<Panel> roadList, ArrayList<Panel> panelList, ArrayList<Box> boxList, Panel basePanel, Panel goalPanel, int count_index){
    if(count_index > 999){
      // 無限ループ防止の保険として
      roadList.clear();
      return; 
    }
    
    Box baseBox = getBoxFromId(basePanel.box_id, boxList);
    int x = baseBox.x;
    int y = baseBox.y;
    if(basePanel.value == 0)  y -= 1;
    if(basePanel.value == 1)  x += 1;
    if(basePanel.value == 2)  y += 1;
    if(basePanel.value == 3)  x -= 1;
    Box nextBox = getBoxFromGrid(x, y, boxList);
    if(nextBox == null){
      // 次がないので破棄
      roadList.clear();
      return; 
    }
    
    Panel nextPanel = getPanelFromBoxId(nextBox.id, panelList);
    if(nextPanel == null){
      // 次がないので破棄
      roadList.clear();
      return; 
    }
    
    if(nextPanel.type == 2){
      // プレイヤーなのでなし
      roadList.clear();
      return;
    }
    
    boolean hasPassed = false;
    for(int i=0; i<roadList.size(); i++){
      if(nextPanel == roadList.get(i)){
        // もう通った
        hasPassed = true;
        break;
      }
    }
    if(hasPassed){
      roadList.clear();
      return;
    }
    
    if(nextPanel == goalPanel){
      // ゴールにたどり着いたのでOK
      roadList.add(nextPanel);
      return;
    }
    
    if(nextPanel.type == 1){
      // 道だったのでもう一度
      roadList.add(nextPanel);
      IrRoad(roadList, panelList, boxList, nextPanel, goalPanel, count_index+1);
    }
  }
}
static class SpriteFinder{
  static PApplet app;
  static String basePath;
  static String[] pathList;
  static PImage[] imageList;
  static int index = 0;
  public static void initialize(PApplet _app, String _basePath){
    app = _app;
    basePath = _basePath;
    pathList = new String[100];
    imageList = new PImage[100];
  }
  public static PImage getSprite(String path){
    for(int i=0; i<pathList.length; i++){
      if(pathList[i] == path){
        return imageList[i]; 
      }
    }
    PImage sprite = app.loadImage(basePath + path);
    pathList[index] = path;
    imageList[index] = sprite;
    index += 1;
    return sprite;
  }
}
