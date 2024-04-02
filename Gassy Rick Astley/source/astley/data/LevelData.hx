package astley.data;

import astley.art.Tilemap;
import astley.art.Cloud;
import astley.art.Shrub;

import flixel.FlxG;

/**
 * ...
 * @author George
 */
class LevelData {
    
    //static public inline var SCORE_BOARD_ID:String = "Gassy_Rick_Astley";
    static public inline var TILE_SIZE:Float = 16;
    static public inline var FLOOR_BUFFER:Float = 2;
    static public var ROWS(default, null):Float;
    static public var COLUMNS(default, null):Float;
    static public var FLOOR_HEIGHT(default, null):Float;
    static public var SKY_ROWS(default, null):Float;
    static public var SKY_HEIGHT(default, null):Float;
    static public var PIPES(default, null):Array<Int>;
    
    static public var width:Float;
    
    static public function init():Void {
        
        ROWS = FlxG.height / TILE_SIZE;
        COLUMNS = FlxG.width / TILE_SIZE;
        FLOOR_HEIGHT = FLOOR_BUFFER * TILE_SIZE;
        SKY_ROWS = ROWS - FLOOR_BUFFER;
        SKY_HEIGHT = FlxG.height - FLOOR_HEIGHT;
        PIPES = [];
        
        Shrub.init();
        Cloud.init();
        Tilemap.init();
    }
}