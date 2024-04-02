package astley.data;

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
    public var lastPressId:String;
    
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
        
        final keys  = this.keys  != null ? this.keys  : FlxG.keys;
        final mouse = this.mouse != null ? this.mouse : FlxG.mouse;
        if (!keys.justPressed.ANY && !mouse.justPressed) {
            
            _antiPress = true;
            
        } else if(_antiPress) {
            
            _antiPress = false;
            isButtonDown = enabled || replayMode;
            
            lastPressId = mouse.justPressed ? "m" : getLastPressedKey(keys);
        }
    }
    
    function getLastPressedKey(keys:FlxKeyboard) {
        
        @:privateAccess
        for (key in keys._keyListArray) {
            
            if (key != null && key.justPressed) {
                
                return switch (key.ID) {
                    
                    case LEFT : "L-A";
                    case RIGHT: "R-A";
                    case UP   : "U-A";
                    case DOWN : "D-A";
                    case key  : String.fromCharCode(key);
                }
            }
        }
        return "";
    }
    
    static public function get_down():Bool { return _instance.isButtonDown; }
}