package props;

import flixel.FlxSprite;

class Gate extends FlxSprite implements data.IResizable
{
    public var buttonId:String;
    
    public function new (x = 0.0, y = 0.0)
    {
        super(x, y);
        
        loadGraphic(data.Global.getMainGraphic(), true, 16, 16);
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
    
    public function onButtonPress()
    {
        kill();
    }
}