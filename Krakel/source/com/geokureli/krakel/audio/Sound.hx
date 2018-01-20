package com.geokureli.krakel.audio;

import flixel.system.FlxSound;

/**
 * ...
 * @author George
 */
class Sound extends FlxSound
{
	static public var enabled:Bool = true;
	
	public var position(get, set):Float;
	public var duration(get, never):Float;
	
	public function new() { super(); }
	
	public function startAt(position:Float):Void { startSound(position); }
	
	public function getPosition(seconds:Float):Float{
		
		return seconds / duration * length;
	}
	
	public function get_duration():Float { return _sound.length / 1000.0; }
	
	public function get_position():Float { return time; }
	
	public function set_position(value:Float):Float { return time = value; }
	
	//static public function get_enabled():Bool { return enabled; }
	//static public function set_enabled(value:Bool):Bool { enabled = value; }
}