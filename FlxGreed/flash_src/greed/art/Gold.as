package greed.art {
	import krakel.KrkSprite;
	
	/**
	 * ...
	 * @author George
	 */
	public class Gold extends KrkSprite {
		
		[Embed(source = "../../../res/greed/graphics/gold.png")] static private const SHEET:Class;
		
		public function Gold(x:Number = 0 , y:Number = 0) {
			super(x, y);
			
			overlapArgs = { collider: { type:"Hero" }};
			
			loadGraphic(SHEET, true, false, 16, 16);
			addAnimation("ui", [0]);
			addAnimation("coin", [0, 1, 2, 3], 10);
			addAnimation("emerald", [4]);
			addAnimation("diamond", [5]);
			addAnimation("ruby", [6]);
			
			initGraphics();
		}
		protected function initGraphics():void {
			offset.x = 4;
			offset.y = 3;
			width = 8;
			height = 11;
			play("coin");
		}
		override public function revive():void {
			super.revive();
		}
	}

}