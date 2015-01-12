package com.geokureli.astley.art;

import com.geokureli.astley.data.LevelData;
import com.geokureli.krakel.data.AssetPaths;
import com.geokureli.krakel.utils.Random;
import flixel.FlxSprite;

/**
 * ...
 * @author George
 */
class Cloud extends FlxSprite
{
	static public var MIN_SPREAD:Int;
	static public var MAX_SPREAD:Int;
	
	static var MAX:Int;
	static var MIN:Int;
	
	static public function init():Void {
		MIN_SPREAD = Std.int(4 * LevelData.TILE_SIZE);
		MAX_SPREAD = Std.int(8 * LevelData.TILE_SIZE);
		
		MAX = Std.int(4 * LevelData.TILE_SIZE);
		MIN = Std.int(-1 * LevelData.TILE_SIZE);
	}
	
	public function new(x:Float) {
		super(x, Random.between(MIN, MAX, LevelData.TILE_SIZE), AssetPaths.image("cloud"));
		
		scrollFactor.x = .5;
	}
}