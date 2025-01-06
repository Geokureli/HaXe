package debug.tools;

import flash.display.BitmapData;
import flash.ui.Keyboard;
import flixel.FlxObject;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.debug.interaction.Interaction;
import openfl.events.MouseEvent;

@:bitmap("assets/images/debug/watch_tool.png")
private class ToolGraphic extends openfl.display.BitmapData {}

class WatchTool extends flixel.system.debug.interaction.tools.Tool
{
    override function init(brain:Interaction):Tool
    {
        super.init(brain);
        
        _name = "Toggle Debug Draw";
        setButton(ToolGraphic);
        button.toggleMode = false;
        
        return this;
    }
    
    override function update():Void
    {
        button.enabled = _brain.selectedItems.countLiving() == 1;
        button.mouseEnabled = button.enabled; 
        button.alpha = button.enabled ? 0.3 : 0.1;
    }
    
    override function onButtonClicked()
    {
        #if FLX_DEBUG
        if (_brain.selectedItems.length != 1)
            return;
        
        final item = _brain.selectedItems[0];
        // TODO
        #end
    }
}
