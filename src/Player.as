package src {
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import src.Boundary;
	import src.Entity;
	
	public class Player extends src.Entity {
		
		//constructor
		public function Player() {
			super();
			
			this.addEventListener(Event.ADDED_TO_STAGE,this.OnPlayerAddedToStage);			
			
		}
		
		//onStageAdd
		private function OnPlayerAddedToStage(e:Event):void {
			//initialize stage children used by parent class
			set_b(get_b());
			
			//run parent class
			super.OnEntityAddedToStage(e);
		}
		
		//getters for children 
		private function get_b():Boundary {
			return this.getChildByName("boundary") as Boundary;
		}
		
		
		
	}
}