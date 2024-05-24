package props;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

class Coin extends FlxSprite
{
    public function new(x = 0.0, y = 0.0)
    {
        super(x, y);
        
        loadGraphic("assets/images/gold.png", true, 16, 16);
        animation.add("ui", [0]);
        animation.add("idle", [0, 1, 2, 3], 10);
        animation.add("collect", [0, 1, 2, 3], 20);
        animation.add("emerald", [4]);
        animation.add("diamond", [5]);
        animation.add("ruby", [6]);
        animation.play("idle");
        
        offset.x = 4;
        offset.y = 3;
        width = 8;
        height = 11;
    }
    
    public function onCollect()
    {
        solid = false;
        // FlxG.sound
        
        animation.play("collect");
        FlxTween.tween(this, { y: y-16 }, 0.5, { ease:FlxEase.circOut, onComplete:(_)->kill() });
    }
}