package com.geokureli.testbed.looptile;

import com.geokureli.astley.data.AssetPaths;
import com.geokureli.krakel.art.LoopingTilemap;
import com.geokureli.krakel.Game;
import com.geokureli.krakel.State;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.input.keyboard.FlxKey;
import flixel.tile.FlxTilemap;
import flixel.util.FlxPoint;
import flixel.util.FlxRect;

import flash.Lib;

/**
 * ...
 * @author George
 */
class TestLoopingTilemap extends Game {
	
	static public inline var SCALE:Int = 8;
	
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
	static inline var map1:String = "1,0,\n0,1,";
	static inline var map2:String = '{"map":"X \r X", "legend":" XO"}';
	
	var _p:FlxPoint;
	
	override public function create():Void {
		super.create();
		
		bgColor = 0x5c94fc;
		
		var map:LoopingTilemap = new LoopingTilemap(map1, AssetPaths.image("autotiles"), 8, 8, true, true, 0, 1);
		map.scrollFactor.x = map.scrollFactor.y = .5;
		add(map);
	}
	
	override public function update():Void {
		super.update();
		
		var up = FlxG.keys.anyPressed(["UP", "W"]);
		var down = FlxG.keys.anyPressed(["DOWN", "S"]);
		var left = FlxG.keys.anyPressed(["LEFT", "A"]);
		var right = FlxG.keys.anyPressed(["RIGHT", "D"]);
		
		if (right) FlxG.camera.scroll.x++;
		if (left) FlxG.camera.scroll.x--;
		if (down) FlxG.camera.scroll.y++;
		if (up) FlxG.camera.scroll.y--;
		
		//FlxG.camera.focusOn(_p);
	}
}