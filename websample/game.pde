/* @pjs preload="sample01.png,sample02.png"; */
PImage sample01;
PImage sample02;
void setup(){
  size(320, 480);
  sample01 = loadImage("sample01.png");
  sample02 = loadImage("sample02.png");
}
void draw(){
  background(255);
  
  image(sample01, 100, 100);
  image(sample02, 100, 300);
}
