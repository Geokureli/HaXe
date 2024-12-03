package data;

import data.Ldtk;
import flixel.FlxG;
import input.Controls;
import states.PlayState;

class Global
{
    inline static public final TILE = 16;
    static public var project(default, null):LdtkProject;
    static public var controls(default, null):Controls;
    
    static public function init()
    {
        project = new LdtkProject();
        controls = new Controls("p1");
        FlxG.inputs.addInput(controls);
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
}