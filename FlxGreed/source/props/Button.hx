package props;

import data.IToggle;
import flixel.FlxSprite;
import flixel.util.FlxSignal;

/* A button is a toggle that can't be untoggled */
class Button
extends FlxSprite
implements IToggle
{
    public var entityId:String;
    public var isOn(default, null) = false;
    public final onToggle = new FlxTypedSignal<(Bool)->Void>();
    
    public function new (x = 0.0, y = 0.0)
    {
        super(x, y);
        
        loadGraphic(data.Global.getMainGraphic(), true, 16, 16);
        animation.add("off", [22]);
        animation.add("on" , [23]);
        animation.play("off");
        
        offset.y = 6;
        height -= 6;
    }
    
    override function destroy()
    {
        super.destroy();
        
        onToggle.removeAll();
    }
    
    public function press()
    {
        animation.play("on");
        isOn = true;
        onToggle.dispatch(isOn);
    }
}