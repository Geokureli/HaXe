package astley.art;

import flixel.util.FlxColor;
import openfl.geom.ColorTransform;

class RainbowColor {
    
    static var COLORS:haxe.ds.ReadOnlyArray<FlxColor> =
        [ FlxColor.WHITE
        , FlxColor.RED
        , FlxColor.YELLOW
        , FlxColor.GREEN
        , FlxColor.CYAN
        , FlxColor.BLUE
        , FlxColor.MAGENTA
        , FlxColor.WHITE
        ];
    
    @:pure
    static public function get(t:Float) {
        
        final i = (((t % 1) + 1) % 1) * COLORS.length;
        
        if (i == COLORS.length)
            return COLORS[0];
        
        return FlxColor.interpolate(COLORS[Math.floor(i)], COLORS[Math.floor(i) + 1], (i % 1));
    }
}