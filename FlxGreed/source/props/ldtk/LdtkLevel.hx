package props.ldtk;

import data.Ldtk;
import flixel.FlxObject;
import flixel.math.FlxRect;
import flixel.util.FlxDestroyUtil;

/**
 * ...
 * @author George
 */
class LdtkLevel extends flixel.group.FlxContainer
{
    public var ldtkData(default, null):Ldtk_Level;
    var bounds:FlxRect;
    
    override function destroy()
    {
        super.destroy();
        
        bounds = FlxDestroyUtil.put(bounds);
    }
    
    public function loadLtdk(level:Ldtk_Level)
    {
        ldtkData = level;
        bounds = FlxRect.get(0, 0, level.pxWid, level.pxHei);
    }
    
    public function isInBounds(object:FlxObject)
    {
        final objBounds = FlxRect.weak(object.x, object.y, object.width, object.height);
        final intBounds = bounds.intersection(objBounds);
        final result = intBounds.width * intBounds.height > 0;
        intBounds.put();
        return result;
    }
}