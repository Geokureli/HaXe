package utils;

import flixel.FlxObject;

class Utils
{
    public function new () {}
    
    inline public function getObjWeight(object:FlxObject)
    {
        return props.i.Weighted.WeightUtils.getObjWeight(object);
    }
}