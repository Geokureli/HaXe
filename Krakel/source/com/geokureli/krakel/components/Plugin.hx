package com.geokureli.krakel.components;

import flixel.FlxBasic;
import flixel.FlxG;

/**
 * ...
 * @author George
 */
class Plugin extends FlxBasic {
    
    public function new() {
        super();
        
        setDefaults();
        
        init();
    }
    
    function setDefaults():Void { }
    
    function init():Void {
        
        FlxG.plugins.addIfUniqueType(this);
    }
}