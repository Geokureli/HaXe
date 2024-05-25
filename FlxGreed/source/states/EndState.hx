package states;

import data.Global;
import flixel.util.typeLimit.NextState;
import flixel.FlxG;
import flixel.text.FlxBitmapText;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import states.PlayState;

class EndState extends flixel.FlxState
{
    final wasHellMode:Bool;
    final hellModeUnlocked:Bool;
    
    var complete = false;
    
    public function new (?progress:GameProgress)
    {
        if (progress == null)
        {
            wasHellMode = true;
            progress = { coinsCollected:0, gemsCollected:0, coinsTotal:0, gemsTotal:0 };
        }
        else
        {
            hellModeUnlocked = progress.coinsCollected == progress.coinsTotal;
        }
        
        super();
        
        final title = new FlxBitmapText("Greed");
        title.scale.set(4, 4);
        title.updateHitbox();
        title.screenCenter(X);
        title.y = FlxG.height * 0.25;
        add(title);
        
        final coinText = new FlxBitmapText("Coins: 00/00");
        coinText.screenCenter(X);
        coinText.y = title.y + title.height + 24;
        coinText.visible = false;
        add(coinText);
        
        final gemText = new FlxBitmapText("Gems: 00/00");
        gemText.screenCenter(X);
        gemText.y = coinText.y + coinText.height + 4;
        gemText.visible = false;
        add(gemText);
        
        
        final actionText
            = wasHellMode
            ? "Thanks for playing!"
            : hellModeUnlocked
                ? "Go to Hell?"
                : "Replay?";
        
        final action = new FlxBitmapText(actionText);
        action.screenCenter(X);
        action.y = gemText.y + gemText.height + 4;
        action.visible = false;
        add(action);
        
        inline function flickerText(text:FlxBitmapText, onComplete:()->Void)
        {
            FlxTween.flicker(text, 0.5, 0.08, { onComplete: (_)->onComplete() });
        }
        
        function tweenText(text:FlxBitmapText, id:String, collected:Int, total:Int, onComplete:()->Void)
        {
            text.visible = true;
            
            FlxTween.num(0, collected, 1.0,
                { onComplete:(_)->flickerText(text, onComplete) },
                function (num)
                {
                    text.text = '$id: ${Std.int(num)}/$total';
                }
            );
        }
        
        FlxTimer.wait(1.0, function()
        {
            tweenText(coinText, "Coins", progress.coinsCollected, progress.coinsTotal,
                FlxTimer.wait.bind(1.0,
                    tweenText.bind(gemText, "Gems", progress.gemsCollected, progress.gemsTotal,
                        function ()
                        {
                            action.visible = true;
                            onIntroComplete();
                        }
                    )
                )
            );
        });
    }
    
    function onIntroComplete()
    {
        complete = true;
    }
    
    override function update(elapsed:Float)
    {
        super.update(elapsed);
        
        if (complete && (FlxG.keys.justPressed.ANY || FlxG.gamepads.anyPressed(ANY)))
        {
            FlxG.switchState(
                hellModeUnlocked
                    ? ()->new HellState()
                    : ()->new CollectState()
            );
        }
    }
}