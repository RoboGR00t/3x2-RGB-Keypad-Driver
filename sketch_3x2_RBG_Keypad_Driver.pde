import processing.serial.*;
Serial myPort;

import java.awt.AWTException;
import java.awt.Robot;
import java.awt.event.KeyEvent;
import java.awt.Event;

KeystrokeSimulator keySim;
HScrollbar red ,green,blue;

//Creating an object for the image
PImage logo , wings, king,rose,train,ao,ot;

//Creating a variable to store the background colour
int keyid=0;

int old_r = 0;
int old_g = 0;
int old_b = 0;


int rectX = 390, rectY = 10 ;      // Position of square button
int rectSize = 90;     // Diameter of rect
color rectColor, baseColor;
color rectHighlight;
color currentColor;
boolean rectOver = false;
int count = 0;
int modes = 3;
String mode_text[] = {"GENERIC","PLATFORM IO","PROTEUS","GIMP"}; 

void setup(){
  keySim = new KeystrokeSimulator(); 
 //Setting the colour mode. In this case we're useing HSB(HueSaturationBrightness). The hue will change while turning the potentiometer.
 
 //loading the image directly form the Internet
 logo=loadImage("./images/AoT.jpg");
 background(logo);
 wings=loadImage("./images/wings.png");
 king=loadImage("./images/king.png");
 rose=loadImage("./images/rose.png");
 train=loadImage("./images/train.png");
 ao=loadImage("./images/Ao.png");
 ot=loadImage("./images/oT.png");
 // you can use "size(logo.width,logo.height)" to automatically adjust the scale
 //if you have problems, adjust it manually:
 size(500,718);
 //Printing a list with all the serial ports your computer has when the program first starts.
 println("Available serial ports:");
 printArray(Serial.list());
 //Telling Processing information about the serial connection. The parameters are: which application will be speaking to, which serial port will be communicating(depending on the previous result), and at what speed.
   while(true){
    try {
      myPort=new Serial(this,Serial.list()[0],9600);
      break;
    } catch (Exception e) {
      System.out.println("Something went wrong.");
    }
   }
 
  red = new HScrollbar(130, 640, 255, 16, 16);
  green = new HScrollbar(130,670, 255, 16, 16);
  blue = new HScrollbar(130, 700, 255, 16, 16);
  
  fill(150);
  stroke(0);
  rect(390, 10, 90, 30, 10); 
  fill(0);
  textSize(10);
  //textFont(createFont("Georgia",10));
}
//Analog function to void loop() in Arduino
void draw(){
 //Reading Arduino data from the serial port
   
 //stroke(255,255,255);
 //strokeWeight(10);
 //rect(200,300,40,40);
 text(mode_text[count],400,30);
 
 if(myPort.available()>0){
    keyid=myPort.read();
    switch(count){
       case 0:
           generic(keyid);
           break;
       case 1:
           platformio(keyid);
           break;
       case 2:
           proteus(keyid);
           break;
       case 3:
           gimp(keyid);
           break;           
    }

   println(keyid);
 }

red.update();
green.update();
blue.update();
int r = int(red.getPos())-140;
int g = int(green.getPos())-140;
int b = int(blue.getPos())-140;

stroke(255,0, 0);
red.display();
stroke(0,255, 0);
green.display();
stroke(0,0, 255);
blue.display();
   
 if(old_r != r){
 for(int i = 0; i <  5; i++){
    myPort.write(255);
    delay(2);
    myPort.write(int(red.getPos())-140);
    old_r = r;
 }
}
 
 if(old_g != g){
  for(int i = 0; i < 5; i++){
    myPort.write(254);
    delay(2);
    myPort.write(int(green.getPos())-140);
    old_g = g;
  }
 }
 
  if(old_b != b){
    for(int i = 0; i < 5; i++){
      myPort.write(253);
      delay(2);
      myPort.write(int(blue.getPos())-140);
      old_b = b;
    }
 }
 
 
 fill(int(red.getPos()-130),int(green.getPos()-130),int(blue.getPos()-130));
 stroke(0);
 rect(100, 400, 320, 220, 28); 
  
 fill(0);
 rect(110, 410, 300,200, 20);
 image(ao,130, 430);
 image(train,225, 430);
 image(wings,320, 430);
 image(ot,130, 515);
 image(rose,225, 515);
 image(king,320, 515);
 
  update(mouseX, mouseY);
}

