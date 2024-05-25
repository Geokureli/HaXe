package props;

import data.ICollectable;
import data.Global;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.math.FlxMath;
import props.collectables.Coin;
import props.collectables.Treasure;

typedef JumpData = { minJump:Float, maxJump:Float, toApex:Float };
typedef MoveData = { speed:Float, speedUp:Float };
typedef FullHeroData = JumpData & MoveData;

/**
 * ...
 * @author George
 */
class Hero extends DialAPlatformer implements data.IPlatformer
{
    static var jumpData:Map<Int, FullHeroData> =
        [ 0 => { speed:11, speedUp:0.25, minJump:1.0, maxJump:5.25, toApex:0.5 }
        , 1 => { speed: 9, speedUp:0.35, minJump:1.0, maxJump:4.25, toApex:0.4 }
        , 2 => { speed: 7, speedUp:0.45, minJump:1.0, maxJump:3.25, toApex:0.3 }
        , 3 => { speed: 5, speedUp:0.55, minJump:1.0, maxJump:2.25, toApex:0.2 }
        ];
    
    static var springData:Map<Int, JumpData> =
        [ 0 => { minJump:5.0, maxJump:7.0, toApex:0.55 }
        , 1 => { minJump:4.0, maxJump:6.0, toApex:0.50 }
        , 2 => { minJump:3.0, maxJump:5.0, toApex:0.45 }
        , 3 => { minJump:2.0, maxJump:4.0, toApex:0.40 }
        ];
    
    inline static final TILE_SIZE = 16;
    
    public var weight(default, null):Int;
    
    var passClouds = false;
    
    public var state(default, null):HeroState = PLATFORMING;
    
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
    
    public function onCollect(collectable:ICollectable)
    {
        if (collectable is Treasure)
        {
            onCollectTreasure(cast collectable);
        }
    }
    
    public function onCollectTreasure(gem:Treasure)
    {
        setWeight(weight + 1);
    }
    
    public function isLandingOn(object:FlxObject)
    {
        return velocity.y > 0 && last.y + height < object.y;
    }
    
    public function onSprung(spring:Spring)
    {
        final data = springData[weight];
        setupVariableJump(data.minJump * TILE_SIZE, data.maxJump * TILE_SIZE, data.toApex);
        _jumpTimer = 0;
        jump(false);
    }
    
    public function fallOut()
    {
        kill();// TODO:Death sequence
    }
    
    public function onSpike()
    {
        kill();// TODO:Death sequence
    }
    
    function setWeight(weight:Int)
    {
        this.weight = weight;
        
        final data = jumpData[weight];
        setupVariableJump(data.minJump * TILE_SIZE, data.maxJump * TILE_SIZE, data.toApex);
        setupSpeed(data.speed * TILE_SIZE, data.speedUp);
    }
    
    function setStandardJump()
    {
        final data = jumpData[weight];
        setupVariableJump(data.minJump * TILE_SIZE, data.maxJump * TILE_SIZE, data.toApex);
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

enum HeroState
{
    PLATFORMING;
    CLIMBING;
}