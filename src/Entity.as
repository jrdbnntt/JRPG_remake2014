/* Classes.Entity

Base class for objects put on screen.
Modifiable properties:
-movement keys
-acceleration magnitude + direction
-velocity magnitude + direction
-x position
-y position
-boundaries on/off
*/
package src {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
	public class Entity extends MovieClip {
		//option flags
		private var boundaryOn:Boolean = true;
		private var canMove:Boolean = true;
		
		//movement flags
		private var leftKeyDown:Boolean = false;		//left key is down
		private var rightKeyDown:Boolean = false;		//right key is down
		private var upKeyDown:Boolean = false;			//up key is down
		private var downKeyDown:Boolean = false;		//down key is down
		
		//movement keys (must be in uppercase)
		private var leftKey:uint = Keyboard["A"];		//left key
		private var rightKey:uint = Keyboard["D"];		//right key
		private var upKey:uint = Keyboard["W"];			//up key
		private var downKey:uint = Keyboard["S"];		//down key
		
		//velocity 
		private var vx:Number = 0;						//x velocity
		private var vy:Number = 0;						//y velocity
		private var a:Number = Main.WORLD_FRICTION*3;	//base component acceleration 
		private var maxComponentSpeed = 15;				//max speed (in both X and Y individually) (good at friction*5) 
														//cannot exceed unit width/height
		
		//collision
		private var b:Boundary;
		
		//constructor
		public function Entity() {
			super();
		}
		
		//onAddedToStage
		public function OnEntityAddedToStage(e:Event):void {
			//add to global entity list
			Main.eList.push(this);
			
			if(this.canMove) {
				stage.addEventListener(KeyboardEvent.KEY_DOWN, OnKeyDown);
				stage.addEventListener(KeyboardEvent.KEY_UP, OnKeyUp);
			}			
		}
		
		//changes correct keyDown flag to true
		private function OnKeyDown(e:KeyboardEvent):void {
			switch(e.keyCode) {
				case this.leftKey: this.leftKeyDown = true; break; 
				case this.rightKey: this.rightKeyDown = true; break; 
				case this.upKey: this.upKeyDown = true; break; 
				case this.downKey: this.downKeyDown = true; break; 
			}
		}
		
		//changes correct keyDown flag to false
		private function OnKeyUp(e:KeyboardEvent):void {
			
			switch(e.keyCode) {
				case this.leftKey: this.leftKeyDown = false; break; 
				case this.rightKey: this.rightKeyDown = false; break; 
				case this.upKey: this.upKeyDown = false; break; 
				case this.downKey: this.downKeyDown = false; break; 
			}
		}
		
		//executed every frame
		public function OnFrame(e:Event):void {			
			if(this.canMove)
				Move();
			
		}
		
		//moves entity due to accelleration, checks for collisions before moving
		//checks movement with copies of values, then changes actuals if no collision
		private function Move():void {
			var bx:Number = this.b.x;		//original b x
			var by:Number = this.b.y;		//original b y
			
			var dx:Number;					//x distance between this boundary to other one
			var dy:Number;					//y distance between this boundary to other one
			var gx:Number = this.b.g.x;		//x pos of this boundary
			var gy:Number = this.b.g.y;		//y pos of this boundary
			var gx2:Number;					//x pos of test boundary
			var gy2:Number;					//y pos of test boundary
			
			//pos of THIS from to test
			var isNorth:Boolean;			
			var isSouth:Boolean;
			var isEast:Boolean;
			var isWest:Boolean;
			
			var i:int;						//loop counter
			
			
			//position, velocity, and acceleration values to be changed
			//if new values result in no collision, then change actuals
			var vx2:Number = this.vx;
			var vy2:Number = this.vy;
			
			//accellerate in direction of keys if not going max in that direction
			if(this.leftKeyDown && (vx > ((-1) * this.maxComponentSpeed)))		//a is left
				vx2 -= a;
			if(this.rightKeyDown && (vx < this.maxComponentSpeed))			//a is right
				vx2 += a;
			if(this.upKeyDown && (vy > ((-1) * this.maxComponentSpeed)))		//a is up
				vy2 -= a;
			if(this.downKeyDown && (vy < this.maxComponentSpeed))			//a is down
				vy2 += a;
			
			//handle friction & set v to 0 if close enough
			//then check if v > max to cap it at max
			if(vx2 > 0) {										//v is right
				vx2 -= Main.WORLD_FRICTION;
				if(vx2 < 0)										//friction went to far
					vx2 = 0;
				else if(vx2 > this.maxComponentSpeed)			//past max speed
					vx2 = this.maxComponentSpeed;
			}
			else if(vx2 < 0) {									//v is left
				vx2 += Main.WORLD_FRICTION;
				if(vx2 > 0)
					vx2 = 0;
				else if(vx2 < ((-1) * this.maxComponentSpeed))
					vx2 = (-1) * this.maxComponentSpeed;
			}
			
			if(vy2 > 0) {										//v is down
				vy2 -= Main.WORLD_FRICTION;
				if(vy2 < 0)
					vy2 = 0;
				else if(vy2 > this.maxComponentSpeed)
					vy2 = this.maxComponentSpeed;
			}
			else if(vy2 < 0) {									//v is up
				vy2 += Main.WORLD_FRICTION;
				if(vy2 > 0)
					vy2 = 0;
				else if(vy2 < ((-1) * this.maxComponentSpeed))
					vy2 = (-1) * this.maxComponentSpeed;
			}
			
			//CHECK COLLISIONS
			for(i = 0; i < Main.bList.length; i++) {
				if(i != this.b.BIndex) {
					//CALCULATE DISTANCES THEN TEST IF NEGATIVE (would be inside)
					dx = 0;
					dy = 0;
					gx2 = Main.bList[i].g.x;
					gy2 = Main.bList[i].g.y;
					
					isEast = gx > (gx2 + Main.bList[i].width);
					isWest = gx2 > (gx + this.b.width);
					isNorth = gy2 > (gy + this.b.height);
					isSouth = gy > (gy2 + Main.bList[i].height);
					
					if((vx2 < 0) && isEast && !(isNorth || isSouth)) {			//left
						dx = Math.abs((gx2 + Main.bList[i].width) - gx);
						if((vx2 + dx) < 0) {
							vx2 = 0;
							this.x = gx2 + Main.bList[i].width + 1;
						}
						
					}
					else if((vx2 > 0) && isWest && !(isNorth || isSouth)) {		//right
						dx = Math.abs((gx + b.width) - gx2);
						if((vx2 - dx) > 0) {
							vx2 = 0;
							this.x = gx2 - this.b.width - 1;
						}
					}
					
					if((vy2 < 0) && isSouth && !(isWest || isEast)) {			//up
						dy = Math.abs((gy2 + Main.bList[i].height) - gy);
						if((vy2 + dy) < 0) {
							vy2 = 0;
							this.y = gy2 + Main.bList[i].height + 1;
						}
					}
					else if ((vy2 > 0) && isNorth && !(isWest || isEast)) {		//down
						dy = Math.abs((gy + b.height) - gy2);
						if((vy2 - dy) > 0) {
							vy2 = 0;
							this.y = gy2 - this.b.height - 1;
						}
						
					}
					
					//diagonal cases
					if(isNorth) {
						if(isWest) {		//northwest
							this.b.x += vx2;
							this.b.y += vy2;
							
							if(this.b.hitTestObject(Main.bList[i])) {
								if(Math.abs(vx2) > Math.abs(vy2)) {
									vy2 = 0;
									this.y = gy2 - this.b.height - 1;
								}
								else {
									vx2 = 0;
									this.x = gx2 - this.b.width - 1;
								}
							}
							this.b.x = bx;
							this.b.y = by;
						}
						else if(isEast) {	//northeast
							this.b.x += vx2;
							this.b.y += vy2;
							
							if(this.b.hitTestObject(Main.bList[i])) {
								if(Math.abs(vx2) > Math.abs(vy2)) {
									vy2 = 0;
									this.y = gy2 - this.b.height - 1;
								}
								else {
									vx2 = 0;
									this.x = gx2 + Main.bList[i].width + 1;
								}
							}
							this.b.x = bx;
							this.b.y = by;
						}
					}
					else if(isSouth) {
						if(isWest) {		//southwest
							this.b.x += vx2;
							this.b.y += vy2;
							
							if(this.b.hitTestObject(Main.bList[i])) {
								if(Math.abs(vx2) > Math.abs(vy2)) {
									vy2 = 0;
									this.y = gy2 + Main.bList[i].height + 1;
								}
								else {
									vx2 = 0;
									this.x = gx2 - this.b.width - 1;
								}
							}
							this.b.x = bx;
							this.b.y = by;
						}
						else if(isEast) {	//southeast
							this.b.x += vx2;
							this.b.y += vy2;
							
							if(this.b.hitTestObject(Main.bList[i])) {
								if(Math.abs(vx2) > Math.abs(vy2)) {
									vy2 = 0;
									this.y = gy2 + Main.bList[i].height + 1;
								}
								else {
									vx2 = 0;
									this.x = gx2 + Main.bList[i].width + 1;
								}
							}
							this.b.x = bx;
							this.b.y = by;
						}
					}
				}
			}
			
			//change v
			vx = vx2;
			vy = vy2;
			
			//move object
			this.x += vx;
			this.y += vy;
		}
		
		//get global point g, relative to stage
		public function get g():Point {
			return this.localToGlobal(new Point());
		}
		
		//setters
		public function set_b(b:Boundary):void {
			this.b = b;
		}
		public function set_maxComponentSpeed(s:Number):void {
			this.maxComponentSpeed = s;
		}
		
		
	}
}