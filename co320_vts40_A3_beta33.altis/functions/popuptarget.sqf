/* InitPopUpTarget.sqf
 *
 * SYNTAX:      nil = [Object, Number, Boolean] execVM "InitPopUpTarget.sqf
 *
 * PARAMETERS:  Object:  A pop-up target
 *              Number:  The number of hits it takes to knock the target down
 *              Boolean: If set to True, the target will pop up again.
 *
 * NOTES:       This function is meant to be placed in the Initialization field
 *              of a pop-up target.
 */



#define HIT_COUNTER   "HitCounter"
#define ONHIT_PARAMS  "AdvPopUp_OnHit_Params"
#define ONHIT_HANDLER "AdvPopUp_OnHit_Handler"
#define ONHIT_INDEX   "AdvPopUp_OnHit_Index"

nopop = true;

_target       = _this select 0;
_requiredHits = _this select 1;
_isPopUp      = _this select 2;

_hitHandler = {
    private ["_target", "_requiredHits", "_isPopUp", "_hitCount", "_keepUp"];
    _target       = _this select 0;
    _requiredHits = _this select 1;
    _isPopUp      = _this select 2;
    if (_target animationPhase "terc" > 0.1) exitWith {};
    _hitCount = (_target getVariable HIT_COUNTER) + 1;
    _keepUp = true;
    if (_hitCount == _requiredHits) then {
        _hitCount = 0;
        _target animate ["terc", 1];
        sleep 5;
        _keepUp = _isPopUp;
    };
    if _keepUp then {
        _target animate ["terc", 0];
    };
    _target setVariable [HIT_COUNTER, _hitCount];
};

_target setVariable [HIT_COUNTER, 0];
_target setVariable [ONHIT_PARAMS, _this];
_target setVariable [ONHIT_HANDLER, _hitHandler];

_code = {
    _t = _this select 0;
    (_t getVariable ONHIT_PARAMS) spawn (_t getVariable ONHIT_HANDLER); // weird!
};

_index = _target addEventHandler ["Hit", _code];
_target setVariable [ONHIT_INDEX, _index];
