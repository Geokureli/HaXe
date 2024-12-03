package props;

import data.ICollectable;
import data.Global;
import data.Ldtk;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.input.FlxControls;
import flixel.addons.util.FlxFSM;
import flixel.math.FlxPoint;
import flixel.math.FlxMath;
import input.Controls;
import props.GreedLevel;
import props.collectables.Coin;
import props.collectables.Treasure;
import states.PlayState;

typedef JumpData = { minJump:Float, maxJump:Float, toApex:Float };
typedef MoveData = { jumpDist:Float, speedUp:Float };
typedef FullHeroData = JumpData & MoveData;

/**
 * ...
 * @author George
 */
class Hero extends DialAPlatformer implements data.IPlatformer
{
    static var jumpData:Map<Int, FullHeroData> =
        [ 0 => { jumpDist:11, speedUp:0.4, minJump:1.0, maxJump:5.25, toApex:0.5 }
        , 1 => { jumpDist: 9, speedUp:0.4, minJump:1.0, maxJump:4.25, toApex:0.4 }
        , 2 => { jumpDist: 7, speedUp:0.4, minJump:1.0, maxJump:3.25, toApex:0.3 }
        , 3 => { jumpDist: 5, speedUp:0.4, minJump:1.0, maxJump:2.25, toApex:0.2 }
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
    
    public final fsm:FlxFSM<Hero>;
    
    public var isTouchingLadder = false;
    final hitbox = new FlxObject();
    
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
        
        inline function round(n:Float) { return '${Math.round(n * 100) / 100}'; }
        
        FlxG.watch.addFunction("gravity", ()->acceleration.y);
        FlxG.watch.addFunction("jVel", ()->_jumpVelocity);
        FlxG.watch.addFunction("vel", ()->velocity);
        FlxG.watch.addFunction("max", ()->maxVelocity);
        FlxG.watch.addFunction("coyote", ()->'${round(_coyoteTimer > coyoteTime ? coyoteTime : _coyoteTimer)}/${round(coyoteTime)}');
        
        fsm = new FlxFSM(this);
        fsm.transitions.add(Platforming, Climbing, platformingToClimbing);
        fsm.transitions.add(Climbing, Platforming, climbingToPlatforming);
        fsm.transitions.addGlobal(Dying, (_)->alive == false);
        fsm.transitions.start(Platforming);
    }
    
    override function destroy()
    {
        super.destroy();
        
        hitbox.destroy();
    }
    
    public function canPassClouds()
    {
        return passClouds;
    }
    
    function platformingToClimbing(_)
    {
        return isTouchingLadder && controls.MOVE.pressed.any(DOWN | UP) && controls.released.JUMP;
    }
    
    function climbingToPlatforming(_)
    {
        return isTouchingLadder == false || controls.justPressed.JUMP || touching.has(FLOOR);
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
        setupVariableJumpRocketBoot(data.minJump * TILE_SIZE, data.maxJump * TILE_SIZE, data.toApex);
        _jumpTimer = 0;
        jump(false);
    }
    
    public function fallOut()
    {
        alive = false;
        kill();// TODO:Death sequence
    }
    
    public function onSpike()
    {
        alive = false;
        kill();// TODO:Death sequence
    }
    
    override function setupJump(height:Float, timeToApex:Float)
    {
        super.setupJump(height, timeToApex);
        maxVelocity.y = Math.abs(_jumpVelocity);
    }
    
    function setWeight(weight:Int)
    {
        this.weight = weight;
        
        final data = jumpData[weight];
        setupVariableJumpHybrid(data.minJump * TILE_SIZE, data.maxJump * TILE_SIZE, data.toApex);
        setupSpeed(data.jumpDist * TILE_SIZE, data.speedUp);
    }
    
    function setStandardJump()
    {
        final data = jumpData[weight];
        setupVariableJumpHybrid(data.minJump * TILE_SIZE, data.maxJump * TILE_SIZE, data.toApex);
    }
    
