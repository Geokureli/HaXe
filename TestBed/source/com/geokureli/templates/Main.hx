package com.geokureli.templates;

import com.geokureli.krakel.data.AssetPaths;
import com.geokureli.krakel.Shell;
import com.geokureli.krakel.State;

/**
 * ...
 * @author George
 */
class Main extends Shell {
    
    public function new() { super(); }
    
    override function setDefaults():Void {
        super.setDefaults();
        
        _introState = IntroState;
        _scale = 1;
        
        AssetPaths.quickInit("assets/<project name>");
    }
}

class IntroState extends State {
    
    override public function create():Void { super.create(); }
    
    override function setDefaults():Void {
        super.setDefaults();
        
        bgColor = 0xFF5c94fc;
        //FlxG.camera.bounds = new FlxRect(0, 0, FlxG.width, FlxG.height);
        
        _musicName = AssetPaths.music("intro");
    }
    
    override function addBG():Void { super.addBG(); }
    override function addMG():Void { super.addMG(); }
    override function addFG():Void { super.addFG(); }
}