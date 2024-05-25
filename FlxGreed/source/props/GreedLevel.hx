package props;

import data.Ldtk;
import data.ICollectable;
import data.IEntityRef;
import data.IPlatformer;
import data.IResizable;
import flixel.FlxG;
import flixel.FlxBasic;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxContainer;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.tile.FlxTile;
import flixel.tile.FlxTilemap;
import flixel.util.FlxSignal;
import ldtk.Layer_Entities;
import ldtk.Json;
import props.collectables.Coin;
import props.collectables.Treasure;
import props.ldtk.LdtkLevel;
import props.ldtk.LdtkTilemap;
import props.ui.Arrow;
import props.ui.Text;

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

class GreedLevel extends LdtkLevel
{
    public final tiles = new GreedTilemap();
    public final bg = new EntityLayer();
    public final fg = new EntityLayer();
    
    public var hero:Hero;
    public var door:Door;
    
    public final refs = new Map<String, IEntityRef>();
    public final colliders = new FlxTypedGroup<FlxObject>();
    public final collectibles = new FlxGroup();
    public final springs = new FlxTypedGroup<Spring>();
    public final gates = new FlxTypedGroup<Gate>();
    public final buttons = new FlxTypedGroup<Button>();
    public final safes = new FlxTypedGroup<Safe>();
    public final texts = new FlxTypedGroup<Text>();
    
    public final onCollect = new FlxTypedSignal<(collector:Hero, collectable:ICollectable)->Void>();
    
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
        collectibles.clear();
        springs.clear();
        gates.clear();
        buttons.clear();
        safes.clear();
        texts.clear();
    }
    
    override function loadLtdk(level:Ldtk_Level)
    {
        super.loadLtdk(level);
        
        add(bg);
        add(tiles);
        add(fg);
        
        tiles.loadLdtk(level.l_Tiles);
        
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
        
        // Make sure hero was created, and in the FG
        final fgHero = fg.getFirst((o)->o is Hero);
        if (fgHero == null)
            throw 'No Hero found in Foreground';
        
        // bring to front
        fg.remove(hero);
        fg.add(hero);
        
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
                collectibles.add(coin);
                coin;
            case Emerald:
                final emerald = new Treasure(EMERALD);
                collectibles.add(emerald);
                emerald;
            case Ruby:
                final ruby = new Treasure(RUBY);
                collectibles.add(ruby);
                ruby;
            case Diamond:
                final diamond = new Treasure(DIAMOND);
                collectibles.add(diamond);
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
            
            case ArrowLeft : new Arrow(LEFT );
            case ArrowRight: new Arrow(RIGHT);
            case ArrowUp   : new Arrow(UP   );
            case ArrowDown : new Arrow(DOWN );
        }
        
        initEntity(entity, data);
        
        return entity;
    }
    
    function initEntity(obj:FlxObject, data:Ldtk_Entity)
    {
        obj.x = data.pixelX;// + (data.pivotX * data.width);
        obj.y = data.pixelY;// + (data.pivotY * data.height);
        
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
        
        FlxG.collide(colliders, tiles);
        FlxG.collide(colliders, colliders);
        
        if (tiles.overlapsTag(hero, HURT))
            hero.onSpike();
        
        if (tiles.overlapsTag(hero, LADDER))
        {
            //TODO:
        }
        
        FlxG.overlap(hero, collectibles, (h, c)->collect(h, cast(c, ICollectable)));
        FlxG.overlap(hero, springs, onSpring, (hero, spring)->hero.isLandingOn(spring));
        
        FlxG.overlap(colliders, buttons, (_, button:Button)->button.press());
    }
    
    function collect(hero:Hero, collectable:ICollectable)
    {
        hero.onCollect(collectable);
        collectable.onCollect(hero);
        onCollect.dispatch(hero, collectable);
    }
    
    function onSpring(hero:Hero, spring:Spring)
    {
        hero.onSprung(spring);
        spring.onSprung();
    }
}

class GreedTilemap extends LdtkTilemap<Enum_TileTags>
{
    override function destroy()
    {
        super.destroy();
    }
    
    override function loadLdtk(layer:Layer_Tiles)
    {
        super.loadLdtk(layer);
        
        for (tile in _tileObjects)
        {
            tile.visible = true;
            tile.allowCollisions = NONE;
            
            final tags = tile.tags;
            if (tags.contains(EDITOR_ONLY))
            {
                tile.debugBoundingBoxColor = 0xFFFF00FF;
            }
            
            if (tags.contains(SOLID))
            {
                tile.allowCollisions = ANY;
            }
            
            // if (tags.contains(HURT)) {}
            
            if (tags.contains(CLOUD))
            {
                tile.allowCollisions = UP;
            }
        }
    }
    
    override function overlapsWithCallback(object:FlxObject, ?callback:(FlxObject, FlxObject)->Bool, flipCallbackParams = false, ?position:FlxPoint):Bool
    {
        // check if object can go through cloud tiles
        if (object is IPlatformer && (cast object:IPlatformer).canPassClouds())
        {
            function checkClouds(tile:LdtkTile<Enum_TileTags>, _)
            {
                // if it's a cloud, pass through
                if (tile.hasTag(CLOUD) && object.y <= tile.y)
                    return false;
                
                // No callback
                if (callback == null)
                    return true;
                
                return flipCallbackParams ? callback(object, tile) : callback(tile, object);
            }
            // Find which tile(s) the platformer is overlapping
            return super.overlapsWithCallback(object, cast checkClouds, false, position);
        }
        
        // normal collision
        return super.overlapsWithCallback(object, callback, flipCallbackParams, position);
    }
}

typedef EntityLayer = TypedEntityLayer<FlxBasic>;

class TypedEntityLayer<T:FlxBasic> extends FlxTypedContainer<T>{}