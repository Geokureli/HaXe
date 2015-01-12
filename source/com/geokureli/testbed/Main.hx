package com.geokureli.testbed;

import flash.display.Sprite;
import com.geokureli.krakel.data.AssetPaths;
import com.geokureli.krakel.Shell;

import com.geokureli.testbed.misc.TestEReg;
//import com.geokureli.testbed.misc.TestLoopingTilemap;

/**
 * ...
 * @author George
 */
class Main extends Shell {
	
	private function new() { super(TestEReg); }
	
	override function setDefaults():Void {
		super.setDefaults();
		
		AssetPaths.quickInit("assets/test");
	}
}