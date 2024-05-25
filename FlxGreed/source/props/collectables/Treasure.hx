package props.collectables;

import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

// TODO: Don't extend Coin, here. Have both implement ICollectible
class Treasure extends flixel.FlxSprite implements data.ICollectable
{
    public var type:TreasureType;
    public function new (x = 0.0, y = 0.0, ?type:TreasureType)
    {
        super(x, y);
        
        loadGraphic("assets/images/props-normal.png", true, 16, 16);
        animation.add("emerald", [36]);
        animation.add("diamond", [37]);
        animation.add("ruby", [38]);
        
        if (type != null)
            setType(type);
    }
    
    public function setType(type:TreasureType)
    {
        this.type = type;
        animation.play(type.anim);
    }
    
    public function onCollect(collector:Hero)
    {
        solid = false;
        // FlxG.sound
        
        FlxTween.tween(this, { y: y-16 }, 0.5, { ease:FlxEase.circOut, onComplete:(_)->kill() });
    }
}

enum abstract TreasureType(String) from String
{
    public static final all:haxe.ds.ReadOnlyArray<TreasureType> = [EMERALD, DIAMOND, RUBY];
    var EMERALD = "emerald";
    var DIAMOND = "diamond";
    var RUBY = "ruby";
    
    public var anim(get, never):String;
    
    inline function get_anim() return this;
}