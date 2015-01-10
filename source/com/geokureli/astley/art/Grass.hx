package com.geokureli.astley.art;

import com.geokureli.krakel.data.AssetPaths;
import com.geokureli.astley.data.LevelData;
import com.geokureli.krakel.art.LoopingTilemap;

/**
 * ...
 * @author George
 */
class Grass extends LoopingTilemap{

	public function new() {
		//todo: find graphic width/height in loopingtilemap constructor
		super("1,\n2,\n2,", AssetPaths.image("tiles_0"), 16, 16, true, false, 0, 0, 1, 2);
		y = LevelData.SKY_HEIGHT;
	}
	
	//override public function draw():Void { super.draw(); }
}