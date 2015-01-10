package com.geokureli.astley;

import com.geokureli.krakel.data.AssetPaths;
import com.geokureli.krakel.Game;
import com.geokureli.krakel.Shell;
import com.geokureli.krakel.State;
import flash.Lib;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxRect;
/**
 * ...
 * @author George
 */
class Main extends Shell {
	
	public static function main():Void
	{
		Lib.current.addChild(new Main());
	}
	
	public function new() { super(AstleyGame); }
	
	override function setDefaults():Void {
		super.setDefaults();
		
		AssetPaths.quickInit("../assets/astley");
	}
	
}
class AstleyGame extends Game {
	
	static public inline var SCALE:Int = 2;
	
	public function new() {
		
		super(
			Std.int(Lib.current.stage.stageWidth / SCALE),
			Std.int(Lib.current.stage.stageHeight / SCALE),
			IntroState,
			SCALE,
			30, 30
		);
	}
}

class IntroState extends State {
	
	var _title:FlxSprite;
	var _instructions:FlxSprite;
	
	override public function create():Void {
		super.create();
		
		add(_title = new FlxSprite(0, 0, AssetPaths.text("gassy_rick_astley")));
		centerX(_title).y = -_title.height;
		
		add(new FlxSprite(100, 123, AssetPaths.image("tap")));
		add(new FlxSprite(45, 128, AssetPaths.image("keys")));
		
		add(_instructions = new FlxSprite(0, 160, AssetPaths.text("press_any_key")));
		centerX(_instructions).visible = false;
		
		FlxTween.tween(_title, { y:52 }, 1, { type:FlxTween.ONESHOT, ease:FlxEase.sineOut, complete:onIntroComplete } );
	}
	
	function onIntroComplete(tween:FlxTween):Void {
		
		_instructions.visible = true;
		FlxTween.tween(_title, { y:46 }, 60 / 115.14, { type:FlxTween.PINGPONG, ease:FlxEase.sineOut } );
	}
	
	override function setDefaults():Void {
		super.setDefaults();
		
		FlxG.camera.bgColor = 0xFF5c94fc;
		FlxG.camera.bounds = new FlxRect(0, 0, FlxG.width, FlxG.height);
		
		_musicName = AssetPaths.music("intro");
	}
	
	private function centerX(sprite:FlxSprite):FlxSprite {
		
		sprite.x = (FlxG.width - sprite.width) / 2;
		return sprite;
	}
}