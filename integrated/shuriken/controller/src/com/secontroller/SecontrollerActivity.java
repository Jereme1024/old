package com.secontroller;

import java.io.BufferedOutputStream;
import java.io.IOException;
import java.lang.Math;
import java.net.InetSocketAddress;
import java.net.Socket;

import android.app.Activity;
import android.os.Bundle;
import android.os.Handler;
import android.os.SystemClock;
/**/
import android.util.DisplayMetrics;
import android.view.MotionEvent;
import android.view.View;
import android.widget.AbsoluteLayout;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.Toast;

public class SecontrollerActivity extends Activity {
	  /*�ŧiImageView�ܼ�*/
	  private ImageView mImageView01;
	  /*�ŧi�����ܼƧ@���x�s�Ϥ��e��,��m�ϥ�*/
	  private int intWidth, intHeight, intDefaultX, intDefaultY;
	  private float mX, mY; 
	  private int picX,picY;
	  private float oldX,oldY;
	  private float dx,dy;
	  private int theta;
	  /*�ŧi�x�s�ù����ѪR���ܼ� */
	  private int intScreenX, intScreenY;
	  
	  private boolean isReseting;

	  private Handler handlerMoving = new Handler();
	  
	  private String address = "192.168.1.104";// �s�u��ip
	  private int port = 1339;// �s�u��port
	  Socket client;
	  InetSocketAddress isa;
	  BufferedOutputStream out;
	  
	  public void initSocket(){
	    
	    client = new Socket();
	    isa = new InetSocketAddress(this.address, this.port);
	      
	      try {
	        client.connect(isa, 10000);
	        out = new BufferedOutputStream(client.getOutputStream());
	      } catch (java.io.IOException e) {
	        mMakeTextToast("Socket�s�u�����D !"+"IOException :" + e.toString(), false);
	      }
	  }
	  
	  public void sendSocket(String msg){
	    try {
	      out.write(msg.getBytes());
	          out.flush();
	    } catch (java.io.IOException e) {
	      mMakeTextToast("sendSocket error!", false);
	      e.printStackTrace();
	    }
	        
	  }

	  public void destorySocket(){
	    try {
	      out.close();
	      out = null;
	    } catch (IOException e) {
	      mMakeTextToast("destorySocket error!", false);
	      e.printStackTrace();
	    }
	        
	  }
	    
	  
	  private Button btnExit;
	  /** Called when the activity is first created. */
	  @Override
	  public void onCreate(Bundle savedInstanceState)
	  {
	    super.onCreate(savedInstanceState); 
	    setContentView(R.layout.main);
	    
	    /* ���o�ù����� */
	    DisplayMetrics dm = new DisplayMetrics(); 
	    getWindowManager().getDefaultDisplay().getMetrics(dm);
	    
	    /* ���o�ù��ѪR���� */
	    intScreenX = dm.widthPixels;
	    intScreenY = dm.heightPixels;

	    /*�z�LfindViewById�غc�l�إ�ImageView����*/ 
	    mImageView01 =(ImageView) findViewById(R.id.myImageView1);
	    /*�N�Ϥ��qDrawable������ImageView�ӧe�{*/
	    mImageView01.setImageResource(R.drawable.dart);
	    
	    /* �]�w�Ϥ����e�� */
	    intWidth = 250;
	    intHeight = 250;
	    
	    initSocket();
	    
	    /* ��l�ƫ��s��m�m�� */
	    RestoreButton();
	        
	    handlerMoving.removeCallbacks(moving);
	    
	    btnExit=(Button)findViewById(R.id.btnExit);
	    btnExit.setOnClickListener(new Button.OnClickListener(){
	      public void onClick(View v){
	        sendSocket("exitprog\0");
	        destorySocket();
	        mMakeTextToast("exit",false);
	      }
	      
	    });
	  }
	  
	  
	  
	  
	  /*�мgĲ���ƥ�*/
	  @Override
	  public boolean onTouchEvent(MotionEvent event) 
	  {
	    if(isReseting)
	      return false;
	    
	    /*���o���Ĳ���ù�����m*/
	    float x = event.getX();
	    float y = event.getY();
	    
	    try
	    {
	      /*Ĳ���ƥ󪺳B�z*/
	      switch (event.getAction()) 
	      {
	        /*�I��ù�*/
	        case MotionEvent.ACTION_DOWN:
	          oldX=x;
	          oldY=y;
	          picMove(x, y,true);
	            break;
	        /*���ʦ�m*/
	        case MotionEvent.ACTION_MOVE:
	          picMove(x, y,true);
	            break;
	        /*���}�ù�*/
	        case MotionEvent.ACTION_UP:
	          picMove(x, y,true); 
	          dx=(x-oldX)/3;
	          dy=(y-oldY)/3;
	          
	          theta=(int) (Math.atan2(dy,dx)/Math.PI*180);
	          theta=theta*-1;
	          if(theta>0){
	            theta-=90;
	          }else{
	            theta+=270;
	          }
	          
	          handlerMoving.postDelayed(moving, 0);
	            break;
	      }
	    }catch(Exception e)
	      {
	        e.printStackTrace();
	      }
	    return true;
	  }
	  
	  //�T�w�n���檺��k
	  private Runnable moving = new Runnable() {
	      public void run() {
	          picMove(picX+dx, picY+dy,false);
	          
	          if(picX+intWidth+100 > 0 && picX < intScreenX+intWidth){
	            handlerMoving.postDelayed(this, 10);
	          }else{
	            isReseting=true;
	            
	            sendSocket("40,"+theta+"\0");
	            
	            SystemClock.sleep(1000);
	            RestoreButton();
	          }
	      }
	  };
	  
	  
	  /*���ʹϤ�����k*/
	  private void picMove(float x, float y,boolean isTouch)
	  {      
	    if(isTouch){
	      /*�w�]�L�չϤ��P���Ъ��۹��m*/ 
	      mX=x-(intWidth/2);
	      mY=(float) (y-(intHeight/1.5));
	    }else{
	      mX=x;
	      mY=y;
	    }
	    
	    /* �HsetLayoutParams��k�A���s�w��Layout�W����m */
	    mImageView01.setLayoutParams
	    (
	      new AbsoluteLayout.LayoutParams(intWidth,intHeight,(int) mX,(int)mY)
	    );
	    
	    picX=(int) mX;
	    picY=(int) mY;
	  }
	  
	  /* �٭�ImageView��m���ƥ�B�z */
	  public void RestoreButton()
	  {
	    intDefaultX = (intScreenX-intWidth)/2+110;
	    intDefaultY = (intScreenY-intHeight)/2-60;
	    
	    /* �HsetLayoutParams��k�A���s�w��Layout�W����m */
	    mImageView01.setLayoutParams
	    (
	      new AbsoluteLayout.LayoutParams(intWidth,intHeight,intDefaultX,intDefaultY)
	    );
	    
	    picX=intDefaultX;
	    picY=intDefaultY;
	    
	    isReseting=false;
	  }
	  /*�ۭq�@�o�X�T������k*/
	  public void mMakeTextToast(String str, boolean isLong)
	  {
	    if(isLong==true)
	    {
	      Toast.makeText(SecontrollerActivity.this, str, Toast.LENGTH_LONG).show();
	    }
	    else
	    {
	      Toast.makeText(SecontrollerActivity.this, str, Toast.LENGTH_SHORT).show();
	    }
	  }
}