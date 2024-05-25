package props.collectables;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

class Coin extends FlxSprite implements data.ICollectable
{
    public function new(x = 0.0, y = 0.0)
    {
        super(x, y);
        
        loadGraphic("assets/images/props-normal.png", true, 16, 16);
        animation.add("idle", [32, 33, 34, 35], 10);
        animation.add("collect", [32, 33, 34, 35], 20);
        animation.play("idle");
        
        offset.x = 4;
        offset.y = 3;
        width = 8;
        height = 11;
    }
    
    public function onCollect(collector:Hero)
    {
        solid = false;
        // FlxG.sound
        
        animation.play("collect");
        FlxTween.tween(this, { y: y-16 }, 0.5, { ease:FlxEase.circOut, onComplete:(_)->kill() });
    }
}