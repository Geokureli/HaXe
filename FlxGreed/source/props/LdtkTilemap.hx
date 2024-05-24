package props;

import data.Ldtk;
import ldtk.Json;
import ldtk.Tileset;
import flixel.tile.FlxTilemap;

class LdtkTilemap extends FlxTilemap
{
    var ldtkData:Layer_Tiles;
    
    public function new()
    {
        super();
    }
    
    override function destroy()
    {
        super.destroy();
        
        ldtkData = null;
    }
    
    public function loadLdtk(layer:Layer_Tiles)
    {
        ldtkData = layer;
        LdtkTileLayerTools.initTilemap(layer, this, (i, md, _)->handleTileMetadata(i, md), (i, tags, _)->handleTileTags(i, tags));
    }
    
    function handleTileMetadata(index:Int, metaData:TileCustomMetadata) {}
    function handleTileTags(index:Int, tags:Array<Enum_TileTags>) {}
}

typedef TilesetDataHandler<Data, Tilemap> = (index:Int, data:Data, tilemap:Tilemap)->Void;
typedef TilesetMetadataHandler<Tilemap> = TilesetDataHandler<TileCustomMetadata, Tilemap>;
typedef TilesetTagHandler<Tilemap> = TilesetDataHandler<Array<Enum_TileTags>, Tilemap>;

abstract LdtkTileLayerTools(Tileset) from Tileset
{
    static public function initTilemap<T:FlxTilemap>
    ( layer:Layer_Tiles
    , tilemap:T
    , metadataHandler:TilesetMetadataHandler<T>
    , tagHandler:TilesetTagHandler<T>
    )
    {
        final tiles = createTileArray(layer);
        final graphic = getPath(layer.tileset);
        final tileWidth = layer.tileset.tileGridSize;
        final tileHeight = layer.tileset.tileGridSize;
        tilemap.loadMapFromArray(tiles, layer.cWid, layer.cHei, graphic, tileWidth, tileHeight);
        
        if (metadataHandler != null)
        {
            for (tileData in layer.tileset.json.customData)
            {
                metadataHandler(tileData.tileId, tileData, tilemap);
            }
        }
        
        if (tagHandler != null)
        {
            @:privateAccess
            for (i in 0...tilemap._tileObjects.length)
            {
                tagHandler(i, layer.tileset.getAllTags(i), tilemap);
            }
        }
    }
    
    static public function createTileArray(layer:Layer_Tiles)
    {
        return
        [
            for (y in 0...layer.cHei)
            {
                for (x in 0...layer.cWid)
                {
                    if (layer.hasAnyTileAt(x, y))
                    {
                        layer.getTileStackAt(x, y)[0].tileId;
                    }
                    else
                        -1;// empty tile
                }
            }
        ];
    }
    
    /** Path to the atlas image file **/
    static public function getPath(tileset:Tileset):String
    {
        @:privateAccess
        final projPath = haxe.io.Path.directory(tileset.untypedProject.projectFilePath);
        return haxe.io.Path.normalize('${projPath}/${tileset.relPath}');
    }
    
    /** Path to the atlas image file **/
    public function getGraphic(tileset:Tileset)
    {
        return tileset.getAtlasGraphic();
    }
}