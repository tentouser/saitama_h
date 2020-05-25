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
    println(index);
    return sprite;
  }
}

/*
@pjs preload="Gu.png, 
Ch.png,
Pa.png
";
*/
class Card{
  public int playerId;
  public int type;
  public int strength;
}
class BackDeck{
  public ArrayList<Card> cardList = new ArrayList<Card>();
}
class HandDeck{
  public Card[] cards = new Card[3]; 
}
class GameData{
  public int playMode;
  public BackDeck player01Deck;
  public BackDeck player02Deck;
  public HandDeck player01Hand;
  public HandDeck player02Hand;
  public int player01Hp;
  public int player02Hp;
}
class PlayerData{
  public int playCount;
  public int winCount;
  public int loseCount;
  public int drawCount;
}
interface IState{
  void enter();
  IState update();
}
class SelectState implements IState{
  public Card playerCard;
  public Card enemyCard;
  int time;
  public void enter(){
    BackDeck player01Deck = gameData.player01Deck;
    BackDeck player02Deck = gameData.player02Deck;
    HandDeck player01Hand = gameData.player01Hand;
    HandDeck player02Hand = gameData.player02Hand;
    
    for(int i=0; i<3; i++){
      if(player01Hand.cards[i] == null){
        player01Hand.cards[i] = logic.getAndRemoveCard(player01Deck.cardList);
      }
    }
    for(int i=0; i<3; i++){
      if(player02Hand.cards[i] == null){
        player02Hand.cards[i] = logic.getAndRemoveCard(player02Deck.cardList);
      }
    }
  }
  public IState update(){
    if(playerCard != null){
      if(gameData.playMode == 1){
        time += 1;
        if(time >= 300){
          DecideState s = new DecideState();
          s.playerCard = playerCard;
          return s;
        }
      }
      if(gameData.playMode == 2 && enemyCard != null){
        time += 1;
        if(time >= 300){
          DecideState s = new DecideState();
          s.playerCard = playerCard;
          s.enemyCard = enemyCard;
          return s;
        }
      }
    }
    
    HandDeck player01Hand = gameData.player01Hand;
    HandDeck player02Hand = gameData.player02Hand;
    for(int i=0; i<player01Hand.cards.length; i++){
      Card card = player01Hand.cards[i];
      if(card == null) continue;
      PVector pos = logic.toPosition(1, i);
      renderCard(card, pos);
    }
    for(int i=0; i<player02Hand.cards.length; i++){
      Card card = player02Hand.cards[i];
      if(card == null) continue;
      PVector pos = logic.toPosition(2, i);
      renderCard(card, pos);
    }
    
    String message = "選択してください。";
    if(playerCard != null){
      message = "選択済み";
    }
    fill(255);
    textSize(12);
    text(message, width/2, 460);
    
    BackDeck player01Deck = gameData.player01Deck;
    BackDeck player02Deck = gameData.player02Deck;
    for(int i=0; i<player01Deck.cardList.size(); i++){
      fill(255);
      stroke(0);
      rect(300, 380 + i * 5, 50/2, 80/2);
    }
    for(int i=0; i<player02Deck.cardList.size(); i++){
      fill(255);
      stroke(0);
      rect(25, 60 + i * 5, 50/2, 80/2);
    }
    
    renderStatus();

    if(gameData.playMode == 2){
      String message02 = "選択してください。";
      if(enemyCard != null){
        message02 = "選択済み";
      }
      fill(255);
      textSize(12);
      text(message02, width/2, 20);
    }
    if(gameData.playMode == 1){
      if(playerCard != null){
        fill(0, 0, 0, 100);
        rect(width/2, height/2, width, height);
        fill(255);
        textSize(24);
        text("Ready?", width/2, height/2);
      }
    }
    if(gameData.playMode == 2){
      if(playerCard != null && enemyCard != null){
        fill(0, 0, 0, 100);
        rect(width/2, height/2, width, height);
        fill(255);
        textSize(24);
        text("Ready?", width/2, height/2);
      }
    }
    
    return null;
  }
  
