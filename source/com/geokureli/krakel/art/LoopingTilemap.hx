package com.geokureli.krakel.art;

import flixel.tile.FlxTilemap;

/**
 * ...
 * @author George
 */
class LoopingTilemap extends FlxTilemap {

	public var wrapX:Bool;
	public var wrapY:Bool;
	
	var currentStart
	
	public function new (
		mapData:Dynamic,
		tileGraphic:Dynamic,
		tileWidth:Int = 0,
		tileHeight:Int = 0,
		autoTile:Int = 0,
		startingIndex:Int = 0,
		drawIndex:Int = 1,
		collideIndex:Int = 1
	) {
		super();
		
		setDefaults();
		
		loadMap(mapData, tileGraphic, tileWidth, tileHeight, autoTile, startingIndex, drawIndex, collideIndex);
	}
	
	function setDefaults():Void { }
	
	override public function draw():Void {
		
		setTile
		
		super.draw();
	}
	
	//override function get_x():Float { return super.get_x(); }
	//override function set_x(value:Float):Float { return set_x(value); }
	
	//override function get_y():Float { return super.get_y(); }
	//override function set_y(value:Float):Float { return set_y(value); }
}