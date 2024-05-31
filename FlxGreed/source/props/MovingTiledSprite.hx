package props;

import data.Global;
import data.Ldtk;
import data.IToggle;
import data.ITogglable;
import ldtk.Json;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.path.FlxBasePath;
import flixel.path.FlxPath;
import utils.FlxTweenPath;

inline final TILE = Global.TILE;

class MovingTiledSprite
extends TiledSprite
implements ITogglable
{
    public var toggleIds:Array<EntityReferenceInfos>;
    public var tweenPath:FlxTweenPath;
    
    public function new (x = 0.0, y = 0.0, tile = 5)
    {
        super(x, y, tile);
        
        immovable = true;
    }
    
    override function update(elapsed:Float)
    {
        super.update(elapsed);
        
        if (tweenPath != null && tweenPath.active && tweenPath.exists)
            tweenPath.update(elapsed);
    }
    
    override function draw()
    {
        if (tweenPath != null && tweenPath.visible && tweenPath.exists)
            tweenPath.draw();
        
        super.draw();
    }
    
    public function toggle(isOn:Bool)
    {
        tweenPath.active = isOn;
    }
    
    public static function fromLdtk(data:Entity_MovingPlatform):MovingTiledSprite
    {
        // Make platform
        final tileId = TiledSprite.tileIndexFromLdtk(data.f_tile_infos);
        final plat = new MovingTiledSprite(data.pixelX, data.pixelY, tileId);
        
        // Make path
        final nodes = FlxTweenPath.nodesFromLdtk(data.f_path, data.pixelX, data.pixelY);
        final speed = data.f_speed;
        final loop = FlxTweenPath.loopFromLdtk(data.f_loop);
        plat.tweenPath = new FlxTweenPath(nodes, plat, speed * TILE);
        plat.tweenPath.loopType = loop;
        return plat;
    }
}

class TiledSprite
extends FlxSprite
implements data.IResizable
{
    var cols:Int = 1;
    var rows:Int = 1;
    
    public function new (x = 0.0, y = 0.0, tile = 5)
    {
        super(x, y);
        
        loadGraphic(data.Global.getMainGraphic(), true, 16, 16);
        setTile(tile);
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