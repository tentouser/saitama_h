class Box{
  public int x;
  public int y;
}
class Gem{
  public int x;
  public int y;
  public int toX;
  public int toY;
  public PVector pos;
  public int type;
  public int status;
  public int attack;
}
static class PlayerData{
  public static int redLevel = 1;
  public static int greenLevel = 1;
  public static int blueLevel = 1;
  public static int yellowLevel = 1;
  public static int waterLevel = 1;
  public static int gold = 100;
  public static int stageLevel = 1;
}
interface Scene{
  void enter();
  Scene update();
}
static class Logic{
  public static int WIDTH = 7;
  public static int HEIGHT = 7;
  public static int TIMELIMIT = 10;
  public static boolean click;
  public static PVector getWorldPosition(int x, int y){
    int _x = x * 40 + 40;
    int _y = y * 40 + 180;
    return new PVector(_x, _y);
  }
  public static int makeAttachScore(ArrayList<Gem> chainList){
    if(chainList.size() < 3){
      return 0;
    }
    int score = 0;
    for(int i=0; i<chainList.size(); i++){
      Gem gem = chainList.get(i);
      score += gem.attack;
    }
    return score;
  }
  public static ArrayList<Gem> getChainList(ArrayList<Gem> gemList, Gem baseGem){
    ArrayList<Gem> chainList = new ArrayList<Gem>();
    chainList.add(baseGem);
    IRChainGem(chainList, gemList, baseGem, 0);
    return chainList;
  }
  public static boolean isExistGem(ArrayList<Gem> gemList, Gem targetGem){
    for(int i=0; i< gemList.size(); i++){
      Gem gem = gemList.get(i);
      if(gem == targetGem){
        return true;
      }
    }
    return false;
  }
  public static Gem getGemFromPosition(ArrayList<Gem> gemList, int x, int y){
    for(int i=0; i<gemList.size(); i++){
      Gem gem = gemList.get(i);
      if(gem.x == x && gem.y == y){
        return gem;
      }
    }
    return null;
  }
  public static Gem getGemFromWroldPosition(ArrayList<Gem> gemList, PVector pos){
     for(int i=0; i<gemList.size(); i++){
       // クリックした物を取得
       Gem gem = gemList.get(i);
       float distance = dist(gem.pos.x, gem.pos.y, pos.x, pos.y);
       if(distance < 20){
         return gem;
       }
     }
     return null;
  }
  public static PVector getDownToPosition(ArrayList<Gem> gemList, Gem gem){
    int x = gem.x;
    int y = gem.y;
    int downCount = 0;
    for(int i=0; i<Logic.HEIGHT; i++){
      int _y = i;
      if(_y > y){
        continue;
      }
      Gem targetGem = getGemFromPosition(gemList, x, _y);
      if(targetGem == null){
        downCount += 1;
      }
    }
    return new PVector(x, y - downCount);
  }
  public static int getLevel(int type){
    if(type == 1)  return PlayerData.redLevel;
    if(type == 2)  return PlayerData.greenLevel;
    if(type == 3)  return PlayerData.blueLevel;
    if(type == 4)  return PlayerData.yellowLevel;
    if(type == 5)  return PlayerData.waterLevel;
    return 0;
  }
  public static int getNeedGold(int nextLevel){
    return (int)pow(nextLevel, 1.2) * 10; 
  }
  public static int getNeedScore(int stageLevel){
    return stageLevel * 2 * 10; 
  }
  static void IRChainGem(ArrayList<Gem> chainList, ArrayList<Gem> gemListAll, Gem gem, int index){
    if(index > 100){
      return ;
    }
    PVector[] directions = new PVector[]{
      new PVector(0, 1), new PVector(1, 0), new PVector(0, -1), new PVector(-1, 0)
    };
    for(int i=0; i<directions.length; i++){
      PVector direction = directions[i];
      int x = gem.x + (int)direction.x;
      int y = gem.y + (int)direction.y;
      Gem targetGem = getGemFromPosition(gemListAll, x, y);
      if(targetGem != null && targetGem.type == gem.type && gem.status == 1){
         if(!isExistGem(chainList, targetGem)){
           chainList.add(targetGem);
           IRChainGem(chainList, gemListAll, targetGem, index + 1);
         }
      }
    }
  }
}
Scene scene;
void setup(){
  size(320, 480);
  changeScene(new GameScene());
}
void draw(){
  Scene newScene = scene.update();
  if(newScene != null){
    changeScene(newScene);
  }
}
void mousePressed(){
  Logic.click = true; 
}
void mouseReleased(){
  Logic.click = false;
}
void changeScene(Scene s){
  scene = s;
  scene.enter();
}


