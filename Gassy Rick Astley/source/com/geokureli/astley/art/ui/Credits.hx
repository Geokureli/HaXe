package com.geokureli.astley.art.ui;

import com.geokureli.krakel.art.Layer;
import com.geokureli.krakel.art.Sprite;
import flixel.FlxBasic;
import flixel.FlxG;
import motion.Actuate;
import motion.easing.Expo;

/**
 * ...
 * @author George
 */
class Credits extends Layer {
    
    var _currentPage:Int;
    var _pages:Array<CreditsLayer>;
    
    public function new() { super(); }
    
    public function start():Void {
        
        _currentPage = 1;
        
        _pages = [];
        while(_assetsByName.exists('credits' + Std.string(_currentPage))) {
            
            _pages.push(cast _assetsByName['credits' + Std.string(_currentPage)]);
            
            _currentPage++;
        }
        _currentPage = 0;
        
        _assetsByName['press'].visible = false;
        startNextPage();
    }
    
    function startNextPage() {
        
        if (_pages.length > _currentPage) {
            
            _pages[_currentPage].startTransition(startNextPage);
            
            _currentPage++;
        }
    }
}


/**
* ...
* @author George
*/
class CreditsLayer extends Layer {
    
    inline static var TRANSITION_TIME:Float = 2.0;
    inline static var WAIT_TIME      :Float = 2.0;
    inline static var LATEST_STAGGER :Float = 2.0;
    
    public function new() { super(); }	
    
    override public function add(obj:FlxBasic):FlxBasic {
        
        cast(obj, Sprite).scrollFactor.x = 0;
        obj.visible = false;
        
        return super.add(obj);
    }
    
    public function startTransition(callback:Void->Void):Void {
        
        var member:Sprite;
        var maxDelay:Float = 0.0;
        var delay:Float;
        var xTo:Float;
        
        for(i in 0 ... length) {
            
            member = cast members[i];
            
            if (member == null) return;
            
            delay = member.y / FlxG.height * LATEST_STAGGER;
            if (delay > maxDelay)
                maxDelay = delay;
            
            xTo = member.x;
            member.x = -FlxG.width;
            member.visible = true;
            Actuate.tween(member, TRANSITION_TIME, { x:xTo } )
                .ease(Expo.easeOut)
                .delay(delay)
                .snapping();
            Actuate.tween(member, TRANSITION_TIME, { x:xTo + FlxG.width }, false)
                .ease(Expo.easeIn)
                .delay(TRANSITION_TIME + WAIT_TIME + LATEST_STAGGER + delay)
                .snapping();
        }
        
        if(callback != null)
            Actuate.timer((LATEST_STAGGER + TRANSITION_TIME) * 2 + WAIT_TIME).onComplete(callback);
    }
}