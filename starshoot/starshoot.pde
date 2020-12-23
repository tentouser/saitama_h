////////////////////////////////////////////////////////////////////////////////////////////
// Main
////////////////////////////////////////////////////////////////////////////////////////////
TGScene scene;
TGInputEvent input = new TGInputEvent();
boolean is2Player;
void setup() {
  size(800, 600);
  PFont font = createFont("Serif", 32);
  textFont(font, 32);
  // Instantiate First Scene
  scene = new TitleScene();
  scene.startScene();
}
void draw() {
  background(0);
  TGTime.makeDeltaTime();
  TGScene newScene = scene.updateScene(); 
  if (newScene != null) {
    scene = newScene;
    scene.startScene();
  } else {
    scene.updateGameObjecs();
  }
}


////////////////////////////////////////////////////////////////////////////////////////////
// Title Scene
////////////////////////////////////////////////////////////////////////////////////////////
class TitleScene extends TGScene {
  TitleUI titleUI;
  float _time;
  public void startScene() {
    titleUI = new TitleUI();
    addGameObject(titleUI);
  }
  public TGScene updateScene() {
    background(0);
    if (titleUI.isEnter) {
      _time += TGTime.deltaTime;
      if (_time > 2) {
        is2Player = titleUI.is2Player;
        GameScene newScene = new GameScene();
        return newScene;
      }
    }
    return null;
  }
}
class TitleUI extends TGGameObject {
  public boolean is2Player;
  public boolean isEnter;
  boolean titleReady;
  float _time;
  public void update(TGScene scene) {
    if (titleReady) {
      if (!isEnter) {
        if (input.up)  is2Player = false;
        if (input.down) is2Player = true;
        renderButtons();
        if (input.spaceKeyDown) {
          isEnter = true;
        }
      } else {
        renderButtonsEntered();
      }
    }
    renderTitle();
  }
  float titleAlpha;
  void renderTitle() {
    titleAlpha =  titleAlpha / 2  + titleAlpha + 0.1;
    if (titleAlpha > 255) {
      titleAlpha = 255;
      titleReady = true;
    }
    fill(255, titleAlpha);
    textSize(42);
    textAlign(CENTER);
    text("Cannon Warriors", width/2, height/3);
  }
  void renderButtons() {
    float alpha01 = 255;
    float alpha02 = 100;
    if (is2Player) {
      alpha01 = 100;
      alpha02 = 255;
    }
    fill(255, alpha01);
    textSize(24);
    textAlign(CENTER);
    text("Single Mode", width/2, height/4 + 200);

    fill(255, alpha02);
    text("VS Mode", width/2, height/3 + 200);

    fill(255, 255, 255, 100);
    text("Select = Up/Down\nEnter = SpaceKey", width/2, height/2 + 200);
  }
  void renderButtonsEntered() {
    float alpha01 = 255;
    float alpha02 = 100;
    if (is2Player) {
      alpha01 = 100;
      alpha02 = 255;
    }

    _time += TGTime.deltaTime;
    if (_time > 0.2) {
      if (!is2Player) {
        alpha01 = 50;
      } else {
        alpha02 = 50;
      }
    }
    if (_time > 0.4) {
      _time = 0;
    }
    fill(255, alpha01);
    textSize(24);
    textAlign(CENTER);
    text("Single Mode", width/2, height/4 + 200);

    fill(255, alpha02);
    text("VS Mode", width/2, height/3 + 200);
  }
}

////////////////////////////////////////////////////////////////////////////////////////////
// Result Scene
////////////////////////////////////////////////////////////////////////////////////////////
class ResultScene extends TGScene {
  boolean isPlayerWin;
  float _time;
  public void setIsPlayerWin(boolean b) {
    isPlayerWin = b;
  }
  public TGScene updateScene() {
    background(0);
    _time += TGTime.deltaTime;
    String title = "";
    if (isPlayerWin) {
      if (is2Player) {
        title = "Player01 Win!";
      } else {
        title = "You Win!";
      }
    } else {
      if (is2Player) {
        title = "Player02 Win!";
      } else {
        title = "You Lose...";
      }
    }
    textSize(42);
    fill(255);
    textAlign(CENTER);
    text(title, width/2, height/2);

    if (input.mouseDown || input.spaceKeyDown) {
      if (_time > 1) {
        return new TitleScene();
      }
    }
    return null;
  }
}


