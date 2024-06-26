package astley.data;
import flixel.system.replay.FlxReplay;

/**
 * ...
 * @author George
 */
class Recordings {
    
    static private var _replays:Array<String> = [];
    
    static public function addRecording(recorder:FlxReplay):Void {
        
        _replays.push(recorder.save());
    }
    
    static public function getLatest():String {
        
        return _replays[_replays.length - 1];
    }
    
    static public function getReplays() {
        
        return _replays.copy();
    }
    
    static public function wipeReplays() {
        
        _replays.resize(0);
    }
}