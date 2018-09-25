package com.geokureli.astley.art;

import com.geokureli.astley.data.LevelData;
import com.geokureli.krakel.data.AssetPaths;
import com.geokureli.krakel.utils.Random;

import flixel.FlxG;
import flixel.util.FlxColor;

import openfl.geom.Point;
import openfl.geom.Rectangle;

/**
 * ...
 * @author George
 */
class LoopSprite extends flixel.FlxSprite {
    
    var _key:String;
    var _loop:Bool;
    var _min:Int;
    var _max:Int;
    var _lastCamX:Float;
    var _wasOnScreen:Bool;
    
    public function new(x:Null<Float> = null, y:Null<Float> = null, size:Int = -1, loop:Bool = true) {
        
        super();
        
        _loop = loop;
        
        randomise(x, y, size);
    }
    
    function randomise(x:Null<Float> = null, y:Null<Float> = null, size:Int = -1):Void {
        
        var ran = -1.0;
        if (x == null) {
            ran = Random.under(FlxG.camera.width);
            x = FlxG.camera.scroll.x + (FlxG.camera.width + ran) / scrollFactor.x;
            
            _lastCamX = FlxG.camera.scroll.x;
            _wasOnScreen = false;
        }
            
        if (y == null)
            y = Random.between(_min, _max, LevelData.TILE_SIZE);
        
        if (size == -1)
            size = Random.ibetween(0, 2);
        else
            size -= 2;
        
        this.x = x;
        this.y = y;
        loadGraphic(FlxG.bitmap.get(_key + "_" + size));
        
        if (ran >= 0) {
            
            // fixes my shitty logic during the intro transition
            while (isOnScreen())
                this.x += FlxG.camera.width;
        }
    }
    
    override public function update(elapsed:Float):Void {
        super.update(elapsed);
        
        if (_loop){
            
            if (isOnScreen(FlxG.camera))
                _wasOnScreen = true;
            else if (_wasOnScreen || FlxG.camera.scroll.x < _lastCamX)
                randomise();
        }
    }
    
    
    static function init(key:String):Void {
        
        var big = FlxG.bitmap.add(AssetPaths.image(key), false, key + "_1");
        big.persist = true;
        FlxG.bitmap.addGraphic(big);
        
        var small = FlxG.bitmap.create
            ( Std.int(LevelData.TILE_SIZE) * 2
            , big.bitmap.height
            , FlxColor.TRANSPARENT
            , true
            , key + "_0"
            );
        small.persist = true;
        FlxG.bitmap.addGraphic(small);
        
        var rect = new Rectangle(0, 0, LevelData.TILE_SIZE, big.bitmap.height);
        var point = new Point();
        small.bitmap.copyPixels(big.bitmap, rect, point);
        rect.x = LevelData.TILE_SIZE * 2;
        point.x = 16;//LevelData.TILE_SIZE;
        small.bitmap.copyPixels(big.bitmap, rect, point);
    }
}