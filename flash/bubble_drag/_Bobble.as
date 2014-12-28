package{
	import flash.display.*;
	import flash.events.*;
	
	public class _Bobble extends MovieClip{
		
		const moveRatio:Number=0.05;
		var dx:Number,dy:Number,theta:Number;
		
		function _Bobble(ix:Number,iy:Number){
			x=ix;
			y=iy;
			addEventListener(Event.ENTER_FRAME,move); //加入移動
		}
		
		function move(event:Event){
			dx=stage.mouseX-x; //目標與滑鼠x距離
			dy=stage.mouseY-y;
			theta=Math.atan2(dy,dx);
			rotation=theta/Math.PI*180;
			x+=dx*moveRatio; //水平移動分量
			y+=dy*moveRatio;			
			
			if(parent!=null&&MovieClip(parent).currentFrame==3) //跳到場景三自動移除
				remove();
		}
		
		public function hitTest(obj):Boolean{ //碰撞測試
			return getChildByName("bobbArea").hitTestObject(obj.getChildByName("ballArea"));
		}
		
		function remove(){
			removeEventListener(Event.ENTER_FRAME,move);
			parent.removeChild(this);
		}
	}
}