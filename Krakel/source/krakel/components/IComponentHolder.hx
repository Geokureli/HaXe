package krakel.components;

import krakel.interfaces.IUpdate;

/**
 * @author George
 */
interface IComponentHolder extends IUpdate {
    
    var components:ComponentList;
    
    function draw():Void;
}