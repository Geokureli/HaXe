package com.geokureli.krakel.art;

import com.geokureli.krakel.data.TilemapData;

import flixel.FlxG;
import flixel.tile.FlxBaseTilemap.FlxTilemapAutoTiling;
import flixel.tile.FlxTilemap;
import flixel.math.FlxPoint;

/**
 * ...
 * @author George
 */
class LoopingTilemap extends FlxTilemap {
    
    public var wrapX:Bool;
    public var wrapY:Bool;
    public var updateAutoTile:Bool;
    
    var _rawMap:TilemapData;
    
    public function new (
        mapData      :Dynamic,
        tileGraphic  :Dynamic,
        tileWidth    :Int                  = 0,
        tileHeight   :Int                  = 0,
        wrapX        :Bool                 = true,
        wrapY        :Bool                 = false,
        ?autoTile    :FlxTilemapAutoTiling,
        startingIndex:Int                  = 0,
        drawIndex    :Int                  = 1,
        collideIndex :Int                  = 1
    ) {
        super();
        
        this.wrapX = wrapX;
        this.wrapY = wrapY;
        
        
        if (wrapX || wrapY) {
            
            if (Std.is(mapData, TilemapData)) {
                
                _rawMap = mapData;
                
            } else {
                
                _rawMap = new TilemapData(mapData);
            }
            
            mapData = _rawMap.toString();
            
            var sourceMapData:TilemapData = _rawMap.copy(true);
            
            var numColumns:Int = _rawMap.columns;
            var numRows:Int = _rawMap.rows;
            
            if (wrapX) {
                
                numColumns = Math.floor(FlxG.width / tileWidth) + 1;
                
                while (_rawMap.data[0].length < numColumns) {
                    
                    for (i in 0 ... _rawMap.data.length) {
                        
                        _rawMap.data[i] = _rawMap.data[i].concat(sourceMapData.data[i].copy());
                    }
                }
            }
            
            var sourceMapData:TilemapData = _rawMap.copy();
            
            if (wrapY) {
                
                numRows = Math.floor(FlxG.height / tileHeight) + 1;
                
                while (_rawMap.data.length < numRows) {
                    
                    _rawMap.append(sourceMapData.data.copy());
                }
            }
            
            mapData = _rawMap.toString();
        }
        
        setDefaults();
        updateAutoTile = updateAutoTile && autoTile != FlxTilemapAutoTiling.OFF;
        
        loadMapFromCSV(mapData, tileGraphic, tileWidth, tileHeight, autoTile, startingIndex, drawIndex, collideIndex);
    }
    
    function setDefaults():Void {
        updateAutoTile = false;
    }
    
    override public function draw():Void {
        
        if (wrapX || wrapY) {
            
            var camTileIndex:FlxPoint = new FlxPoint(
                Math.ffloor(FlxG.camera.scroll.x / tileWidth * scrollFactor.x),
                Math.ffloor(FlxG.camera.scroll.y / tileHeight * scrollFactor.y)
            );
            
            var dirty:Bool = false;
            var delta:Int;
            if (wrapX && x * scrollFactor.x / tileWidth != camTileIndex.x) {
                
                dirty = true;
                delta = Std.int(x / tileWidth - camTileIndex.x);
                
                while (delta > 0) {
                    
                    for (row in _rawMap.data) {
                        
                        row.push(row.shift());
                    }
                    delta--;
                }
                
                while (delta < 0) {
                    
                    for (row in _rawMap.data) {
                        
                        row.unshift(row.pop());
                    }
                    delta++;
                }
                
                x = camTileIndex.x * tileWidth;
            }
            
            if (wrapY && y * scrollFactor.y / tileHeight != camTileIndex.y) {
                
                dirty = true;
                delta = Std.int(y / tileHeight - camTileIndex.y);
                
                while (delta > 0) {
                    
                    _rawMap.data.push(_rawMap.data.shift());
                    delta--;
                }
                
                while (delta < 0) {
                    
                    _rawMap.data.unshift(_rawMap.data.pop());
                    delta++;
                }
                
                y = camTileIndex.y * tileHeight;
            }
            
            if (dirty) {
                
                _data = _rawMap.flatten();
                
                // --- UPDATE GRAPHICS
                
                for (i in 0 ... _data.length) {
                    
                    if (updateAutoTile) {
                        
                        setTileByIndex(i, getTileByIndex(i));
                    } else {
                        
                        updateTile(i);
                    }
                }
            }
        }
        
        super.draw();
    }
    
    //override function get_x():Float { return super.get_x(); }
    //override function set_x(value:Float):Float { return set_x(value); }
    
    //override function get_y():Float { return super.get_y(); }
    //override function set_y(value:Float):Float { return set_y(value); }
}