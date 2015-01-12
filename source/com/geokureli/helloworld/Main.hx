package com.geokureli.helloworld;

import com.geokureli.krakel.Shell;
import com.geokureli.krakel.State;

/**
 * ...
 * @author George
 */
class Main extends Shell {
	
	private function new() { super(IntroState); }
	
	override function setDefaults():Void {
		super.setDefaults();
		
		//AssetPaths.quickInit("../assets/test");
	}
}

class IntroState extends State {
	
	override public function create():Void {
		super.create();
		
		trace("Hello world");
	}
}