package greed {
	import greed.states.GameState;
	import krakel.KrkGame;
	
	/**
	 * ...
	 * @author George
	 */
	public class Editor extends KrkGame {
		static private const SCALE:Number = 2;
		
		public function Editor() {
			super(640 / SCALE, 360 / SCALE, GameState, SCALE);
		}
		
	}

}