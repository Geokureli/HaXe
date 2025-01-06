package props;

import props.i.Toggle;
import ldtk.Json;
import flixel.FlxSprite;

class Gate
extends FlxSprite
implements props.i.Resizable
implements props.i.Togglable
{
    public var toggleIds:Array<EntityReferenceInfos>;
    
    public function new (x = 0.0, y = 0.0)
    {
        super(x, y);
        
        loadGraphic(G.getMainGraphic(), true, 16, 16);
        animation.add("idle", [24]);
        animation.play("idle");
        immovable = true;
        origin.set(0, 0);
    }
    
    public function setEntitySize(width:Int, height:Int)
    {
        setGraphicSize(width, height);
        this.width = width;
        this.height = height;
    }
    
    public function toggle(isOn:Bool)
    {
        isOn ? kill() : revive();
    }
}