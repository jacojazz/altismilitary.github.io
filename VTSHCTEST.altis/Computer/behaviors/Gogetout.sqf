sleep 1;

_unite = _this select 0;

private ["_grpunit"];
if (typeName _unite != "GROUP") then
{
_grpunit = group _unite;
}else{
_grpunit = _unite;
};

//_posmap = [spawn_x2,spawn_y2,spawn_z2];
_posmap = [_this select 1,_this select 2,0];

_wp=_grpunit addwaypoint [_posmap,0];
_wp setWaypointType "GETOUT";
_wp setWaypointBehaviour var_console_valid_attitude;
_wp setWaypointSpeed var_console_valid_vitesse;
_wp setWaypointFormation var_console_valid_formation;

