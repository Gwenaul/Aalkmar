import fullscreen.*;
import japplemenubar.*;
import processing.video.*;
import processing.serial.*;
import cc.arduino.*;

FullScreen fs;

Movie myMovie;
Arduino arduino;

int last = 0;
int m = 0;

void setup() {

  size(720, 576, P2D);
  fs = new FullScreen(this);
  fs.enter(); 
  background(0);
  myMovie = new Movie(this, "videomoulin.mov");
  myMovie.play();
  
  arduino = new Arduino(this, Arduino.list()[1],57600);
  arduino.pinMode(13, Arduino.OUTPUT); //correspond à enable 1 du H-Bridge
  arduino.pinMode(11, Arduino.OUTPUT); //correspond à input 1 du H-Bridge
  arduino.pinMode(8, Arduino.OUTPUT); //correspond à input 2 du H-Bridge
  arduino.pinMode(7, Arduino.INPUT);  //correspond au contact a bille 1
  arduino.pinMode(10, Arduino.INPUT);   //correspond au contact à bille 2
 
}

void draw(){
  
  m=millis()-last;
  image(myMovie, 0, 0);
  println(m);
  
  println(arduino.digitalRead(7));
  println(-arduino.digitalRead(10));

  if(m >=34500 && m <=55000){
    if(arduino.digitalRead(7)== Arduino.HIGH){
      arduino.digitalWrite(13,Arduino.LOW);  
    }
    else if(arduino.digitalRead(7)== Arduino.LOW){
      arduino.digitalWrite(13,Arduino.HIGH);
      arduino.digitalWrite(11,Arduino.HIGH);
      arduino.digitalWrite(8,Arduino.LOW); 
    }
  }
  
  if(m >=78000 && m <=90000){ 
    if(arduino.digitalRead(10) == Arduino.HIGH){
      arduino.digitalWrite(13,Arduino.LOW);  
    }
    else if(arduino.digitalRead(10) == Arduino.LOW){
      arduino.digitalWrite(13,Arduino.HIGH);     
      arduino.digitalWrite(11,Arduino.LOW);
      arduino.digitalWrite(8,Arduino.HIGH);  
    }  
   }
  
  if(millis() > last+110000){
    last = millis();
    myMovie.jump(0);

  }
}
