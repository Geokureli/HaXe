package utils;

import data.Global;
import data.Ldtk;
import flixel.math.FlxPoint;
import flixel.path.FlxBasePath;
import flixel.path.FlxPath;
import flixel.tweens.FlxTween;

class FlxTweenPath extends FlxBasePath
{
    public var speed:Float;
    public var anchorMode:FlxPathAnchorMode = TOP_LEFT;
    
    var tweens:FlxTweenManager = new FlxTweenManager();
    var currentTween:FlxTween;
    
    public function new (?nodes, ?target, speed = 100.0)
    {
        this.speed = speed;
        
        super(nodes, target);
    }
    
    override function isTargetAtNext(elapsed:Float):Bool
    {
        return currentTween.finished;
    }
    
    override function setNextIndex()
    {
        super.setNextIndex();
        
        if (finished == false)
        {
            currentTween = tweens.linearMotion
                ( target
                , current.x
                , current.y
                , next.x
                , next.y
                , speed
                , false
                );
        }
    }
    
    override function updateTarget(elapsed:Float)
    {
        tweens.update(elapsed);
    }
    
    public static function nodesFromLdtk(points:Array<ldtk.Point>, startX:Float, startY:Float):Array<FlxPoint>
    {
        final TILE = Global.TILE;
        final nodes = points.map(function (p)
        {
            return FlxPoint.get(p.cx * TILE, p.cy * TILE);
        });
        
        nodes.unshift(FlxPoint.get(startX, startY));
        return nodes;
    }
    
    public static function loopFromLdtk(loop:Enum_PathLoop):FlxPathLoopType
    {
        return switch(loop)
        {
            case Enum_PathLoop.ONCE: FlxPathLoopType.ONCE;
            case Enum_PathLoop.LOOP: FlxPathLoopType.LOOP;
            case Enum_PathLoop.YOYO: FlxPathLoopType.YOYO;
        }
    }
    
}