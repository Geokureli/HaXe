package props.platforms;

import flixel.system.FlxAssets;
import flixel.FlxCamera;
import flixel.math.FlxRect;
import data.Ldtk;
import ldtk.Json;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import utils.SimplePath;


class TiledSprite
extends FlxSprite
implements props.i.Resizable
implements props.i.Collidable
{
    inline static final TILE = G.TILE;
    
    var cols:Int = 1;
    var rows:Int = 1;
    final tile:Int;
    
    public function new (x = 0.0, y = 0.0, tile = 5, cols = 1, rows = 1, setCollision = true)
    {
        this.tile = tile;
        super(x, y);
        
        loadGraphic(G.getMainGraphic(), true, 16, 16);
        setTile(tile);
        
        if (cols * rows > 1)
            setEntityGridSize(cols, rows);
        
        if (setCollision)
        {
            allowCollisions = switch (tile)
            {
                case 2: UP;
                case 5: ANY;
                default: ANY;
            };
        }
    }
    
    public function setTile(tile = 5)
    {
        animation.add("idle", [tile]);
        animation.play("idle");
    }
    
    public function setEntitySize(width:Int, height:Int)
    {
        setEntityGridSize
            ( Math.round(width  / TILE)
            , Math.round(height / TILE)
            );
    }
    
    public function setEntityGridSize(cols:Int, rows:Int)
    {
        this.cols = cols;
        this.rows = rows;
        this.width = TILE * cols;
        this.height = TILE * rows;
        origin.set(0, 0);
        trace('$ID - fw: ${frameWidth} Fh: ${frameHeight}');
    }
    
    override function loadGraphic(graphic:FlxGraphicAsset, animated:Bool = false, frameWidth:Int = 0, frameHeight:Int = 0, unique:Bool = false, ?key:String):FlxSprite
    {
        final result = super.loadGraphic(graphic, animated, frameWidth, frameHeight, unique, key);
        trace('loadGraphic.$ID - fw: $frameWidth, fh: $frameHeight');
        return result;
    }
    
    public function onProcess(object:FlxObject)
    {
        if (allowCollisions == UP && object is Hero)
            return false == (cast object:Hero).canPassClouds();
        
        return true;
    }
    
    public function onCollide(object:FlxObject){}
    
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
    
    override function getGraphicBounds(?rect:FlxRect):FlxRect
    {
        rect = super.getGraphicBounds(rect);
        rect.setSize(rect.width * cols, rect.height * rows);
        return rect;
    }
    
    override function getScreenBounds(?newRect:FlxRect, ?camera:FlxCamera):FlxRect
    {
        newRect = getGraphicBounds(newRect);
        
        if (camera == null)
            camera = FlxG.camera;
        
        _scaledOrigin.set(origin.x * scale.x, origin.y * scale.y);
        newRect.x += -Std.int(camera.scroll.x * scrollFactor.x) - offset.x + origin.x - _scaledOrigin.x;
        newRect.y += -Std.int(camera.scroll.y * scrollFactor.y) - offset.y + origin.y - _scaledOrigin.y;
        if (isPixelPerfectRender(camera))
            newRect.floor();
        return newRect.getRotatedBounds(angle, _scaledOrigin, newRect);
    }
    
    static public function tileIndexFromLdtk(tileData:Null<TilesetRect>):Int
    {
        final tileset = G.project.all_tilesets.Tiles;
        if (tileset.json.uid != tileData.tilesetUid)
            throw 'Unexpected tileset uid: ${tileData.tilesetUid}';//TODO:
        
        final SIZE = tileset.tileGridSize;
        final cols = Math.round(tileset.pxWid / SIZE);
        return Math.round(tileData.x / SIZE) + cols * Math.round(tileData.y / SIZE);
    }
}