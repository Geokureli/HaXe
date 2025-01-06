package props;

import flixel.FlxObject;
import flixel.FlxSprite;
import props.i.Collidable;
import props.i.Tossable;

class Safe extends FlxSprite
implements Collidable
implements Tossable
{
    var tosser:Null<FlxObject> = null;
    
    public function new (x = 0.0, y = 0.0)
    {
        super(x, y);
        
        loadGraphic(G.getMainGraphic(), true, 16, 16);
        animation.add("idle", [29]);
        animation.play("idle");
        
        acceleration.y = 1000;
        drag.x = 400;
        collisionXDrag = ALWAYS;
        allowCollisions = UP | DOWN;
    }
    
    public function onProcess(object:FlxObject)
    {
        if (!moves)
            return false;
        
        if (tosser != null && object == tosser)
            false;
        
        if (object is Hero)
        {
            immovable = true;
            allowCollisions = UP;
        }
        else
        {
            immovable = false;
            allowCollisions = ANY;
        }
        return true;
    }
    
    public function onCollide(object:FlxObject){}
    
    override function update(elapsed:Float)
    {
        super.update(elapsed);
        
        if (tosser != null)
        {
            // Prevent immediate collisions with tosser
            if (G.overlap(tosser, this) == false)
                tosser = null;
        }
    }
    
    public function onPickUp(carrier:FlxObject)
    {
        active = false;
        moves = false;
    }
    
    public function onToss(carrier:FlxObject)
    {
        active = true;
        moves = true;
        tosser = carrier;
    }
}