package com.geokureli.astley.art.ui;

import com.geokureli.astley.data.SecretData;

import com.geokureli.krakel.art.Layer;
import com.geokureli.krakel.data.AssetPaths;
import com.geokureli.krakel.data.serial.DameReader;

import flixel.FlxBasic;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

import haxe.Json;

#if newgrounds
import io.newgrounds.NG;
import io.newgrounds.objects.ScoreBoard;
#end

/**
 * ...
 * @author George
 */
class Credits extends Layer {
    
    var _currentPage:Int;
    var _pages:Array<CreditsLayer>;
    #if newgrounds
    var _scoreBoard:ScoreBoard;
    var _scoresSkip:Int;
    #end
    public var dameReader:DameReader;
    
    public function new() { super(); }
    
    public function start():Void {
        
        
        _pages = [];
        var page = 1;
        while(_assetsByName.exists('credits' + Std.string(page))) {
            
            _pages.push(cast _assetsByName['credits' + Std.string(page)]);
            
            page++;
        }
        
        #if newgrounds
        _scoresSkip = 0;
        if (NG.core.session.status.match(LOGGED_IN(_)))
        {
            _scoreBoard = NG.core.scoreBoards.get(SecretData.SCOREBOARD);
            loadNextScores();
        }
        #end
        _currentPage = 0;
        
        _assetsByName['press'].visible = false;
        startNextPage();
    }
    
    function startNextPage() {
        
        if (_currentPage < _pages.length) {
            
            _pages[_currentPage].startTransition(startNextPage);
            
            _currentPage++;
        #if newgrounds
        } else if (_scoreBoard != null && _scoreBoard.scores.length > 0) {
            
            var data:String = "";
            var y:Int = 71;
            for (score in _scoreBoard.scores) {
                
                data += '{ "class":"CreditsText", "text":"${ score.user.name }", "x":  8, "y":$y },'
                    + '{ "class":"CreditsText", "text":"${ score.value     }", "x":138, "y":$y },';
                y += 13;
            }
            
            data = '{ "class":"CreditsLayer", "name":"scores${_scoresSkip}", "children": [${data.substr(0, data.length - 1)}] }';
            
            var page:CreditsLayer = dameReader.create(Json.parse(data));
            page.startTransition(startNextPage);
            add(page);
            
            _scoresSkip += 10;
            loadNextScores();
        #end
        } else {
            
            // end logic
        }
    }
    
    #if newgrounds
    function loadNextScores():Void {
        
        _scoreBoard.requestScores(10, _scoresSkip);
    }
    #end
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
        
        cast(obj, FlxSprite).scrollFactor.x = 0;
        obj.visible = false;
        
        return super.add(obj);
    }
    
    public function startTransition(callback:Void->Void):Void {
        
        var member:FlxSprite;
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
            FlxTween.tween
                ( member
                , { x:xTo }
                , TRANSITION_TIME
                ,   { ease      : FlxEase.expoOut
                    , startDelay: delay
                    }
                );
                
            FlxTween.tween
                ( member
                , { x:xTo + FlxG.width }
                , TRANSITION_TIME
                ,   { ease      : FlxEase.expoIn
                    , startDelay: TRANSITION_TIME + WAIT_TIME + LATEST_STAGGER + delay
                    }
                );
        }
        
        if(callback != null)
            new FlxTimer().start((LATEST_STAGGER + TRANSITION_TIME) * 2 + WAIT_TIME, (_)->{ callback(); });
    }
}

class CreditsText extends flixel.text.FlxBitmapText {
    
    public function new ():Void {
        super(AssetPaths.bitmapFont("letters_med"));
        
        autoUpperCase = true;
    }
}