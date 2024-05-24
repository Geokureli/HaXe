package props;

import flixel.FlxSprite;

class Door extends FlxSprite
{
    public function new (x = 0.0, y = 0.0)
    {
        super(x, y);
        
        loadGraphic("assets/images/door.png", 16, 24);
    }
}