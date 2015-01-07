_unite = _this select 0;
_posmap = [spawn_x2,spawn_y2,spawn_z2];
_posx = _this select 1;
_posy = _this select 2;

_grpunit = _unite;

if (typeName _unite != "GROUP") then
{
_grpunit = group _unite;
}else{
_grpunit = _unite;
};

_go_come_pos = _posmap;

if ((_posx==0) and (_posy==0)) then 
{
	_WP0_go_come = _grpunit addWaypoint [getpos leader _unite, 0];
	_WP0_go_come setWaypointType "Move";
	_WP0_go_come setWaypointBehaviour var_console_valid_attitude;
	_WP0_go_come setWaypointFormation var_console_valid_formation;
	_WP0_go_come setWaypointSpeed var_console_valid_vitesse;
}
else
{
	_WP0_go_come = _grpunit addWaypoint[_go_come_pos,0];
	_WP0_go_come setWaypointType "Move";
	_WP0_go_come setWaypointBehaviour var_console_valid_attitude;
	_WP0_go_come setWaypointSpeed var_console_valid_vitesse;
	_WP0_go_come setWaypointFormation var_console_valid_formation;
};



_WP1_go_come = _grpunit addWaypoint [[_posx,_posy,0], 0];
_WP1_go_come setWaypointFormation var_console_valid_formation;
_WP1_go_come setWaypointType "Move";
_WP1_go_come setWaypointBehaviour var_console_valid_attitude;
_WP1_go_come setWaypointSpeed var_console_valid_vitesse;
_WP2_go_come = _grpunit addWaypoint [_go_come_pos,0];
_WP2_go_come setWaypointType "CYCLE";