    function setHitbox(x = 0.0, y = 0.0, ?width:Float, ?height:Float)
    {
        hitbox.x = this.x + x;
        hitbox.y = this.y + y;
        hitbox.last.x = this.last.x + x;
        hitbox.last.y = this.last.y + y;
        hitbox.width = width == null ? this.width : width;
        hitbox.height = height == null ? this.height : height;
    }
    
    function checkTouchingLadder(tiles:GreedTilemap)
    {
        if (fsm.state is Platforming && controls.MOVE.pressed.up)
        {
            // smaller hitbox so we can't climb up a ladder while standing on a ladder-cloud
            setHitbox((width - 1) / 2, 0, 1, height / 2);
        }
        else
        {
            setHitbox((width - 1) / 2, 0, 1, null);
        }
        
        return tiles.overlapsTag(hitbox, LADDER);
    }
    
    override function update(elapsed:Float)
    {
        final tiles = cast(FlxG.state, PlayState).level.tiles;
        
        // check spikes before super, ensuring it happens after collision
        if (tiles.overlapsTag(this, HURT))
            onSpike();
        
        super.update(elapsed);
        
        isTouchingLadder = checkTouchingLadder(tiles);
        fsm.update(elapsed);
    }
    
    override function onLand()
    {
        if (fsm.state is Platforming)
            setStandardJump();
    }
}

private class State extends FlxFSMState<Hero> {} 

@:access(props.Hero)
@:access(props.DialAPlatformer)
class Platforming extends State
{
    override function enter(hero:Hero, fsm:FlxFSM<Hero>)
    {
        hero.setStandardJump();
    }
    
    override function update(elapsed:Float, hero:Hero, fsm:FlxFSM<Hero>)
    {
        final jump = hero.controls.pressed.JUMP;
        
        hero.passClouds = hero.controls.MOVE.pressed.down;
        
        final isSkid = (hero.flipX && hero.acceleration.x > 0) || (!hero.flipX && hero.acceleration.x < 0);
        final onGround = hero.getOnCoyoteGround();
        
        var action = "idle";
        if (onGround)
        {
            if (!hero.flipX && hero.velocity.x < 0)
                hero.flipX = true;
            else if (hero.flipX && hero.velocity.x > 0)
                hero.flipX = false;
            
            if (hero.acceleration.x != 0 || hero.velocity.x != 0)
                action = (isSkid ? "walkSkid" : "walk");
        }
        else
        {
            action = (isSkid ? "jumpSkid" : "jump");
        }
        
        hero.animation.play(action);
        
        hero.acceleration.y = hero.controls.pressed.JUMP ? hero._maxJumpGravity : hero._minJumpGravity;
	}
}

@:access(props.Hero)
class Climbing extends State
{
	override function enter(hero:Hero, fsm:FlxFSM<Hero>)
	{
        hero.setStandardJump();
        hero.acceleration.y = 0;
        hero.velocity.set(0, 0);
	}

	override function update(elapsed:Float, hero:Hero, fsm:FlxFSM<Hero>)
	{
        hero._coyoteTimer = 0;// like on ground
        
        final u = hero.controls.MOVE.pressed.up;
        final d = hero.controls.MOVE.pressed.down;
        final l = hero.controls.MOVE.pressed.left;
        final r = hero.controls.MOVE.pressed.right;
        
        final TILE = 16;
        hero.velocity.x = 3.0 * TILE * ((r ? 1 : 0) - (l ? 1 : 0));
        hero.velocity.y = 6.0 * TILE * ((d ? 1 : 0) - (u ? 1 : 0));
        
        hero.animation.play(hero.velocity.isZero() ? "c_idle" : "climb");
    }
    
    override function exit(hero:Hero)
    {
        super.exit(hero);
        
        if (hero.controls.justPressed.JUMP)
        {
            hero.setStandardJump();
            hero.jump(true);
            hero._jumpTimer = 0;
            hero.animation.play("jump");
            hero.velocity.x = hero.maxVelocity.x * hero.controls.MOVE.x;
            return;
        }
    }
}

@:access(props.Hero)
class Dying extends State { }