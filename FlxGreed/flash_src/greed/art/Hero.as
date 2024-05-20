package greed.art {
	import greed.schemes.Scheme;
	import krakel.jump.JumpScheme;
	import krakel.KrkSprite;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.system.FlxTile;
	/**
	 * ...
	 * @author George
	 */
	public class Hero extends KrkSprite {
		
		[Embed(source="../../../res/greed/graphics/theif.png")] static private const SHEET:Class;
		
		private var jumpDecrease:int,
					_weight:int;
		
		public function Hero(x:Number = 0, y:Number = 0) {
			super(x, y);
			//numHops = 1;
			
			loadGraphic(SHEET, true, true, 32, 24);
			
			moves = true;
			
			width = 10;
			height = 22;
			jumpDecrease = 6;
			//scale.x = scale.y = 1 / 1.75;
			
			addAnimation("idle", [3]);
			addAnimation("walk", [0,1,2,3,4,5], 10);
			addAnimation("skid", [7]);
			addAnimation("jumpSkid", [6]);
			addAnimation("jump", [8]);
			addAnimation("c_idle", [14]);
			addAnimation("climb", [14,15,16,17], 10);
			addAnimation("duck", [22]);
			addAnimation("slide", [23]);
			
			movePairs = CEILING
			
			scheme = new Scheme();
			weight = 0;
		}
		
		override public function setParameters(data:XML):void {
			
			x += offset.x = 11;
			y += offset.y = 2;
			
			super.setParameters(data);
			
			if (maxFall < 0)	maxFall = maxVelocity.y;
			if (maxRise < 0)	maxRise = maxFall;
			
			if (groundDrag < 0)	groundDrag = drag.x;
			if (airDrag < 0)	airDrag = groundDrag;
			
			if (airAcc < 0)		airAcc = acc;
			
			Scheme.JUMP_MAX = jumpMax;
		}
		
		override public function update():void {
			super.update();
			
			var anim:String = "idle";
			if (jumpScheme.onLadder) {
				anim = velocity.x == 0 && velocity.y == 0 ? "c_idle" : "climb";
			} else if (isTouching(FLOOR)) {
				if (velocity.x != 0) {
					facing = velocity.x > 0 ? RIGHT : LEFT;
					offset.x = velocity.x > 0 ? 11 : 10;
					anim = jumpScheme.isDecelX ? "skid" : "walk";
				}
			} else
				anim = (acceleration.x < 0) == (facing == RIGHT) ? "jumpSkid" : "jump";
			
			play(anim);
			
		}
		
		override public function revive():void {
			super.revive();
			velocity.x = velocity.y = 0;
			weight = 0;
		}
		
		override public function hitObject(obj:FlxObject):void {
			
			if (obj is Gold) {
				obj.kill();
				if (obj is Treasure) weight++;
			} else
				super.hitObject(obj);
			
			//var str:String = 
				//(justTouched(UP) ? "UP" : "") + 
				//(justTouched(LEFT) ? "LEFT" : "") + 
				//(justTouched(DOWN) ? "DOWN" : "") +
				//(justTouched(RIGHT) ? "RIGHT" : "");
			//
			//if (str != "") trace(str);
		}
		
		override public function destroy():void {
			super.destroy();
		}
		
		public function get weight():int { return _weight; }
		public function set weight(value:int):void {
			_weight = value;
			//jumpScheme.dragOnDecel = value == 0;
			jumpMax = Scheme.JUMP_MAX - weight * jumpDecrease;
			if (jumpMax < jumpMin)
				jumpMax = jumpMin;
			
			//jumpScheme.groundDrag = Scheme.DRAG - weight * 40;
			//if (jumpScheme.groundDrag < Scheme.DRAG_MIN)
				//jumpScheme.groundDrag = Scheme.DRAG_MIN;
		}
		
		public function get jumpScheme():Scheme { return scheme as Scheme; }
		
		public function get maxWallFall():Number { return jumpScheme.maxWallFall; }
		public function set maxWallFall(value:Number):void { jumpScheme.maxWallFall = value; }
		
		public function get groundDrag():Number { return jumpScheme.groundDrag; }
		public function set groundDrag(value:Number):void { jumpScheme.groundDrag = value; }
		
		public function get jumpSkidV():Number { return jumpScheme.jumpSkidV; }
		public function set jumpSkidV(value:Number):void { jumpScheme.jumpSkidV = value; }
		
		public function get airDrag():Number { return jumpScheme.airDrag; }
		public function set airDrag(value:Number):void { jumpScheme.airDrag = value; }
		
		public function get maxRise():Number { return jumpScheme.maxRise; }
		public function set maxRise(value:Number):void { jumpScheme.maxRise = value; }
		
		public function get maxFall():Number { return jumpScheme.maxFall; }
		public function set maxFall(value:Number):void { jumpScheme.maxFall = value; }
		
		public function get numHops():Number { return jumpScheme.numHops; }
		public function set numHops(value:Number):void { jumpScheme.numHops = value; }
		
		public function get airAcc():Number { return jumpScheme.airAcc; }
		public function set airAcc(value:Number):void { jumpScheme.airAcc = value; }
		
		public function get jumpV():Number { return jumpScheme.jumpV; }
		public function set jumpV(value:Number):void { jumpScheme.jumpV = value; }
		
		public function get hopV():Number { return jumpScheme.hopV; }
		public function set hopV(value:Number):void { jumpScheme.hopV = value; }
		
		public function get acc():Number { return jumpScheme.acc; }
		public function set acc(value:Number):void { jumpScheme.acc = value; }
		
		// --- ABILITIES
		public function get canSkidJump():Boolean { return jumpScheme.canSkidJump; }
		public function set canSkidJump(value:Boolean):void { jumpScheme.canSkidJump = value; }
		
		public function get canWallJump():Boolean { return jumpScheme.canWallJump; }
		public function set canWallJump(value:Boolean):void { jumpScheme.canWallJump = value; }
		
		public function get canWallSlide():Boolean { return jumpScheme.canWallSlide; }
		public function set canWallSlide(value:Boolean):void { jumpScheme.canWallSlide = value; }
		
		public function get changeDirOnHop():Boolean { return jumpScheme.changeDirOnHop; }
		public function set changeDirOnHop(value:Boolean):void { jumpScheme.changeDirOnHop = value; }		
		
		public function get jumpMin():int { return jumpScheme.jumpMin; }
		public function set jumpMin(value:int):void { jumpScheme.jumpMin = value; }
		
		public function get jumpMax():int { return jumpScheme.jumpMax; }
		public function set jumpMax(value:int):void { jumpScheme.jumpMax = value; }
		
		public function get hopMin():int { return jumpScheme.hopMin; }
		public function set hopMin(value:int):void { jumpScheme.hopMin = value; }
		
		public function get hopMax():int { return jumpScheme.hopMax; }
		public function set hopMax(value:int):void { jumpScheme.hopMax = value; }
		
		public function get wallMin():int { return jumpScheme.wallMin; }
		public function set wallMin(value:int):void { jumpScheme.wallMin = value; }
		
		public function get wallMax():int { return jumpScheme.wallMax; }
		public function set wallMax(value:int):void { jumpScheme.wallMax = value; }
	}

}
