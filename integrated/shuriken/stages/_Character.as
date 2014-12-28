package{
	import flash.display.*;
	import flash.events.*;
	
	//人物類別
	public class _Character extends MovieClip{
		const stageHeight=720;
		const g=0.98;
		var vx:Number;
		var vy:Number;
		var isAlive:Boolean;
		var role:int;
		const roleNumber=8;
		
		function _Character(ix:Number,iRole:int){
			isAlive=true;
			
			y=720;
			x=ix;
			
			vx=Math.random()*20-10;
			vy=-1*(Math.random()*10-5+30);
			
			var ratio=Math.random()*0.5+0.4;

			height*=ratio;
			width*=ratio;
			
			//如果方向往左 則圖片水平翻轉180度
			if(vx>0)
				rotationY=180;
						
			role=iRole;
			gotoAndStop(role);
			addEventListener(Event.ENTER_FRAME,moving);
		}
		
		function moving(event:Event){
			x+=vx;
			y+=vy;
			
			vy+=g;
			
			if(MovieClip(parent).dart!=null){
				if(MovieClip(parent).dart.hitTest(this))
					onHit();
					//trace("Hit");
			}
			
			if(y>750 && parent!=null) 
				remove();
		}
		
		function onHit(){
			if(isAlive==true){
				role+=roleNumber;
				gotoAndStop(role);
				alpha=0.6;
				MovieClip(parent).score++;
				MovieClip(parent).scoreView.text=MovieClip(parent).score;
			}
			isAlive=false;
		}
		
		function remove(){
			//trace("Remove:"+this);
			removeEventListener(Event.ENTER_FRAME,moving);
			parent.removeChild(this);
		}
	}
}