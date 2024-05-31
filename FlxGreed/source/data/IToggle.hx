package data;

import flixel.util.FlxSignal;

interface IToggle extends IEntityRef
{
    var isOn(default, null):Bool;
    final onToggle:FlxTypedSignal<(Bool)->Void>;
}