  public void tap(){
    if(gameData.playMode == 1){
      if(playerCard != null){
        time = 300;
      }
    }
    if(gameData.playMode == 2){
      if(playerCard != null && enemyCard != null){
        time = 300;
      }
    }
  }
}
class DecideState implements IState{
  public Card playerCard;
  private Card enemyCard;
  int time;
  public void enter(){
    HandDeck player01Hand = gameData.player01Hand;
    for(int i=0; i<player01Hand.cards.length; i++){
      if(player01Hand.cards[i] == playerCard){
        player01Hand.cards[i] = null; 
      }
    }
    
    HandDeck player02Hand = gameData.player02Hand;
    if(enemyCard == null){
      enemyCard = logic.aiSelect(player02Hand.cards, player01Hand.cards, playerCard);
    }
    for(int i=0; i<player02Hand.cards.length; i++){
      if(player02Hand.cards[i] == enemyCard){
        player02Hand.cards[i] = null;
        break;
      }
    }

    int selfAttack = logic.getAttack(playerCard, enemyCard);
    int otherAttack = logic.getAttack(enemyCard, playerCard);
    
    gameData.player01Hp += selfAttack;
    gameData.player02Hp += otherAttack;
    
    
  }
  public IState update(){
    time += 1;
    HandDeck player01Hand = gameData.player01Hand;
    HandDeck player02Hand = gameData.player02Hand;
    int handCount = 0;
    for(int i=0; i<player01Hand.cards.length; i++){
      Card card = player01Hand.cards[i];
      if(card != null){
        handCount += 1;
        PVector pos = logic.toPosition(1, i);
        renderCard(card, pos);
      }
    }
    for(int i=0; i<player02Hand.cards.length; i++){
      Card card = player02Hand.cards[i];
      if(card != null){
        PVector pos = logic.toPosition(2, i);
        renderCard(card, pos);
      }
    }
    
    renderCard(this.playerCard, new PVector(width/2, 300));
    renderCard(this.enemyCard, new PVector(width/2, 180));
    
    renderStatus();
    
    BackDeck player01Deck = gameData.player01Deck;
    BackDeck player02Deck = gameData.player02Deck;
    for(int i=0; i<player01Deck.cardList.size(); i++){
      fill(255);
      stroke(0);
      rect(300, 380 + i * 5, 50/2, 80/2);
    }
    for(int i=0; i<player02Deck.cardList.size(); i++){
      fill(255);
      stroke(0);
      rect(25, 60 + i * 5, 50/2, 80/2);
    }

    if(time > 120){
      int point = logic.getMaxPoint();
      if(gameData.player01Hp >= point || gameData.player02Hp >= point || handCount == 0){
        renderResult();
      }else{
        return new SelectState(); 
      }
    }
    return null;
  }
}
class TitleState implements IState{
  public void enter(){
  }
  public IState update(){
    fill(255);
    textSize(24);
    textAlign(CENTER, CENTER);
    text("強く儚い者たち", width/2, 100);
    
    fill(255);
    if(mouseX > width/2 - width/4 && mouseX < width/2 + width/4){
      if(mouseY > 300 - 25 && mouseY < 300 + 25){
        fill(50, 50, 200);
      }
    }
    rect(width/2, 300, width/2, 50);
    fill(0);
    text("CPU対戦", width/2, 300);
    
    fill(255);
    if(mouseX > width/2 - width/4 && mouseX < width/2 + width/4){
      if(mouseY > 400 - 25 && mouseY < 400 + 25){
        fill(50, 50, 200);
      }
    }
    rect(width/2, 400, width/2, 50);
    fill(0);
    text("ローカル対戦", width/2, 400);

    textSize(12);
    fill(255);
    textAlign(RIGHT, CENTER);
    text("2020.05.25 ", width, 450);
    
    return null; 
  }
}

