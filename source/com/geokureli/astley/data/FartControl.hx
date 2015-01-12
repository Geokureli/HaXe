package com.geokureli.astley.data;

import flixel.FlxG;
import flash.events.KeyboardEvent;
import flixel.plugin.FlxPlugin;

/**
 * ...
 * @author George
 */
class FartControl extends FlxPlugin {
	
	static public var down(get, never):Bool;
	static public var enabled:Bool = true;
	static public var replayMode:Bool = false;
	static private var _instance:FartControl;
	
	
	var _keysDown:Array<Int>;
	var lastCount:Int;
	var _antiPress:Bool;
	
	public var isButtonDown:Bool;
	public var mouseJustPressed:Bool;
	
	
	static public function create():Void {
		
		_instance = new FartControl();
	}
	
	public function new () {
		super();
		
		_keysDown = [];
		isButtonDown = false;
		_antiPress = true;
		
		FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyHandler);
		FlxG.stage.addEventListener(KeyboardEvent.KEY_UP, keyHandler);
		
		FlxG.plugins.add(this);
	}
	
	function keyHandler(e:KeyboardEvent):Void {
		
		if (e.type == KeyboardEvent.KEY_UP) {
			
			_keysDown.remove(e.keyCode);
			
		} else if (_keysDown.indexOf(e.keyCode) == -1) {
			
			_keysDown.push(e.keyCode);
		}
	}
	
	override public function update():Void {
		
		isButtonDown = false;
		mouseJustPressed = FlxG.mouse.justPressed;
		
		if (_keysDown.length == 0 && !FlxG.mouse.pressed) {
			
			_antiPress = true;
			
		} else if(_antiPress) {
			
			_antiPress = false;
			isButtonDown = enabled || replayMode;
		}
	}
	
	static public function get_down():Bool { return _instance.isButtonDown; }
}