package com.geokureli.krakel.utils;

import flash.display.BitmapData;
import flash.geom.Rectangle;
import flash.geom.Matrix;
import flash.geom.Point;

//typedef mergeParams = { color:int , alpha:Number };
//typedef channelParams { channel:uint };
//typedef slowDrawParams { ?scaleX:Number, ?scaleY:Number, ?scale:Number };

/**
 * ...
 * @author George
 */
class BitmapUtils {
    
    static public function clearBG(graphic:BitmapData, color:Int = -1):Void {
        
        // --- IF NO COLOR PROVIDED REMOVE COLOR OF TOP-LEFT PIXEL
        if (color == -1) color = graphic.getPixel32(0, 0);
        
        graphic.threshold(graphic, graphic.rect, new Point(), "==", color, 0, 0xFFFFFFFF, true);
    }
    
    static public function drawTo(src:BitmapData, target:BitmapData, ?destRect:Rectangle, ?srcRect:Rectangle):Void {
        
        if (destRect == null) {
            
            destRect = target.rect;
        }
        
        if (srcRect == null) {
            
            srcRect = src.rect;
        }
        
        if (destRect.width == srcRect.width && destRect.height == srcRect.height) {
            
            target.copyPixels(
                src,
                srcRect,
                destRect.topLeft
            );
        } else {
            var mat:Matrix = new Matrix();
            mat.translate(-srcRect.x, -srcRect.y);
            mat.scale(destRect.width / srcRect.width, destRect.height / srcRect.height);
            mat.translate(destRect.x, destRect.y);
            target.draw(src, mat, null, null, destRect, false);
        }
    }
    
    //static function hasMethodParams(params:Dynamic, drawParams:Dynamic):Bool {
        //for (var i:String in params)
        //
            //if (i in drawParams && params[i] is drawParams[i])
                //return true;
        //
        //return false;
    //}
    
    //static public function apply9Grid(src:BitmapData, grid:Rectangle, width:int, height:int):BitmapData {
        //return apply9GridTo(src, grid, new BitmapData(width, height));
    //}
    
    static public function apply9GridTo(src:BitmapData, target:BitmapData, grid:Rectangle, ?srcRect:Rectangle, ?destRect:Rectangle):BitmapData {
        
        if (srcRect == null) srcRect = src.rect;
        if (destRect == null) destRect = target.rect;
        
        var sampleRect:Rectangle = new Rectangle();
        var targetRect:Rectangle = new Rectangle();
        src.lock();
        
        // --- TOP LEFT
        sampleRect.x = srcRect.x;
        sampleRect.y = srcRect.y;
        targetRect.x = destRect.x;
        targetRect.y = destRect.y;
        sampleRect.width  = targetRect.width  = grid.x;
        sampleRect.height = targetRect.height = grid.y;
        drawTo(src, target, targetRect, sampleRect);
        
        // --- TOP
        sampleRect.x = srcRect.x + grid.x;
        sampleRect.width = grid.width;
        targetRect.x = destRect.x + grid.x;
        targetRect.width = destRect.width - srcRect.width + grid.width;
        drawTo(src, target, targetRect, sampleRect);
        
        // --- TOP RIGHT
        sampleRect.x = srcRect.x + grid.right;
        targetRect.width = sampleRect.width = srcRect.width - grid.right;
        targetRect.x = destRect.right - sampleRect.width;
        drawTo(src, target, targetRect, sampleRect);
        
        // --- RIGHT
        sampleRect.y = srcRect.y + grid.y;
        sampleRect.height = grid.height;
        targetRect.height = destRect.height - srcRect.height + grid.height;
        targetRect.y = destRect.y + grid.y;
        drawTo(src, target, targetRect, sampleRect);
        
        // --- BOTTOM RIGHT
        sampleRect.y = srcRect.y + grid.bottom;
        targetRect.height = sampleRect.height = srcRect.height - grid.bottom;
        targetRect.y = destRect.bottom - sampleRect.height;
        drawTo(src, target, targetRect, sampleRect);
        
        // --- BOTTOM
        sampleRect.width = grid.width;
        sampleRect.x = srcRect.x + grid.x;
        targetRect.x = destRect.x + grid.x;
        targetRect.width = destRect.width - srcRect.width + grid.width;
        drawTo(src, target, targetRect, sampleRect);
        
        // --- BOTTOM LEFT
        sampleRect.x = srcRect.x;
        targetRect.width = sampleRect.width = grid.x;
        targetRect.x = destRect.x;
        drawTo(src, target, targetRect, sampleRect);
        
        // --- LEFT
        sampleRect.y = srcRect.y + grid.y;
        sampleRect.height = grid.height;
        targetRect.height = destRect.height - srcRect.height + grid.height;
        targetRect.y = destRect.y + grid.y;
        drawTo(src, target, targetRect, sampleRect);
        
        // ---CENTER
        sampleRect.x = srcRect.x + grid.x;
        targetRect.x = destRect.x + grid.x;
        sampleRect.width = grid.width;
        targetRect.width = destRect.width - srcRect.width + grid.width;
        drawTo(src, target, targetRect, sampleRect);
        
        src.unlock();
        
        return target;
    }
    
    //static public function apply9GridTo(path:String, pixels:BitmapData, rectangle:Rectangle) {
        //
        //Assets.getBitmapData(path, false);
        //
        //
    //}
}