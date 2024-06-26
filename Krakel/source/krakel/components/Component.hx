package krakel.components ;

import flixel.FlxBasic;

/**
 * ...
 * @author George
 */
class Component extends FlxBasic {
    
    public var target(default, set):IComponentHolder;
    var _components(get, never):ComponentList;
    
    public var enabled(default, set):Bool;
    
    public function new() {
        super();
        
        setDefaults();
    }
    
    function setDefaults() {
        
        enabled = true;
    }
    
    /** Called by the target before it's own update process. */
    public function preUpdate(elapsed:Float):Void { }
    /** Called by the target after it's own update process. */
    //override public function update(elapsed:Float):Void { super.update(elapsed); }
    
    /** Called by the target before it's own draw process. */
    public function preDraw():Void { }
    /** Called by the target after it's own draw process. */
    override public function draw():Void { }
    
    function get__components():ComponentList { return target.components; }
    
    function set_target(value:IComponentHolder):IComponentHolder {
        
        if (value != null) {
            
            target = value;
            revive();// --- POST CALL
            
        } else {
            
            kill();// --- PRE CALL
            target = null;
        }
        
        return value;
    }
    
    function set_enabled(value:Bool):Bool { return enabled = value; }
}