package{
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;
	import _Ball;
	
	public class _Bullet extends _Ball{
		
		var isShoot:Boolean=false; //是否為發射
		const distance:int=50; //與Bobble距離
		
		//function _Ball(ix:Number=600,iy:Number=400,itheta:Number=0,ispeed:int=0,iframe:int=7){
		function _Bullet(){
			//trace(this);
		}
		
		override function move(event:Event){			
			if(this!=null){
				switch(this.isShoot){
					case false: //尚未發射,跟隨Bubble
						following();
						break;
					case true: //發射後,水球移動方式moving()
						moving();
						break;
					default:
						break;
				}
			}
			
			if((MovieClip(parent).b2Area!=null)&&(hitTestObject(MovieClip(parent).b2Area))&&(isShoot)){ //攻擊Bobble2
				MovieClip(parent).minBlood(); //减血
				newBullet(); //填充子彈
				remove(); //移除自己
			}

			if(parent!=null&&MovieClip(parent).currentFrame==3){ //跳到場景三自動移除
				switch(this.isShoot){
					case true:
						timer.stop();
						timer.removeEventListener(TimerEvent.TIMER,loading);
					default:
						remove();
				}
			}
		}
		
		function following(){ //跟隨Bobble
			x=MovieClip(parent).bobble.x+distance*Math.cos(MovieClip(parent).bobble.theta);
			y=MovieClip(parent).bobble.y+distance*Math.sin(MovieClip(parent).bobble.theta);
		}
		
		
		var timer:Timer //發射存在時間計時器
		
		public function toShoot(){ //發射(由stage 偵測mouse_down呼叫此函數)
			if(!isShoot){ //避免重複執行裡面
				isShoot=true;
				timer=new Timer(1000,1);
				timer.addEventListener(TimerEvent.TIMER,loading); 
				timer.start();
				//-----moving()用參數
				speed=20;
				theta=MovieClip(parent).bobble.theta;
				//------
			}
		}
		
		function loading(event:TimerEvent){ //after 1000ms,沒射到物體
			isShoot=false;
			parent.addChild(new _Ball(x,y,theta,3,currentFrame)); //新增一個水球在stage(原本子彈變成水球)
			newBullet(); //填充子彈
			remove(); //進行此子彈移除
		}
		
		public function onHit(obj){ //當球碰到子彈呼叫此函數 此函數進行解構該球
			if(isShoot&&(obj.currentFrame==this.currentFrame)){ //判斷是否為發射的子彈,同顏色
				MovieClip(parent).addScore(); //加分
				obj.remove(); //移除目標
				newBullet(); //填充子彈
				remove(); //移除自己
			}
		}
		
		function newBullet(){
			timer.stop();
			timer.removeEventListener(TimerEvent.TIMER,loading);
			MovieClip(parent).bullets=parent.addChild(new _Bullet()); //stage的變數bullets指向新子彈
			MovieClip(parent).bullets.randCol();//變色
		}
		
//		override public function remove(){				
//			speedupTimer.removeEventListener(TimerEvent.TIMER,speedup);
//			removeEventListener(Event.ENTER_FRAME,move); 
//			parent.removeChild(this);
//		}		
		
	}
}