package com.geokureli.astley.data;

import com.geokureli.krakel.components.Plugin;

import flixel.input.mouse.FlxMouse;
import flixel.input.keyboard.FlxKeyboard;
import flixel.FlxG;

/**
 * ...
 * @author George
 */
class FartControl extends Plugin {
    
    static public var down(get, never):Bool;
    static public var enabled:Bool = true;
    static public var replayMode:Bool = false;
    static private var _instance:FartControl;
    
    var lastCount:Int;
    var _antiPress:Bool;
    
    public var keys:FlxKeyboard;
    public var mouse:FlxMouse;
    public var isButtonDown:Bool;
    
    static public function create():Void {
        
        _instance = new FartControl();
    }
    
    public function new () { super(); }
    
    override function setDefaults():Void {
        super.setDefaults();
        
        isButtonDown = false;
        _antiPress = true;
    }
    
    override public function update(elapsed:Float):Void {
        
        isButtonDown = false;
        
        if (!(keys  != null ? keys.justPressed.ANY : FlxG.keys.justPressed.ANY)
        &&  !(mouse != null ? mouse.pressed : FlxG.mouse.pressed)) {
            
            _antiPress = true;
            
        } else if(_antiPress) {
            
            _antiPress = false;
            isButtonDown = enabled || replayMode;
        }
    }
    
    static public function get_down():Bool { return _instance.isButtonDown; }
}