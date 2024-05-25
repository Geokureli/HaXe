package states;

import flixel.FlxG;
import flixel.text.FlxBitmapText;
import flixel.util.typeLimit.NextState;

class MenuState extends flixel.FlxState
{
    var nextState:NextState;
    public function new (nextState:NextState)
    {
        this.nextState = nextState;
        
        super();
    }
    
    override function create()
    {
        final text = new FlxBitmapText("Greed");
        text.scale.set(4, 4);
        text.updateHitbox();
        text.screenCenter();
        add(text);
    }
    
    override function update(elapsed:Float)
    {
        super.update(elapsed);
        
        if (FlxG.keys.justPressed.ANY || FlxG.gamepads.anyPressed(ANY))
            FlxG.switchState(nextState);
    }
}