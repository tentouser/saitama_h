IState state;
GameData gameData;
void setup(){
  size(320, 480);
  rectMode(CENTER);
  textFont(createFont("Arial", 32));
  gameData = createGameData();
  setState(new NormalState());
}
void draw(){
  background(255);
  IState newState = state.update();
  if(newState != null){
    setState(newState);
  }
  renderBoxList(gameData.boxList);
  renderStoneList(gameData.stoneList);
  updateUnitList(gameData.unitList);
  renderUI();
}

void mousePressed(){
  Unit unit = gameData.unitList.get(0);
  unit.status = 1;
}
void mouseReleased(){
  Unit unit = gameData.unitList.get(0);
  PVector gridPosition = Logic.worldToGridPosition(unit.pos);
  Box targetBox = Logic.findBox(gameData.boxList, (int)gridPosition.x, (int)gridPosition.y);
  Stone targetStone = Logic.findStone(gameData.stoneList, (int)gridPosition.x, (int)gridPosition.y);
  if(targetBox != null && targetStone == null){
    Stone stone = new Stone();
    stone.x = targetBox.x;
    stone.y = targetBox.y;
    stone.type = unit.type;
    
    gameData.stoneList.add(stone);
    unit.status = 99;
    ChainState chainState = new ChainState();
    chainState.stone = stone;
    setState(chainState);
  }else{
    unit.status = 0; 
  }
}

class ClearState implements IState{
  public void enter(){
  }
  public IState update(){
    return null;
  }
}
class ChainState implements IState{
  public Stone stone;
  ArrayList<Stone> chainList;
  float time;
  public void enter(){
    cacheChainList();
  }
  public IState update(){
    time += 1;
    if(chainList.size() < Logic.getNeedChainCount(stone.type)){
      gameData.unitList.remove(0);
      return new NormalState();
    }
    if(time > 30){
      if(chainList.size() >= Logic.getNeedChainCount(stone.type)){
         merge(chainList, stone);
         cacheChainList();
         time = 0;
         
         if(stone.type == gameData.stageData.goal){
           return new ClearState();
         }
      }
    }
    return null;
  }
  void cacheChainList(){
    ArrayList<Stone> chainList = Logic.getChainList(gameData.stoneList, stone);
    this.chainList = chainList;
  }
  void merge(ArrayList<Stone> chainList, Stone baseStone){
    for(int i=0; i<chainList.size(); i++){
      gameData.stoneList.remove(chainList.get(i));
    }
    baseStone.type += 1;
    gameData.stoneList.add(baseStone);
    this.stone = baseStone;
  }
}
class NormalState implements IState{
  public void enter(){
  }
  public IState update(){
    return null;
  }
}

interface IState{
  void enter();
  IState update();
}

void setState(IState s){
  state = s;
  state.enter();
}

void renderUI(){
  String goal = Logic.typeToMoneyString(gameData.stageData.goal) + "円";
  fill(0);
  textSize(32);
  textAlign(CENTER, CENTER);
  text(goal + "を作れ", width/2, 30); 
  
  if(state instanceof ClearState){
    fill(0);
    textSize(64);
    text("CLEAR", width/2, height-100);
  }
}

void updateUnitList(ArrayList<Unit> unitList){
  Unit unit = unitList.get(0);
  if(unit.status == 0){
    PVector defaultPosition = new PVector(width/2, height-100);
    PVector diff = defaultPosition.get();
    diff.sub(unit.pos);
    diff.mult(0.1);
    PVector pos = unit.pos.get();
    pos.add(diff);
    unit.pos = pos;
  }
  if(unit.status == 1){
    PVector targetPosition = new PVector(mouseX, mouseY - 50);
    unit.pos = targetPosition;
  }
  if(unit.status == 99){
    return;
  }
  PVector pos = unit.pos.get();
  renderStone(pos.x, pos.y, unit.type);
}
void renderBoxList(ArrayList<Box> boxList){
  for(int i=0; i<boxList.size(); i++){
    Box box = boxList.get(i);
    PVector pos = Logic.gridToWorldPosition(box.x, box.y);
    fill(255);
    rect(pos.x, pos.y, 50, 50);
  }
}
void renderStoneList(ArrayList<Stone> stoneList){
  for(int i=0; i<stoneList.size(); i++){
    Stone stone = stoneList.get(i);
    PVector pos = Logic.gridToWorldPosition(stone.x, stone.y);
    renderStone(pos.x, pos.y, stone.type);
  }
}
void renderStone(float x, float y, int type){
  String money = Logic.typeToMoneyString(type);
  fill(255);
  ellipse(x, y, 40, 40);
  textAlign(CENTER, CENTER);
  fill(0);
  textSize(12);
  text(money, x, y);
}

