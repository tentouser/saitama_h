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