////////////////////////////////////////////////////////////////////////////////////////////
// Game Scene
////////////////////////////////////////////////////////////////////////////////////////////
class GameScene extends TGScene {
  Ship player01;
  Ship player02;
  float _item_popup_time;
  float _finish_wait_time;
  boolean isPlayerWin;
  boolean hasGameFinished;
  public void startScene() {
    player01 = new ShipBoard();
    if (is2Player) {
      player02 = new ShipMouse();
    } else {
      player02 = new ShipAI();
    }
    addGameObject(player01);
    addGameObject(player02);
  }
  public TGScene updateScene() {
    background(0);
    _item_popup_time += TGTime.deltaTime;
    checkGameFinish();
    if (hasGameFinished) {
      _finish_wait_time += TGTime.deltaTime;
      if (_finish_wait_time > 3) {
        ResultScene resultScene = new ResultScene();
        resultScene.setIsPlayerWin(isPlayerWin);
        return resultScene;
      }
    } else {
      if (_item_popup_time > 5) {
        addGameObject(new Item());
        _item_popup_time = 0;
      }
    }

    return null;
  }
  void checkGameFinish() {
    if ( player01 == null || player01.hasDestroyed) {
      hasGameFinished = true;
      isPlayerWin = false;
    }
    if ( player02 == null || player02.hasDestroyed) {
      hasGameFinished = true;
      isPlayerWin = true;
    }
  }
}
class ShipAI extends Ship {
  float _time;
  ShipAIIF _state;
  public void start(TGScene scene) {
    super.start(scene);
    position = new PVector(width/2, 100);
    fillColor = color(255, 255, 0);
    _state = new ShipAIStateNormal();
    _state.enter(this);
  }
  public void update(TGScene scene) {
    super.update(scene);
    ShipAIIF newState = _state.update(this);
    if (newState != null) {
      _state = newState;
      _state.enter(this);
    }
    shot();
    render();
  }
  public boolean moveTo(PVector targetPosition) {
    PVector distance = targetPosition.get();
    distance.sub(position);
    if (distance.mag() < 3) {
      return false;
    }
    distance.normalize();
    moveBy(distance);
    return true;
  }
  public Bullet getNearBullet() {
    ArrayList<TGGameObject> gameObjects = _scene.gameObjects;
    for (int i=0; i<gameObjects.size(); i++) {
      TGGameObject o = gameObjects.get(i);
      if (o.tag != "Bullet") continue;
      Bullet b = (Bullet)o;
      if (b.getShip() == this) continue;
      PVector distance = b.position.get();
      distance.sub(position);
      if (distance.mag() < scale.x * 5) {
        return b;
      }
    }
    return null;
  }
}
class ShipAIStateNormal implements ShipAIIF {
  PVector targetPosition;
  public void enter(ShipAI c) {
    targetPosition = new PVector(random(width), c.position.y);
  }
  public ShipAIIF update(ShipAI c) {
    Bullet bullet = c.getNearBullet();
    if (bullet != null) {
      targetPosition.x = bullet.position.x - c.position.x * -1;
      if (targetPosition.x < 0)  targetPosition.x = 0;
      if (targetPosition.x > width)  targetPosition.x = width;
    }
    if (!c.moveTo(targetPosition)) {
      return new ShipAIStateNormal();
    }
    return null;
  }
}
interface ShipAIIF {
  void enter(ShipAI c);
  ShipAIIF update(ShipAI c);
}

