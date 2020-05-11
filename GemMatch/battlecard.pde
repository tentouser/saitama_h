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
  public BackDeck player01Deck;
  public BackDeck player02Deck;
  public HandDeck player01Hand;
  public HandDeck player02Hand;
  public int player01Hp;
  public int player02Hp;
}
interface IState{
  void enter();
  IState update();
}
class SelectState implements IState{
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
    HandDeck player01Hand = gameData.player01Hand;
    HandDeck player02Hand = gameData.player02Hand;
    for(int i=0; i<player01Hand.cards.length; i++){
      Card card = player01Hand.cards[i];
      PVector pos = logic.toPosition(1, i);
      renderCard(card, pos);
    }
    for(int i=0; i<player02Hand.cards.length; i++){
      Card card = player02Hand.cards[i];
      PVector pos = logic.toPosition(2, i);
      renderCard(card, pos);
    }
    return null;
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
    int r = (int)random(0, player02Hand.cards.length);
    enemyCard = player02Hand.cards[r];
    player02Hand.cards[r] = null;
    
    int selfAttack = logic.getAttack(playerCard, enemyCard);
    int otherAttack = logic.getAttack(enemyCard, playerCard);
    
    gameData.player01Hp -= otherAttack;
    gameData.player02Hp -= selfAttack;
    
    
  }
  public IState update(){
    time += 1;
    if(time > 120){
      return new SelectState(); 
    }
    HandDeck player01Hand = gameData.player01Hand;
    HandDeck player02Hand = gameData.player02Hand;
    for(int i=0; i<player01Hand.cards.length; i++){
      Card card = player01Hand.cards[i];
      if(card != null){
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
    return null;
  }
}
GameData gameData;
Logic logic = new Logic();
IState state;
void setup(){
  size(320, 480); 
  rectMode(CENTER);
  textFont(createFont("Arial", 32));
  gameInit();
  state = new SelectState();
}
void draw(){
  background(0);
  IState newState = state.update();
  if(newState != null){
    state = newState;
    state.enter();
  }
  renderStatus();
}
void mousePressed(){
  if(state instanceof SelectState){
    HandDeck player01Hand = gameData.player01Hand;
    for(int i=0; i<player01Hand.cards.length; i++){
      Card card = player01Hand.cards[i];
      PVector pos = logic.toPosition(1, i);
      if(mouseX < pos.x + 25 && mouseX > pos.x - 25){
        if(mouseY < pos.y + 40 && mouseY > pos.y - 40){
          DecideState s = new DecideState();
          s.playerCard = card;
          state = s;
          state.enter();
          break; 
        }
      }
    }
  }
}
void renderStatus(){
  textAlign(CENTER, CENTER);
  textSize(64);
  fill(0, 0, 255);
  text(gameData.player01Hp, width/2 + 80, 300);
  fill(255, 0, 0);
  text(gameData.player02Hp, width/2 - 80, 180);
}
void renderCard(Card card, PVector pos){
  fill(255);
  rect(pos.x, pos.y, 50, 80);
  textAlign(CENTER, CENTER);
  textSize(24);
  fill(0);
  String mes = "";
  if(card.type == 1)  mes = "必殺";
  if(card.type == 2)  mes = "攻撃";
  if(card.type == 3)  mes = "防御";
  text(mes, pos.x, pos.y - 20);
  if(card.strength > 0){
    text(card.strength, pos.x, pos.y + 10);
  }
}
void gameInit(){
  gameData = new GameData();
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
  public ArrayList<Card> createCardList(int playerId){
    ArrayList<Card> cardList = new ArrayList<Card>();
    // 必殺
    for(int i=1; i<=6; i++){
      Card card = new Card();
      card.playerId = playerId;
      card.type = 1;
      card.strength = i % 3 + 1;
      cardList.add(card);
    }
    // 攻撃
    for(int i=1; i<=6; i++){
      Card card = new Card();
      card.playerId = playerId;
      card.type = 2;
      card.strength = i % 3 + 1;
      cardList.add(card);
    }
    // 防御
    for(int i=1; i<=6; i++){
      Card card = new Card();
      card.playerId = playerId;
      card.type = 3;
      card.strength = 0;
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
      if(self.strength <= other.strength){
        return self.strength;
      }
    }
    if(self.type == 1 && other.type == 2){
      return self.strength; 
    }
    if(self.type == 2 && other.type == 3){
      return self.strength;
    }
    return 0;
  }
}
