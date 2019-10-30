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
