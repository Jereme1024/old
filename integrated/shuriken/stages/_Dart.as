package{
	import flash.display.*;
	import flash.events.*;
	
	//飛鏢類別
	public class _Dart extends MovieClip{

		var speed:Number;
		var theta:Number;
		var angle:Number;

		const stageWidth=1280;
		const stageHeight=720;
		const mid=1280/2;

		//控制參數: 度度, 角度
		function _Dart(ispeed:Number,itheta:Number){
			
			x=mid;
			y=stageHeight;
			
			theta=itheta;
			angle=theta/180*Math.PI;
			speed=ispeed;
	
			rotationX=-65;
			
			addEventListener(Event.ENTER_FRAME,moving);

		}
		
		function moving(event:Event){
			//trace(Math.cos(theta));
			
			x+=speed*Math.cos(angle);
			y-=speed*Math.sin(angle);
		}
		
		public function hitTest(obj):Boolean{ //碰撞測試
			if(obj.getChildByName("HitArea")==null) return false;
			return getChildByName("HitArea").hitTestObject(obj.getChildByName("HitArea"));
		}
		
		function remove(){
			removeEventListener(Event.ENTER_FRAME,moving);
			parent.removeChild(this);
		}
	}
}