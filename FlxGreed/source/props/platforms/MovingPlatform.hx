package props.platforms;

import data.Ldtk;
import ldtk.Json;
import flixel.FlxG;
import utils.SimplePath;


class MovingPlatform
extends TiledSprite
implements data.ITogglable
implements data.IPathFollower
{
    public var toggleIds:Array<EntityReferenceInfos>;
    public var simplePath:SimplePath;
    
    public function new (x = 0.0, y = 0.0, tile = 5, cols = 1, rows = 1)
    {
        super(x, y, tile, cols, rows);
        
        immovable = true;
    }
    
    override function update(elapsed:Float)
    {
        super.update(elapsed);
        
        if (simplePath != null && simplePath.active && simplePath.exists)
            simplePath.update(elapsed);
    }
    
    override function draw()
    {
        if (simplePath != null && simplePath.visible && simplePath.exists)
            simplePath.draw();
        
        super.draw();
    }
    
    public function toggle(isOn:Bool)
    {
        simplePath.active = isOn;
    }
    
    public static function fromLdtk(data:Entity_MOVING_PLATFORM):MovingPlatform
    {
        // Make platform
        final tileId = TiledSprite.tileIndexFromLdtk(data.f_tile_infos);
        final plat = new MovingPlatform(data.pixelX, data.pixelY, tileId);
        return plat;
    }
}