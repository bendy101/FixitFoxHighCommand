/*
 * Author: Your Name
 * Description: Example function that demonstrates how to create a simple function
 *
 * Arguments:
 * 0: _unit <OBJECT> - Unit to perform action on
 * 1: _target <OBJECT> - Target of the action
 *
 * Return Value:
 * Boolean - Success/Failure
 *
 * Example:
 * [player, cursorObject] call MyAwesomeMod_fnc_myFunction
 */

params ["_unit", "_target"];

if (isNull _unit || isNull _target) exitWith {
    // Return false if invalid parameters
    false
};

// Example function logic
private _distance = _unit distance _target;
if (_distance > 10) exitWith {
    // Target is too far away
    hint "Target is too far away";
    false
};

// Do something with the unit and target
_unit doMove (position _target);

// Return success
true 