class GameScene implements Scene{
  ArrayList<Box> boxList = new ArrayList();
  ArrayList<Gem> gemList = new ArrayList();
  public int score;
  public float time;
  public int status = 1;
  public void enter(){
    rectMode(CENTER);
    init();
  }
  public Scene update(){
    background(255);
    if(status == 1){
      time += 1;
      if(getTime() >= Logic.TIMELIMIT){
        status = 0;
        time = 0;
      }
    }
    updateGemList();
    renderBoxList();
    renderGemList();
    renderUI();
    if(status == 0){
      fill(0, 0, 0, 100);
      rect(0 + width/2, 0 + height/2, width, height);
      if(score >= Logic.getNeedScore(PlayerData.stageLevel)){
        fill(255);
        text("CLEAR!", width/2, height/2);
      }else{
        fill(255);
        text("FAILED...", width/2, height/2);    
      }
      time += 1;
      if(Logic.click && time > 60){
        PlayerData.gold = (int)(score);
        if(score >= Logic.getNeedScore(PlayerData.stageLevel)){
          PlayerData.stageLevel += 1; 
        }
        return new LevelScene(); 
      }
    }
    

    return null; 
  }
  void updateGemList(){
    if(Logic.click && status == 1){
      PVector mousePos = new PVector(mouseX, mouseY);
      Gem tapGem = Logic.getGemFromWroldPosition(gemList, mousePos);
      if(tapGem != null && tapGem.status == 1){
         ArrayList<Gem> chainGemList = Logic.getChainList(gemList, tapGem);
         int attachScore = Logic.makeAttachScore(chainGemList);
         score += attachScore;
         for(int i=0; i<chainGemList.size(); i++){
            Gem chainedGem = chainGemList.get(i);
            gemList.remove(chainedGem);
         }
         
         // 新しいGEMを作る
         createNewGems();
         Logic.click = false;
      }
    }
    
    // 移動させる
    for(int i=0; i<gemList.size(); i++){
      Gem gem = gemList.get(i);
      if(gem.status == 0){
        int toX = gem.toX;
        int toY = gem.toY;
        PVector targetPosition = Logic.getWorldPosition(toX, toY);
        PVector temp = targetPosition.get();
        temp.sub(gem.pos);
        
        if(temp.mag() < 10){
          // 到着
          gem.x = toX;
          gem.y = toY;
          gem.pos = targetPosition;
          gem.status = 1;
        }else{
          temp.mult(0.1);
          gem.pos.add(temp);
        }
      }
      
    }
  }

  void renderBoxList(){
    for(int i=0; i<boxList.size(); i++){
      Box box = boxList.get(i);
      PVector pos = Logic.getWorldPosition(box.x, box.y);
      fill(255);
      rect(pos.x, pos.y, 40, 40);
    }
  }
  void renderGemList(){
    for(int i=0; i<gemList.size(); i++){
      Gem gem = gemList.get(i);
      fill(getColor(gem.type));
      ellipse(gem.pos.x, gem.pos.y, 30, 30);
    }
  }
  void renderUI(){
    textAlign(CENTER);
    textSize(32);
    fill(10, 10, 10);
    text(score, width/2, 130);
    
    text("STAGE " + PlayerData.stageLevel, width/2, 50);
    textSize(12);
    text("NEED " + Logic.getNeedScore(PlayerData.stageLevel), width/2, 70);
    
    textSize(24);
    text(Logic.TIMELIMIT - getTime(), 300, 50);
  }
  int getTime(){
    int _time = (int)(time / 60); 
    if(_time < 0)  return 0;
    return _time;
  }
  color getColor(int type){
    if(type == 1)  return color(255, 0, 0);
    if(type == 2)  return color(0, 255, 0);
    if(type == 3)  return color(0, 0, 255);
    if(type == 4)  return color(255, 255, 0);
    if(type == 5)  return color(0, 255, 255);
    return color(0);
  }
  void createNewGems(){
    for(int x=0; x<Logic.WIDTH; x++){
      int count = 0;
      for(int y=0; y<Logic.HEIGHT; y++){
        Gem gem = Logic.getGemFromPosition(gemList, x, y);
        if(gem == null){
          count += 1;
          // 新しく作る
          gem = createGem(x, Logic.HEIGHT + count - 1);
          gem.status = 0;
          gemList.add(gem);
        }
      }
      
      for(int i=0; i<Logic.HEIGHT * 2; i++){
        Gem gem = Logic.getGemFromPosition(gemList, x, i);
        if(gem == null){
          continue;
        }
        PVector nextPosition = Logic.getDownToPosition(gemList, gem);
        gem.status = 0;
        gem.toX = (int)nextPosition.x;
        gem.toY = (int)nextPosition.y;
      }
    }
  }
  void init(){
    boxList.clear();
    gemList.clear();
    for(int x=0; x<Logic.WIDTH; x++){
      for(int y=0; y<Logic.HEIGHT; y++){
        Box box = new Box();
        box.x = x;
        box.y = y;
        boxList.add(box);
        
        Gem gem = createGem(x, y);
        gem.status = 1;
        gemList.add(gem);
      }
    }
  }
  Gem createGem(int x, int y){
    Gem gem = new Gem();
    gem.x = x;
    gem.y = y;
    gem.pos = Logic.getWorldPosition(x, y);
    gem.type = (int)random(1, 6);
    gem.attack = 1;
    if(gem.type == 1)  gem.attack = PlayerData.redLevel;
    if(gem.type == 2)  gem.attack = PlayerData.greenLevel;
    if(gem.type == 3)  gem.attack = PlayerData.blueLevel;
    if(gem.type == 4)  gem.attack = PlayerData.yellowLevel;
    if(gem.type == 5)  gem.attack = PlayerData.waterLevel;
    return gem;
  }
}

