class Item{
  public int x;
  public int y;
  public String str;
  public PVector pos;
}
class Grid{
  public ArrayList<Item> itemList;
  public String makeMessage(int hour, int minutes){
    int _h = hour;
    String message = "";
    message += "IT IS ";
    if(minutes <= 4){
      message += "";
    }else if(minutes <= 9){
      message += "FIVe PAST ";
    }else if(minutes <= 14){
      message += "TEn PAST ";
    }else if(minutes <= 19){
      message += "QUARTER PAST "; 
    }else if(minutes <= 24){
      message += "TWENTY PAST ";
    }else if(minutes <= 29){
      message += "TWENTYFIVe PAST ";
    }else if(minutes <= 34){
      message += "HALF PAST ";
    }else if(minutes <= 39){
      message += "TWENTYFIVe TO ";
    }else if(minutes <= 44){
      message += "TWENTY TO ";
    }else if(minutes <= 49){
      message += "QUARTER TO ";
    }else if(minutes <= 54){
      message += "TEn TO ";
    }else if(minutes <= 59){
      message += "FIVe TO ";
    }
    
    if(minutes >= 35){
      _h = hour + 1;
      _h = _h % 12;
    }
    if(_h == 0)  message += "TWELVE ";
    if(_h == 1)  message += "ONE ";
    if(_h == 2)  message += "TWO ";
    if(_h == 3)  message += "THREE ";
    if(_h == 4)  message += "FOUR ";
    if(_h == 5)  message += "FIVE ";
    if(_h == 6)  message += "SIX ";
    if(_h == 7)  message += "SEVEN ";
    if(_h == 8)  message += "EIGHT ";
    if(_h == 9)  message += "NINE ";
    if(_h == 10)  message += "TEN ";
    if(_h == 11)  message += "ELEVEN ";

    message += "_CLOCK";
    return message;
  }
  public void createItemList(){
    itemList = new ArrayList<Item>();
    String mes = getBaseString();
    for(int y=0; y<10; y++){
      for(int x=0; x<11; x++){
        int index = y * 11 + x;
        String s = mes.substring(index, index+1);
        PVector pos = getPos(x, y);
        Item item = new Item();
        item.x = x;
        item.y = y;
        item.str = s;
        item.pos = getPos(x, y);
        if(s.equals("_")){
          item.pos.x += 5; 
        }
        itemList.add(item);
      }
    }
  }
  public ArrayList<Item> findItemListFromMessage(String message){
    ArrayList<Item> resultList = new ArrayList<Item>();
    ArrayList<String> targetList = splitMessage(message);
    for(int i=0; i<targetList.size(); i++){
      String target = targetList.get(i);
      ArrayList<Item> findList = findItemListFromTarget(target);
      for(int j=0; j<findList.size(); j++){
        resultList.add(findList.get(j));
      }
    }
    return resultList;
  }
  ArrayList<Item> findItemListFromTarget(String target){
    ArrayList<Item> resultList = new ArrayList<Item>();
    for(int i=0; i<itemList.size(); i++){
      // 特殊処理
      if(target.equals("FIVE")){
        if(i < 50) continue; 
      }
      for(int j=0; j<target.length(); j++){
         int index = i + j;
         Item item = itemList.get(index);
         String s = target.substring(j, j+1);
         if(item.str.equals(s)){
           resultList.add(item); 
         }else{
           resultList = new ArrayList<Item>();
           break;
         }
         if(resultList.size() == target.length()){
           return resultList;
         }
      }
    }
    return resultList;
  }
  ArrayList<String> splitMessage(String message){
    ArrayList<String> targetList = new ArrayList<String>();
    String temp = "";
    for(int i=0; i<message.length(); i++){
      String s = message.substring(i, i+1);
      if(s.equals(" ")){
        targetList.add(temp);
        temp = "";
      }else if(i == message.length() - 1){
        temp += s;
        targetList.add(temp);
      }else{
        temp += s; 
      }
    }
    return targetList;
  }
  PVector getPos(int x, int y){
    return new PVector(x * 40 + 100, y * 40 + 120); 
  }
  String getBaseString(){
    String mes = "";
    mes += "ITLISASAMPM";
    mes += "ACQUARTERDC";
    mes += "TWENTYFIVeX";
    mes += "HALFSTEnFTO";
    mes += "PASTERUNINE";
    mes += "ONESIXTHREE";
    mes += "FOURFIVETWO";
    mes += "EIGHTELEVEN";
    mes += "SEVENTWELVE";
    mes += "TENSE_CLOCK";
    return mes;
  }
}
Grid grid;
int sec = 0;
void setup(){
  size(600, 600);
  grid = new Grid();
  grid.createItemList();
}
void draw(){
  background(0);
  
  textAlign(CENTER, CENTER);
  textSize(32);
  for(int i=0; i<grid.itemList.size(); i++){
    Item item = grid.itemList.get(i);
    String s = makeString(item.str);
    fill(#333333);
    text(s, item.pos.x, item.pos.y);
  }
  
  int hour = hour();
  int minutes = minute();
  
  // sec += 10;
  // hour = (int)(sec / 3600) % 24;
  // minutes = (int)(sec / 60) % 60;

  String message = grid.makeMessage(hour, minutes);
  ArrayList<Item> findList = grid.findItemListFromMessage(message);
  for(int i=0; i<findList.size(); i++){
    Item item = findList.get(i);
    String s = makeString(item.str);
    fill(#FFFFFF);
    text(s, item.pos.x, item.pos.y);
  }
  
  for(int i=0; i<4; i++){
    float x = i % 2 * 500 + 50;
    float y = (int)(i / 2) * 500 + 50;
    fill(#333333);
    if(i == 0){
      if(minutes % 5 > 0)  fill(#FFFFFF);
    }
    if(i == 1){
      if(minutes % 5 > 1)  fill(#FFFFFF);
    }
    if(i == 2){
      if(minutes % 5 > 3)  fill(#FFFFFF);
    }
    if(i == 3){
      if(minutes % 5 > 2)  fill(#FFFFFF); 
    }
    rect(x, y, 5, 5);
  }
}
String makeString(String str){
  String s = str;
  if(s.equals("_")) s = "O'";
  if(s.equals("e")) s = "E";
  if(s.equals("n")) s = "N";
  return s;
}
