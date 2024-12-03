package props;

import data.Global;
import data.ICollectable;
import data.IEntity;
import data.IEntityRef;
import data.IPathFollower;
import data.IPlatformer;
import data.IResizable;
import data.ITogglable;
import data.IToggle;
import data.Ldtk;
import flixel.FlxG;
import flixel.FlxBasic;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxContainer;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.path.FlxPath;
import flixel.tile.FlxTile;
import flixel.tile.FlxTilemap;
import flixel.util.FlxDirection;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxSignal;
import ldtk.Json;
import ldtk.Layer_Entities;
import props.platforms.MovingPlatform;
import props.platforms.ScalePlatform;
import props.collectables.Coin;
import props.collectables.Treasure;
import props.ldtk.LdtkLevel;
import props.ldtk.LdtkTilemap;
import props.ui.Arrow;
import props.ui.Text;
import props.ui.Sign;
import utils.SimplePath;

typedef HitMetaData = { ?x:Int, ?y:Int, ?width:Int, ?height:Int };
class GreedTile extends LdtkTile<Enum_TileTags>
{
    var hit:FlxRect;
    
    public function new (tilemap:GreedTilemap, index, width, height)
    {
        super(cast tilemap, index, width, height, true, NONE);
        
        #if debug
        ignoreDrawDebug = true;
        #end
    }
    
    override function destroy()
    {
        super.destroy();
        
        FlxDestroyUtil.put(hit);
    }
    
    override function setMetaData(metaData:String)
    {
        super.setMetaData(metaData);
        
        try
        {
            final data:{ ?hit:HitMetaData } = haxe.Json.parse(metaData);
            if (data.hit != null)
            {
                final hitData = data.hit;
                hit = FlxRect.get
                    ( hitData.x      ?? 0
                    , hitData.y      ?? 0
                    , hitData.width  ?? width
                    , hitData.height ?? height
                    );
                
                overlapsObject = function(object:FlxObject):Bool
                {
                    return object.x + object.width >= x + hit.left
                        && object.x < x + hit.right
                        && object.y + object.height >= y + hit.top
                        && object.y < y + hit.bottom;
                }
            }
        }
        catch(e)
        {
            FlxG.log.error('Error parsing tile: $index metaData: $metaData');
        }
    }
    
    override function setTags(tags:Array<Enum_TileTags>)
    {
        super.setTags(tags);
        
        visible = true;
        allowCollisions = NONE;
        #if debug
        ignoreDrawDebug = tags.length == 0;
        #end
        
        #if debug
        if (tags.contains(EDITOR_ONLY))
        {
            debugBoundingBoxColor = 0xFFFF00FF;
        }
        #end
        
        if (tags.contains(INVISIBLE))
        {
            visible = false;
        }
        
        if (tags.contains(SOLID))
        {
            allowCollisions = ANY;
        }
        
        if (tags.contains(HURT)) {}
        
        if (tags.contains(CLOUD))
        {
            allowCollisions = UP;
        }
    }
}

class GreedTilemap extends LdtkTypedTilemap<Enum_TileTags, GreedTile>
{
    override function destroy()
    {
        super.destroy();
    }
    
    override function createTile(index:Int, width:Float, height:Float):GreedTile
    {
        return new GreedTile(this, index, width, height);
    }
    
    override function objectOverlapsTiles<TObj:FlxObject>(object:TObj, ?callback:(GreedTile, TObj) -> Bool, ?position:FlxPoint, isCollision:Bool = true):Bool
    {
        // check if object can go through cloud tiles
        if (object is IPlatformer && (cast object:IPlatformer).canPassClouds())
        {
            function checkClouds(tile:GreedTile, _)
            {
                // if it's a cloud, pass through
                if (tile.hasTag(CLOUD) && object.y <= tile.y)
                    return false;
                
                // No callback
                if (callback == null)
                    return true;
                
                return callback(tile, object);
            }
            // Find which tile(s) the platformer is overlapping
            return super.objectOverlapsTiles(object, checkClouds, position, isCollision);
        }
        
        // normal collision
        return super.objectOverlapsTiles(object, callback, position, isCollision);
    }
}