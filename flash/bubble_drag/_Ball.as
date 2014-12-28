package{
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;
	
	public class _Ball extends MovieClip{
		
		var speed:int; //速度
		var theta:Number; //徑度
		var angle:Number; //角度
		var vx:Number,vy:Number; //移動分量
		var frame:int;
		static const totalframes=6; //_Ball總影格
		const SU=0.5; //速度增加量
		var speedupTimer:Timer; //加速計時器
		function _Ball(ix:Number=620,iy:Number=450,itheta:Number=0,ispeed:int=0,iframe:int=7){
			x=ix;
			y=iy;
			speed=ispeed;
			theta=itheta;
			angle=theta/180*Math.PI;
			rotation=angle;
			frame=iframe;
			if(iframe==7){
				randCol();
			}
			
			gotoAndStop(frame); //隨機選取顏色(影格)
			speedupTimer=new Timer(5000,5);
			speedupTimer.addEventListener(TimerEvent.TIMER,speedup); //每5000ms加速 共5次
			speedupTimer.start();
			
			addEventListener(Event.ENTER_FRAME,move); //加入移動
		}
		
		function move(event:Event){
			
			
			moving();
			
			if(MovieClip(parent).bobble.hitTest(this)){ //是否與Bobble碰撞
				MovieClip(parent).GameOver();
				//MovieClip(parent).gotoAndStop(3);
			}
			if(MovieClip(parent).bullets.hitTest(this)){ //是否與子彈碰撞
				//trace("HIT!!");
				MovieClip(parent).bullets.onHit(this); //呼叫Bullet的onHit
			}
			if(parent!=null&&MovieClip(parent).currentFrame==3) //跳到場景三自動移除
				remove();
		}
		
		function moving(){
			vx=speed*Math.cos(theta);
			vy=speed*Math.sin(theta);
			x+=vx;
			y+=vy;
			rotation+=speed;
			
			//-----邊界反彈
			if((x+width/2)>stage.stageWidth){
				x=stage.stageWidth-width/2; //新x位置
				theta=Math.PI-theta; //反彈後角度
			}
			if((x-width/2)<0){
				x=width/2;
				theta=Math.PI-theta;
			}
			if((y+height/2)>stage.stageHeight){
				y=stage.stageHeight-height/2; //新y位置
				theta=-theta; //反彈後角度
			}
			if((y-height/2)<0){
				y=height/2;
				theta=-theta;
			}
			//-----
		}
		
		function speedup(event:TimerEvent){ //增加速度
			if(vx>0) vx+=SU;
			else vx-=SU;
			if(vy>0) vy+=SU;
			else vy-=SU;
		}
		
		public function randCol(){ //變換隨機顏色
			frame=Math.floor(Math.random()*totalframes)+1;
			gotoAndStop(frame);
		}
		
		public function hitTest(obj):Boolean{ //碰撞測試
			return getChildByName("ballArea").hitTestObject(obj.getChildByName("ballArea"));
		}
		public function remove(){ //移除
			speedupTimer.removeEventListener(TimerEvent.TIMER,speedup);
			removeEventListener(Event.ENTER_FRAME,move);
			parent.removeChild(this);
		}
		
	}
}