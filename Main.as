package  {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	import src.*;
	
	public class Main extends MovieClip {
		//global variables accessable from anywhere by "Main.variableName"
		public static var bList:Vector.<Boundary> = new Vector.<Boundary>();		//list of boundaries
		public static var eList:Vector.<Entity> = new Vector.<Entity>();			//list of entities
		
		//world constants
		public static const WORLD_FRICTION:Number = 3;		//friction
		
		public function Main() {
			super();
			CreateLevel();
			
			this.addEventListener(Event.ENTER_FRAME, OnFrame);
		}
		private function CreateLevel():void {
			var i:int;		//loop counter
			
			for(i = 0; i < Main.bList.length; i++) {
				trace(Main.bList[i] + " #" + i);
				trace("Relative x: " + Main.bList[i].x);
				trace("Relative y: " + Main.bList[i].y);
				trace("Global x: " + Main.bList[i].g.x);
				trace("Global y: " + Main.bList[i].g.y);
				trace();
			}
			
			for(i = 0; i < Main.eList.length; i++) {
				trace(Main.eList[i] + " #" + i);
				trace("Relative x: " + Main.eList[i].x);
				trace("Relative y: " + Main.eList[i].y);
				trace("Global x: " + Main.eList[i].g.x);
				trace("Global y: " + Main.eList[i].g.y);
				trace();
			}
		}
		private function OnFrame(e:Event):void {
			var i:int;		//loop counter
			
			//activate onFrame events for boundaries
			for(i = 0; i < Main.bList.length; i++) {
				Main.bList[i].OnFrame(e);
			}
			
			//activate onFrame events for entities
			for(i = 0; i < Main.eList.length; i++) {
				Main.eList[i].OnFrame(e);
			}
		}
		
		
		
	}
}