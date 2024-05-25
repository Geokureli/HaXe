package props;

import flixel.FlxSprite;
import flixel.util.FlxSignal;

class Button extends FlxSprite implements data.IEntityRef
{
    public var entityId:String;
    public var isOn(default, null) = false;
    public final onPress = new FlxSignal();
    
    public function new (x = 0.0, y = 0.0)
    {
        super(x, y);
        
        loadGraphic("assets/images/props-normal.png", true, 16, 16);
        animation.add("off", [22]);
        animation.add("on" , [23]);
        animation.play("off");
        
        offset.y = 6;
        height -= 6;
    }
    
    override function destroy()
    {
        super.destroy();
        
        onPress.removeAll();
    }
    
    public function press()
    {
        animation.play("on");
        onPress.dispatch();
    }
}