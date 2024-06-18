package props;

import data.Global;
import data.ICollectable;
import data.IEntity;
import data.IEntityRef;
import data.IPathFollower;
import data.IPlatformer;
import data.IResizable;
import data.ITogglable;
import data.IToggle;
import data.Ldtk;
import flixel.FlxG;
import flixel.FlxBasic;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxContainer;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.path.FlxPath;
import flixel.tile.FlxTile;
import flixel.tile.FlxTilemap;
import flixel.util.FlxDirection;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxSignal;
import ldtk.Layer_Entities;
import ldtk.Json;
import props.platforms.MovingPlatform;
import props.collectables.Coin;
import props.collectables.Treasure;
import props.ldtk.LdtkLevel;
import props.ldtk.LdtkTilemap;
import props.ui.Arrow;
import props.ui.Text;
import props.ui.Sign;
import utils.SimplePath;

class GreedLevel extends LdtkLevel
{
    public final tiles = new GreedTilemap();
    public final bg = new EntityLayer();
    public final fg = new EntityLayer();
    
    public var hero:Hero;
    public var door:Door;
    public var totalCoins = 0;
    
    public final props = new FlxGroup();
    public final refs = new Map<String, IEntityRef>();
    public final togglables = new Array<ITogglable>();
    public final colliders = new FlxTypedGroup<FlxObject>();
    public final collectables = new FlxGroup();
    public final springs = new FlxTypedGroup<Spring>();
    public final buttons = new FlxTypedGroup<Button>();
    public final textsById = new Map<String, Text>();
    
    
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
        
        props.clear();
        refs.clear();
        
        colliders.clear();
        collectables.clear();
        springs.clear();
        buttons.clear();
        textsById.clear();
    }
    
    public function isHeroAtEnd()
    {
        return hero.overlaps(door) && hero.touching.has(FLOOR);
    }
    
    override function loadLtdk(level:Ldtk_Level)
    {
        super.loadLtdk(level);
        
        add(bg);
        add(tiles);
        add(fg);
        
        tiles.loadLdtk(level.l_Tiles);
        
        for (data in level.l_Props.getAllUntyped())
        {
            final entity = createEntity(data);
            props.add(entity);
        }
        
        // Make sure hero was created, and in the FG
        final fgHero = fg.getFirst((o)->o is Hero);
        if (fgHero == null)
            throw 'No Hero found in Foreground';
        
        // bring to front
        fg.remove(hero, true);
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
        for (entity in togglables)
        {
            if (entity.toggleIds != null)
            {
                for (id in entity.toggleIds)
                {
                    if (refs.exists(id.entityIid) == false)
                        throw 'No Toggle found with id: $id';
                    
                    final toggle = cast(refs[id.entityIid], IToggle);
                    toggle.onToggle.add(entity.toggle);
                    entity.toggle(toggle.isOn);
                }
            }
        }
    }
    
    function createEntity(data:Ldtk_Entity):FlxBasic
    {
        final entity:FlxObject = switch (data.entityType)
        {
            case HERO: hero = new Hero();
            case DOOR  : door = new Door();
            case TEXT:
                final textData:Entity_TEXT = cast data;
                final text = new Text(textData.f_text.split("\n").join(" "));
                textsById[textData.f_textId] = text;
                text;
            case SPRING:
                final spring = new Spring();
                springs.add(spring);
                spring;
            case BUTTON:
                final button = new Button();
                buttons.add(button);
                button;
                
            case COIN:
                totalCoins++;
                new Coin();
            case EMERALD        : new Treasure(EMERALD);
            case RUBY           : new Treasure(RUBY);
            case DIAMOND        : new Treasure(DIAMOND);
            case SAFE           : new Safe();
            case GATE           : new Gate();
            case MOVING_PLATFORM: MovingPlatform.fromLdtk(cast data);
            case ARROW_LEFT     : new Arrow(0, 0, LEFT );
            case ARROW_RIGHT    : new Arrow(0, 0, RIGHT);
            case ARROW_UP       : new Arrow(0, 0, UP   );
            case ARROW_DOWN     : new Arrow(0, 0, DOWN );
            case SIGN_BUTTON    : new Sign(BUTTON);
            case SIGN_HOLD      : new Sign(HOLD  );
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
        {
            (cast obj:IResizable).setEntitySize(data.width, data.height);
        }
        
        if (obj is ITogglable)
        {
            togglables.push(cast obj);
            
            final entity:ITogglable = cast obj;
            entity.toggleIds = (cast data: { f_toggles:Array<EntityReferenceInfos> }).f_toggles;
        }
        
        if (obj is ICollectable)
        {
            collectables.add(obj);
        }
        
        if (obj is IPathFollower)
        {
            (cast obj:IPathFollower).simplePath = SimplePath.fromLdtk(obj, data);
        }
        
        final tags:Array<EntityTags> = data.json.__tags;
        if (tags.contains(COLLIDES)      ) colliders.add(obj);
        if (tags.contains(MOVES) == false) obj.moves = false;
        if (tags.contains(FG)            ) fg.add(obj);
        if (tags.contains(BG)            ) bg.add(obj);
        
        // Check tags match interfaces
        
        if (tags.contains(TOGGLE) != obj is IToggle)
            throw 'Object ${Type.getClassName(Type.getClass(obj))} needs to implement IToggle';
        
        if (tags.contains(COLLECTABLE) != obj is ICollectable)
            throw 'Object ${Type.getClassName(Type.getClass(obj))} needs to implement ICollectable';
        
        // call last
        if (obj is IEntity)
        {
            (cast obj:IEntity).onEntityInit();
        }
    }
    
    override function update(elapsed:Float)
    {
        super.update(elapsed);
        
        FlxG.collide(colliders, tiles);
        FlxG.collide(colliders, colliders);
        
        FlxG.overlap(hero, collectables, (h, c)->collect(h, cast(c, ICollectable)));
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
typedef EntityLayer = TypedEntityLayer<FlxBasic>;

class TypedEntityLayer<T:FlxBasic> extends FlxTypedContainer<T>{}

enum abstract EntityTags(String) from String
{
    /** Whether this object has physics */
    var MOVES = "moves";
    
    /** Whether this object should collide with other collidables */
    var COLLIDES = "collides";
    
    /** Whether this object shows below the tiles */
    var TOGGLE = "toggle";
    
    /** Whether this object can be collected */
    var COLLECTABLE = "collectable";
    
    /** Whether this object shows above the tiles */
    var FG = "fg";
    
    /** Whether this object shows below the tiles */
    var BG = "bg";
}