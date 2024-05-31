import flixel.util.typeLimit.NextState;
import states.PlayState;
import states.MenuState;

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
        final playState = ()->new CollectState(LEGACY);
        #if debug
        _introState = playState;
        #else
        _introState = ()->new MenuState(playState);
        #end
    }
}