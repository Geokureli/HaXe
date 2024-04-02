package astley.art;

import astley.data.LevelData;
import com.geokureli.krakel.data.AssetPaths;
import com.geokureli.krakel.art.LoopingTilemap;

import flixel.tile.FlxBaseTilemap.FlxTilemapAutoTiling;

/**
 * ...
 * @author George
 */
class Grass extends LoopingTilemap {
    
    public function new() {
        //todo: find graphic width/height in loopingtilemap constructor
        super("1,\n2,\n3,", AssetPaths.image("tiles_0"), 16, 16, true, false, FlxTilemapAutoTiling.OFF, 0, 1, 2);
        
        y = LevelData.SKY_HEIGHT - LevelData.TILE_SIZE;
        
        height = LevelData.TILE_SIZE * 2;
        //offset.y = LevelData.TILE_SIZE;
        solid = true;
    }
    
//override public function draw():Void { super.draw(); }
}