package com.geokureli.krakel.art;

import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxSprite;
import flixel.system.layer.DrawStackItem;
import flixel.tile.FlxTilemapBuffer;

/**
 * ...
 * @author George
 */
class GridSprite extends Sprite {

	public var columns:Int;
	public var rows:Int;
	public var wrapX:Bool,
	public var wrapY:Bool;
	
	var _x:Float
	var _y:Float
	
	/**
	 * Internal list of buffers, one for each camera, used for drawing the tilemaps.
	 */
	private var _buffers:Array<FlxTilemapBuffer>;
	
	public function new(x:Float = 0, y:Float = 0, ?simpleGraphic:Dynamic, columns:Int = 1, rows:Int = 1) {
		super(x, y, simpleGraphic);
		
		this.rows = rows;
		this.columns = columns;
		_x = x;
		_y = y
	}
	
	override function setDefaults():Void {
		super.setDefaults();
		
		_buffers = new Array<FlxTilemapBuffer>();
	}
	
	override public function draw():Void
	{
		//if (_flickerTimer != 0) {
			//_flicker = !_flicker;
			//if (_flicker) return;
		//}
		
		if (dirty)	//rarely 
		{
			calcFrame();
		}
		
		var cameras = cameras;
		var camera:FlxCamera;
		var buffer:FlxTilemapBuffer;
		var i:Int = 0;
		var l:Int = cameras.length;
		
		while (i < l)
		{
			camera = cameras[i];
			
			if (!camera.visible || !camera.exists)
			{
				continue;
			}
			
			if (_buffers[i] == null)
			{
				_buffers[i] = createBuffer(camera);
			}
			
			buffer = _buffers[i++];
			buffer.dirty = true;
			#if FLX_RENDER_BLIT
			if (!buffer.dirty)
			{
				// Copied from getScreenXY()
				_point.x = _x - (camera.scroll.x * scrollFactor.x) + buffer.x; 
				_point.y = _y - (camera.scroll.y * scrollFactor.y) + buffer.y;
				buffer.dirty = (_point.x > 0) || (_point.y > 0) || (_point.x + buffer.width < camera.width) || (_point.y + buffer.height < camera.height);
			}
			
			if (buffer.dirty)
			{
				drawTilemap(buffer, camera);
				buffer.dirty = false;
			}
			
			// Copied from getScreenXY()
			_flashPoint.x = _x - (camera.scroll.x * scrollFactor.x) + buffer.x; 
			_flashPoint.y = _y - (camera.scroll.y * scrollFactor.y) + buffer.y;
			buffer.draw(camera, _flashPoint, scale.x, scale.y);
			#else
			drawTilemap(buffer, camera);
			#end
			
			#if !FLX_NO_DEBUG
			FlxBasic._VISIBLECOUNT++;
			#end
		}
		
		//#if !FLX_NO_DEBUG
		//if (FlxG.debugger.drawDebug)
			//drawDebug();
		//#end
	}
	/**
	 * Internal function that actually renders the tilemap to the tilemap buffer. Called by draw().
	 * 
	 * @param	Buffer		The FlxTilemapBuffer you are rendering to.
	 * @param	Camera		The related FlxCamera, mainly for scroll values.
	 */
	private function drawTilemap(Buffer:FlxTilemapBuffer, Camera:FlxCamera):Void
	{
	#if FLX_RENDER_BLIT
		Buffer.fill();
	#else
		_helperPoint.x = _x - Camera.scroll.x * scrollFactor.x; //copied from getScreenXY()
		_helperPoint.y = _y - Camera.scroll.y * scrollFactor.y;
		
		var tileID:Int;
		var drawX:Float;
		var drawY:Float;
		
		var hackScaleX:Float = tileScaleHack * scale.x;
		var hackScaleY:Float = tileScaleHack * scale.y;
		
		var drawItem:DrawStackItem = Camera.getDrawStackItem(cachedGraphics, false, 0);
		var currDrawData:Array<Float> = drawItem.drawData;
		var currIndex:Int = drawItem.position;
	#end
		
		// Copy tile images into the tile buffer
		_point.x = (Camera.scroll.x * scrollFactor.x) - _x; //modified from getScreenXY()
		_point.y = (Camera.scroll.y * scrollFactor.y) - _y;
		
		var screenXInTiles:Int = Math.floor(_point.x / _scaledTileWidth);
		var screenYInTiles:Int = Math.floor(_point.y / _scaledTileHeight);
		var screenRows:Int = Buffer.rows;
		var screenColumns:Int = Buffer.columns;
		
		// Bound the upper left corner
		if (screenXInTiles < 0)
		{
			screenXInTiles = 0;
		}
		if (screenXInTiles > widthInTiles - screenColumns)
		{
			screenXInTiles = widthInTiles - screenColumns;
		}
		if (screenYInTiles < 0)
		{
			screenYInTiles = 0;
		}
		if (screenYInTiles > heightInTiles - screenRows)
		{
			screenYInTiles = heightInTiles - screenRows;
		}
		
		var rowIndex:Int = screenYInTiles * widthInTiles + screenXInTiles;
		_flashPoint.y = 0;
		var row:Int = 0;
		var column:Int;
		var columnIndex:Int;
		var tile:FlxTile;
		
		#if !FLX_NO_DEBUG
		var debugTile:BitmapData;
		#end 
		
		while (row < screenRows)
		{
			columnIndex = rowIndex;
			column = 0;
			_flashPoint.x = 0;
			
			while (column < screenColumns)
			{
				#if FLX_RENDER_BLIT
				_flashRect = _rects[columnIndex];
				
				if (_flashRect != null)
				{
					Buffer.pixels.copyPixels(cachedGraphics.bitmap, _flashRect, _flashPoint, null, null, true);
					
					#if !FLX_NO_DEBUG
					if (FlxG.debugger.drawDebug && !ignoreDrawDebug) 
					{
						tile = _tileObjects[_data[columnIndex]];
						
						if (tile != null)
						{
							if (tile.allowCollisions <= FlxObject.NONE)
							{
								// Blue
								debugTile = _debugTileNotSolid; 
							}
							else if (tile.allowCollisions != FlxObject.ANY)
							{
								// Pink
								debugTile = _debugTilePartial; 
							}
							else
							{
								// Green
								debugTile = _debugTileSolid; 
							}
							
							Buffer.pixels.copyPixels(debugTile, _debugRect, _flashPoint, null, null, true);
						}
					}
					#end
				}
				#else
				tileID = _rectIDs[columnIndex];
				
				if (tileID != -1)
				{
					drawX = _helperPoint.x + (columnIndex % widthInTiles) * _scaledTileWidth;
					drawY = _helperPoint.y + Math.floor(columnIndex / widthInTiles) * _scaledTileHeight;
					
					currDrawData[currIndex++] = pixelPerfectRender ? Math.floor(drawX) : drawX;
					currDrawData[currIndex++] = pixelPerfectRender ? Math.floor(drawY) : drawY;
					currDrawData[currIndex++] = tileID;
					
					// Tilemap tearing hack
					currDrawData[currIndex++] = hackScaleX; 
					currDrawData[currIndex++] = 0;
					currDrawData[currIndex++] = 0;
					// Tilemap tearing hack
					currDrawData[currIndex++] = hackScaleY; 
					
					// Alpha
					currDrawData[currIndex++] = 1.0; 
				}
				#end
				
				#if FLX_RENDER_BLIT
				_flashPoint.x += _tileWidth;
				#end
				column++;
				columnIndex++;
			}
			
			#if FLX_RENDER_BLIT
			_flashPoint.y += _tileHeight;
			#end
			rowIndex += widthInTiles;
			row++;
		}
		
		#if FLX_RENDER_TILE
		drawItem.position = currIndex;
		#end
		
		Buffer.x = screenXInTiles * _scaledTileWidth;
		Buffer.y = screenYInTiles * _scaledTileHeight;
	}
	
	private inline function createBuffer(camera:FlxCamera):FlxTilemapBuffer
	{
		var buffer = new FlxTilemapBuffer(_tileWidth, _tileHeight, widthInTiles, heightInTiles, camera, scale.x, scale.y);
		buffer.pixelPerfectRender = pixelPerfectRender;
		return buffer;
	}
	
	//@:getter(x)
	override function get_x():Float { return super.get_x(); }
	
	//@:setter(x)
	override function set_x(value:Float):Float {
		
		_x %= frameWidth;
		
		return set_x(value);
	}
	
	//@:getter(x)
	override function get_y():Float { return super.get_y(); }
	
	//@:setter(x)
	override function set_y(value:Float):Float {
		
		_y %= frameWidth;
		
		return set_y(value);
	}
}