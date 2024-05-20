package greed.art {
	import krakel.helpers.StringHelper;
	import krakel.KrkSprite;
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	
	/**
	 * ...
	 * @author George
	 */
	public class WeightForm extends KrkSprite {
		public var drop:Number,
					slack:Number,
					counterWeight:Number;
		
		private var counterWeightTarget:WeightForm;
		static private const SPEED:Number = 200;
		
		public function WeightForm(x:Number=0, y:Number=0, graphic:Class=null) {
			super(x, y, graphic);
			moves = true;
			immovable = true;
			slack = 16;
			drop = 16;
			overlapArgs = { collider: { moves:true }};
			dragOnDecel = true;
			drag.y = 800;
			counterWeight = 0;
		}
		override public function setParameters(data:XML):void {
			super.setParameters(data);
			
			if (counterWeight == 0 && counterWeightTarget == null)
				counterWeight = mass;
		}
		override public function update():void {
			super.update();
			var mass:Number = getPairMass(this) - counterWeight;
			//trace(drop * mass);
			var targetY:Number = spawn.y + drop * mass;
			
			if(mass > 0)
				targetY += drop / 4;
			if (y + SPEED*FlxG.elapsed < targetY) {
				acceleration.y = SPEED;
			} else if (y - SPEED*FlxG.elapsed > targetY) {
				acceleration.y = -SPEED;
			} else {
				acceleration.y = 0;
				if (velocity.y == 0)
					y = targetY;
			}
			
		}
		private function getPairMass(obj:KrkSprite, ignore:KrkSprite = null):Number {
			var mass:Number = obj.mass;
			if (obj is Hero) mass += (obj as Hero).weight;
			
			for each(var pair:KrkSprite in obj.pairs[UP]) {
				
				if (pair.moves && pair != ignore && pair != this)
					mass += getPairMass(pair, obj);
			}
			return mass;
		}
		override public function hitObject(obj:FlxObject):void {
			super.hitObject(obj);
			//trace("Hit");
		}
		//override public function separateObject(obj:FlxObject):void {
			//super.separateObject(obj);
			//trace("Separate");
		//}
		
	}

}