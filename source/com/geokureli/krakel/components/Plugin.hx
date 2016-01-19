package com.geokureli.krakel.components;

import flixel.FlxG;
import flixel.plugin.FlxPlugin;

/**
 * ...
 * @author George
 */
class Plugin extends FlxPlugin {

	public function new() {
		super();
		
		setDefaults();
		
		init();
	}
	
	function setDefaults():Void { }
	
	function init():Void {
		
		FlxG.plugins.add(this);
	}
}