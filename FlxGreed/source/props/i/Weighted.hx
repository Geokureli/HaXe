package props.i;

interface Weighted
{
    function getTotalWeight():Float;
}

class WeightUtils
{
    static public function getObjWeight(obj:flixel.FlxObject)
    {
        return (obj is Weighted) ? (cast obj:Weighted).getTotalWeight() : obj.mass;
    }
}