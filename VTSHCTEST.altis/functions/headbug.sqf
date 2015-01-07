if (vehicle player != player) exitWith {hint "You must be on foot"};

_pos = position player;
_dir = direction player;
if (surfaceIsWater _pos) then {_pos = getPosASL player}; // for LHD


_headCar = "MMT_USMC" createVehicleLocal getpos player;
if (surfaceIsWater _pos) then {_headCar setposasl getposasl player;};
titleCut ["", "black faded", 0];
player moveInDriver _headCar;
sleep 0.5;

unassignVehicle player;
moveout player;
deleteVehicle _headCar;
sleep 0.5;

if (surfaceIsWater _pos) then {player setPosASL _pos} else {player setPos _pos}; // for LHD
player setDir _dir;
titleCut ["", "BLACK in", 1];
