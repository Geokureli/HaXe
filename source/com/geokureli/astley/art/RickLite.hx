package com.geokureli.astley.art;

import com.geokureli.astley.data.AssetPaths;
import com.geokureli.astley.data.AssetPaths.ImagePaths;
import flixel.FlxSprite;

/**
 * ...
 * @author George
 */
class RickLite extends FlxSprite{
	
	static public inline var WIDTH:Int = 16;
	
	public function new(x:Float = 0, y:Float = 0) {
		super(x, y);
		
		loadGraphic(
			AssetPaths.auto("rick"),
			true,
			WIDTH,
			32
		);
		
		var fartFrames:Array<Int> = [];
		for (i in 1 ... frames - 1) {
			
			fartFrames.push(i);
		}
		fartFrames.push(0);
		
		animation.add("idle", [0]);
		animation.add("farting", fartFrames, 15, false);
		animation.add("dead", [frames-1]);
	}
	
}