import java.awt.Robot;
import java.awt.AWTException;

public class KeystrokeSimulator {

private Robot robot;
  
  KeystrokeSimulator(){
    try{
      robot = new Robot();  
    }
    catch(AWTException e){
      println(e);
    }
  }
  
  void press(int c) throws AWTException {
      robot.keyPress(c);
  }
  
  void release(int c) throws AWTException {
      robot.keyRelease(c);
  }

  
}



class HScrollbar {
  int swidth, sheight;    // width and height of bar
  float xpos, ypos;       // x and y position of bar
  float spos, newspos;    // x position of slider
  float sposMin, sposMax; // max and min values of slider
  int loose;              // how loose/heavy
  boolean over;           // is the mouse over the slider?
  boolean locked;
  float ratio;

  HScrollbar (float xp, float yp, int sw, int sh, int l) {
    swidth = sw;
    sheight = sh;
    int widthtoheight = sw - sh;
    ratio = (float)sw / (float)widthtoheight;
    xpos = xp;
    ypos = yp-sheight/2;
    spos = xpos + swidth/2 - sheight/2;
    newspos = spos;
    sposMin = xpos;
    sposMax = xpos + swidth - sheight;
    loose = l;
  }

  void update() {
    if (overEvent()) {
      over = true;
    } else {
      over = false;
    }
    if (mousePressed && over) {
      locked = true;
    }
    if (!mousePressed) {
      locked = false;
    }
    if (locked) {
      newspos = constrain(mouseX-sheight/2, sposMin, sposMax);
    }
    if (abs(newspos - spos) > 1) {
      spos = spos + (newspos-spos)/loose;
    }
  }

  float constrain(float val, float minv, float maxv) {
    return min(max(val, minv), maxv);
  }

  boolean overEvent() {
    if (mouseX > xpos && mouseX < xpos+swidth &&
       mouseY > ypos && mouseY < ypos+sheight) {
      return true;
    } else {
      return false;
    }
  }

  void display() {
    //noStroke();
    fill(204);
    rect(xpos, ypos, swidth, sheight);
    if (over || locked) {
      fill(0, 0, 0);
    } else {
      fill(102, 102, 102);
    }
    rect(spos, ypos, sheight, sheight);
  }

  float getPos() {
    // Convert spos to be values between
    // 0 and the total width of the scrollbar
    return spos * ratio;
  }
}



void update(int x, int y) {
  if ( overRect(rectX, rectY, rectSize, 30) ) {
    rectOver = true;
  }
  else {
    rectOver = false;
  }
}

void mousePressed() {
  if (rectOver) {
    fill(150);
    stroke(0);
    rect(390, 10, 90, 30, 10); 
    count++;
    if(count > modes){
      count = 0;
    }
    println(count);
  }
}

boolean overRect(int x, int y, int width, int height)  {
  if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}


void generic(int keyid){
     try{
        
        switch(keyid) {
          case 1: 
                /*CTRL+A*/
                keySim.press(17);
                keySim.press(65);
                keySim.release(65);
                keySim.release(17);
            break;
          case 2: 
                /*CTRL+C*/
                keySim.press(17);
                keySim.press(67);
                keySim.release(67);
                keySim.release(17);            
                break;
          case 3: 
                /*CTRL+V*/          
                keySim.press(17);
                keySim.press(86);
                keySim.release(86);
                keySim.release(17); 
                break;
            case 4: 
                /*CTRL+X*/          
                keySim.press(17);
                keySim.press(88);
                keySim.release(88);
                keySim.release(17); 
                break;            
          case 5: 
                /*CTRL+Z*/          
                keySim.press(17);
                keySim.press(90);
                keySim.release(90);
                keySim.release(17); 
                break;             
    
          case 6: 
                /*CTRL+S*/          
                keySim.press(17);
                keySim.press(83);
                keySim.release(83);
                keySim.release(17); 
                break;               
        }
      }
      catch(AWTException e){
    println(e);
  }

}



