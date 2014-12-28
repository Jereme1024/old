import krister.Ess.*;
//AudioChannel main,btn,playing,re,win;//bye,shot
//AudioChannel nowplay;
public int manu=0;
public int score=0;
public int bullets=10;
public boolean bull=false;
public boolean gsec=true;
boolean play=false;
int sec=60;
PImage start0,start1,start2,start3;
PImage quit;
PImage backward,forward;
PImage gun0,gun1;
PImage sc,sc0,sc1;
PImage he,he0,he1;
PImage die;

target ta1,ta2,ta3,ta4,ta5;
//========================================================================================
void setup()
{
  size(800,600);
  Ess.start(this);
  start0=loadImage("start0.jpg");start1=loadImage("start1.jpg");start2=loadImage("start2.jpg");start3=loadImage("start3.jpg");
  quit=loadImage("quit.jpg");
  backward=loadImage("backward.jpg");forward=loadImage("forward.gif");
  gun0=loadImage("gun0.gif");gun1=loadImage("gun1.gif");
  die=loadImage("die.gif");
  sc=loadImage("sc.jpg");sc0=loadImage("sc0.jpg");sc1=loadImage("sc1.jpg");
  he=loadImage("he.jpg");he0=loadImage("he0.jpg");he1=loadImage("he1.jpg");
  PFont fontA = loadFont("Ziggurat-HTF-Black-32.vlw");
  textFont(fontA, 20);
  
  //main=new AudioChannel("main.wav");btn=new AudioChannel("btn.wav");
  //playing=new AudioChannel("playing.wav");re=new AudioChannel("re.wav");win=new AudioChannel("win.wav");
  //bye=new AudioChannel("bye.wav");shot=new AudioChannel("shot.wav");
  
  
  ta1=new target();ta2=new target();ta3=new target();ta4=new target();ta5=new target();
  ta1.num=1;ta2.num=2;ta3.num=3;ta4.num=4;ta5.num=5;
  ta1.pic=loadImage("t1.gif");ta2.pic=loadImage("t2.gif");ta3.pic=loadImage("t3.gif");ta4.pic=loadImage("t4.gif");ta5.pic=loadImage("t5.gif");
  ta1.picx=loadImage("t1.gif");ta2.picx=loadImage("t2.gif");ta3.picx=loadImage("t3.gif");ta4.picx=loadImage("t4.gif");ta5.picx=loadImage("t5.gif");
}
//========================================================================================
void draw()
{
  /*if(keyPressed) {
    if (key == 't' || key == 'T') {
      println(mouseX+" "+mouseY);
    }
  }*/
  //sound();
  if(manu==0){
    if(mouseX>280 && mouseX<520){
      if(mouseY>240 && mouseY<285){
        image(start1,0,0);
        if(mousePressed){
          manu=1;
          bullets=10;
          play=false;
          //nowplay.stop();
          //btn.play();
	  PFont fontA = loadFont("Ziggurat-HTF-Black-32.vlw");
  	  textFont(fontA, 20);
        }
      }
      else if(mouseY>350 && mouseY<395){
        image(start2,0,0);
        if(mousePressed){
          manu=2;
          //btn.play();
        }
      }
      else if(mouseY>450 && mouseY<495){
        image(start3,0,0);
        if(mousePressed){
          manu=3;
          //btn.play();
        }
      }
      else  image(start0,0,0);
    }
    else  image(start0,0,0);
  }
  else if(manu==1){
    if(gsec){
      image(backward,0,0);
      //tar1();
      ta1.exe();ta2.exe();ta3.exe();ta4.exe();ta5.exe();
      view2();
      gun();
      shooter();
      if(bullets>0)  bull=true;
      else bull=false;
      time();
    }
    else{
      sco();
      //nowplay.stop();
      //win.play();
    }
  }
  else if(manu==2){
    image(he,0,0);
    if(mouseX>515 && mouseX<740){
      if(mouseY>50 && mouseY<100){
        image(he1,0,0);
        if(mousePressed){
          manu=1;
          bullets=10;
          play=false;
          //nowplay.stop();
          //btn.play();
          PFont fontA = loadFont("Ziggurat-HTF-Black-32.vlw");
  	  textFont(fontA, 20);
        }
      }
      else if(mouseY>160 && mouseY<210){
        image(he0,0,0);
        if(mousePressed){
          manu=0;
          //btn.play();
        }
      }
    }
  }
  else{
    image(quit,0,0);  
  }  
  
}
//========================================================================================
void sound(){
  if(manu==0||manu==2){
    if(!play){
      //nowplay=main;
      play=true;
      //nowplay.play(Ess.FOREVER);
    }
  }else if(manu==1){
    if(!play){
      //nowplay=playing;
      play=true;
      //nowplay.play(Ess.FOREVER);
    }
  }else{
    ;//nowplay.stop();
  }
    
}
//========================================================================================
public int i=4;
int n=(int)random(5)+1;
color c=color(0);
void shooter(){
  smooth();
  strokeWeight(3);   
  stroke(c);
  noFill();
  ellipse(mouseX,mouseY,50,50);
  if(i>=4){
    line((mouseX-35),mouseY,(mouseX-15),mouseY);
    line(mouseX+35,mouseY,mouseX+15,mouseY);
    line(mouseX,mouseY-35,mouseX,mouseY-15);
    line(mouseX,mouseY+35,mouseX,mouseY+15);
  }else if(i==3){
    line((mouseX-35),mouseY,(mouseX-15),mouseY);
    line(mouseX+35,mouseY,mouseX+15,mouseY);
    line(mouseX,mouseY+35,mouseX,mouseY+15);
  }else if(i==2){
    line((mouseX-35),mouseY,(mouseX-15),mouseY);
    line(mouseX,mouseY+35,mouseX,mouseY+15);
  }else if(i==1){
    line((mouseX-35),mouseY,(mouseX-15),mouseY);
  }else{
    c=color(random(255),random(255),random(255));
    n=(int)random(5)+1;
    i=4;
  }
    
}
//========================================================================================
void mousePressed(){
  if(bull){
   bullets--;
  } 
   
}
void keyPressed() {
  if (key == 'r' || key == 'R') {
    if(!bull){
      bullets=10;
      //re.play();
    }
  }
}
//========================================================================================
void view2(){
  fill(0);
  noStroke();
  rect(650,0,150,600);
  image(forward,0,390);
  fill(255);
  text("Time left", 655, 150);
  text(sec+"sec", 655, 180);  
  text("Score", 655, 250);
  text(score, 655, 280);  
  text("Bullets", 655, 350);
  if(bull)  text(bullets, 655, 380); 
  else  text("Press 'R'", 655, 380); 
  if(n==1)  image(ta1.pic,655,20,100,100);
  else if(n==2)  image(ta2.pic,655,20,100,100);
  else if(n==3)  image(ta3.pic,655,20,100,100);
  else if(n==4)  image(ta4.pic,655,20,100,100);
  else if(n==5)  image(ta5.pic,655,20,100,100);
  
}
//========================================================================================
void sco(){
  image(sc,0,0);
  if(mouseY>530 && mouseY<565){
    if(mouseX>545 && mouseX<770){
      image(sc0,0,0);
      if(mousePressed){  
        manu=3;
        //btn.play();
      }
    }
    else if(mouseX>285 && mouseX<515){
      image(sc1,0,0);
      if(mousePressed){
        manu=0;
        //btn.play();
        sec=60;
        score=0;
        gsec=true;
      }
    }
  }
  PFont fontA = loadFont("Ziggurat-HTF-Black-32.vlw");
  textFont(fontA, 40);
  fill(0);
  text("Time UP!!!", 300, 300);
  text("Score", 300, 400);
  text(score, 300, 500);  
}
//========================================================================================
int st1=0,st2=0;
boolean timeget=false;

