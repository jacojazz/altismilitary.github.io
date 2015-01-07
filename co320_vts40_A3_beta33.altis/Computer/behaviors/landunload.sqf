sleep 1;

//player sidechat "landunload";

_unite = _this select 0;
_posmap = [spawn_x2,spawn_y2,spawn_z2];

private ["_grpunit"];
if (typeName _unite != "GROUP") then
{
_grpunit = group _unite;
}else{
_grpunit = _unite;
};

_class=(typeOf (vehicle (leader _unite)));

_wp=_grpunit addwaypoint [_posmap,0];
_wp setWaypointType "MOVE";
_wp setWaypointBehaviour var_console_valid_attitude;
_wp setWaypointSpeed var_console_valid_vitesse;
_wp setWaypointFormation var_console_valid_formation;

_wp=_grpunit addwaypoint [_posmap,0];
_wp setWaypointType "Scripted";
_wp setWaypointBehaviour var_console_valid_attitude;
_wp setWaypointSpeed var_console_valid_vitesse;
_wp setWaypointFormation var_console_valid_formation;
_wp setWaypointScript "functions\landunloadwp.sqs this";


_hpad=vts_emptyhelipad createVehicle _posmap;
if (surfaceiswater _posmap) then {_hpad setposasl [_posmap select 0,_posmap select 1,0];};
