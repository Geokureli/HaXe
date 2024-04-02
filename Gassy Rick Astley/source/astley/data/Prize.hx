package astley.data;

/**
 * ...
 * @author George
 */

#if newgrounds
    import io.newgrounds.NG;
#end

import astley.art.Tilemap;
import astley.art.ui.MedalPopup;

import krakel.data.AssetPaths;

class Prize {
    
    static public inline var NONE:String = "none";
    static public inline var BRONZE:String = "bronze";
    static public inline var SILVER:String = "silver";
    static public inline var GOLD:String = "gold";
    static public inline var PLATINUM:String = "platinum";
    
    static public var checkMedals:Bool;
    
    static var TIERS:Array<String> = [
        NONE, BRONZE, SILVER, GOLD, PLATINUM
    ];
    
    static var GOALS = 
        [ SecretData.PROGRESS_4 => 131.0
        , SecretData.PROGRESS_3 =>  51.0
        , SecretData.PROGRESS_2 =>  20.0
        , SecretData.PROGRESS_1 =>   8.0
        , SecretData.PROGRESS_0 =>   1.5
        ];
    
    static var ICONS = 
        [ SecretData.CREDITS_ME => "me"
        , SecretData.PLAY_AGAIN => "rick"
        , SecretData.PROGRESS_0 => "pipe"
        , SecretData.PROGRESS_1 => "bronze"
        , SecretData.PROGRESS_2 => "silver"
        , SecretData.PROGRESS_3 => "gold"
        , SecretData.PROGRESS_4 => "platinum"
        ];
    
    inline static public function getIconPath(id:Int):String {
        
        return AssetPaths.image('medals/${ICONS[id]}.gif', false);
    }
    
    static public function init():Void {
        
    }
    
    static public function unlockLocalMedals(best:Int){
        
        #if newgrounds
        if (NG.core.medals.state == Loaded) {
            
            MedalPopup.instance.enabled = false;
            checkProgressPrize(best);
            MedalPopup.instance.enabled = true;
            
        } else
            NG.core.medals.onLoad.add(unlockLocalMedals.bind(best));
        #end
    }
    
    static public function checkProgressPrize(score:Float):Void {
        
        for(goal in GOALS.keys()) {
            
            if(score >= GOALS.get(goal))
                unlockMedal(goal);
        }
    }
    
    static public function unlockMedal(id:Int):Void {
        
        #if newgrounds
        if (NG.core.session.status.match(LOGGED_IN(_)) && NG.core.medals.state == Loaded) {
            
            var medal = NG.core.medals.get(id);
            if (!medal.unlocked)
                medal.sendUnlock();
        }
        #end
    }
    
    static public inline var CREDIT_MEDAL:String = "That's me!";
    static public inline var CONTINUE_MEDAL:String = "Never gonna give you up";
    
    static var POWERS:Float = Math.pow(2.71828, TIERS.length - 1);
    static public var NUM_TIERS:Int = TIERS.length;
    
    static public function getPrize(score:Int):String {
        
        var percent:Float = Tilemap.getCompletion(score);
        if (Std.int(percent * POWERS) == 0) return TIERS[0];
        if (percent >= 1) return TIERS[TIERS.length - 1];
        
        return TIERS[Std.int(Math.log(Std.int(percent * POWERS)))];
    }
}