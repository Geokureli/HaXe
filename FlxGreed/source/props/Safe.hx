package props;

import flixel.FlxObject;
import flixel.FlxSprite;

class Safe extends FlxSprite
{
    public function new (x = 0.0, y = 0.0)
    {
        super(x, y);
        
        loadGraphic(data.Global.getMainGraphic(), true, 16, 16);
        animation.add("idle", [29]);
        animation.play("idle");
        
        acceleration.y = 1000;
        drag.x = 400;
        collisionXDrag = ALWAYS;
    }
}