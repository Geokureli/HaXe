package com.geokureli.astley.art;

import com.geokureli.astley.data.LevelData;
import com.geokureli.krakel.data.AssetPaths;
import com.geokureli.krakel.utils.Random;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;

import openfl.geom.Point;
import openfl.geom.Rectangle;

/**
 * ...
 * @author George
 */
class Cloud extends FlxSprite
{
    static public var MIN_SPREAD:Int;
    static public var MAX_SPREAD:Int;
    
    static var MAX:Int;
    static var MIN:Int;
    
    static public function init():Void {
        MIN_SPREAD = Std.int(4 * LevelData.TILE_SIZE);
        MAX_SPREAD = Std.int(8 * LevelData.TILE_SIZE);
        
        MAX = Std.int(4 * LevelData.TILE_SIZE);
        MIN = Std.int(-1 * LevelData.TILE_SIZE);
        
        var big = FlxG.bitmap.add(AssetPaths.image("cloud"), false, "cloud_1");
        big.persist = true;
        FlxG.bitmap.addGraphic(big);
        
        var small = FlxG.bitmap.create(32, 32, FlxColor.TRANSPARENT, true, "cloud_0");
        small.persist = true;
        FlxG.bitmap.addGraphic(small);
        
        var rect = new Rectangle(0, 0, 16, 32);
        var point = new Point();
        small.bitmap.copyPixels(big.bitmap, rect, point);
        rect.x = 32;
        point.x = 16;
        small.bitmap.copyPixels(big.bitmap, rect, point);
    }
    
    public function new(x:Float, y:Null<Float> = null, size:Int = -1) {
        
        if (y == null)
            y = Random.between(MIN, MAX, LevelData.TILE_SIZE);
        
        if (size == -1)
            size = Random.ibetween(0, 2);
        else
            size -= 2;
        
        super(x, y, FlxG.bitmap.get("cloud_" + size));
        
        scrollFactor.x = scrollFactor.y = .5;
    }
}