class ShipMouse extends Ship {
  public void start(TGScene scene) {
    super.start(scene);
    position = new PVector(width/2, 100);
    fillColor = color(255, 255, 0);
  }
  public void update(TGScene scene) {
    super.update(scene);
    PVector mousePosition = scene.camera.screenToWorldPosition(new PVector(mouseX, mouseY));
    PVector direction = new PVector(mousePosition.x - position.x, 0);
    if (direction.mag() >= scale.x / 2) {
      direction.normalize();
      moveBy(direction);
    }
    if (input.mouseDown) {
      shot();
    }
    render();
  }
}
class ShipBoard extends Ship {
  public void start(TGScene scene) {
    super.start(scene);
    position = new PVector(width/2, height-100);
    fillColor = color(255, 0, 255);
  }
  public void update(TGScene scene) {
    super.update(scene);
    PVector direction = new PVector(0, 0);
    if (input.left) {
      direction.x = -1;
    }
    if (input.right) {
      direction.x = 1;
    }
    if (input.spaceKeyDown) {
      shot();
    }
    moveBy(direction);

    position.x = min(position.x, width - scale.x / 2);
    position.x = max(position.x, scale.x / 2);

    render();
  }
}
class Ship extends TGGameObject {
  class Param {
    public float moveSpeed = 100;
    public float bulletSpeed = 150;
    public float shotWait = 1.5;
    public float shotEnergy = 10;
    public float energyWait = 0.5;
    public void attachMoveSpeed(float attach) {
      moveSpeed += attach;
      if (moveSpeed < 30)  moveSpeed = 30;
    }
    public void attachBulletSpeed(float attach) {
      bulletSpeed += attach;
      if (bulletSpeed < 10)  bulletSpeed = 30;
    }
    public void attachShotWait(float attach) {
      shotWait += attach;
      if (shotWait < 0.1)  shotWait = 0.1;
      if (shotWait > 10)  shotWait = 10;
    }
  }
  class ItemEffectSession {
    public float time;
    public int itemType;
    ItemEffectSession(int itemType) {
      this.itemType = itemType;
    }
  }
  ArrayList<ItemEffectSession> itemEffectSessions = new ArrayList<ItemEffectSession>();
  public color fillColor;
  protected Param param;
  protected TGScene _scene;
  protected float shotWait;
  public void start(TGScene scene) {
    _scene = scene;
    tag = "Ship";
    param = new Param();
    scale = new PVector(20, 20);
  }
  public void update(TGScene scene) {
    shotWait += TGTime.deltaTime;
  }
  public void attackShip(Ship ship) {
    _scene.addGameObject(new Explosion(ship.position));
    ship.destroy();
  }
  public void getItem(Item item) {
    if(item.itemType == MOVE_SPEED_UP){
      param.attachMoveSpeed(100);
    }
    if(item.itemType == MOVE_SPEED_DOWN){
      param.attachMoveSpeed(-100);
    }
    if(item.itemType == BULLET_SPEED_UP){
      param.attachBulletSpeed(100);
    }
    if(item.itemType == BULLET_SPEED_DOWN){
      param.attachBulletSpeed(-100);
    }
    if(item.itemType == SHOT_WAIT_UP){
      param.attachShotWait(-0.3);
    }
    if(item.itemType == SHOT_WAIT_DOWN){
      param.attachShotWait(0.3);
    }
    itemEffectSessions.add(new ItemEffectSession(item.itemType));
    item.destroy();
  }
  protected void moveBy(PVector moveDirection) {
    PVector direction = moveDirection.get();
    direction.mult(param.moveSpeed * TGTime.deltaTime);
    position.add(direction);
  }
  protected void render() {
    fill(fillColor);
    rectMode(CENTER);
    rect(position.x, position.y, scale.x * 1.2, scale.y*1.2);

    String title = "";
    for (int i=0; i<itemEffectSessions.size(); i++) {
      ItemEffectSession s = itemEffectSessions.get(i);
      s.time += TGTime.deltaTime;
      if (s.time <= 2) {
        title += getName(s.itemType) + "\n";
        // title += s.itemType.toString() + "\n";
      }
    }
    for (int i=0; i<itemEffectSessions.size(); i++) {
      ItemEffectSession s = itemEffectSessions.get(i);
      if (s.time > 2) {
        itemEffectSessions.remove(s);
      }
    }

    renderMeter();

    fill(fillColor);
    textAlign(CENTER);
    text(title, position.x, position.y - 20);
  }
  protected void renderMeter() {
    float per = 1;
    if (shotWait < 0) {
      per = max(shotWait + param.shotWait, 0) / param.shotWait;
    }

    fill(255, 255, 255, 100);
    rectMode(CORNER);
    rect(position.x - 15, position.y - 25, 30, 5);
    fill(255, 255, 255, 255);
    rect(position.x - 15, position.y - 25, 30 * per, 5);
    rectMode(CENTER);
  }
  protected void shot() {
    if (shotWait < 0) {
      return;
    }
    Bullet bullet = new Bullet();
    bullet.setShip(this);
    _scene.addGameObject(bullet);
    shotWait = param.shotWait * -1;
  }
}
class Bullet extends TGGameObject {
  Ship _ship;
  color fillColor;
  PVector moveDirection;
  float moveSpeed;
  public void setShip(Ship ship) {
    _ship = ship;
    tag = "Bullet";
    fillColor = ship.fillColor;
    position = ship.position.get();
    moveDirection = new PVector(0, 1);
    if (ship instanceof ShipBoard) {
      moveDirection = new PVector(0, -1);
    }
    moveSpeed = ship.param.bulletSpeed;
  }
  public void start(TGScene scene) {
    scale = new PVector(5, 5);
  }
  public void update(TGScene scene) {
    if (position.y < 0 || position.y > height) {
      destroy();
    }
    PVector direction = moveDirection.get();
    direction.mult(moveSpeed * TGTime.deltaTime);
    position.add(direction);
    noStroke();
    fill(fillColor);
    ellipse(position.x, position.y, scale.x, scale.y);
  }
  public Ship getShip() {
    return _ship;
  }
  void onCollisionEnter(TGGameObject o) {
    if (o.tag == "Item") {
      Item item = (Item)o;
      _ship.getItem(item);
      destroy();
    }
    if (o.tag == "Ship") {
      if (o != _ship) {
        Ship ship = (Ship)o;
        _ship.attackShip(ship);
        destroy();
      }
    }
  }
}

