package com.geokureli.testbed;

import com.geokureli.krakel.data.AssetPaths;
import com.geokureli.krakel.Shell;

//import com.geokureli.testbed.misc.TestEReg;
//import com.geokureli.testbed.misc.TestText;
//import com.geokureli.testbed.misc.TestLoopingTilemap;
//import com.geokureli.testbed.misc.Test9Slice;
//import com.geokureli.testbed.misc.TestCast;
import com.geokureli.testbed.misc.Weigh12Islanders;

/**
 * ...
 * @author George
 */
class Main extends Shell {
	
	private function new() { super(); }
	
	override function setDefaults():Void {
		super.setDefaults();
		
		_introState = Weigh12Islanders;
		
		AssetPaths.quickInit("assets/test");
	}
}