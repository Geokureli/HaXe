package com.geokureli.krakel;

//import flash.Lib;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxMath;

/**
 * A FlxState which can be used for the game's menu.
 */
class State extends FlxState {
	
	var _fadeInColor:Int;
	var _fadeOutColor:Int;
	var _fadeInTime:Float;
	var _fadeOutTime:Float;
	var _fadeInMusic:Bool;
	var _fadeOutMusic:Bool;
	
	var _nextState:FlxState;
	
	var _musicName:Dynamic;
	var _music:FlxSound;
	
	override public function create():Void {
		
		super.create();
		
		setDefaults();
		
		startMusic();
		
		if (_fadeInTime > 0) {
			
			startFadeIn();
		}
		
	}
	
	function setDefaults():Void {
		
		_fadeInColor = _fadeOutColor = FlxColor.BLACK;
		_fadeInTime = _fadeOutTime = 0;
		_fadeInMusic = false;
		_fadeOutMusic = true;
	}
	
	function startMusic():Void {
		
		if (_musicName != null) {
			
			_music = new FlxSound().loadEmbedded(_musicName, true).play();
		}
	}
	
	function startFadeIn():Void {
		
		FlxG.camera.fade(_fadeInColor, _fadeInTime, true, onFadeInComplete, true);
		
		if (_fadeInMusic && _music != null) {
			
			_music.fadeIn(_fadeInTime);
		}
	}
	
	function onFadeInComplete():Void { }
	
	function switchState(state:FlxState):Void {
		
		if (_fadeOutTime > 0) {
			
			_nextState = state;
			startFadeOut();
			
		} else {
			
			FlxG.switchState(state);
		}
	}
	
	function startFadeOut():Void {
		
		FlxG.camera.fade(_fadeOutColor, _fadeOutTime, false, onFadeOutComplete, true);
		
		if (_fadeOutMusic && _music != null) {
			
			_music.fadeOut(_fadeOutTime);
		}
	}
	
	function onFadeOutComplete():Void {
		
		_music.destroy();
		
		FlxG.switchState(_nextState);
	}
	
	//override public function destroy():Void { super.destroy(); }
	
	//override public function update():Void { super.update(); }
}