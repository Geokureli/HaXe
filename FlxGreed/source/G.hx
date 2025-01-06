package;

import data.Ldtk;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.system.debug.watch.Tracker;
import input.Controls;
import props.i.Collidable;
import states.PlayState;
import utils.Utils;

class G
{
    inline static public final TILE = 16;
    
    #if debug
    static public final dev = new DevG();
    #end
    
    static public var project(default, null):LdtkProject;
    static public var controls(default, null):Controls;
    
    static public var utils(default, null):Utils = new Utils();
    
    static public function init()
    {
        project = new LdtkProject();
        controls = new Controls("p1");
        FlxG.inputs.addInput(controls);
        
        dev.init();
    }
    
    public static function isHellMode()
    {
        return FlxG.state is HellState;
    }
    
    public static function getMainGraphic():String
    {
        if (isHellMode())
            return "assets/images/props-hell.png";
        return "assets/images/props-normal.png";
    }
    
    public static function overlap<TA:FlxObject, TB:FlxObject>(a:FlxBasic, b:FlxBasic, ?notify:(TA, TB)->Void, ?process:(TA, TB)->Bool)
    {
        return FlxG.overlap(a, b,
            function notifyFunc(a:TA, b:TB)
            {
                if (a is Collidable)
                    (cast a:Collidable).onCollide(b);
                
                if (b is Collidable)
                    (cast b:Collidable).onCollide(a);
                
                if (null != notify)
                    notify(a, b);
            },
            function processFunc(a:TA, b:TB)
            {
                return (false == (a is Collidable) || (cast a:Collidable).onProcess(b))
                    && (false == (b is Collidable) || (cast b:Collidable).onProcess(a))
                    && (null == process || process(a, b));
            }
        );
    }
    
    public static function collide<TA:FlxObject, TB:FlxObject>(a:FlxBasic, b:FlxBasic, ?notify:(TA, TB)->Void)
    {
        return overlap(a, b, notify, FlxObject.separate);
    }
}

#if FLX_DEBUG
@:bitmap("assets/images/debug/camera_tool.png")
private class CameraToolGraphic extends openfl.display.BitmapData {}
#end

#if debug
@:allow(G)
class DevG
{
    public function new ()
    {
        #if FLX_DEBUG
        // Add tracker profiles
        final add = FlxG.debugger.addTrackerProfile;
        add(props.platforms.MovingPlatform.createTrackerProfile());
        add(utils.SimplePath.createTrackerProfile());
        #end
    }
    
    function init()
    {
        // Add things we can't init right away, here
    }
}
#end