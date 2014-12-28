package {
	import flash.display.*;
	import flash.events.*;

	public class _Button extends MovieClip {
		var where:int;
		function _Button(input:int,ix:int=410,iy:int=300) {
			x=ix;
			y=iy;
			where=input;
			buttonMode=true;

			addEventListener(MouseEvent.MOUSE_UP,start);
			addEventListener(MouseEvent.MOUSE_OVER,mover);
			addEventListener(MouseEvent.MOUSE_OUT,mout);
		}

		function start(event:MouseEvent) {
			MovieClip(parent).gotoAndStop(where);
			remove();
		}
		function mover(event:MouseEvent) {
			gotoAndStop(2);
		}
		function mout(event:MouseEvent) {
			gotoAndStop(3);
		}
		
		function remove(){
			removeEventListener(MouseEvent.MOUSE_UP,start);
			removeEventListener(MouseEvent.MOUSE_OVER,mover);
			removeEventListener(MouseEvent.MOUSE_OUT,mout);
			MovieClip(parent).removeChild(this);
		}
		
	}
}