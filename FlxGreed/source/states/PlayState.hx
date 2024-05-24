package states;

import data.Global;
import data.Ldtk;
import props.GreedLevel;

class PlayState extends flixel.FlxState
{
    override public function create():Void
    {
        super.create();
        
        final levelData = Global.project.all_levels.Level_0;
        final level = new GreedLevel();
        level.loadLtdk(levelData);
        add(level);
    }
}