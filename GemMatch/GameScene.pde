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
