_vehicles=[];


_position = _this select 0;


_currentcamp=var_console_valid_camp;
if (count _this>1) then {_currentcamp=_this select 1;};

_radiustocheck=radius;
if (count _this>2) then {_radiustocheck=_this select 2;};

_motionradius=5000;
if (count _this>3) then {_motionradius=_this select 3;};

if (count _this>4) then {var_console_valid_side=_this select 4;};

if (count _this>5) then {console_unit_moral=_this select 5;};

call compile format["_vehicles=%1_Land;",_currentcamp];

if (isnil "_vehicles") exitwith {breakclic = 0;hint "No vehicles";};
if (count _vehicles<1) exitwith {breakclic = 0;hint "No land vehicles in this faction"};


_roads = _position nearRoads _radiustocheck;

_nroad=count _roads;

if (_nroad<1) exitwith {breakclic = 0;hint "No roads found";};

_numofspawn=round (_radiustocheck/100);
//hint format["%1",_numofspawn];
for "_i" from 1 to  _numofspawn do
{
  
	_road=_roads select (random (_nroad-1));
	_dirroad=0;
	_roadconnected=(roadsConnectedTo _road) select 0;
	//Get the road orientation from the position of two roads piece because direction on road not work anymore
	if !(isnull _roadconnected) then 
	{
		_dirroad=((getposatl _road select 0) - (getposatl _roadconnected select 0)) atan2 ((getposatl _road select 1) - (getposatl _roadconnected select 1));
	};  
  
  _landvehicle=_vehicles select (random ((count _vehicles)-1));
  
  _spawned=objnull;
  
  call compile format["_spawned=[position _road,_dirroad,_landvehicle,%1] call bis_fnc_spawnvehicle;",var_console_valid_side];
  
  _newgrp=grpnull;
  call compile format["_newgrp = (creategroup %1);",var_console_valid_side];			

  _grp=_spawned select 2;
  {
	[_x] joinsilent _newgrp;
    _x call vts_setskill;
  } foreach units _grp;
  deletegroup _grp;
  _grp=_newgrp;
    


  

  
  _vehicle=_spawned select 0;
  
  _speed="NORMAL";
  if (round(random 1)==0) then {_speed="LIMITED";};
  
  _wp = _grp addWaypoint [getpos _vehicle,0];
  _wp setWaypointType "MOVE";
  _wp setWaypointBehaviour "SAFE";
  _wp setWaypointSpeed _speed;
  
  _roadsmotion=getpos _vehicle nearRoads _motionradius;
  _nroadsmotion=count _roadsmotion;
  _nrandomroad=((_nroadsmotion*0.5)-((_nroadsmotion*0.5)%1));
  
  _roaddestination=_roadsmotion select ((_nroadsmotion-1)-(random _nrandomroad));
  
  _wp = _grp addWaypoint [getpos _roaddestination,0];
  _wp setWaypointType "MOVE";
  _wp setWaypointBehaviour "SAFE";
  _wp setWaypointSpeed _speed;
  
  
  _wp = _grp addWaypoint [getpos _vehicle,0];
  _wp setWaypointType "CYCLE";
  _wp setWaypointBehaviour "SAFE";
  _wp setWaypointSpeed _speed;
};

_code=nil;
call compile format["
_code={
if ([player] call vts_getisGM) then {""Spawn result : %1 vehicle(s) moving to %2 position(s)"" spawn vts_gmmessage;};
};
",_numofspawn,_numofspawn*2];
[_code] call vts_broadcastcommand;
breakclic = 0;