package props.platforms;

import data.Global;
import data.Ldtk;
import ldtk.Json;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import utils.SimplePath;


class TiledSprite
extends FlxSprite
implements data.IResizable
{
    inline static final TILE = Global.TILE;
    
    var cols:Int = 1;
    var rows:Int = 1;
    
    public function new (x = 0.0, y = 0.0, tile = 5, cols = 1, rows = 1)
    {
        super(x, y);
        
        loadGraphic(Global.getMainGraphic(), true, 16, 16);
        setTile(tile);
        
        if (cols * rows > 1)
            setEntityGridSize(cols, rows);
    }
    
    public function setTile(tile = 5)
    {
        animation.add("idle", [tile]);
        animation.play("idle");
    }
    
    public function setEntitySize(width:Int, height:Int)
    {
        this.width = width;
        this.height = height;
        cols = Math.round(this.width  / TILE);
        rows = Math.round(this.height / TILE);
        origin.set(0, 0);
    }
    
    inline public function setEntityGridSize(cols:Int, rows:Int)
    {
        setEntitySize(cols * TILE, rows * TILE);
    }
    
    override function draw()
    {
        final oldX = x;
        final oldY = y;
        
        checkEmptyFrame();
        
        if (alpha == 0 || _frame.type == EMPTY)
            return;
        
        if (dirty) // rarely
            calcFrame(useFramePixels);
        
        for (camera in getCamerasLegacy())
        {
            if (!camera.visible || !camera.exists || !isOnScreen(camera))
                continue;
            
            final drawMode = (isSimpleRender(camera) ? drawSimple : drawComplex);
            
            for (tx in 0...cols)
            {
                for (ty in 0...rows)
                {
                    x = oldX + TILE * tx;
                    y = oldY + TILE * ty;
                    drawMode(camera);
                }
            }
            
            #if FLX_DEBUG
            FlxBasic.visibleCount++;
            #end
        }
        
        x = oldX;
        y = oldY;
        
        #if FLX_DEBUG
        if (FlxG.debugger.drawDebug)
          drawDebug();
        #end
    }
    
    static public function tileIndexFromLdtk(tileData:Null<TilesetRect>):Int
    {
        final tileset = Global.project.all_tilesets.Tiles;
        if (tileset.json.uid != tileData.tilesetUid)
            throw 'Unexpected tileset uid: ${tileData.tilesetUid}';//TODO:
        
        final SIZE = tileset.tileGridSize;
        final cols = Math.round(tileset.pxWid / SIZE);
        return Math.round(tileData.x / SIZE) + cols * Math.round(tileData.y / SIZE);
    }
}