void time(){
  if(!timeget){
    st1=second()+10;
    st2=st1;
    timeget=true;

  }else{
    st2=second()+10;
  }

  if(st2!=st1){
    sec--;
    timeget=false;
  }
  if(sec>0)  gsec=true;
  else gsec=false;
}
//========================================================================================
int flag=0;
void gun(){
  if(mousePressed && bull){
    image(gun1,mouseX+160,300);
  }
  else  image(gun0,mouseX+200,400);
}
//========================================================================================
/*int px=(int)random(600)-100,py=(int)random(200)+300;
float sx=px,sy=py-1;
int half=0;
float ler=0.0;
float sz=150;
int ward=(int)random(2);
int speed=(int)random(2);
boolean shoot=false;
void tar1()
{
  
  if(ler<1){
    if(ward==0)  sx=lerp(px,px+200,ler);
    else sx=lerp(px,px-200,ler);
    if(half==0){
      sy-=3;
      if(sy<=100)  half=1;
    }else{
      sy+=3;
    }
    if(speed==1)  ler+=0.01;
    else if(speed==0) ler+=0.005;
    sz=lerp(150,50,ler);
    image(t1,sx,sy,sz,sz);
  }
  else{
    px=(int)random(600);
    py=(int)random(100)+300;
    ward=(int)random(2);
    speed=(int)random(2);
    ler=0.0;
    half=0;
    shoot=false;
    t1=loadImage("t1.gif");
  }
  if(bull){
    if(mousePressed){
      if(mouseX>=sx && mouseX<=sx+lerp(sx,100,1-ler) && mouseY>=sy && mouseY<=sy+lerp(sx,100,1-ler)){
        println("shoot!");
        t1=die;
        if(!shoot){
          if(half!=0)
            score+=23;
          else
            score+=16;
        }
         shoot=true;
      }
    }
  }
}*/
public void stop() {
  Ess.stop();
  super.stop();
}