int MOVE_SPEED_UP = 0;
int MOVE_SPEED_DOWN = 1;
int BULLET_SPEED_UP = 2;
int BULLET_SPEED_DOWN = 3;
int SHOT_WAIT_UP = 4;
int SHOT_WAIT_DOWN = 5;


int getRandom() {
  return (int)random(0, 6);
}
String getName(int itemType) {
  String name = "";
  if(itemType == MOVE_SPEED_UP)  name = "移動スピードアップ";
  if(itemType == MOVE_SPEED_DOWN)  name = "移動スピードダウン";
  if(itemType == BULLET_SPEED_UP)  name = "銃弾スピードアップ";
  if(itemType == BULLET_SPEED_DOWN)  name = "銃弾スピードダウン";
  if(itemType == SHOT_WAIT_UP)  name = "連射間隔スピードアップ";
  if(itemType == SHOT_WAIT_DOWN)  name = "連射間隔スピードダウン";
  return name;
}

class Item extends TGGameObject {
  public int itemType;
  PVector moveDirection;
  float moveSpeed = 30;
  public void start(TGScene scene) {
    tag = "Item";
    itemType = getRandom();
    position = new PVector(0, random(height*0.4, height*0.6));
    scale = new PVector(20, 20);
    moveDirection = new PVector(1, 0);
    if (random(0, 100) >= 50) {
      position.x = width;
      moveDirection = new PVector(-1, 0);
    }
    moveSpeed = random(30, 100);
  }
  public void update(TGScene scene) {
    if (position.x < 0 || position.x > width) {
      destroy();
    }
    PVector direction = moveDirection.get();
    direction.mult(moveSpeed * TGTime.deltaTime);
    position.add(direction);
    render();
  }
  void render() {
    color fillColor = color(0, 255, 0);
    String title = getName(itemType);
    title = getName(itemType);
    if (itemType % 2 == 1) {
      fillColor = color(255, 0, 0);
    }

    noStroke();
    fill(fillColor);
    textSize(scale.x);
    ellipse(position.x, position.y, scale.x*1.2, scale.y*1.2);

    // TODO text omoi

    textAlign(CENTER);
    text(title, position.x, position.y - 20);
  }
}

class Explosion extends TGGameObject {
  ParticleSystem ps;
  float _time;
  Explosion(PVector position) {
    this.position = position;
    ps = new ParticleSystem(position);
  }
  public void update(TGScene scene) {
    _time += TGTime.deltaTime;
    ps.addParticle();
    ps.run();
    if (_time >= 0.5) {
      destroy(this);
    }
  }
}

