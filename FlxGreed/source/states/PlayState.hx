package states;

import flixel.tweens.FlxTween;
import flixel.text.FlxBitmapText;
import data.Ldtk;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxContainer;
import props.GreedLevel;
import props.Hero;
import props.collectables.Coin;
import props.collectables.Treasure;
import props.i.Collectable;
import states.EndState;

enum LevelType
{
    BY_ID(worldId:String, levelId:String);
    INSTANCE(level:Ldtk_Level);
    LEGACY;
    DEBUG;
    MAIN;
}

typedef GameProgress = { coinsCollected:Int, gemsCollected:Int, coinsTotal:Int, gemsTotal:Int };

class CollectState extends PlayState
{
    final hud = new Hud();
    final progress:GameProgress;
    
    public function new (level:LevelType, ?progress:GameProgress)
    {
        this.progress = progress ?? { coinsCollected:0, gemsCollected:0, coinsTotal:0, gemsTotal:0 };
        
        super(level);
    }
    
    override function create():Void
    {
        super.create();
        
        hud.totalCoins = level.totalCoins;
        add(hud);
    }
    
    override function update(elapsed:Float)
    {
        super.update(elapsed);
        
        #if debug
        if (FlxG.keys.justPressed.ONE)
        {
            if (FlxG.keys.pressed.SHIFT)
                FlxG.switchState(()->new HellState(DEBUG));
            else
                FlxG.switchState(()->new CollectState(DEBUG));
        }
        #end
    }
    
    override function onCollect(collector:Hero, collectable:Collectable)
    {
        super.onCollect(collector, collectable);
        
        hud.onCollect(collector, collectable);
        
        switch (levelData.identifier)
        {
            case "Legacy_0":
                final text = level.textsById["disgust"];
                
                if (hud.gemsCollected >= 3)
                    text.text = "Heh, nice job, you little rat";
                else
                    text.text = "Don't half-ass the job, get all 3 gems";
                
                if (text.visible == false)
                {
                    text.visible = true;
                    text.alpha = 0;
                    FlxTween.tween(text, { alpha: 1.0 }, 0.5);
                }
        }
    }
    
    override function checkWinCondition()
    {
        return  
            (  hud.gemsCollected == 3 // anticipated condition
            || ( hud.gemsCollected == 0 && hud.coinsCollected == 0) // secret condition
            ) && level.isHeroAtEnd();
    }
    
    override function onComplete()
    {
        #if debug
        // press shift on complete to pretend we got everything
        if (FlxG.keys.pressed.SHIFT)
        {
            progress.coinsCollected += hud.totalCoins;
            progress.coinsTotal += hud.totalCoins;
            progress.gemsCollected += 3;
            progress.gemsTotal += 3;
        }
        else
        #end
        {
            progress.coinsCollected += hud.coinsCollected;
            progress.coinsTotal += hud.totalCoins;
            progress.gemsCollected += hud.gemsCollected;
            progress.gemsTotal += 3;
        }
        super.onComplete();
    }
    
    override function switchToLevel(level:LevelType)
    {
        FlxG.switchState(()->new CollectState(level, progress));
    }
    
    override function allLevelsComplete()
    {
        FlxG.switchState(()->new EndState(progress));
    }
}

class HellState extends PlayState
{
    public function new (level:LevelType)
    {
        super(level);
    }
    
    override function create():Void
    {
        super.create();
        
        level.onCollect.add((hero, _)->hero.onSpike());
    }
    
    override function checkWinCondition()
    {
        return level.isHeroAtEnd();
    }
    
    override function switchToLevel(level:LevelType)
    {
        FlxG.switchState(()->new HellState(level));
    }
    
    override function allLevelsComplete()
    {
        FlxG.switchState(()->new EndState());
    }
}

class PlayState extends flixel.FlxState
{
    public var level(default, null):GreedLevel;
    final levelData:Ldtk_Level;
    
    public function new (level:LevelType)
    {
        levelData = switch (level)
        {
            case INSTANCE(level):
                level;
            case DEBUG      :
                G.project.all_worlds.Debug.all_levels.Debug_0;
            case LEGACY     :
                G.project.all_worlds.Legacy.all_levels.Level_0;
            case MAIN       :
                G.project.all_worlds.Legacy.all_levels.Level_4;
            case BY_ID(worldId, levelId):
                final world = G.project.getWorld(worldId);
                if (world == null)
                    throw 'no world found with id:$worldId';
                final data = world.getLevel(levelId);
                if (data == null)
                    throw 'no level found with id:$levelId';
                data;
        };
        
        super();
        
    }
    
    override function create():Void
    {
        super.create();
        
        FlxG.camera.bgColor = 0xFF847e87;
        
        level = new GreedLevel();
        level.loadLtdk(levelData);
        level.onCollect.add(onCollect);
        add(level);
        
        switch (levelData.identifier)
        {
            case "Legacy_0":
                level.textsById["disgust"].visible = false;
        }
    }
    
