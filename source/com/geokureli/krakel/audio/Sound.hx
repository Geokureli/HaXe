package com.geokureli.krakel.audio;

import flixel.system.FlxSound;

/**
 * ...
 * @author George
 */
class Sound extends FlxSound
{
	public var duration(get, never):Float;
	
	public function new() { super(); }
	
	public function get_duration():Float { return _sound.length / 1000.0; }
}