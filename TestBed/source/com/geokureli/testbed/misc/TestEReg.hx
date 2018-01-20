package com.geokureli.testbed.misc;

import com.geokureli.krakel.data.AssetPaths;
import com.geokureli.krakel.Game;
import com.geokureli.krakel.State;
import flash.Lib;

/**
 * ...
 * @author George
 */
class TestEReg extends Game {
	
	static public inline var SCALE:Int = 1;
	
	public function new():Void {
		
		super(
				Std.int(Lib.current.stage.stageWidth / SCALE),
				Std.int(Lib.current.stage.stageHeight / SCALE),
				MainState,
				SCALE,
				30, 30
		);
	}
}

class MainState extends State {
	
	override public function create():Void {
		super.create();
		
		trace(AssetPaths.auto("{build}"));
	}
}