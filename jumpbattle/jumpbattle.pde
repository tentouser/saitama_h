class Player{
  public PVector pos;
  public PVector size;
  public PVector velocity;
  public int point;
  public boolean isGround;
}
class Block{
  public PVector pos;
  public PVector size;
}
class Gold{
  public PVector pos; 
  public PVector size;
}
class Input{
  public boolean left01;
  public boolean right01;
  public boolean left02;
  public boolean right02;
}
Player player01;
Player player02;
Player[] players;
Gold gold;
Input input;
ArrayList<Block> blockList = new ArrayList<Block>();
void setup(){
  size(600, 400);
  createPlayers();
  createBlocks();
  createGold();
  input = new Input();
  rectMode(CENTER);
}
void draw(){
  background(0);
  
  updatePlayers();
  
  for(int i=0; i<players.length; i++){
    Player p = players[i];
    if(!p.isGround){
      p.velocity.y += 0.5;
    }
    for(int j=0; j<blockList.size(); j++){
      Block b = blockList.get(j);
      boolean hit = isHit(p.pos.x, p.pos.y, p.size.x, p.size.y, b.pos.x, b.pos.y, b.size.x, b.size.y);
      if(hit){
        p.velocity.y = 0;
        p.pos.y = b.pos.y - b.size.y / 2 - p.size.y / 2;
        p.isGround = true;
      }
    }
    for(int j=0; j<players.length; j++){
      Player other = players[j];
      if(other == p){
        continue;
      }
      boolean hit = isHit(p.pos.x, p.pos.y, p.size.x, p.size.y, other.pos.x, other.pos.y, other.size.x, other.size.y);
      boolean isUnder = false;
      if(p.pos.y < other.pos.y - other.size.y/2){
        isUnder = true;
      }
      if(hit && isUnder){
        // p.pos.y + p.size.y/2 < other.pos.y - other.size.y/2
         p.velocity.y = -20;
         other.velocity.y += 5;
      }
    }
    boolean isGoldHit = isHit(p.pos.x, p.pos.y, p.size.x, p.size.y, gold.pos.x, gold.pos.y, gold.size.x, gold.size.y);
    if(isGoldHit){
      p.point += 1;
      createGold();
    }
    p.pos.add(p.velocity);
  }
  
  renderStatus();

  fill(255, 255, 0);
  ellipse(gold.pos.x, gold.pos.y, gold.size.x, gold.size.y);
  fill(0);
  textAlign(CENTER, CENTER);
  textSize(10);
  text("$", gold.pos.x, gold.pos.y);
  
  for(int i=0; i<blockList.size(); i++){
    Block b = blockList.get(i);
    fill(255);
    rect(b.pos.x, b.pos.y, b.size.x, b.size.y);
  }
  for(int i=0; i<players.length; i++){
    Player p = players[i];
    if(i == 0)  fill(0, 0, 255);
    if(i == 1)  fill(255, 0, 0);
    rect(p.pos.x, p.pos.y, p.size.x, p.size.y);
  }
}
void updatePlayers(){
  player01.velocity.x *= 0.9;
  player02.velocity.x *= 0.9;
  
  for(int i=0; i<players.length; i++){
    Player p = players[i];
    p.pos.x = clamp(p.pos.x, 0, width);
    p.pos.y = clamp(p.pos.y, 0, height);
  }
  
  float power = 0.5;
  if(input.left01){
    player01.velocity.x -= power;
    if(player01.isGround){
      player01.velocity.y = -15;
      player01.isGround = false;
    }
  }
  if(input.right01){
    player01.velocity.x += power;
    if(player01.isGround){
      player01.velocity.y = -15;
      player01.isGround = false;
    }
  }
  if(input.left02){
    player02.velocity.x -= power;
    if(player02.isGround){
      player02.velocity.y = -15;
      player02.isGround = false;
    }
  }
  if(input.right02){
    player02.velocity.x += power;
    if(player02.isGround){
      player02.velocity.y = -15;
      player02.isGround = false;
    }
  }
}
void renderStatus(){
  textSize(40);
  textAlign(CENTER);
  fill(255);
  text(player01.point, 50, 50);
  text(player02.point, width - 50, 50);
}
void createPlayers(){
  player01 = new Player();
  player01.size = new PVector(30, 30);
  player01.pos = new PVector(100, height - 50 - player01.size.y / 2);
  player01.velocity = new PVector(0, 0);
  
  player02 = new Player();
  player02.size = new PVector(30, 30);
  player02.pos = new PVector(width - 100, height - 50 - player02.size.y / 2);
  player02.velocity = new PVector(0, 0);
  
  players = new Player[2];
  players[0] = player01;
  players[1] = player02;
}
void createBlocks(){
  Block floor = new Block();
  floor.size = new PVector(width, 50);
  floor.pos = new PVector(width/2, height - floor.size.y/2);
  blockList.add(floor);
}
void createGold(){
  gold = new Gold();
  float x = random(50, width-50);
  float y = 50;
  gold.pos = new PVector(x, y);
  gold.size = new PVector(20, 20);
}
void keyPressed(){
  if(key == 'a'){
    input.left01 = true; 
  }
  if(key == 's'){
    input.right01 = true;
  }
  if(keyCode == LEFT){
    input.left02 = true;
  }
  if(keyCode == RIGHT){
    input.right02 = true;
  }
}
void keyReleased(){
  if(key == 'a'){
    input.left01 = false; 
  }
  if(key == 's'){
    input.right01 = false;
  }
  if(keyCode == LEFT){
    input.left02 = false;
  }
  if(keyCode == RIGHT){
    input.right02 = false;
  }
}

float clamp(float v, float min, float max){
  if(v < min)  return min;
  if(v > max)  return max;
  return v;
}

boolean isHit(float px, float py, float pw, float ph, float ex, float ey, float ew, float eh){
  px = px - pw / 2;
  py = py - ph / 2;
  ex = ex - ew / 2;
  ey = ey - eh / 2;
  if (px < ex + ew && px + pw > ex) {
    if (py < ey + eh && py + ph > ey) {
      return true;
    }
  }
  return false;
}
