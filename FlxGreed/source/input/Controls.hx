package input;

import flixel.input.gamepad.FlxGamepadInputID as GPad;
import flixel.input.keyboard.FlxKey as Key;

/**
 * Since, in many cases multiple actions should use similar keys, we don't want the
 * rebinding UI to list every action. ActionBinders are what the user percieves as
 * an input so, for instance, they can't set jump-press and jump-release to different keys.
 */
enum Action
{
    @:group("Move") @:inputs([Key.UP    , Key.W, GPad.DPAD_UP   , GPad.LEFT_STICK_DIGITAL_UP    ]) UP;
    @:group("Move") @:inputs([Key.DOWN  , Key.S, GPad.DPAD_DOWN , GPad.LEFT_STICK_DIGITAL_DOWN  ]) DOWN;
    @:group("Move") @:inputs([Key.LEFT  , Key.A, GPad.DPAD_LEFT , GPad.LEFT_STICK_DIGITAL_LEFT  ]) LEFT;
    @:group("Move") @:inputs([Key.RIGHT , Key.D, GPad.DPAD_RIGHT, GPad.LEFT_STICK_DIGITAL_RIGHT ]) RIGHT;
    @:group("Menu") @:inputs([Key.K     , Key.Z, GPad.A         ]) ACCEPT;
    @:group("Menu") @:inputs([Key.L     , Key.X, GPad.B         ]) BACK;
    @:group("Menu") @:inputs([Key.ENTER , Key.P, GPad.START     ]) PAUSE;
    @:group("Menu") @:inputs([Key.ESCAPE, Key.R, GPad.BACK      ]) RESET;
    @:inputs([Key.K , Key.Z, GPad.A]) JUMP;
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