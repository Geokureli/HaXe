package props.ui;

import data.IResizable;
import flixel.text.FlxBitmapText;

class Text extends FlxBitmapText implements IResizable
{
    public function new (x = 0.0, y = 0.0, text)
    {
        super(x, y, text);
    }
    
    public function setEntitySize(width:Int, height:Int)
    {
        this.autoSize = false;
        this.wrap = WORD(NEVER);
        this.multiLine = true;
        this.fieldWidth = width;
        this.alignment = CENTER;
    }
}