package data;

import data.Ldtk;
import input.Controls;

class Global
{
    static public var project(get, null):Ldtk;
    
    static function get_project()
    {
        if (project == null)
            project = new Ldtk();
        
        return project;
    }
    
    static public final controls = new Controls("p1");
}