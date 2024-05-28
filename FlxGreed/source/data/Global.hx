package data;

import data.Ldtk;
import flixel.FlxG;
import input.Controls;
import states.PlayState;

class Global
{
    inline static public final TILE = 16;
    static public var project(get, null):Ldtk;
    
    static function get_project()
    {
        if (project == null)
            project = new Ldtk();
        
        return project;
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
    
    static public final controls = new Controls("p1");
}