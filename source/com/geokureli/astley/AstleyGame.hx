package com.geokureli.astley;

import com.geokureli.astley.art.RickLite;
import com.geokureli.astley.AssetPaths.ImagePaths;
import com.geokureli.astley.AssetPaths.MusicPaths;
import com.geokureli.krakel.Game;
import com.geokureli.krakel.State;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flash.Lib;
import flixel.plugin.TweenManager;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxRect;

/**
 * ...
 * @author George
 */
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
	
	static inline var TITLE:String = ImagePaths.TEXT_PATH + "gassy_rick_astley.png";
	static inline var INSTRUCTIONS:String = ImagePaths.TEXT_PATH + "press_any_key.png";
	
	var _title:FlxSprite;
	var _instructions:FlxSprite;
	
	override public function create():Void {
		super.create();
		
		add(_title = new FlxSprite(0, 0, TITLE));
		centerX(_title).y = -_title.height;
		
		add(new FlxSprite(100, 123, ImagePaths.PATH + "tap.png"));
		add(new FlxSprite(45, 128, ImagePaths.PATH + "keys.png"));
		
		add(_instructions = new FlxSprite(0, 160, INSTRUCTIONS));
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
		
		_musicName = MusicPaths.PATH + "intro.mp3";
	}
	
	private function centerX(sprite:FlxSprite):FlxSprite {
		
		sprite.x = (FlxG.width - sprite.width) / 2;
		return sprite;
	}
}