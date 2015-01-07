// --------------------------------- Script patrouille aléatoire



// Transmission

_unite = _this select 0;
_positX = _this select 1;
_positY = _this select 2;
//  hint format["%1 %2",_positX,_positY];
// Mémoriser le point de départ de l'unité

_sav_positX = _positX;
_sav_positY = _positY;
_distance = radius/4 ;
_distance_next = 10;

sleep 1 ;

private ["_wp","_group","_positX","_positY","_sav_positX","_sav_positY"];

if ((typeName _unite)=="GROUP") then {_group = _unite} else {_group = group _unite};


// boucle : effacer le point de mouvement précédent et créa d'un point de mouvement à 200m autour de l'unit. Récupérer attitude et formation dans l'init principal. une chance sur 9 qu'elle retourne à son point de départ.
_n=0;
_nmax=5;
while {_n<=_nmax} do
{
	_random = random 17;
	_i = 11;
	
	if (_random<2) then {_positY =_positY+_distance;};
	if ((_random<4) and (_random>2)) then {_positX =_positX+_distance;_positY =_positY+_distance;};
	if ((_random<6) and (_random>4)) then {_positX =_positX+_distance;};
	if ((_random<8) and (_random>6)) then {_positX =_positX+_distance;_positY =_positY-_distance;};
	if ((_random<10) and (_random>8)) then {_positY =_positY-_distance;};
	if ((_random<12) and (_random>10)) then {_positX =_positX-_distance;_positY =_positY-_distance;};
	if ((_random<14) and (_random>12)) then {_positX =_positX-_distance;};
	if ((_random<16) and (_random>14)) then {_positX =_positX-_distance;_positY =_positY+_distance;};
	if (_random>16) then {_positX =_sav_positX;_positY =_sav_positY;_i=20;};
	
	//No patrol in water
	_pos=[_positX,_positY,0];
	/*
	if (SurfaceisWater _pos) then
	{
    	 _pos = getpos (leader _group);
  };
  */
  
	call compile format["
	_marker = createMarkerLocal [""WaypMark%1"",_pos];
	_marker setMarkerTextLocal ""WP %1"";
	_marker setMarkerTypeLocal ""mil_Dot"";
	_marker setMarkerSizeLocal [1,1];
	_marker setMarkerDirLocal 0;
	_marker setMarkerColorLocal ""ColorRed"";
	_marker setMarkerAlphaLocal 0.5;
	",_n];
	

	_wp = _group addWaypoint [_pos,0];
	_wp setWaypointType "MOVE";
	_wp setWaypointFormation var_console_valid_formation;
	_wp setWaypointBehaviour var_console_valid_attitude;
  _wp setWaypointSpeed var_console_valid_vitesse;

	
	sleep 0.1;
	_n=_n+1;
};
sleep 3;
for "_n" from 0 to _nmax do
{
  call compile format["deletemarkerlocal ""WaypMark%1""",_n];
  sleep 0.1; 
};

_wp setWaypointType "CYCLE";

if (true) exitWith {};
