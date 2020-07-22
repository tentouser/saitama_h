/* @pjs preload="sample01.png,sample02.png"; */
PImage sample01;
PImage sample02;
float x = 100;
void setup(){
  size(320, 480);
  sample01 = loadImage("sample01.png");
  sample02 = loadImage("sample02.png");
}
void draw(){
  background(255);
  x += 5;
  if(x > width){
    x = 0;
  }
  image(sample01, x, 100);
  image(sample02, x, 300);
}
