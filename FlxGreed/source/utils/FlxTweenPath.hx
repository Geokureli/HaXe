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
    public var anchorMode:FlxPathAnchorMode = CENTER;
    
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
            final offset = anchorMode.computeAnchorOffset(target);
            currentTween = tweens.linearMotion
                ( target
                , current.x - offset.x
                , current.y - offset.y
                , next.x - offset.x
                , next.y - offset.y
                , speed
                , false
                );
            offset.put();
        }
    }
    
    override function updateTarget(elapsed:Float)
    {
        tweens.update(elapsed);
    }
    
    public static function nodesFromLdtk(points:Array<ldtk.Point>, startX:Float, startY:Float, center = false):Array<FlxPoint>
    {
        final TILE = Global.TILE;
        final offset = center ? TILE / 2 : 0;
        final nodes = points.map(function (p)
        {
            return FlxPoint.get(p.cx * TILE + offset, p.cy * TILE + offset);
        });
        
        nodes.unshift(FlxPoint.get(startX + offset, startY + offset));
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