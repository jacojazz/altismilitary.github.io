sleep 1;

_unite = _this select 0;
_posmap = [spawn_x2,spawn_y2,spawn_z2];

private ["_grpunit"];
if (typeName _unite != "GROUP") then
{
_grpunit = group _unite;
}else{
_grpunit = _unite;
};

//?
//_class=(typeOf (vehicle (leader _unite)));


_wp=_grpunit addwaypoint [_posmap,0];
_wp setWaypointType "Move";
_wp setWaypointBehaviour var_console_valid_attitude;
_wp setWaypointSpeed var_console_valid_vitesse;
_wp setWaypointFormation var_console_valid_formation;

/*
_obj=nearestobject "Building";
_pos=[_obj] call buildingPosCount;
if (count _pos>0) then 
{
	
};
*/