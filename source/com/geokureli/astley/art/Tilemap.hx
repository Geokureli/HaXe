package com.geokureli.astley.art;

import com.geokureli.astley.data.LevelData;
import com.geokureli.krakel.data.AssetPaths;
import com.geokureli.krakel.utils.Random;
import flixel.FlxG;
import flixel.tile.FlxTilemap;

/**
 * ...
 * @author George
 */

 typedef MapTiles = Array<Array<Int>>;
class Tilemap extends FlxTilemap
{

	static public inline var PIPE_INTERVAL:Int = 6;
	static public inline var PIPE_START:Int = 12;
	
	static public var addPipes:Bool = true;
	
	static inline var PIPE_MIN:Int = 2;
	static inline var PIPE_FRAME:Int = 3;
	static inline var PIPE_GAP:Int = 4;
	
	static var CLOUD_STAMP:MapTiles;
	static var PIPE_STAMP:MapTiles;
	static var PIPE_SHAFT:Array<Int>;
	static var PIPE_BASE:Array<Int>;
	static var FLOOR_FRAME:Int;
	static var GROUND_FRAME:Int;
	
	static public function init():Void {
		
		CLOUD_STAMP = [[1, 2], [3, 4]];
		PIPE_SHAFT = [2 + PIPE_FRAME, 3 + PIPE_FRAME];
		PIPE_BASE = [6 + PIPE_FRAME, 7 + PIPE_FRAME];
		FLOOR_FRAME = PIPE_FRAME-2;
		GROUND_FRAME = PIPE_FRAME-1;
		
		PIPE_STAMP = [[4 + PIPE_FRAME, 5 + PIPE_FRAME]];
		for (i in 0 ... PIPE_GAP)
		{
			PIPE_STAMP.push([0, 0]);
		}
		
		PIPE_STAMP.push([0 + PIPE_FRAME, 1 + PIPE_FRAME]);
	}
	
	public var numPipes:Int;
	public var endY:Int;
	public var endX:Int;
	
	private var _isReplay:Bool;
	
	public function new(isReplay:Bool = false) {
		super();
		
		_isReplay = isReplay;
		numPipes = 0;
		
		loadMap(
			
			generateTileData(),
			AssetPaths.image("tiles_0"),
			Std.int(LevelData.TILE_SIZE),
			Std.int(LevelData.TILE_SIZE),
			FlxTilemap.OFF,
			0,
			1,
			GROUND_FRAME
		);
	}
	
	function generateTileData():String {
		
		var columns:Int = Std.int(FlxG.camera.bounds.width / LevelData.TILE_SIZE);
		var rows:Int = Std.int(LevelData.ROWS);
		
		var data:MapTiles = [];
		var row:Array<Int>;
		var tile:Int;
		for (i in 0 ... rows) {
			
			tile = 0;
			if (i == rows - LevelData.FLOOR_BUFFER - 1)
				tile = 0;// FLOOR_FRAME;
			else if (i >= rows - LevelData.FLOOR_BUFFER)
				tile = GROUND_FRAME;
			
			row = [];
			for (j in 0 ... columns) {
				
				row.push(tile);
			}
			data.push(row);
		}
		
		if (addPipes){
			
			createPipes(data, columns);
		}
		
		var map:String = "";
		while (data.length > 0) {
			
			map += data.shift().join(',') + '\n';
		}
		
		return map.substr(0, map.length - 1);
	}
	
	function createPipes(data:MapTiles, columns:Int):Void {
		var x:Int = PIPE_START;
		
		do {
			
			endY = stampPipe(x, data);
			x += PIPE_INTERVAL;
			numPipes++;
			
		} while (x < columns);
		
		endY += 2;
		endY *= Std.int(LevelData.TILE_SIZE);
		endX = (x - PIPE_INTERVAL + 1) * Std.int(LevelData.TILE_SIZE);
	}
	
	private function stampImage(x:Int, y:Int, data:MapTiles, stamp:MapTiles):Void {
		
		for (i in 0 ... stamp[0].length) {
			
			for (j in 0 ... stamp.length) {
				
				data[j + y][i + x] = stamp[j][i];
			}
		}
	}
	
	private function stampCloud(x:Int, data:MapTiles):Void {
		
		stampImage(x, Random.ibetween(Std.int(y)), data, CLOUD_STAMP);
	}
	
	public function stampPipe(x:Int, data:MapTiles):Int {
		var y:Int;
		var ret:Int;
		
		if (_isReplay) {
			
			y = LevelData.PIPES[Std.int((x - PIPE_START) / PIPE_INTERVAL)];
		}
		else {
			
			y = Random.ibetween(PIPE_MIN, Std.int(FlxG.height / LevelData.TILE_SIZE - PIPE_MIN - PIPE_GAP - LevelData.FLOOR_BUFFER));
			LevelData.PIPES.push(y);
		}
		ret = y;
		var stamp:MapTiles = PIPE_STAMP.copy();
		
		while (y > 0) {
			stamp.unshift(PIPE_SHAFT);
			y--;
		}
		
		while (stamp.length < data.length - LevelData.FLOOR_BUFFER)
		{
			stamp.push(PIPE_SHAFT);
		}
		//stamp.push(PIPE_BASE);
		
		stampImage(x, y, data, stamp);
		
		return ret;
	}
	
	static public function getScore(distance:Float):Float {
		
		return 1 + (distance / LevelData.TILE_SIZE - PIPE_START) / PIPE_INTERVAL;
	}
	
	static public function getCompletion(score:Float):Float {
		
		//trace(score, getScore(FlxG.camera.bounds.width), score / getScore(FlxG.camera.bounds.width));
		return score / getScore(FlxG.camera.bounds.width);
	}
}