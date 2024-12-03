import data.Global;
import flixel.FlxG;


class Main extends openfl.display.Sprite
{
    public function new()
    {
        super();
        
        final playState = ()->new states.PlayState.CollectState(LEGACY);
        #if debug
        final introState = playState;
        #else
        final introState = ()->new states.MenuState(playState);
        #end
        
        final game = new Game(2, ()->new BootState(introState));
        addChild(game);
    }
}

class Game extends flixel.FlxGame
{
    public function new (scale:Int, initialState, frameRate = 60, skipSplash = false, fullscreen = false)
    {
        final stage = openfl.Lib.current.stage;
        final gameWidth = Std.int(stage.stageWidth / scale);
        final gameHeight = Std.int(stage.stageHeight / scale);
        
        super(gameWidth, gameHeight, initialState, frameRate, frameRate, skipSplash, fullscreen);
    }
}

class BootState extends flixel.FlxState
{
    final nextState:flixel.util.typeLimit.NextState;
    
    public function new (nextState)
    {
        this.nextState = nextState;
        super();
    }
    
    override function create()
    {
        super.create();
        
        Global.init();
        FlxG.autoPause = false;
        FlxG.mouse.useSystemCursor = true;
    }
    
    override function update(elapsed:Float)
    {
        super.update(elapsed);
        FlxG.switchState(nextState);
    }
}