    override function update(elapsed:Float)
    {
        super.update(elapsed);
        
        if (level.isInBounds(level.hero) == false)
            level.hero.fallOut();
        
        if (level.hero.alive == false)
            FlxG.resetState();
        
        final controls = G.controls;
        
        if (controls.justReleased.RESET)
            FlxG.resetState();
        
        level.door.upArrow.visible = checkWinCondition();
        if ((checkWinCondition() && controls.MOVE.pressed.up) #if debug || controls.justReleased.PAUSE #end)
        {
            onComplete();
        }
    }
    
    function onCollect(collector:Hero, collectable:Collectable) {}
    
    function checkWinCondition()
    {
        return level.isHeroAtEnd();
    }
    
    function onComplete()
    {
        final level = getNextLevel();
        if (level != null && level.f_enabled)
        {
            switchToLevel(INSTANCE(level));
            return;
        }
        
        // No neighbors found to the east
        allLevelsComplete();
    }
    
    function getNextLevel():Null<Ldtk_Level>
    {
        final world = G.project.getWorldOf(level.ldtkData.iid);
        switch world.layout
        {
            case Free | GridVania:
                for (neighbor in level.ldtkData.neighbours)
                {
                    if (neighbor.dir == East)
                        return G.project.getLevel(neighbor.levelIid);
                }
            case LinearHorizontal | LinearVertical:
                final index = world.levels.indexOf(level.ldtkData);
                if (world.levels.length > index)
                    return world.levels[index + 1];
        }
        
        return null;
    }
    
    function getPrevLevel():Null<Ldtk_Level>
    {
        final world = G.project.getWorldOf(level.ldtkData.iid);
        switch world.layout
        {
            case Free | GridVania:
                for (neighbor in level.ldtkData.neighbours)
                {
                    if (neighbor.dir == West)
                        return G.project.getLevel(neighbor.levelIid);
                }
            case LinearHorizontal | LinearVertical:
                final index = world.levels.indexOf(level.ldtkData);
                if (index > 0)
                    return world.levels[index - 1];
        }
        
        return null;
    }
    
    function switchToLevel(level:LevelType)
    {
        FlxG.switchState(()->new PlayState(level));
    }
    
    function allLevelsComplete()
    {
        FlxG.switchState(()->new MenuState(()->new PlayState(LEGACY)));
    }
}

class Hud extends FlxContainer
{
    final coin = new UiCoin();
    final text = new FlxBitmapText(" x 00/25");
    final gems = new Map<TreasureType, UiGem>();
    
    public var totalCoins:Int = 0;
    public var coinsCollected(default, null):Int = 0;
    public var gemsCollected(default, null):Int = 0;
    
    public function new ()
    {
        super();
        
        final MARGIN = 8;
        text.x = FlxG.width - text.width - MARGIN;
        text.y = MARGIN;
        text.scrollFactor.set(0, 0);
        add(text);
        
        coin.x = text.x - coin.width;
        coin.y = text.y + (text.height - coin.height) / 2;
        add(coin);
        
        final topWidth = (text.x + text.width - coin.x);
        final gemsWidth = 16 * 3;
        final gemX = coin.x + (topWidth - gemsWidth) / 2;
        final gemY = text.y + text.height + 2;
        
        for (i=>gemType in TreasureType.all)
        {
            final gem = new UiGem(gemX + (i * 16), gemY, gemType);
            gems[gemType] = gem;
            add(gem);
        }
    }
    
    public function onCollect(collector:Hero, collectable:Collectable)
    {
        if (collectable is Treasure)// check first
        {
            gemsCollected++;
            final type = (cast collectable:Treasure).type;
            gems[type].setFrame(type, true);
        }
        else if (collectable is Coin)
        {
            if (coinsCollected == 0)
                coin.setFrame(true);
            
            coinsCollected++;
            text.text = ' x $coinsCollected/$totalCoins';
        }
        else
            throw 'Invalid collectable type: "${Type.getClassName(Type.getClass(collectable))}"';
    }
    
    override function destroy()
    {
        super.destroy();
        
        gems.clear();
    }
}

@:forward
abstract UiCoin(FlxSprite) to FlxSprite
{
    inline public function new (x = 0.0, y = 0.0)
    {
        this = new FlxSprite(x, y);
        this.loadGraphic(G.getMainGraphic(), true, 16, 16);
        setFrame(false);
        this.scrollFactor.set(0, 0);
        this.offset.x = 4;
        this.offset.y = 3;
        this.width = 8;
        this.height = 11;
    }
    
    inline public function setFrame(color:Bool)
    {
        this.animation.frameIndex = color ? 32 : 44;
    }
}

@:forward
abstract UiGem(FlxSprite) to FlxSprite
{
    inline public function new (x = 0.0, y = 0.0, type:TreasureType)
    {
        this = new FlxSprite(x, y);
        this.loadGraphic(G.getMainGraphic(), true, 16, 16);
        setFrame(type, false);
        this.scrollFactor.set(0, 0);
    }
    
    inline public function setFrame(type:TreasureType, color:Bool)
    {
        this.animation.frameIndex = switch(type)
        {
            case EMERALD: color ? 36 : 45;
            case DIAMOND: color ? 37 : 46;
            case RUBY   : color ? 38 : 47;
        }
    }
}