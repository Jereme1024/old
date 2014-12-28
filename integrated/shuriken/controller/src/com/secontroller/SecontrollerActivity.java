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
	  /*宣告ImageView變數*/
	  private ImageView mImageView01;
	  /*宣告相關變數作為儲存圖片寬高,位置使用*/
	  private int intWidth, intHeight, intDefaultX, intDefaultY;
	  private float mX, mY; 
	  private int picX,picY;
	  private float oldX,oldY;
	  private float dx,dy;
	  private int theta;
	  /*宣告儲存螢幕的解析度變數 */
	  private int intScreenX, intScreenY;
	  
	  private boolean isReseting;

	  private Handler handlerMoving = new Handler();
	  
	  private String address = "192.168.1.104";// 連線的ip
	  private int port = 1339;// 連線的port
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
	        mMakeTextToast("Socket連線有問題 !"+"IOException :" + e.toString(), false);
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
	    
	    /* 取得螢幕物件 */
	    DisplayMetrics dm = new DisplayMetrics(); 
	    getWindowManager().getDefaultDisplay().getMetrics(dm);
	    
	    /* 取得螢幕解析像素 */
	    intScreenX = dm.widthPixels;
	    intScreenY = dm.heightPixels;

	    /*透過findViewById建構子建立ImageView物件*/ 
	    mImageView01 =(ImageView) findViewById(R.id.myImageView1);
	    /*將圖片從Drawable指派給ImageView來呈現*/
	    mImageView01.setImageResource(R.drawable.dart);
	    
	    /* 設定圖片的寬高 */
	    intWidth = 250;
	    intHeight = 250;
	    
	    initSocket();
	    
	    /* 初始化按鈕位置置中 */
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
	  
	  
	  
	  
	  /*覆寫觸控事件*/
	  @Override
	  public boolean onTouchEvent(MotionEvent event) 
	  {
	    if(isReseting)
	      return false;
	    
	    /*取得手指觸控螢幕的位置*/
	    float x = event.getX();
	    float y = event.getY();
	    
	    try
	    {
	      /*觸控事件的處理*/
	      switch (event.getAction()) 
	      {
	        /*點選螢幕*/
	        case MotionEvent.ACTION_DOWN:
	          oldX=x;
	          oldY=y;
	          picMove(x, y,true);
	            break;
	        /*移動位置*/
	        case MotionEvent.ACTION_MOVE:
	          picMove(x, y,true);
	            break;
	        /*離開螢幕*/
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
	  
	  //固定要執行的方法
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
	  
	  
	  /*移動圖片的方法*/
	  private void picMove(float x, float y,boolean isTouch)
	  {      
	    if(isTouch){
	      /*預設微調圖片與指標的相對位置*/ 
	      mX=x-(intWidth/2);
	      mY=(float) (y-(intHeight/1.5));
	    }else{
	      mX=x;
	      mY=y;
	    }
	    
	    /* 以setLayoutParams方法，重新安排Layout上的位置 */
	    mImageView01.setLayoutParams
	    (
	      new AbsoluteLayout.LayoutParams(intWidth,intHeight,(int) mX,(int)mY)
	    );
	    
	    picX=(int) mX;
	    picY=(int) mY;
	  }
	  
	  /* 還原ImageView位置的事件處理 */
	  public void RestoreButton()
	  {
	    intDefaultX = (intScreenX-intWidth)/2+110;
	    intDefaultY = (intScreenY-intHeight)/2-60;
	    
	    /* 以setLayoutParams方法，重新安排Layout上的位置 */
	    mImageView01.setLayoutParams
	    (
	      new AbsoluteLayout.LayoutParams(intWidth,intHeight,intDefaultX,intDefaultY)
	    );
	    
	    picX=intDefaultX;
	    picY=intDefaultY;
	    
	    isReseting=false;
	  }
	  /*自訂一發出訊息的方法*/
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