class LevelScene implements Scene{
  public void enter(){
    textAlign(CENTER, CENTER);
  }
  public Scene update(){
    background(255);
    textSize(32);
    fill(0);
    text(PlayerData.gold + " GOLD", width/2, 20);
    for(int i=1; i<=5; i++){
       float x = width/2;
       float y = i * 80;
       if(Logic.click){
          float distance = dist(x, y, mouseX, mouseY);
          if(distance < 40){
            if(i == 1){
              if(PlayerData.gold >= Logic.getNeedGold(PlayerData.redLevel + 1)){
                PlayerData.gold -= Logic.getNeedGold(PlayerData.redLevel + 1);
                PlayerData.redLevel += 1;
              }else{
                return new GameScene(); 
              }
            }
            if(i == 2){
              if(PlayerData.gold >= Logic.getNeedGold(PlayerData.greenLevel + 1)){
                PlayerData.gold -= Logic.getNeedGold(PlayerData.greenLevel + 1);
                PlayerData.greenLevel += 1;
              }else{
                return new GameScene(); 
              }              PlayerData.greenLevel += 1;
            }
            if(i == 3){
              if(PlayerData.gold >= Logic.getNeedGold(PlayerData.blueLevel + 1)){
                PlayerData.gold -= Logic.getNeedGold(PlayerData.blueLevel + 1);
                PlayerData.blueLevel += 1;
              }else{
                return new GameScene(); 
              }   
            }
            if(i == 4){
              if(PlayerData.gold >= Logic.getNeedGold(PlayerData.yellowLevel + 1)){
                PlayerData.gold -= Logic.getNeedGold(PlayerData.yellowLevel + 1);
                PlayerData.yellowLevel += 1;
              }else{
                return new GameScene(); 
              }   
            }
            if(i == 5){
              if(PlayerData.gold >= Logic.getNeedGold(PlayerData.waterLevel + 1)){
                PlayerData.gold -= Logic.getNeedGold(PlayerData.waterLevel + 1);
                PlayerData.waterLevel += 1;
              }else{
                return new GameScene(); 
              }   
            }
            Logic.click = false; 
          }
       }
       fill(getColor(i));
       ellipse(x, y, 50, 50);
       
       textSize(12);
       fill(0);
       text("Lv." + Logic.getLevel(i), x, y);
       
       fill(0);
       text(Logic.getNeedGold(Logic.getLevel(i) + 1) + " GOLD", x, y + 35);
    }
    return null;
  }
  color getColor(int type){
    if(type == 1)  return color(255, 0, 0);
    if(type == 2)  return color(0, 255, 0);
    if(type == 3)  return color(0, 0, 255);
    if(type == 4)  return color(255, 255, 0);
    if(type == 5)  return color(0, 255, 255);
    return color(0);
  }
}
