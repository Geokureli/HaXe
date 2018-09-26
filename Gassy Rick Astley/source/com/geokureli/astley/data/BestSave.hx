package com.geokureli.astley.data;

import io.newgrounds.components.ScoreBoardComponent.Period;
import flixel.util.FlxSave;

#if newgrounds
    import com.geokureli.astley.data.NGData;
    
    import io.newgrounds.NG;
#end

/**
 * ...
 * @author George
 */
class BestSave {
    
    static inline var SAVE_ID:String = "GRA_Best";
    static inline var FRESH_START:Bool = #if fresh_start_best_score true #else false #end;
    static inline var PRETEND_ZERO:Bool = #if pretend_zero_score true #else false #end;
    
    static public var best(get, set):Int;
    
    static var _best:Int;
    static var _saveFile:FlxSave = new FlxSave();
    
    static public function init():Void {
        
        _saveFile.bind(SAVE_ID);
        
        _best = 0;
        if (Reflect.hasField(_saveFile.data, "best") && (!FRESH_START || PRETEND_ZERO)){
            
            _best = _saveFile.data.best;
            trace('save file found. best:$_best');
            
        } else if (FRESH_START)
            best = 0;
    }
    
    static public function loadBestScore():Void {
        
        #if newgrounds
            var callback:Void->Void = null;
            
            if (NG.core.loggedIn && !FRESH_START && !PRETEND_ZERO) {
                
                callback = () -> {
                    
                    var board = NG.core.scoreBoards.get(NGData.SCOREBOARD);
                    //TODO: allow null
                    board.requestScores(10, 0, Period.ALL, false, null, NG.core.user);
                    board.onUpdate.add(
                        () -> {
                            trace('remote best loaded: ${board.scores[0].value}');
                            if (board.scores[0].value >= _best) {
                                
                                _best = board.scores[0].value;
                                saveLocal(_best);
                                trace("saving remote best to local");
                                
                            } else {
                                
                                Prize.unlockLocalMedals(_best);
                                saveRemote(_best);
                                trace("saving local best to remote");
                            }
                        }
                    );
                };
            }
            
            NG.core.requestScoreBoards(callback);
        #end
    }
    
    static public function get_best():Int {
        
        return _best;
    }
    
    static public function set_best(score:Int):Int {
        
        if (!PRETEND_ZERO) {
            
            saveLocal(score);
            saveRemote(score);
        }
        
        return _best;
    }
    
    static inline function saveLocal(score:Int):Void {
        
        _saveFile.data.best = _best = score;
        //_saveFile.data.replay = Recordings.getLatest();
        _saveFile.flush();
    }
    
    static inline function saveRemote(score:Int):Void {
         
        #if newgrounds
            if (NG.core.loggedIn)
                NG.core.scoreBoards.get(NGData.SCOREBOARD).postScore(score);
        #end
    }
}