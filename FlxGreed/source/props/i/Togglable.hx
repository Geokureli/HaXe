package props.i;

import ldtk.Json;
import data.Ldtk;

interface Togglable
{
    var toggleIds:Array<EntityReferenceInfos>;
    
    function toggle(isOn:Bool):Void;
}