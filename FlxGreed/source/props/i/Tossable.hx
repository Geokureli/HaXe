package props.i;

import flixel.FlxObject;

interface Tossable
{
    function onPickUp(carrier:FlxObject):Void;
    function onToss(carrier:FlxObject):Void;
}