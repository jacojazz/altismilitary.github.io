//teleport.sqf
//to teleport to the base

_tele = _this select 0;
_caller = _this select 1;

_caller setPos (getPos (medic));
