package krakel;

import krakel.data.BuildInfo;
import flash.display.Sprite;
import flash.events.Event;
import flash.Lib;
import flixel.FlxState;

/**
 * ...
 * @author George
 */
class Shell extends Sprite {
    
    /** The Game class the program starts with. */
    var _gameFactory:()->Game;
    var _introState:()->FlxState;
    
    var _gameWidth:Int;
    var _gameHeight:Int;
    var _frameRate:Int;
    var _updateRate:Int;
    var _scale:Float;
    
    var _skipSplash:Bool;
    var _fullScreen:Bool;
    
    var _game:Game;
    
    public function new(?gameFactory:()->Game) {
        
        _gameFactory = gameFactory;
        
        super();
        
        setDefaults();
        
        if (stage != null) 
        {
            init();
        }
        else 
        {
            addEventListener(Event.ADDED_TO_STAGE, init);
        }
    }
    
    function setDefaults():Void {
        
        _gameWidth = -1;
        _gameHeight = -1;
        
        _frameRate = 30;
        _updateRate = -1;
        
        _skipSplash = false;
        _fullScreen = false;
        
        _scale = 1;
        _introState = State.new;
    }
    
    function init(?e:Event):Void {
        
        if (e != null) removeEventListener(e.type, init);
        
        // trace(BuildInfo.buildInfo);
        
        setupGame();
    }
    
    function setupGame():Void {
        
        if (_gameFactory != null) {
            
            addChild(_game = _gameFactory());
            
        } else {
            
            if (_gameWidth < 0) {
                
                _gameWidth = Std.int(Lib.current.stage.stageWidth / _scale);
            }
            
            if (_gameHeight < 0) {
                
                _gameHeight = Std.int(Lib.current.stage.stageHeight / _scale);
            }
            
            if (_updateRate == -1) {
                
                _updateRate = _frameRate;
            }
            
            addChild(
                _game = new Game(
                    _gameWidth, _gameHeight,
                    _introState,
                    _updateRate, _frameRate,
                    _skipSplash,
                    _fullScreen
                )
            );
        }
    }
}