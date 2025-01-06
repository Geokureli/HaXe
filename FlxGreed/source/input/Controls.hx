package input;

import flixel.input.gamepad.FlxGamepadInputID as GPad;
import flixel.input.keyboard.FlxKey as Key;
import flixel.addons.input.FlxControlInputType;
import flixel.addons.input.FlxControlInputType.FlxKeyInputType.Arrows as ArrowKeys;

/**
 * Since, in many cases multiple actions should use similar keys, we don't want the
 * rebinding UI to list every action. ActionBinders are what the user percieves as
 * an input so, for instance, they can't set jump-press and jump-release to different keys.
 */
enum Action
{
    @:inputs([WASD, ArrowKeys, DPad, LeftStickDigital]) @:analog(x, y) MOVE;
    @:group("Menu") @:inputs([Key.K     , Key.Z, GPad.A    ]) ACCEPT;
    @:group("Menu") @:inputs([Key.L     , Key.X, GPad.B    ]) BACK;
    @:group("Menu") @:inputs([Key.ENTER , Key.P, GPad.START]) PAUSE;
    @:group("Menu") @:inputs([Key.ESCAPE, Key.R, GPad.BACK ]) RESET;
    @:group("Game") @:inputs([Key.K , Key.Z, GPad.A]) JUMP;
    @:group("Game") @:inputs([Key.L , Key.X, GPad.X]) USE;
}

/**
 *  
 */
class ControlGroup<Action>
{
    final name:String;
    final list:Array<Action>;
    
    public function new (name, list)
    {
        this.name = name;
        this.list = list;
    }
}

class Controls extends flixel.addons.input.FlxControls<Action> {}