package greed.art {
	/**
	 * ...
	 * @author George
	 */
	public class Treasure extends Gold {
		
		static public const ORDER:Vector.<String> = new < String > ["emerald", "ruby", "diamond"];
		
		public function Treasure(x:Number = 0, y:Number = 0) { super(x, y); }
		
		override protected function initGraphics():void {
			offset.x = offset.y = 1;
			width = height = 14;
			play("diamond");
		}
	}

}