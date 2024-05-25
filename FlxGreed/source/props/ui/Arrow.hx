package props.ui;

import flixel.util.FlxDirection;
import flixel.FlxSprite;

abstract Arrow(FlxSprite) to FlxSprite
{
    inline public function new (x = 0.0, y = 0.0, ?direction:FlxDirection)
    {
        this = new FlxSprite(x, y);
        
        
        this.loadGraphic("assets/images/props-normal.png", true, 16, 16);
        
        if (direction != null)
            setDirection(direction);
    }
    
    inline public function setDirection(direction:FlxDirection)
    {
        this.animation.frameIndex = switch(direction)
        {
            case UP   : 40;
            case DOWN : 41;
            case LEFT : 42;
            case RIGHT: 43;
        }
    }
}