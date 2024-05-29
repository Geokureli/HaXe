package props.ldtk;

import data.Ldtk;
import ldtk.Json;
import ldtk.Tileset;
import flixel.FlxObject;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.tile.FlxTile;
import flixel.tile.FlxTilemap;

class LdtkTile<Tag:EnumValue> extends FlxTile
{
    @:allow(props.ldtk.LdtkTilemap)
    public var metaData(default, null):Null<TileCustomMetadata>;
    @:allow(props.ldtk.LdtkTilemap)
    public var tags(default, null):Null<haxe.ds.ReadOnlyArray<Tag>>;
    
    public function new (tilemap:LdtkTilemap<Tag>, index, width, height, visible, allowCollisions)
    {
        super(cast tilemap, index, width, height, visible, allowCollisions);
    }
    
    public function hasTag(tag:Tag)
    {
        return tags != null && tags.contains(tag);
    }
}

class LdtkTilemap<Tag:EnumValue> extends FlxTypedTilemap<LdtkTile<Tag>>
{
    var ldtkData:Layer_Tiles;
    
    override function destroy()
    {
        super.destroy();
        
        ldtkData = null;
    }
    
    override function createTile(index, width, height, visible, allowCollisions)
    {
        return new LdtkTile(this, index, width, height, visible, allowCollisions);
    }
    
    public function loadLdtk(layer:Layer_Tiles)
    {
        ldtkData = layer;
        LdtkTileLayerTools.initTilemap(layer, this, (i, md, _)->handleTileMetadata(i, md), (i, tags, _)->handleTileTags(i, tags));
    }
    
    public function forEachOverlappingTile(object:FlxObject, func:(LdtkTile<Tag>)->Void, ?position:FlxPoint)
    {
        var xPos = x;
        var yPos = y;
        
        if (position != null)
        {
            xPos = position.x;
            yPos = position.y;
            position.putWeak();
        }
        
        inline function bindInt(value:Int, min:Int, max:Int)
        {
            return Std.int(FlxMath.bound(value, min, max));
        }
        
        // Figure out what tiles we need to check against, and bind them by the map edges
        final minTileX:Int = bindInt(Math.floor((object.x - xPos) / scaledTileWidth), 0, widthInTiles);
        final minTileY:Int = bindInt(Math.floor((object.y - yPos) / scaledTileHeight), 0, heightInTiles);
        final maxTileX:Int = bindInt(Math.ceil((object.x + object.width - xPos) / scaledTileWidth), 0, widthInTiles);
        final maxTileY:Int = bindInt(Math.ceil((object.y + object.height - yPos) / scaledTileHeight), 0, heightInTiles);
        
        // Loop through the range of tiles and call the callback on them, accordingly
        final deltaX:Float = xPos - last.x;
        final deltaY:Float = yPos - last.y;
        
        for (row in minTileY...maxTileY)
        {
            for (column in minTileX...maxTileX)
            {
                final mapIndex:Int = (row * widthInTiles) + column;
                final dataIndex:Int = _data[mapIndex] < 0 ? 0 : _data[mapIndex];
                
                final tile = _tileObjects[dataIndex];
                tile.width = scaledTileWidth;
                tile.height = scaledTileHeight;
                tile.x = xPos + column * tile.width;
                tile.y = yPos + row * tile.height;
                tile.last.x = tile.x - deltaX;
                tile.last.y = tile.y - deltaY;
                
                final overlapFound = ((object.x + object.width) > tile.x)
                    && (object.x < (tile.x + tile.width))
                    && ((object.y + object.height) > tile.y)
                    && (object.y < (tile.y + tile.height));
                
                if (overlapFound)
                {
                    func(tile);
                }
            }
        }
    }
    
    public function overlapsTag(object, tag, ?position):Bool
    {
        return overlapsTagWithCallback(object, tag, null, position);
    }
    
    public function overlapsTagWithCallback(object, tag:Tag, ?callback:(LdtkTile<Tag>)->Void, ?position):Bool
    {
        var overlapFound = false;
        function checkTags(tile:LdtkTile<Tag>)
        {
            if (tile.hasTag(tag))
            {
                overlapFound = true;
            }
            
            if (callback != null)
                callback(tile);
        }
        
        forEachOverlappingTile(object, checkTags, position);
        return overlapFound;
    }
    
    
    function handleTileMetadata(index:Int, metaData:TileCustomMetadata)
    {
        final tile = _tileObjects[index];
        tile.metaData = metaData;
    }
    
    function handleTileTags(index:Int, tags:Array<Tag>)
    {
        final tile = _tileObjects[index];
        tile.tags = tags;
    }
}

typedef TilesetDataHandler<Data, Map> = (index:Int, data:Data, tilemap:Map)->Void;
typedef TilesetMetadataHandler<Map> = TilesetDataHandler<TileCustomMetadata, Map>;
typedef TilesetTagHandler<Map, Tag:EnumValue> = TilesetDataHandler<Array<Tag>, Map>;

abstract LdtkTileLayerTools(Tileset) from Tileset
{
    static public function initTilemap<Tile:FlxTile, Tag:EnumValue, Map:FlxTypedTilemap<Tile>>
    ( layer:Layer_Tiles
    , tilemap:Map
    , metadataHandler:TilesetMetadataHandler<Map>
    , tagHandler:TilesetTagHandler<Map, Tag>
    )
    {
        final tiles = createTileArray(layer);
        // final graphic = getPath(layer.tileset);
        final graphic = data.Global.getMainGraphic();
        final tileWidth = layer.tileset.tileGridSize;
        final tileHeight = layer.tileset.tileGridSize;
        tilemap.loadMapFromArray(tiles, layer.cWid, layer.cHei, graphic, tileWidth, tileHeight, null, 0, 0);
        
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
                tagHandler(i, cast layer.tileset.getAllTags(i), tilemap);
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