PlayerData playerData;
GameData gameData;
Logic logic = new Logic();
IState state;
void setup(){
  size(320, 480); 
  rectMode(CENTER);
  imageMode(CENTER);
  textFont(createFont("Arial", 32));
  SpriteFinder.initialize(this, "");
  playerData = new PlayerData();
  state = new TitleState();
}
void draw(){
  background(0);
  IState newState = state.update();
  if(newState != null){
    state = newState;
    state.enter();
  }
}
void mousePressed(){
  if(state instanceof TitleState){
    int playMode = 1;
    if(mouseX > width/2 - width/4 && mouseX < width/2 + width/4){
      if(mouseY > 400 - 25 && mouseY < 400 + 25){
        playMode = 2;
      }
    }
    gameInit(playMode);
    SelectState s = new SelectState();
    state = s;
    state.enter();
  }else if(state instanceof SelectState){
    SelectState s = (SelectState)state;
    
    // ここで処理してあげないとダメかも。
    s.tap();
    HandDeck player01Hand = gameData.player01Hand;
    for(int i=0; i<player01Hand.cards.length; i++){
      Card card = player01Hand.cards[i];
      PVector pos = logic.toPosition(1, i);
      if(mouseX < pos.x + 25 && mouseX > pos.x - 25){
        if(mouseY < pos.y + 40 && mouseY > pos.y - 40){
          s.playerCard = card;
          break; 
        }
      }
    }
    if(gameData.playMode == 2){
      HandDeck player02Hand = gameData.player02Hand;
      for(int i=0; i<player02Hand.cards.length; i++){
        Card card = player02Hand.cards[i];
        PVector pos = logic.toPosition(2, i);
        if(mouseX < pos.x + 25 && mouseX > pos.x - 25){
          if(mouseY < pos.y + 40 && mouseY > pos.y - 40){
            s.enemyCard = card;
            break; 
          }
        }
      }
    }
  }
}
void renderResult(){
  int result = logic.getResult(gameData);
  String message = "";
  if(result == 1){
    message = "You Win!";
    if(gameData.playMode == 2){
      message = "Player01\nWin!";
    }
  }
  if(result == 2){
    message = "You Lose";
    if(gameData.playMode == 2){
      message = "Player02\nWin!";
    }
  }
  if(result == 9){
    message = "Draw";
  }
  fill(0, 0, 0, 100);
  rect(width/2, height/2, width, height);
  textAlign(CENTER);
  textSize(64);
  fill(255);
  text(message, width/2, height/2); 
}
void renderStatus(){
  textAlign(CENTER, CENTER);
  textSize(32);
  fill(0, 0, 255);
  text(gameData.player01Hp, width/2 + 135, 330);
  fill(255, 0, 0);
  text(gameData.player02Hp, width/2 - 135, 120);
}
void renderCard(Card card, PVector pos){
  fill(255);
  if(card.type == 1)  fill(255, 100, 100);
  if(card.type == 2)  fill(100, 100, 255);
  if(card.type == 3)  fill(255, 255, 50);
  stroke(255);
  rect(pos.x, pos.y, 50, 80);
  textAlign(CENTER, CENTER);
  textSize(24);
  fill(0);
  String file = "";
  if(card.type == 1)  file = "Gu.png";
  if(card.type == 2)  file = "Ch.png";
  if(card.type == 3)  file = "Pa.png";
  // text(mes, pos.x, pos.y - 20);
  image(SpriteFinder.getSprite(file), pos.x, pos.y, 40, 40);
  if(card.strength > 0){
    fill(255);
    ellipse(pos.x + 15, pos.y - 30, 15, 15);
    fill(0);
    textSize(12);
    text(card.strength, pos.x + 15, pos.y - 30);
  }
}
void gameInit(int playMode){
  gameData = new GameData();
  gameData.playMode = playMode;
  BackDeck player01Deck = new BackDeck();
  player01Deck.cardList = logic.createCardList(1);
  BackDeck player02Deck = new BackDeck();
  player02Deck.cardList = logic.createCardList(2);
  HandDeck player01Hand = new HandDeck();
  for(int i=0; i<3; i++){
    player01Hand.cards[i] = logic.getAndRemoveCard(player01Deck.cardList);
  }
  HandDeck player02Hand = new HandDeck();
  for(int i=0; i<3; i++){
    player02Hand.cards[i] = logic.getAndRemoveCard(player02Deck.cardList);
  }
  gameData.player01Deck = player01Deck;
  gameData.player02Deck = player02Deck;
  gameData.player01Hand = player01Hand;
  gameData.player02Hand = player02Hand;
}
class Logic{
  public int getMaxPoint(){
    return 6;
  }
  public ArrayList<Card> createCardList(int playerId){
    ArrayList<Card> cardList = new ArrayList<Card>();
    // 必殺
    for(int i=0; i<3; i++){
      Card card = new Card();
      card.playerId = playerId;
      card.type = 1;
      card.strength = i % 3 + 1;
      cardList.add(card);
    }
    
    // 攻撃
    for(int i=0; i<3; i++){
      Card card = new Card();
      card.playerId = playerId;
      card.type = 2;
      card.strength = i % 3 + 1;
      cardList.add(card);
    }
    
    // 防御
    for(int i=0; i<3; i++){
      Card card = new Card();
      card.playerId = playerId;
      card.type = 3;
      card.strength = i % 3 + 1;
      cardList.add(card);
    }
    // shuffle
    for(int i=0; i<100; i++){
      int from = (int)random(0, cardList.size());
      int to = (int)random(0, cardList.size());
      Card fromCard = cardList.get(from);
      Card toCard = cardList.get(to);
      cardList.set(from, toCard);
      cardList.set(to, fromCard);
    }
    return cardList;
  }
  public Card getAndRemoveCard(ArrayList<Card> cardList){
    if(cardList.size() == 0){
      return null;
    }
    Card card = cardList.get(0);
    cardList.remove(card);
    return card;
  }
  public PVector toPosition(int playerId, int index){
    float y = 400;
    if(playerId == 2){
      y = 80;
    }
    float x = index * 80 + 80;
    return new PVector(x, y);
  }
  public int getAttack(Card self, Card other){
    // 同じカードだったら
    if(self.type == other.type){
      if(self.strength < other.strength){
        return self.strength;
      }
    }
    if(self.type == 1 && other.type == 2){
      return self.strength; 
    }
    if(self.type == 2 && other.type == 3){
      return self.strength;
    }
    if(self.type == 3 && other.type == 1){
      return self.strength;
    }
    return 0;
  }
  public Card aiSelect(Card[] selfCards, Card[] enemyCards, Card battleCard){
    if(random(0, 100) > 80){
      int index = -1;
      int _attack = 0;
      for(int i=0; i<selfCards.length; i++){
        Card selfCard = selfCards[i];
        if(selfCard == null) continue;
        int attack = getAttack(selfCard, battleCard);
        if(attack > _attack){
          index = i;
          _attack = attack;
        }
      }
      if(index >= 0){
        return selfCards[index]; 
      }
    }
    
    // とりあえずランダムでとっておく
    int r = (int)random(0, selfCards.length);
    Card selectCard = selfCards[r];
    
    // 絶対に得するカードをピックアップして選択
    ArrayList<Card> victoryCardList = new ArrayList<Card>();
    for(int i=0; i<selfCards.length; i++){
      Card selfCard = selfCards[i];
      if(selfCard == null) continue;
      boolean isVictory = true;
      for(int j=0; j<enemyCards.length; j++){
        Card enemyCard = enemyCards[j];
        if(enemyCard == null) continue;
        // 与えられるダメージ数を算出
        int attack = getAttack(selfCard, enemyCard);
        if(attack <= 0){
          isVictory = false;
          break;
        }
      }
      if(isVictory){
        victoryCardList.add(selfCard); 
      }
    }
    if(victoryCardList.size() > 0){
      r = (int)random(0, victoryCardList.size());
      selectCard = victoryCardList.get(r);
    }
    
    // 絶対に損するカードを排除して選択
    ArrayList<Card> effectiveCardList = new ArrayList<Card>();
    for(int i=0; i<selfCards.length; i++){
      Card selfCard = selfCards[i];
      if(selfCard == null) continue;
      for(int j=0; j<enemyCards.length; j++){
        Card enemyCard = enemyCards[j];
        if(enemyCard == null) continue;
        // デメリットを算出
        int damage = getAttack(enemyCard, selfCard);
        if(damage == 0){
          effectiveCardList.add(selfCard);
          break;
        }
      }
    }
    if(effectiveCardList.size() > 0){
      r = (int)random(0, effectiveCardList.size());
      selectCard = effectiveCardList.get(r);
    }
    return selectCard;
  }
  public int getResult(GameData gameData){
    int result = 9;
    int point = logic.getMaxPoint();
    if(gameData.player01Hp >= point){
      result = 1;
    }
    if(gameData.player02Hp >= point){
      result = 2;
    }

    
    // 枚数があるか
    int count = 0;
    for(int i=0; i<gameData.player01Hand.cards.length; i++){
      if(gameData.player01Hand.cards[i] != null){
        count += 1;
      }
    }
    if(count == 0){
       if(gameData.player01Hp > gameData.player02Hp){
         result = 1;
       }
       if(gameData.player01Hp < gameData.player02Hp){
         result = 2;
       }
    }
  
    if(gameData.player01Hp >= point && gameData.player02Hp >= point){
      result = 9;
    } 
    return result;
  }
}
