package com.geokureli.astley.art.ui;

import com.geokureli.krakel.data.AssetPaths;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.text.FlxBitmapText;
import flixel.math.FlxPoint;
import openfl.Assets;

/**
 * ...
 * @author George
 */
class ScoreText extends FlxBitmapText {
	
	static var SHADOW_POINT:FlxPoint = new FlxPoint(1, 1);
	
	static var PX_FONT_KEY:String = "score";
	var _showShadow:Bool;
	
	public function new(x:Int = 0, y:Int = 0, shadow:Bool = false) {
		super(AssetPaths.bitmapFont("numbers_10"));
		
		this.x = x;
		this.y = y;
		_showShadow = shadow;
		
		useTextColor = false;
		
		//setKerning('1', 6).x++;
		//padding.x = -1;
		text = '0';
	}
	
	override public function draw():Void {
		
		if (_showShadow) {
			
			// --- DRAW DROP SHADOW
			x += 1;
			y += 1;
			super.draw();
			// --- DRAW NORMAL
			x -= 1;
			y -= 1;
		}
		super.draw();
	}
	
	//override public function set_text(value:String):Void {
		//super.text = Std.int(value).toString();
	//}
}