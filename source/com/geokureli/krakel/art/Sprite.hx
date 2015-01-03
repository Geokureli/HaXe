package com.geokureli.krakel.art;

import flixel.FlxSprite;

/**
 * ...
 * @author George
 */
class Sprite extends FlxSprite{

	public function new(x:Float=0, y:Float=0, ?simpleGraphic:Dynamic) {
		super(x, Y, simpleGraphic);
		
		setDefaults();
	}
	
	function setDefaults():Void { }
}