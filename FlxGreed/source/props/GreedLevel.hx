package props;

import flixel.math.FlxPoint;
import ldtk.Layer_Entities;
import flixel.group.FlxContainer;
import data.Ldtk;
import data.IEntityRef;
import data.IPlatformer;
import data.IResizable;
import flixel.FlxG;
import flixel.FlxBasic;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.group.FlxContainer;
import flixel.tile.FlxTile;
import flixel.tile.FlxTilemap;
import flixel.util.FlxSignal;
import ldtk.Json;

enum abstract EntityTags(String) from String
{
    /** Whether this object has physics */
    var MOVES = "moves";
    
    /** Whether this object should collide with other collidables */
    var COLLIDES = "collides";
    
    /** Only used in the editor */
    var FG = "fg";
    
    /** Only used in the editor */
    var BG = "bg";
}

/**
 * ...
 * @author George
 */
class GreedLevel extends flixel.group.FlxContainer
{
    public final tiles = new GreedTilemap();
    public final bg = new EntityLayer();
    public final fg = new EntityLayer();
    
    public var hero:Hero;
    public var door:Door;
    
    public final refs = new Map<String, IEntityRef>();
    public final colliders = new FlxTypedGroup<FlxObject>();
    public final coins = new FlxTypedGroup<Coin>();
    public final springs = new FlxTypedGroup<Spring>();
    public final gates = new FlxTypedGroup<Gate>();
    public final buttons = new FlxTypedGroup<Button>();
    public final safes = new FlxTypedGroup<Safe>();
    public final texts = new FlxTypedGroup<Text>();
    
    public function new()
    {
        super();
    }
    
    override function destroy()
    {
        super.destroy();
        hero = null;
        door = null;
        
        refs.clear();
        
        colliders.clear();
        coins.clear();
        springs.clear();
        gates.clear();
        buttons.clear();
        safes.clear();
        texts.clear();
    }
    
    public function loadLtdk(level:Ldtk_Level)
    {
        add(bg);
        add(tiles);
        add(fg);
        
        tiles.loadLdtk(level.l_Tiles);
        colliders.add(tiles);
        
        for (data in level.l_BG.getAllUntyped())
        {
            final entity = createEntity(data);
            bg.add(entity);
        }
        
        for (data in level.l_FG.getAllUntyped())
        {
            final entity = createEntity(data);
            fg.add(entity);
        }
        
        initCam();
        resolveEntityRefs();
    }
    
    function initCam()
    {
        final cam = FlxG.camera;
        tiles.follow(cam);
        cam.follow(hero, PLATFORMER);
    }
    
    function resolveEntityRefs()
    {
        for (gate in gates)
        {
            if (refs.exists(gate.buttonId) == false)
                throw 'No button found with id: ${gate.buttonId}';
            
            final button:Button = cast(refs[gate.buttonId], Button);
            button.onPress.add(gate.onButtonPress);
        }
    }
    
    function createEntity(data:Ldtk_Entity):FlxBasic
    {
        final entity:FlxObject = switch (data.entityType)
        {
            case Player:
                hero = new Hero();
                hero;
            case Coin:
                final coin = new Coin();
                coins.add(coin);
                coin;
            case Emerald:
                final emerald = new Treasure(EMERALD);
                coins.add(emerald);
                emerald;
            case Ruby:
                final ruby = new Treasure(RUBY);
                coins.add(ruby);
                ruby;
            case Diamond:
                final diamond = new Treasure(DIAMOND);
                coins.add(diamond);
                diamond;
            case Text:
                final textData:Entity_Text = cast data;
                final text = new Text(textData.f_text.split("\n").join(" "));
                texts.add(text);
                text;
            case Spring:
                final spring = new Spring();
                springs.add(spring);
                spring;
            case Safe:
                final safe = new Safe();
                safes.add(safe);
                safe;
            case Gate:
                final gate = new Gate();
                gate.buttonId = cast (data, Entity_Gate).f_button.entityIid;
                gates.add(gate);
                gate;
            case Button:
                final button = new Button();
                buttons.add(button);
                button;
            case Door:
                door = new Door();
        }
        
        initEntity(entity, data);
        
        return entity;
    }
    
    function initEntity(obj:FlxObject, data:Ldtk_Entity)
    {
        obj.x = data.pixelX - (data.pivotX * data.width);
        obj.y = data.pixelY - (data.pivotY * data.height);
        
        if (obj is IEntityRef)
        {
            final objRef = (cast obj:IEntityRef);
            objRef.entityId = data.iid;
            refs[objRef.entityId] = objRef;
        }
        
        if (obj is IResizable)
            (cast obj:IResizable).setEntitySize(data.width, data.height);
        
        final tags:Array<EntityTags> = data.json.__tags;
        if (tags.contains(COLLIDES)) colliders.add(obj);
        if (!tags.contains(MOVES)) obj.moves = false;
    }
    
    override function update(elapsed:Float)
    {
        super.update(elapsed);
        
        FlxG.collide(colliders, colliders);
        
        FlxG.overlap(hero, coins, collectCoin);
        FlxG.overlap(hero, springs, onSpring, (hero, spring)->hero.velocity.y > 0);
    }
    
    function collectCoin(hero:Hero, coin:Coin)
    {
        hero.onCollect(coin);
        coin.onCollect();
    }
    
    function onSpring(hero:Hero, spring:Spring)
    {
        hero.onSprung(spring);
        spring.onSprung();
    }
}

class GreedTilemap extends LdtkTilemap
{
    public final hurtCallback = new FlxTypedSignal<(FlxTile, FlxObject)->Void>();
    final clouds = new FlxTypedGroup<FlxTile>();
    final hurt = new FlxTypedGroup<FlxTile>();
    
    override function destroy()
    {
        hurtCallback.removeAll();
        clouds.clear();
        
        super.destroy();
    }
    
    override function handleTileTags(index:Int, tags:Array<Enum_TileTags>)
    {
        final tile = _tileObjects[index];
        
        if (tags.contains(SOLID))
        {
            tile.allowCollisions = ANY;
        }
        
        if (tags.contains(HURT))
        {
            tile.callbackFunction = function (tile, object)
            {
                hurtCallback.dispatch(cast tile, object);
            }
            hurt.add(tile);
        }
        
        if (tags.contains(CLOUD))
        {
            tile.allowCollisions = UP;
            clouds.add(tile);
        }
    }
    
    public function isCloud(tile:FlxTile)
    {
        return clouds.members.contains(tile);
    }
    
    override function overlapsWithCallback(object:FlxObject, ?callback:(FlxObject, FlxObject)->Bool, flipCallbackParams = false, ?position:FlxPoint):Bool
    {
        // check if object can go through cloud tiles
        if (object is IPlatformer && (cast object:IPlatformer).canPassClouds())
        {
            function checkClouds(tile:FlxObject, _)
            {
                // if it's a cloud, pass through
                if (isCloud(cast tile))
                    return false;
                
                return flipCallbackParams ? callback(object, tile) : callback(tile, object);
            }
            // Find which tile(s) the platformer is overlapping
            return super.overlapsWithCallback(object, checkClouds, true, position);
        }
        
        // normal collision
        return super.overlapsWithCallback(object, callback, flipCallbackParams, position);
    }
}

typedef EntityLayer = TypedEntityLayer<FlxBasic>;

class TypedEntityLayer<T:FlxBasic> extends FlxTypedContainer<T>{}