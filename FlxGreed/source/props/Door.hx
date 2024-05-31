package props;

import flixel.FlxSprite;
import props.ui.Arrow;

class Door extends FlxSprite
{
    public final upArrow = new Arrow(UP);
    
    public function new (x = 0.0, y = 0.0)
    {
        super(x, y);
        
        loadGraphic("assets/images/door.png", 16, 24);
        
        upArrow.visible = false;
    }
    
    override function destroy()
    {
        super.destroy();
        
        upArrow.destroy();
    }
    
    override function draw()
    {
        super.draw();
        
        if (upArrow.visible && upArrow.exists)
        {
            upArrow.x = x + (width - upArrow.width) / 2;
            upArrow.y = y - upArrow.height;
            upArrow.draw();
        }
    }
}