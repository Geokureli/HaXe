package utils;

import data.Global;
import data.Ldtk;
import flixel.FlxObject;
import flixel.math.FlxPoint;
import flixel.path.FlxBasePath;
import flixel.path.FlxPath;
import flixel.tweens.FlxTween;

class SimplePath extends flixel.path.FlxBasePath
{
    static final TILE = Global.TILE;
    
    public var speed:Float;
    
    public function new (?nodes, ?target, speed = 4.0)
    {
        this.speed = speed;
        super(nodes, target);
    }
    
    override function isTargetAtNext(elapsed:Float):Bool
    {
        final frameSpeed = elapsed * speed;
        final deltaX = next.x - target.x;
        final deltaY = next.y - target.y;
        // Whether the distance remaining is less than the distance we will travel this frame
        return Math.sqrt(deltaX * deltaX + deltaY * deltaY) <= frameSpeed;
    }
    
    override function updateTarget(elapsed:Float)
    {
        // Aim velocity towards the next node then set magnitude to the desired speed
        target.velocity.set(next.x - target.x, next.y - target.y);
        target.velocity.length = speed * TILE;
    }
    
    static public function fromLdtk(target:FlxObject, data:Ldtk_Entity):SimplePath
    {
        final pathData:LdtkEntityPath = cast data;
        final nodes = nodesFromLdtk(pathData.f_path, data.pixelX, data.pixelY);
        final speed = pathData.f_speed;
        final path = new SimplePath(nodes, target, speed);
        if (pathData.f_loop != null)
        {
            path.loopType = SimplePath.loopFromLdtk(pathData.f_loop);
        }
        
        return path;
    }
    
    static public function nodesFromLdtk(points:Array<ldtk.Point>, startX:Float, startY:Float):Array<FlxPoint>
    {
        final TILE = Global.TILE;
        final nodes = points.map(function (p)
        {
            return FlxPoint.get(p.cx * TILE, p.cy * TILE);
        });
        
        nodes.unshift(FlxPoint.get(startX, startY));
        return nodes;
    }
    
    static public function loopFromLdtk(loop:Enum_PathLoop):FlxPathLoopType
    {
        return switch(loop)
        {
            case Enum_PathLoop.ONCE: FlxPathLoopType.ONCE;
            case Enum_PathLoop.LOOP: FlxPathLoopType.LOOP;
            case Enum_PathLoop.YOYO: FlxPathLoopType.YOYO;
        }
    }
}

typedef LdtkEntityPath =
{
    var f_path:Array<ldtk.Point>;
    var f_speed:Float;
    @:optional var f_loop:Enum_PathLoop;
}