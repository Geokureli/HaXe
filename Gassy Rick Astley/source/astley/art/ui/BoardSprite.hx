package astley.art.ui;

import krakel.data.AssetPaths;

import flixel.math.FlxRect;

class BoardSprite extends flixel.addons.display.FlxSliceSprite {
    
    public function new(width:Int, height:Int) {
        
        super(AssetPaths.bitmapData("board"), new FlxRect(5, 7, 1, 1), width, height);
        stretchBottom = stretchTop = stretchCenter = stretchLeft = stretchRight = true;
    }
    
    //override function set_x(x:Float):Float { return super.set_x(Std.int(x); }
    //override function set_y(y:Float):Float { return super.set_y(Std.int(y); }
    override function set_width(width:Float):Float { return super.set_width(Std.int(width)); }
    override function set_height(height:Float):Float { return super.set_height(Std.int(height)); }
}
