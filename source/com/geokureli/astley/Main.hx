package com.geokureli.astley;

import com.geokureli.astley.art.Grass;
import com.geokureli.astley.states.BaseState;
import com.geokureli.astley.states.RollinState;
import com.geokureli.krakel.data.AssetPaths;
import com.geokureli.astley.data.LevelData;
import com.geokureli.krakel.art.LoopingTilemap;
import com.geokureli.krakel.Game;
import com.geokureli.krakel.Shell;
import com.geokureli.krakel.State;
import com.geokureli.astley.data.FartControl;
import flash.Lib;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxRect;
import motion.Actuate;
import motion.easing.Linear;
/**
 * ...
 * @author George
 */
class Main extends Shell {
	
	//public static function main():Void
	//{
		//Lib.current.addChild(new Main());
	//}
	
	public function new() { super(); }
	
	override function setDefaults():Void {
		super.setDefaults();
		
		_frameRate = 30;
		_scale = 2;
		_introState = IntroState;
		
		AssetPaths.quickInit("assets/astley");
		Actuate.defaultEase = Linear.easeNone;
	}
}

class IntroState extends State {
	
	var _title:FlxSprite;
	var _instructions:FlxSprite;
	
	override public function create():Void {
		super.create();
		
		LevelData.init();
		FartControl.create();
		FartControl.enabled = false;
		
		add(_title = new FlxSprite(0, 0, AssetPaths.text("gassy_rick_astley")));
		centerX(_title).y = -_title.height;
		
		add(new FlxSprite(100, 123, AssetPaths.image("tap")));
		add(new FlxSprite(45, 128, AssetPaths.image("keys")));
		
		add(_instructions = new FlxSprite(0, 160, AssetPaths.text("press_any_key")));
		centerX(_instructions).visible = false;
		
		add(new Grass());
		
		FlxTween.tween(_title, { y:52 }, 1, { type:FlxTween.ONESHOT, ease:FlxEase.sineOut, complete:onIntroComplete } );
	}
	
	override function setDefaults():Void {
		super.setDefaults();
		
		FlxG.camera.bgColor = 0xFF5c94fc;
		FlxG.camera.bounds = new FlxRect(0, 0, FlxG.width, FlxG.height);
		
		_musicName = AssetPaths.music("intro");
		_fadeOutMusic = true;
		_fadeOutTime = .5;
	}
	
	function onIntroComplete(tween:FlxTween):Void {
		
		_instructions.visible = true;
		FlxTween.tween(_title, { y:46 }, 60 / 115.14, { type:FlxTween.PINGPONG, ease:FlxEase.sineOut } );
		
		FartControl.enabled = true;
	}
	
	override public function update():Void {
		super.update();
		
		if (FartControl.down) {
			
			switchState(new RollinState());
		}
	}
	
	private function centerX(sprite:FlxSprite):FlxSprite {
		
		sprite.x = (FlxG.width - sprite.width) / 2;
		return sprite;
	}
}