void platformio(int keyid){
     try{
        
        switch(keyid) {
          case 1: 
                /*CTRL+ALT+B COMPLITE*/
                keySim.press(17);
                keySim.press(18);
                keySim.press(66);
                keySim.release(66);
                keySim.release(18);
                keySim.release(17);
            break;
          case 2: 
                /*CTRL+ALT+U UPLOAD*/
                keySim.press(17);
                keySim.press(18);
                keySim.press(85);
                keySim.release(85);
                keySim.release(18);
                keySim.release(17);           
                break;
          case 3: 
                /*CTRL+ALT+C CLEAN*/
                keySim.press(17);
                keySim.press(18);
                keySim.press(67);
                keySim.release(67);
                keySim.release(18);
                keySim.release(17);
                break;
            case 4: 
                /*CTRL+TAB TOGGLE*/
                keySim.press(17);
                keySim.press(9);
                keySim.release(9);
                keySim.release(17); 
                break;            
          case 5: 
                /*ALT+SHIFT+M SERIAL*/
                keySim.press(18);
                keySim.press(16);
                keySim.press(77);
                keySim.release(77);
                keySim.release(16);
                keySim.release(18);
                break;             
    
          case 6: 
                /*ALT+SHIFT+T TERMINAL*/
                keySim.press(18);
                keySim.press(16);
                keySim.press(84);
                keySim.release(84);
                keySim.release(16);
                keySim.release(18);
                break;               
        }
      }
      catch(AWTException e){
    println(e);
  }

}


void proteus(int keyid){
     try{
        
        switch(keyid) {
          case 1: 
                /*CTRL+C ENTER*/
                keySim.press(17);
                keySim.press(67);
                keySim.release(67);
                keySim.release(17);            
                break;
          case 2: 
                /*CTRL+X EXIT*/
                keySim.press(17);
                keySim.press(88);
                keySim.release(88);
                keySim.release(17);         
                break;
          case 3: 
                /*O Origin*/          
                keySim.press(79);
                keySim.release(79);
                break;
            case 4: 
                /*CTRL+M MIRROR*/          
                keySim.press(17);
                keySim.press(77);
                keySim.release(77);
                keySim.release(17); 
                break;            
          case 5: 
                /*CTRL+E EDIT*/          
                keySim.press(17);
                keySim.press(69);
                keySim.release(69);
                keySim.release(17); 
                break;             
    
          case 6: 
                /*CTRL+Z UNDO*/          
                keySim.press(17);
                keySim.press(90);
                keySim.release(90);
                keySim.release(17); 
                break;               
        }
      }
      catch(AWTException e){
    println(e);
  }

}


void gimp(int keyid){
     try{
        switch(keyid) {
          case 1: 
                /*CTRL+O OPEN*/
                keySim.press(17);
                keySim.press(79);
                keySim.release(79);
                keySim.release(17);
            break;
          case 2: 
                /*CTRL+SHIFT+E EXPORT*/
                keySim.press(17);
                keySim.press(16);
                keySim.press(69);
                keySim.release(69);
                keySim.release(16);            
                keySim.release(17);            
                break;
          case 3: 
                /*CTRL+ALT+O OPEN AS LAYER*/          
                keySim.press(17);
                keySim.press(18);
                keySim.press(79);
                keySim.release(79);
                keySim.release(18); 
                keySim.release(17); 
                break;
            case 4: 
                /*SHIFT+CTRL+A SELECT NONE*/          
                keySim.press(16);
                keySim.press(17);
                keySim.press(65);
                keySim.release(65);
                keySim.release(17);
                keySim.release(16);
                break;            
          case 5: 
                /*CTRL+I SELECT INVERT*/          
                keySim.press(17);
                keySim.press(73);
                keySim.release(73);
                keySim.release(17); 
                break;             
    
          case 6: 
                /*SHIFT+O SELECT BY COLOR*/          
                keySim.press(16);
                keySim.press(79);
                keySim.release(79);
                keySim.release(16); 
                break;               
        }
      }
      catch(AWTException e){
    println(e);
  }

}
