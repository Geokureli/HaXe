package props.platforms;

import props.i.Referable;
import data.Ldtk;
import ldtk.Json;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.path.FlxBasePath;
import flixel.util.FlxDestroyUtil;
import utils.SimplePath;


class ScalePlatform
extends TiledSprite
implements Referable
implements props.i.Linkable
implements props.i.Collidable
// implements props.i.Entity
{
    inline static final TILE = G.TILE;
    inline static final TOUCH_MARGIN = 1;// pixels
    inline static final SPEED_UP_TIME = 1.0;// seconds
    
    public final anchor = FlxPoint.get();
    public final opposingId:Null<String>;
    public final minY:Float;
    public final initialLength:Float;
    
    public var entityId:String;
    public var opposing(default, null):Null<ScalePlatform>;
    public var isLead(default, null):Bool = false;
    public var weight:Float;
    
    var touchObjs = new Array<FlxObject>();
    var prevTouchObjs = new Array<FlxObject>();
    final tether = new Tether();
    
    public function new (data:InitData)
    // tile = 5, cols = 1, rows = 1, ?opposingId:String)
    {
        var _x:Float;
        var _y:Float;
        var _tileId:Int;
        switch(data)
        {
            case Ldtk(data):
                this.anchor.y = data.f_anchor.cy * TILE;
                this.weight = data.f_weight
                    ?? (data.f_density * data.width * data.height / TILE / TILE);
                this.opposingId = data.f_opposing.entityIid;
                this.initialLength = data.cy - data.f_anchor.cy;
                this.minY = (data.f_anchor.cy + data.f_minLength) * TILE;
                
                final tileId = TiledSprite.tileIndexFromLdtk(data.f_tile_infos);
                super(data.pixelX, data.pixelY, tileId, true);
                
            case Custom(_??0 => x, _??0 => y, _??5 => tileId, _??1 => rows, _??1 => cols, opposingId, anchorY, weight, _??0 => minLength):
                this.anchor.y = anchorY;
                this.weight = switch weight
                {
                    case null: rows * cols;
                    case Manual(weight): weight;
                    case Auto(density): rows * cols * density;
                };
                this.opposingId = opposingId;
                this.initialLength = (y - anchor.y) / TILE;
                this.minY = anchor.y + (minLength * TILE);
                
                super(x, y, tileId, rows, cols, true);
        }
        
        mass = weight;
        immovable = true;
        maxVelocity.y = 100;
        drag.y = maxVelocity.y / SPEED_UP_TIME;
    }
    
    override function destroy()
    {
        super.destroy();
        
        opposing = null;
        FlxDestroyUtil.put(anchor);
    }
    
    #if FLX_DEBUG
    public function initDebugWatch()
    {
        FlxG.watch.addFunction('$ID.weight', ()->'${weight}/${opposing != null ? '${opposing.weight}' : "?"}');
        FlxG.watch.addFunction('$ID.touch', ()->'(${getTouchingCounts()})/(${opposing.getTouchingCounts()})');
    }
    
    function getTouchingCounts()
    {
        return '${prevTouchObjs.length}->${touchObjs.length}';
    }
    #end
    
    override function setEntitySize(width:Int, height:Int)
    {
        super.setEntitySize(width, height);
        
        anchor.x = x + width / 2;
    }
    
    public function initLinks(lookup:(id:String)->Null<Referable>)
    {
        opposing = cast(lookup(opposingId), ScalePlatform);
        if (false == opposing.isLead)
        {
            isLead = true;
            #if FLX_DEBUG
            initDebugWatch();
            #end
        }
    }
    
    override function onCollide(object:FlxObject)
    {
        super.onCollide(object);
        
        if (object.y + object.height - TOUCH_MARGIN < y && false == touchObjs.contains(object))
            touchObjs.push(object);
    }
    
    function trackTouches()
    {
        weight = mass;
        // Add weight of new colliders
        for (obj in touchObjs)
        {
            // if (false == prevTouchObjs.contains(obj))
                weight += G.utils.getObjWeight(obj);
        }
        
        // Remove weight on separation
        // for (obj in prevTouchObjs)
        // {
        //     if (false == touchObjs.contains(obj))
        //         weight -= G.utils.getObjWeight(obj);
        // }
    }
    
    function resetTouches()
    {
        // move current touches to prev
        final temp = prevTouchObjs;
        prevTouchObjs = touchObjs;
        touchObjs = temp;
        // remove all
        touchObjs.resize(0);
    }
    
    override function update(elapsed:Float)
    {
        if (isLead)
        {
            trackTouches();
            opposing.trackTouches();
            
            acceleration.y = 0;
            final netWeight = weight - (opposing != null ? opposing.weight : 0);
            if (netWeight < 0 && y > minY)
                acceleration.y = maxVelocity.y / SPEED_UP_TIME * netWeight;
            else if (netWeight > 0 && opposing.y > opposing.minY)
                acceleration.y = maxVelocity.y / SPEED_UP_TIME * netWeight;
            
            opposing.acceleration.y = -acceleration.y;
        }
        
        super.update(elapsed);
        tether.update(elapsed);
        
        if (isLead)
        {
            final totalLength = (opposing.initialLength + initialLength) * TILE;
            
            if (y < minY)
            {
                // This is fully retracted
                y = minY;
                opposing.y = opposing.anchor.y + totalLength;
                opposing.velocity.y = velocity.y = 0;
                opposing.acceleration.y = acceleration.y = 0;
            }
            else if (opposing.y < opposing.minY)
            {
                // Opposing is fully retracted
                opposing.y = opposing.minY;
                y = opposing.anchor.y + totalLength;
                opposing.velocity.y = velocity.y = 0;
                opposing.acceleration.y = acceleration.y = 0;
            }
            
            resetTouches();
            opposing.resetTouches();
        }
    }
    
    override function draw()
    {
        tether.drawAt(anchor.x, anchor.y, x + width / 2, y);
        
        super.draw();
    }
    
    public function getLength()
    {
        return y - anchor.y;
    }
    
    override function set_cameras(value)
    {
        tether.cameras = value;
        return super.set_cameras(value);
    }
    
    public static function fromLdtk(data:Entity_SCALE_PLATFORM):ScalePlatform
    {
        return new ScalePlatform(Ldtk(data));
    }
    
    public static function make
    ( x = 0.0, y = 0.0
    , tileId = 5, rows = 1, cols = 1
    , ?opposingId:String, anchorY:Float, weight:WeightData, minLength = 0.0
    ):ScalePlatform
    {
        return new ScalePlatform(Custom(x, y, tileId, opposingId, anchorY, weight, minLength));
    }
}

class Tether extends FlxSprite
{
    public function new ()
    {
        super();
        makeGraphic(1, 1, 0xFF000000);
    }
    
    public function drawAt(x1:Float, y1:Float, x2:Float, y2:Float)
    {
        final dis = FlxPoint.get(x2-x1, y2-y1);
        
        x = x1;
        y = y1;
        width = 1;
        height = dis.length;
        setGraphicSize(height, 1);
        origin.set(0, 0);
        angle = dis.degrees;
        
        draw();
    }
}

private enum InitData
{
    Ldtk(data:Entity_SCALE_PLATFORM);
    Custom
    ( ?x:Float, ?y:Float
    , ?tileId:Int, ?rows:Int, ?cols:Int
    , opposingId:String, anchorY:Float, ?weight:WeightData, ?minLength:Float
    );
}

private enum WeightData
{
    Manual(weight:Float);
    Auto(?density:Float);
}