////////////////////////////////////////////////////////////////////////////////////////////
// End Game
////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////
// TG Framework
////////////////////////////////////////////////////////////////////////////////////////////
class TGScene {
  public ArrayList<TGGameObject> gameObjects = new ArrayList<TGGameObject>();
  public TGCamera camera;
  TGScene() {
    camera = new TGCamera();
    camera.start(this);
  }
  public void startScene() {
  }
  public TGScene updateScene() { 
    return null;
  }
  public void updateGameObjecs() {
    for (int i=0; i<gameObjects.size(); i++) {
      gameObjects.get(i).update(this);
      gameObjects.get(i).collisionCheck();
    }
    for (int i=0; i<gameObjects.size(); i++) {
      TGGameObject o = gameObjects.get(i);
      if (o.hasDestroyed) {
        removeGameObject(o);
        o = null;
      }
    }
  }
  public void addGameObject(TGGameObject o) {
    gameObjects.add(o);
    o.start(this);
  }
  public void removeGameObject(TGGameObject o) {
    for (int i=0; i<gameObjects.size(); i++) {
      if (o == gameObjects.get(i)) {
        gameObjects.remove(o);
        break;
      }
    }
  }
}
class TGGameObject {
  public String tag;
  public PVector position = new PVector(width/2, height/2);
  public PVector scale = new PVector(1, 1);
  public boolean hasDestroyed;
  public <T extends TGGameObject> T setPosition(PVector pos) {
    this.position = pos;
    return (T)this;
  }
  public <T extends TGGameObject> T setScale(PVector scale) {
    this.scale = scale;
    return (T)this;
  }
  public void destroy(TGGameObject o) {
    o.hasDestroyed = true;
  }
  public void destroy() {
    hasDestroyed = true;
  }
  public void start(TGScene scene) {
  }
  public void update(TGScene scene) {
  }
  protected void onCollisionEnter(TGGameObject o) {
  }
  protected void collisionCheck() {
    ArrayList<TGGameObject> gameObjects = scene.gameObjects;
    for (int i=0; i<gameObjects.size(); i++) {
      TGGameObject o = gameObjects.get(i);
      if (o == this) continue;
      PVector diff = new PVector(o.position.x - position.x, o.position.y - position.y);
      // ellipse(position.x, position.y, scale.x, scale.y);

      if (diff.mag() < scale.x) {
        onCollisionEnter(o);
        return;
      }
      if (diff.mag() < o.scale.x) {
        onCollisionEnter(o);
        return ;
      }
    }
  }
}
class TGCamera extends TGGameObject {
  public PVector screenToWorldPosition(PVector screenPosition) {
    PVector c = new PVector(width/2, height/2);
    PVector distanceFromCenter = new PVector(position.x - c.x, position.y - c.y);
    PVector worldPosition = new PVector(screenPosition.x + distanceFromCenter.x, screenPosition.y + distanceFromCenter.y);
    return worldPosition;
  }
  public PVector worldToScreenPosition(PVector worldPosition) {
    PVector c = new PVector(width/2, height/2);
    PVector distanceFromCenter = new PVector(position.x - c.x, position.y - c.y);
    PVector screenPosition = new PVector(worldPosition.x - distanceFromCenter.x, worldPosition.y - distanceFromCenter.y);
    return screenPosition;
  }
}
class TGInputEvent {
  public boolean mouseDown;
  public boolean spaceKeyDown;
  public boolean left;
  public boolean right;
  public boolean up;
  public boolean down;
}
static class TGTime {
  public static float deltaTime;
  static double prevTime;
  public static void makeDeltaTime() {
    /*
    double currentTime = System.currentTimeMillis();
    if (prevTime == 0) {
      prevTime = currentTime;
    }
    deltaTime = (float)(currentTime - prevTime) * 0.001;
    prevTime = currentTime;
    */
    deltaTime = 1 / 60f;
  }
}

void mousePressed() {
  input.mouseDown = true;
}
void mouseReleased() {
  input.mouseDown = false;
}
void keyPressed() {
  if (key == ' ') {
    input.spaceKeyDown = true;
  }
  if (keyCode == LEFT) {
    input.left = true;
    input.right = false;
  }
  if (keyCode == RIGHT) {
    input.right = true;
    input.left = false;
  }
  if (keyCode == UP) {
    input.up = true;
    input.down = false;
  }
  if (keyCode == DOWN) {
    input.up = false;
    input.down = true;
  }
}
void keyReleased() {
  if (key == ' ') {
    input.spaceKeyDown = false;
  }
  if (keyCode == LEFT) {
    input.left = false;
  }
  if (keyCode == RIGHT) {
    input.right = false;
  }
  if (keyCode == UP) {
    input.up = false;
  }
  if (keyCode == DOWN) {
    input.down = false;
  }
}
////////////////////////////////////////////////////////////////////////////////////////////
// End TG Framework
////////////////////////////////////////////////////////////////////////////////////////////


///////////////////////////////////////////////////////////////////////////////////////
// Library
////////////////////////////////////////////////////////////////////////////////////////////
class ParticleSystem {
  ArrayList<Particle> particles;
  PVector origin;

  ParticleSystem(PVector location) {
    origin = location.get();
    particles = new ArrayList<Particle>();
  }

  void addParticle() {
    particles.add(new Particle(origin));
  }

  void run() {
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.run();
      if (p.isDead()) {
        particles.remove(i);
      }
    }
  }
}
class Particle {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float lifespan;

  Particle(PVector l) {
    acceleration = new PVector(0, 0.05);
    velocity = new PVector(random(-1, 1), random(-2, 0));
    location = l.get();
    lifespan = 255.0;
  }

  void run() {
    update();
    display();
  }

  // Method to update location
  void update() {
    velocity.add(acceleration);
    location.add(velocity);
    lifespan -= 10.0;
  }

  // Method to display
  void display() {
    noStroke();
    fill(255, lifespan);
    rect(location.x, location.y, 8, 8);
  }

  // Is the particle still useful?
  boolean isDead() {
    if (lifespan < 0.0) {
      return true;
    } else {
      return false;
    }
  }
}
