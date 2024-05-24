package props;

// import greed.schemes.Scheme;
// import krakel.jump.JumpScheme;
import data.Global;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.math.FlxMath;
/**
 * ...
 * @author George
 */
class Hero extends DialAPlatformer implements data.IPlatformer
{
    static var jumpData =
        [ 0 => { speed:11, speedUp:0.25, maxJump:5.5, toApex:0.5 }
        , 1 => { speed: 9, speedUp:0.35, maxJump:4.5, toApex:0.4 }
        , 2 => { speed: 7, speedUp:0.45, maxJump:3.5, toApex:0.3 }
        , 3 => { speed: 5, speedUp:0.55, maxJump:2.5, toApex:0.2 }
        ];
    
    inline static final TILE_SIZE = 16;
    
    public var weight(default, null):Int;
    
    var passClouds = false;
    
    public function new(x = 0.0, y = 0.0)
    {
        super(x, y);
        
        loadGraphic("assets/images/theif.png", true, 32, 24);
        
        offset.set(11, 2);
        width = 10;
        height = 22;
        
        animation.add("idle", [3]);
        animation.add("walk", [0,1,2,3,4,5], 10);
        animation.add("walkSkid", [7]);
        animation.add("jump", [8]);
        animation.add("jumpSkid", [6]);
        animation.add("c_idle", [14]);
        animation.add("climb", [14,15,16,17], 10);
        animation.add("duck", [22]);
        animation.add("slide", [23]);
        
        weight = 0;
        
        skidDrag = true;
        coyoteTime = 0.1;
        setWeight(0);
    }
    
    override function destroy()
    {
        super.destroy();
    }
    
    public function canPassClouds()
    {
        return passClouds;
    }
    
    public function onCollect(coin:Coin)
    {
        if (coin is Treasure)
        {
            onCollectTresure(cast coin);
        }
    }
    
    public function onCollectTresure(gem:Treasure)
    {
        setWeight(weight + 1);
    }
    
    public function onSprung(spring:Spring)
    {
        final data = jumpData[weight];
        setupVariableJump(2.0 * 1.5 * TILE_SIZE, 2.0 * data.maxJump * TILE_SIZE, 1.5 * data.toApex);
        _jumpTimer = 0;
        jump(false);
    }
    
    function setWeight(weight:Int)
    {
        this.weight = weight;
        
        final data = jumpData[weight];
        setupVariableJump(1.5 * TILE_SIZE, data.maxJump * TILE_SIZE, data.toApex);
        setupSpeed(data.speed * TILE_SIZE, data.speedUp);
    }
    
    function setStandardJump()
    {
        final data = jumpData[weight];
        setupVariableJump(1.5 * TILE_SIZE, data.maxJump * TILE_SIZE, data.toApex);
    }
    
    override function onLand()
    {
        setStandardJump();
    }
    
    override function update(elapsed:Float)
    {
        super.update(elapsed);
        
        final jump = controls.pressed.check(JUMP);
        maxVelocity.y = jump ? Math.abs(_jumpVelocity) : 0;
        
        passClouds = controls.pressed.check(DOWN);
        
        final isSkid = (flipX && acceleration.x > 0) || (!flipX && acceleration.x < 0);
        final onGround = getOnCoyoteGround();
        
        var action = "idle";
        if (onGround)
        {
            if (!flipX && velocity.x < 0)
                flipX = true;
            else if (flipX && velocity.x > 0)
                flipX = false;
            
            if (acceleration.x != 0)
                action = (isSkid ? "walkSkid" : "walk");
        }
        else
        {
            action = (isSkid ? "jumpSkid" : "jump");
        }
        
        animation.play(action);
    }
}