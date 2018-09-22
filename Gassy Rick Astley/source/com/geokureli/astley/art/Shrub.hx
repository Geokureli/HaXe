package com.geokureli.astley.art;

import com.geokureli.krakel.data.AssetPaths;
import com.geokureli.astley.data.LevelData;
import com.geokureli.krakel.utils.Random;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;

import openfl.geom.Rectangle;
import openfl.geom.Point;

/**
 * ...
 * @author George
 */
class Shrub extends FlxSprite{
    
    static public var DEFAULT_Y(default, null):Float;
    static public var MIN_SPREAD(default, null):Float;
    static public var MAX_SPREAD(default, null):Float;
    
    static public function init():Void {
        
        DEFAULT_Y = LevelData.SKY_HEIGHT;
        MIN_SPREAD = 4 * LevelData.TILE_SIZE;
        MAX_SPREAD = 16 * LevelData.TILE_SIZE;
        
        var big = FlxG.bitmap.add(AssetPaths.image("shrub"), false, "shrub_1");
        big.persist = true;
        FlxG.bitmap.addGraphic(big);
        
        var small = FlxG.bitmap.create(32, 16, FlxColor.TRANSPARENT, true, "shrub_0");
        small.persist = true;
        FlxG.bitmap.addGraphic(small);
        
        var rect = new Rectangle(0, 0, 16, 32);
        var point = new Point();
        small.bitmap.copyPixels(big.bitmap, rect, point);
        rect.x = 32;
        point.x = 16;
        small.bitmap.copyPixels(big.bitmap, rect, point);
    }
    
    public function new(x:Float, size:Int = -1) {
        
        if (size == -1)
            size = Random.ibetween(0, 2);
        else
            size -= 2;
        
        super(x, DEFAULT_Y - LevelData.TILE_SIZE, FlxG.bitmap.get("shrub_" + size));
    }
}