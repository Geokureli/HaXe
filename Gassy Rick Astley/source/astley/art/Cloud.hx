package astley.art;

import astley.data.LevelData;

/**
 * ...
 * @author George
 */
class Cloud extends LoopSprite
{
    static var MAX:Int;
    static var MIN:Int;
    
    static public function init():Void {
        
        MAX = Std.int(4 * LevelData.TILE_SIZE);
        MIN = Std.int(-1 * LevelData.TILE_SIZE);
        
        LoopSprite.init("cloud");
    }
    
    public function new(x:Null<Float> = null, y:Null<Float> = null, size:Int = -1, loop:Bool = true) {
        super(x, y, size, loop);
    }
    
    override function initVars():Void {
        super.initVars();
        
        _key = "cloud";
        _min = MIN;
        _max = MAX;
        scrollFactor.x = scrollFactor.y = .5;
    }
}