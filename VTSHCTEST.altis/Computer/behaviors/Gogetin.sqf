sleep 1;

_unite = _this select 0;

private ["_grpunit"];
if (typeName _unite != "GROUP") then
{
_grpunit = group _unite;
}else{
_grpunit = _unite;
};


_posmap = [_this select 1,_this select 2,0];

_wp0=_grpunit addwaypoint [_posmap,0];
_wp0 setWaypointType "GETIN NEAREST";
_wp0 setWaypointBehaviour var_console_valid_attitude;
_wp0 setWaypointSpeed var_console_valid_vitesse;
_wp0 setWaypointFormation var_console_valid_formation;

