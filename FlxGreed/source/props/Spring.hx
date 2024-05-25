package props;

import flixel.FlxSprite;

class Spring extends FlxSprite
{
    public function new (x = 0.0, y = 0.0)
    {
        super(x, y);
        
        loadGraphic("assets/images/spring.png", true, 16, 22);
        animation.add("idle", [1]);
        animation.add("trigger", [1,2,2,3,3,3,3,2,2,1,0,0,1], 20, false);
        animation.play("idle");
        
        height = 12;
        offset.y = 10;
    }
    
    public function onSprung()
    {
        animation.play("trigger", true);
    }
}