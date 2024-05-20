package greed.states {
	import greed.Imports;
	import greed.levels.HellLevel;
	import greed.levels.ChoiceLevel;
	import krakel.KrkLevelManager;
	
	/**
	 * ...
	 * @author George
	 */
	[SWF(width = "350", height = "800", backgroundColor = "#FFFFFF", frameRate = "30")]
	public class GameState extends KrkLevelManager {
		
		static public const NUM_LEVELS:int = 4;
		
		private var levelNum:Number;
		
		public function GameState() {
			super();
			trace("state constructor");
		}
		override public function create():void {
			super.create();
			
			levelNum = 0;
			defaultLevelClass = ChoiceLevel;
			
			startLevel(Imports.getLevel(levelNum.toString()));
		}
		
		override protected function onLevelEnd():void {
			super.onLevelEnd();
			
			trace("end: " + levelNum);
			
			levelNum++;
			if (levelNum == NUM_LEVELS) {
				if (defaultLevelClass == HellLevel) return;
				else {
					defaultLevelClass = HellLevel;
					levelNum = 0;
				}
			}
			startLevel(Imports.getLevel(levelNum.toString()));
		}
		
	}

}