package props.platforms;

import data.Ldtk;
import ldtk.Json;
import flixel.FlxG;
import flixel.system.debug.watch.Tracker;
import utils.SimplePath;


class MovingPlatform
extends TiledSprite
implements props.i.Togglable
implements props.i.PathFollower
{
    public var toggleIds:Array<EntityReferenceInfos>;
    public var path:SimplePath;
    
    public function new (x = 0.0, y = 0.0, tile = 5, cols = 1, rows = 1)
    {
        super(x, y, tile, cols, rows);
        
        immovable = true;
    }
    
    override function update(elapsed:Float)
    {
        super.update(elapsed);
        
        if (path != null && path.active && path.exists)
            path.update(elapsed);
    }
    
    override function draw()
    {
        if (path != null && path.visible && path.exists)
            path.draw();
        
        super.draw();
    }
    
    public function toggle(isOn:Bool)
    {
        path.active = isOn;
    }
    
    public static function fromLdtk(data:Entity_MOVING_PLATFORM):MovingPlatform
    {
        // Make platform
        final tileId = TiledSprite.tileIndexFromLdtk(data.f_tile_infos);
        final plat = new MovingPlatform(data.pixelX, data.pixelY, tileId);
        
        if (data.f_loop == LOOP)
            FlxG.watch.add(plat, "path", 'plat.${plat.ID}');
        
        return plat;
    }
    
    public static function createTrackerProfile()
    {
        return new TrackerProfile(MovingPlatform, ['x', 'y', 'velocity', 'path']);
    }
}