package props.i;

import flixel.util.FlxSignal;

interface Toggle extends Referable
{
    var isOn(default, null):Bool;
    final onToggle:FlxTypedSignal<(Bool)->Void>;
}