package greed.levels {
	import krakel.KrkState;
	
	/**
	 * ...
	 * @author George
	 */
	public class LevelList extends KrkState {
		public var level:Vector.<XML>;
		
		public function LevelList(levels:Vector.<XML>) {
			super();
			this.levels = levels;
		}
		
		override public function create():void {
			super.create();
			
			
		}
		
	}

}