package greed.art {
	import krakel.KrkSprite;
	
	/**
	 * ...
	 * @author George
	 */
	public class Door extends KrkSprite {
		
		[Embed(source="../../../res/greed/graphics/door.png")] static private const SHEET:Class;
		
		public function Door() {
			super(0, 0, SHEET);
			
		}
		
	}

}