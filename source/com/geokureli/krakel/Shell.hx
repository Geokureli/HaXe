package com.geokureli.krakel;

import com.geokureli.krakel.data.BuildInfo;
import com.geokureli.krakel.State;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.Lib;
import flixel.FlxGame;
import flixel.FlxState;

/**
 * ...
 * @author George
 */
class Shell extends Sprite {

	/** The Game class the program starts with. */
	var _gameClass:Class<Game>;
	var _introState:Class<FlxState>;
	
	var _gameWidth:Int;
	var _gameHeight:Int;
	var _frameRate:Int;
	var _updateRate:Int;
	var _scale:Float;
	
	var _skipSplash:Bool;
	var _fullScreen:Bool;
	
	var _game:Game;
	
	public function new(?gameClass:Class<Game>) 
	{
		_gameClass = gameClass;
		
		super();
		
		setDefaults();
		
		if (stage != null) 
		{
			init();
		}
		else 
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
	}
	
	function setDefaults():Void {
		
		_gameWidth = -1;
		_gameHeight = -1;
		
		_frameRate = 30;
		_updateRate = -1;
		
		_skipSplash = false;
		_fullScreen = false;
		
		_scale = 1;
		_introState = State;
	}
	
	function init(?e:Event):Void 
	{
		if (e != null) removeEventListener(e.type, init);
		
		trace(BuildInfo.buildInfo);
		
		setupGame();
	}
	
	function setupGame():Void
	{
		if (_gameClass != null) {
			
			addChild(_game = Type.createInstance(_gameClass, []));
			
		} else {
			
			if (_gameWidth < 0) {
				
				_gameWidth = Std.int(Lib.current.stage.stageWidth / _scale);
			}
			
			if (_gameHeight < 0) {
				
				_gameHeight = Std.int(Lib.current.stage.stageHeight / _scale);
			}
			
			if (_updateRate == -1) {
				
				_updateRate = _frameRate;
			}
			
			addChild(
				_game = new Game(
					_gameWidth, _gameHeight,
					_introState,
					_scale,
					_updateRate, _frameRate,
					_skipSplash,
					_fullScreen
				)
			);
		}
	}
}