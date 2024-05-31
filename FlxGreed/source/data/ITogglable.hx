package data;

import ldtk.Json;
import data.Ldtk;

interface ITogglable
{
    var toggleIds:Array<EntityReferenceInfos>;
    
    function toggle(isOn:Bool):Void;
}