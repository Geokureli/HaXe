import flixel.util.typeLimit.NextState;
import states.PlayState;

import flixel.text.FlxBitmapText;
import flixel.FlxG;

class Main extends krakel.Shell
{
    public function new()
    {
        super();
        
        FlxG.autoPause = false;
        FlxG.mouse.useSystemCursor = true;
    }
    
    override function setDefaults():Void
    {
        super.setDefaults();
        
        _frameRate = 60;
        _scale = 2;
        _introState = PlayState.new;
        // _introState = ()->new IntroState(PlayState.new);
    }
}

class IntroState extends krakel.State
{
    var nextState:NextState;
    public function new (nextState:NextState)
    {
        this.nextState = nextState;
        
        super();
    }
    
    override function setDefaults()
    {
        super.setDefaults();
    }
    
    override function addBG()
    {
        super.addBG();
    }
    
    override function addMG()
    {
        super.addMG();
    }
    
    override function addFG()
    {
        super.addFG();
        
        final text = new FlxBitmapText("Greed");
        text.screenCenter();
        add(text);
    }
    
    override function update(elapsed:Float)
    {
        super.update(elapsed);
        
        if (FlxG.mouse.pressed)
            FlxG.switchState(nextState);
    }
}