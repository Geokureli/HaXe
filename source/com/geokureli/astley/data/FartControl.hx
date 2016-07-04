package com.geokureli.astley.data;

import com.geokureli.krakel.components.Plugin;
import flash.events.KeyboardEvent;
import flixel.FlxG;

/**
 * ...
 * @author George
 */
class FartControl extends Plugin {
	
	static public var down(get, never):Bool;
	static public var enabled:Bool = true;
	static public var replayMode:Bool = false;
	static private var _instance:FartControl;
	
	
	var _keysDown:Array<Int>;
	var lastCount:Int;
	var _antiPress:Bool;
	
	public var isButtonDown:Bool;
	
	static public function create():Void {
		
		_instance = new FartControl();
	}
	
	public function new () { super(); }
	
	override function setDefaults():Void {
		super.setDefaults();
		
		_keysDown = [];
		isButtonDown = false;
		_antiPress = true;
	}
	
	override public function update(elapsed:Float):Void {
		
		isButtonDown = false;
		
		if (!FlxG.keys.justPressed.ANY && !FlxG.mouse.pressed) {
			
			_antiPress = true;
			
		} else if(_antiPress) {
			
			_antiPress = false;
			isButtonDown = enabled || replayMode;
		}
	}
	
	static public function get_down():Bool { return _instance.isButtonDown; }
}