package states;

import data.ICollectable;
import data.Global;
import data.Ldtk;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.group.FlxContainer;
import props.GreedLevel;
import props.Hero;
import props.collectables.Coin;
import props.collectables.Treasure;

class PlayState extends flixel.FlxState
{
    var level:GreedLevel;
    final levelData:Ldtk_Level;
    
    var coinsCollected:Int = 0;
    var treasureCollected:Int = 0;
    
    public function new (?levelId:String)
    {
        super();
        
        levelData = levelId != null
            ? Global.project.getLevel(levelId)
            : Global.project.all_levels.Level_1;
        
        if (levelData == null)
            throw 'no level found with id:$levelId';
    }
    
    override public function create():Void
    {
        super.create();
        
        FlxG.camera.bgColor = 0xFF847e87;
        
        level = new GreedLevel();
        level.onCollect.add(onCollect);
        level.loadLtdk(levelData);
        add(level);
    }
    
    function onCollect(collector:Hero, collectable:ICollectable)
    {
        if (collectable is Treasure)// check first
            treasureCollected++;
        else if (collectable is Coin)
            coinsCollected++;
        else
            throw 'Invalid collectable type: "${Type.getClassName(Type.getClass(collectable))}"';
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
        return (
                ( treasureCollected == 0 && coinsCollected == 0) // secret condition
                || treasureCollected == 3
                )
            && level.hero.overlaps(level.door);
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
                        FlxG.switchState(()->new PlayState(lvl.identifier));
                        
                        return;
                    }
                }
            }
        }
    }
}

class Hud extends FlxContainer
{
    public function new ()
    {
        super();
        
        
    }
}