package com.geokureli.astley.art;

import com.geokureli.astley.data.LevelData;
import com.geokureli.krakel.data.AssetPaths;
import flixel.FlxSprite;

/**
 * ...
 * @author George
 */
class Shrub extends FlxSprite{
	static public var DEFAULT_Y(default, null):Float;
	static public var MIN_SPREAD(default, null):Float;
	static public var MAX_SPREAD(default, null):Float;
	
	static public function init():Void {
		
		DEFAULT_Y = LevelData.SKY_HEIGHT;
		MIN_SPREAD = 4 * LevelData.TILE_SIZE;
		MAX_SPREAD = 16 * LevelData.TILE_SIZE;
	}
	
	public function new(x:Float) {
		super(x, DEFAULT_Y, AssetPaths.image("shrub"));
	}
	
}