GameData createGameData(){
  int stageLevel = 1;
  if(gameData != null){
    stageLevel = gameData.stageData.stageLevel + 1;
  }
  GameData gameData = new GameData();
  StageData stageData = createStageData(stageLevel);
  gameData.stageData = stageData;
  gameData.boxList = createBoxList();
  gameData.stoneList = createStoneList(stageData);
  gameData.unitList = createUnitList(stageData);
  return gameData;
}
StageData createStageData(int stageLevel){
  StageData stageData = new StageData();
  stageData.stageLevel = stageLevel;
  stageData.seed = stageLevel;
  stageData.goal = (int)random(2, 10);
  stageData.difficultyUnit = (int)random(1, 100);
  stageData.difficultyMap = (int)random(1, 100);
  return stageData;
}
ArrayList<Box> createBoxList(){
  ArrayList<Box> list = new ArrayList<Box>();
  for(int x=0; x<5; x++){
    for(int y=0; y<5; y++){
      Box box = new Box();
      box.x = x;
      box.y = y;
      box.status = 0;
      list.add(box);
    }
  }
  return list;
}

ArrayList<Stone> createStoneList(StageData stageData){
  ArrayList<Stone> list = new ArrayList<Stone>();
  int goal = stageData.goal;
  if(true){
    Stone stone = new Stone();
    stone.x = (int)random(0, 5);
    stone.y = (int)random(0, 5);
    stone.type = goal - 1;
    list.add(stone);
  }
  return list;
}
ArrayList<Unit> createUnitList(StageData stageData){
  ArrayList<Unit> list = new ArrayList<Unit>();
  int goal = stageData.goal;
  int max = goal - 3;
  if(max < 1)  max = 1;
  for(int i=0; i<999; i++){
    Unit unit = new Unit();
    unit.type = (int)random(1, max + 1);
    unit.pos = new PVector(width/2, height + 100);
    list.add(unit);
  }
  return list;
}

static class Logic{
  public static Box findBox(ArrayList<Box> boxList, int x, int y){
    for(int i=0; i<boxList.size(); i++){
      Box box = boxList.get(i);
      if(box.x == x && box.y == y){
        return box;
      }
    }
    return null;
  }
  public static Stone findStone(ArrayList<Stone> stoneList, int x, int y){
    for(int i=0; i<stoneList.size(); i++){
      Stone stone = stoneList.get(i);
      if(stone.x == x && stone.y == y){
        return stone;
      }
    }
    return null;
  }
  public static int getNeedChainCount(int type){
    if(type % 2 == 0)  return 2;
    return 5;
  }
  public static String typeToMoneyString(int type){
    if(type == 1)  return "1";
    if(type == 2)  return "5";
    if(type == 3)  return "10";
    if(type == 4)  return "50";
    if(type == 5)  return "100";
    if(type == 6)  return "500";
    if(type == 7)  return "1000";
    if(type == 8)  return "5000";
    if(type == 9)  return "10000";
    return "0";
  }
  public static PVector worldToGridPosition(PVector pos){
    for(int i=0; i<100; i++){
      int x = i % 10;
      int y = i / 10;
      PVector worldPosition = gridToWorldPosition(x, y);
      worldPosition.sub(pos);
      if(worldPosition.mag() < 20){
        return new PVector(x, y); 
      }
    }
    return new PVector(-99, -99);
  }
  public static PVector gridToWorldPosition(int x, int y){
    return new PVector(x * 50 + 60, y * 50 + 100); 
  }
  
  public static ArrayList<Stone> getChainList(ArrayList<Stone> stoneList, Stone baseStone){
    ArrayList<Stone> chainList = new ArrayList<Stone>();
    chainList.add(baseStone);
    IrChain(chainList, stoneList, baseStone, 0);
    return chainList;
  }
  static void IrChain(ArrayList<Stone> chainList, ArrayList<Stone> stoneList, Stone baseStone, int index){
    if(index > 100){
      return;
    }
    PVector[] directions = new PVector[]{
      new PVector(0, 1), new PVector(1, 0), new PVector(0, -1), new PVector(-1, 0)
    };
    for(int i=0; i<directions.length; i++){
      int x = baseStone.x + (int)directions[i].x;
      int y = baseStone.y + (int)directions[i].y;
      Stone targetStone = Logic.findStone(stoneList, x, y);
      if(targetStone != null && targetStone.type == baseStone.type){
        boolean hasStone = chainList.contains(targetStone);
        if(!hasStone){
          chainList.add(targetStone);
          IrChain(chainList, stoneList, targetStone, index+1);
        }
      }
    }
  }
}

class Box{
  public int x;
  public int y;
  public int status; 
}
class Stone{
  public int x;
  public int y;
  public int type;
}
class Unit{
  public int type;
  public PVector pos;
  public int status;
}
class StageData{
  public int stageLevel;
  public int seed;
  public int goal;
  public int difficultyUnit;
  public int difficultyMap;
}
class GameData{
  public StageData stageData;
  public ArrayList<Box> boxList = new ArrayList<Box>();
  public ArrayList<Stone> stoneList = new ArrayList<Stone>();
  public ArrayList<Unit> unitList = new ArrayList<Unit>();
}
