package com.geokureli.astley.art;

import com.geokureli.astley.data.LevelData;

/**
 * ...
 * @author George
 */
class Shrub extends LoopSprite {
    
    static var DEFAULT_Y:Int;
    
    static public function init():Void {
        
        DEFAULT_Y = Std.int(LevelData.SKY_HEIGHT - LevelData.TILE_SIZE);
        
        LoopSprite.init("shrub");
    }
    
    public function new(x:Null<Float> = null, size:Int = -1, loop:Bool = true) {
        
        super(x, null, size, loop);
    }
    
    override function initVars():Void {
        super.initVars();
        
        _key = "shrub";
        _min = DEFAULT_Y;
        _max = DEFAULT_Y;
    }
}