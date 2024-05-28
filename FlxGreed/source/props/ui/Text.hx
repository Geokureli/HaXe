package props.ui;

import data.IResizable;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.input.mouse.FlxMouseEvent;
import flixel.math.FlxPoint;
import flixel.text.FlxBitmapText;

class Text extends FlxBitmapText implements IResizable
{
    #if debug
    inline static final TILE = data.Global.TILE;
    
    final handleSprite:FlxSprite;
    var handle:DragHandle = NONE;
    final dragStart = FlxPoint.get();
    var isOver = false;
    #end
    
    public function new (x = 0.0, y = 0.0, text)
    {
        super(x, y, text);
        
        #if debug
        FlxMouseEvent.add(this, (_)->onMouseDown(), (_)->onMouseUp(), (_)->onMouseOver(), (_)->onMouseOut(), false, true, false);
        backgroundColor = 0x80FFFFFF;
        handleSprite = new FlxSprite();
        handleSprite.makeGraphic(2, 2, 0xFFffffff);
        handleSprite.visible = false;
        #end
    }
    
    public function setEntitySize(width:Int, height:Int)
    {
        this.autoSize = false;
        this.wrap = WORD(NEVER);
        this.multiLine = true;
        this.fieldWidth = width;
        this.alignment = CENTER;
        // this.height = height;
    }
    
    #if debug
    function onMouseDown()
    {
        final m = FlxG.mouse.getWorldPosition(dragStart);
        
        final HALF_TILE = TILE >> 1;
        
        handle = if (m.x < x         + HALF_TILE && m.y < y          + HALF_TILE) TL;
            else if (m.x > x + width - HALF_TILE && m.y < y          + HALF_TILE) TR;
            else if (m.x < x         + HALF_TILE && m.y > y + height - HALF_TILE) BL;
            else if (m.x > x + width - HALF_TILE && m.y > y + height - HALF_TILE) BR;
            else C;
        
        m.put();
    }
    
    function onMouseUp() {}
    
    function onMouseOver()
    {
        isOver = true;
    }
    
    function onMouseOut()
    {
        isOver = false;
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
        
        if (handle != NONE)
        {
            if (FlxG.mouse.justReleased)
            {
                handle = NONE;
            }
            else
            {
                switch (handle)
                {
                    case NONE:// never
                    case TL:
                        final right = x + width;
                        x = Math.round(FlxG.mouse.x / TILE) * TILE;
                        y = Math.round(FlxG.mouse.y / TILE) * TILE;
                        fieldWidth = Math.round(right - x);
                    case TR:
                        final right = Math.round(FlxG.mouse.x / TILE) * TILE;
                        y = Math.round(FlxG.mouse.y / TILE) * TILE;
                        fieldWidth = Math.round(right - x);
                    case BL:
                        final right = x + width;
                        x = Math.round(FlxG.mouse.x / TILE) * TILE;
                        fieldWidth = Math.round(right - x);
                    case BR:
                        final right = Math.round(FlxG.mouse.x / TILE) * TILE;
                        fieldWidth = Math.round(right - x);
                    case C:
                        final deltaX = Math.round((FlxG.mouse.x - dragStart.x) / TILE) * TILE;
                        final deltaY = Math.round((FlxG.mouse.y - dragStart.y) / TILE) * TILE;
                        if (deltaX != 0)
                        {
                            x += deltaX;
                            dragStart.x += deltaX;
                        }
                        
                        if (deltaY != 0)
                        {
                            y += deltaY;
                            dragStart.y += deltaY;
                        }
                }
            }
        }
    }
    
    override function draw()
    {
        
        background
            = handleSprite.visible
            = (isOver || handle != NONE);
        
        super.draw();
        
        if (handleSprite.exists && handleSprite.visible)
            drawHandles();
    }
    
    function drawHandles()
    {
        inline function colorHandle(position:DragHandle)
        {
            return handle == position || handle == C ? 0xFFffffff : 0xFFffff00;
        }
        
        handleSprite.x = x;
        handleSprite.y = y;
        handleSprite.color = colorHandle(TL);
        handleSprite.draw();
        
        handleSprite.x = x + width - 2;
        handleSprite.color = colorHandle(TR);
        handleSprite.draw();
        
        handleSprite.y = y + height - 2;
        handleSprite.color = colorHandle(BR);
        handleSprite.draw();
        
        handleSprite.x = x;
        handleSprite.color = colorHandle(BL);
        handleSprite.draw();
    }
    #end
}

enum DragHandle
{
    TL;
    TR;
    BL;
    BR;
    C;
    NONE;
}