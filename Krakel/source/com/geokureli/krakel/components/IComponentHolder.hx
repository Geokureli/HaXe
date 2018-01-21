package com.geokureli.krakel.components;

import com.geokureli.krakel.interfaces.IUpdate;

/**
 * @author George
 */
interface IComponentHolder extends IUpdate {
    
    var components:ComponentList;
    
    function draw():Void;
}