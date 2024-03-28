package com.geokureli.astley.data;

import flixel.FlxG;
import flixel.util.FlxSave;

#if newgrounds
    import com.geokureli.astley.data.NGData;
    
    import io.newgrounds.Call;
    import io.newgrounds.NG;
    import io.newgrounds.components.ScoreBoardComponent;
    import io.newgrounds.objects.events.Outcome;
#end

/**
 * ...
 * @author George
 */
class BestSave {
    
    static inline var FRESH_START:Bool = #if fresh_start_best_score true #else false #end;
    static inline var PRETEND_ZERO:Bool = #if pretend_zero_score true #else false #end;
    
    static public var best(get, set):Int;
    
    static var _best:Int;
    static var _saveFile:FlxSave;
    
    static public function init():Void {
        
        _saveFile = FlxG.save;
        
        _best = 0;
        if (Reflect.hasField(_saveFile.data, "best") && (!FRESH_START || PRETEND_ZERO)){
            
            _best = _saveFile.data.best;
            trace('save file found. best:$_best');
            
        } else if (FRESH_START)
            best = 0;
    }
    
    static public function loadBestScore():Void {
        
        #if newgrounds
            var callback:(Outcome<CallError>)->Void = null;
            
            if (NG.core.session.status.match(LOGGED_IN(_)) && !FRESH_START && !PRETEND_ZERO) {
                
                callback = (outcome) -> switch (outcome) {
                    
                    case FAIL(_):
                    case SUCCESS:
                        final board = NG.core.scoreBoards.get(NGData.SCOREBOARD);
                        board.requestScores(10, 0, Period.ALL, false, null, NG.core.session.current.user);
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
            
            NG.core.scoreBoards.loadList(callback);
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
            if (NG.core.session.status.match(LOGGED_IN(_)))
                NG.core.scoreBoards.get(NGData.SCOREBOARD).postScore(score);
        #end
    }
}