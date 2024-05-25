package states;

import flixel.text.FlxBitmapText;
import data.ICollectable;
import data.Global;
import data.Ldtk;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxContainer;
import props.GreedLevel;
import props.Hero;
import props.collectables.Coin;
import props.collectables.Treasure;

class CollectState extends PlayState
{
    final hud = new Hud();
    
    override function create():Void
    {
        super.create();
        
        level.onCollect.add(hud.onCollect);
        hud.totalCoins = level.totalCoins;
        add(hud);
    }
    
    override function checkWinCondition()
    {
        return  
            (  hud.gemsCollected == 3 // anticipated condition
            || ( hud.gemsCollected == 0 && hud.coinsCollected == 0) // secret condition
            ) && level.isHeroAtEnd();
    }
    
    override function switchToLevel(levelId:String)
    {
        FlxG.switchState(()->new CollectState(levelId));
    }
}

class PlayState extends flixel.FlxState
{
    var level:GreedLevel;
    final levelData:Ldtk_Level;
    
    public function new (?levelId:String)
    {
        super();
        
        levelData = levelId != null
            ? Global.project.getLevel(levelId)
            : Global.project.all_levels.Level_1;
        
        if (levelData == null)
            throw 'no level found with id:$levelId';
    }
    
    override function create():Void
    {
        super.create();
        
        FlxG.camera.bgColor = 0xFF847e87;
        
        level = new GreedLevel();
        level.loadLtdk(levelData);
        add(level);
    }
    
    override function update(elapsed:Float)
    {
        super.update(elapsed);
        
        if (level.isInBounds(level.hero) == false)
            level.hero.fallOut();
        
        if (level.hero.alive == false)
            FlxG.resetState();
        
        if (Global.controls.justReleased.check(RESET))
            FlxG.resetState();
        
        if (checkWinCondition() #if debug || Global.controls.justReleased.check(PAUSE) #end)
            onComplete();
    }
    
    function checkWinCondition()
    {
        return level.isHeroAtEnd();
    }
    
    function onComplete()
    {
        for (neighbor in level.ldtkData.neighbours)
        {
            if (neighbor.dir == East)
            {
                final iid = neighbor.levelIid;
                for (lvl in Global.project.levels)
                {
                    if (lvl.iid == iid)
                    {
                        switchToLevel(lvl.identifier);
                        
                        return;
                    }
                }
            }
        }
        
        // No neighbors found to the east
        allLevelsComplete();
    }
    
    function switchToLevel(levelId:String)
    {
        FlxG.switchState(()->new PlayState(levelId));
    }
    
    function allLevelsComplete()
    {
        FlxG.switchState(()->new MenuState(()->new PlayState()));
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
    
    public function onCollect(collector:Hero, collectable:ICollectable)
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
        this.loadGraphic("assets/images/props-normal.png", true, 16, 16);
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
        this.loadGraphic("assets/images/props-normal.png", true, 16, 16);
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