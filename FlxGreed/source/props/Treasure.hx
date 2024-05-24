package props;

import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

class Treasure extends Coin
{
    public var type:TreasureType;
    public function new (x = 0.0, y = 0.0, ?type:TreasureType)
    {
        super();
        
        if (type != null)
            setType(type);
    }
    
    public function setType(type:TreasureType)
    {
        animation.play(type.anim);
    }
    
    override function onCollect()
    {
        solid = false;
        // FlxG.sound
        
        FlxTween.tween(this, { y: y-16 }, 0.5, { ease:FlxEase.circOut, onComplete:(_)->kill() });
    }
}

enum abstract TreasureType(String) from String
{
    var EMERALD = "emerald";
    var DIAMOND = "diamond";
    var RUBY = "ruby";
    
    @:allow(props.Treasure)
    var anim(get, never):String;
    
    inline function get_anim() return this;
}