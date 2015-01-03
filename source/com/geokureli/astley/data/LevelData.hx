package com.geokureli.astley.data;

import org.flixel.FlxG;

/**
 * ...
 * @author George
 */
class LevelData{

	/**
	 * ...
	 * @author George
	 */
	public class LevelData {
		
		static public inline var TILE_SIZE:int = 16;
		static public inline var ROWS:int = FlxG.height / TILE_SIZE;
		static public inline var COLUMNS:int = FlxG.width / TILE_SIZE;
		static public inline var FLOOR_BUFFER:int = 2;
		static public inline var FLOOR_HEIGHT:int = FLOOR_BUFFER * TILE_SIZE;
		static public inline var SKY_ROWS:int = ROWS - FLOOR_BUFFER;
		static public inline var SKY_HEIGHT:int = FlxG.height - FLOOR_HEIGHT;
		static public inline var PIPES:Array<Int> = [];
		static public inline var SCORE_BOARD_ID:String = "Gassy_Rick_Astley";
	}
}