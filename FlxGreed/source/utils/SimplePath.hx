package utils;

import data.Ldtk;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.math.FlxPoint;
import flixel.path.FlxBasePath;
import flixel.path.FlxPath;
import flixel.system.debug.watch.Tracker;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import openfl.display.Graphics;

class SimplePath extends flixel.path.FlxBasePath
{
    static final TILE = G.TILE;
    
    public final speed:Float;
    public final nodeRest:Float;
    public final endRest:Float;
    public var rest:Float = 0.0;
    
    public function new (?nodes, ?target, speed = 4.0, nodeRest = 0.0, endRest = 0.0)
    {
        this.speed = speed;
        this.nodeRest = nodeRest;
        this.endRest = endRest;
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
    
    override function setNextIndex()
    {
        super.setNextIndex();
        
        if (nextIndex == -1)
            target.velocity.set(0, 0);
        else if (currentIndex == 0 && loopType.isLooping())
            rest = endRest;
        else if (currentIndex == nodes.length - 1)
            rest = endRest;
        else
            rest = nodeRest;
        
        if (rest > 0)
            target.velocity.set(0, 0);
    }
    
    override function updateTarget(elapsed:Float)
    {
        if (rest > 0)
            rest -= elapsed;
        else
        {
            // Aim velocity towards the next node then set magnitude to the desired speed
            target.velocity.set(next.x - target.x, next.y - target.y);
            target.velocity.length = speed * TILE;
        }
    }
    
    static public function fromLdtk(target:FlxObject, data:Ldtk_Entity):SimplePath
    {
        final pathData:LdtkEntityPath = cast data;
        final speed = pathData.f_speed;
        final endRest = pathData.f_endRest;
        final nodeRest = pathData.f_nodeRest;
        final nodes = nodesFromLdtk(pathData.f_path, data.pixelX, data.pixelY);
        
        final path = new SimplePath(nodes, target, speed, nodeRest, endRest);
        if (pathData.f_loop != null)
        {
            path.loopType = SimplePath.loopFromLdtk(pathData.f_loop);
        }
        path.visible = pathData.f_showPath;
        
        // if (pathData.f_loop == LOOP)
        // {
        //     FlxG.debugger.track(path, 'path.${path.ID}');
        // }
        
        return path;
    }
    
    static public function nodesFromLdtk(points:Array<ldtk.Point>, startX:Float, startY:Float):Array<FlxPoint>
    {
        final TILE = G.TILE;
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
    
    override function getCameras():Array<FlxCamera>
    {
        if (target != null)
            return target.getCameras();
        
        return super.getCameras();
    }
    
    override function draw()
    {
        flixel.FlxBasic.visibleCount++;
        
        for (camera in getCameras())
        {
            drawDebugOnCamera(camera);
        }
    }
    
    override function drawNode(gfx:Graphics, node:FlxPoint, size:Int, color:FlxColor)
    {
        final p = FlxPoint.get();
        p.set(node.x + target.width / 2, node.y + target.height / 2);
        super.drawNode(gfx, p, size, color);
        p.put();
    }
    
    override function drawLine(gfx:Graphics, node1:FlxPoint, node2:FlxPoint)
    {
        final p1 = FlxPoint.get();
        final p2 = FlxPoint.get();
        p1.set(node1.x + target.width / 2, node1.y + target.height / 2);
        p2.set(node2.x + target.width / 2, node2.y + target.height / 2);
        super.drawLine(gfx, p1, p2);
        p1.put();
        p2.put();
    }
    
    public static function createTrackerProfile()
    {
        return new TrackerProfile(SimplePath, ['currentIndex', 'nextIndex', 'rest', 'endRest', "nodeRest"]);
    }
}

typedef LdtkEntityPath =
{
    var f_path:Array<ldtk.Point>;
    var f_speed:Float;
    var f_endRest:Float;
    var f_nodeRest:Float;
    var f_showPath:Bool;
    @:optional var f_loop:Enum_PathLoop;
}