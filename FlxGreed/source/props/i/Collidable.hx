package props.i;

interface Collidable
{
    function onCollide(object:flixel.FlxObject):Void;
    function onProcess(object:flixel.FlxObject):Bool;
}