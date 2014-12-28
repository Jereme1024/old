class target{
PImage pic;
PImage picx;

int px=(int)random(300)+(int)random(300)-100,py=(int)random(250)+400;
float sx=px,sy=py-1;
int half=0;
float ler=0.0;
float sz=150;
int ward=(int)random(2);
int speed=(int)random(2);
boolean shoot=false;
int num;
void exe()
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
    image(picx,sx,sy,sz,sz);
  }
  else{
    px=(int)random(600);
    py=(int)random(100)+300;
    ward=(int)random(2);
    speed=(int)random(2);
    ler=0.0;
    half=0;
    shoot=false;
    picx=pic;
  }
  if(bull){
    if(mousePressed){
      if(mouseX>=sx && mouseX<=sx+lerp(sx,100,1-ler) && mouseY>=sy && mouseY<=sy+lerp(sx,100,1-ler)){
        //println("shoot!");
        picx=die;
        if(!shoot){
          i--;
          if(num==n){
            score-=31;
          }else{
          if(half!=0)
            score+=23;
          else
            score+=16;
          }
        }
         shoot=true;
      }
    }
  }
}
}
