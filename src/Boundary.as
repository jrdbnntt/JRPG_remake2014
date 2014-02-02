package src {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class Boundary extends MovieClip {
		private var bIndex:int;							//the index of this in bList
		
		private var canMove:Boolean = false;
		
		public function Boundary() {
			super();
			
			Main.bList.push(this);
			this.bIndex = Main.bList.length - 1;
			
		}	
		
		public function OnFrame(e:Event):void {
			
		}
		
		//get global point g, relative to stage
		public function get g():Point {
			return this.localToGlobal(new Point());
		}
		public function get BIndex():int {
			return this.bIndex;
		}
	}
}