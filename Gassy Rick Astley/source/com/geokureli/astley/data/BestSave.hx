package com.geokureli.astley.data;

import flixel.util.FlxSave;

#if newgrounds
    import io.newgrounds.NG;
#end

/**
 * ...
 * @author George
 */
class BestSave {
    
    static inline var SAVE_ID:String = "GRA_Best";
    static inline var FRESH_START:Bool = false;
    static inline var PRETEND_ZERO:Bool = false;
    
    static public var best(get, set):Int;
    
    static var _best:Int;
    static var _saveFile:FlxSave = new FlxSave();
    
    static public function init():Void {
        
        _saveFile.bind(SAVE_ID);
        
        _best = 0;
        if (Reflect.hasField(_saveFile.data, "best") && (!FRESH_START || PRETEND_ZERO))
            _best = _saveFile.data.best;
        
        else if (FRESH_START)
            best = 0;
        
        #if newgrounds
            NG.core.requestScoreBoards();
        #end
    }
    
    static public function get_best():Int {
        
        return _best;
    }
    
    static public function set_best(score:Int):Int {
        
        if (!PRETEND_ZERO) {
            
            _saveFile.data.best = _best = score;
            //_saveFile.data.replay = Recordings.getLatest();
            _saveFile.flush();
            
            #if newgrounds
                if (NG.core.loggedIn)
                    NG.core.scoreBoards.get(NGData.SCOREBOARD).postScore(score);
            #end
        }
        
        return _best;
    }
}