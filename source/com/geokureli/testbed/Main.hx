package com.geokureli.testbed;

import com.geokureli.astley.data.AssetPaths;
import com.geokureli.krakel.Shell;
import com.geokureli.testbed.looptile.TestLoopingTilemap;

import flash.events.Event;

/**
 * ...
 * @author George
 */
class Main extends Shell {
	
	private function new() { super(TestLoopingTilemap); }
	
	override function setDefaults():Void {
		super.setDefaults();
		
		AssetPaths.quickInit("../assets/test");
	}
}