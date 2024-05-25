package props.ui;

import flixel.FlxSprite;

enum SignType
{
    HOLD;
    BUTTON;
}

abstract Sign(FlxSprite) to FlxSprite
{
    inline public function new (x = 0.0, y = 0.0, ?type:SignType)
    {
        this = new FlxSprite(x, y);
        
        
        this.loadGraphic("assets/images/signs.png", true, 24, 24);
        
        if (type != null)
            setType(type);
    }
    
    inline public function setType(type:SignType)
    {
        switch(type)
        {
            case HOLD   :
                this.animation.frameIndex = 0;
            case BUTTON :
                this.animation.frameIndex = 1;
        }
    }
}