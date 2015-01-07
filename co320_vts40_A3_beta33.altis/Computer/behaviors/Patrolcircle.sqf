// --------------------------------- Script patrouille aléatoire_ronde

// !!! lors de la créa de l'unité, transformer la position en variables locales à transmettre à ce script !!! Ce serait bien que les unités spawnées exécutent le script de repli tac

// Transmission

_unite = _this select 0;
_positX = _this select 1;
_positY = _this select 2;

// Mémoriser le point de départ de l'unité

_sav_positX = _positX;
_sav_positY = _positY;
//_distance = 200 + round(random 200);
_distance = radius;

_angle = random 360;
_way = round(random 1);

// boucle : effacer le point de mouvement précédent et créa d'un point de mouvement à 200m autour de l'unit. Récupérer attitude et formation dans l'init principal. une chance sur 9 qu'elle retourne à son point de départ.

private ["_wp","_group"];
if ((typeName _unite)=="GROUP") then {_group = _unite} else {_group = group _unite};

//call compile format["_h = ""h%1"";",(_unite)];

_n=0;
_nmax=6;
while {_n<=_nmax} do
	{



  _positX = _sav_positX + _distance * sin (_angle);
  _positY = _sav_positY + _distance * cos (_angle);

	_pos=[_positX,_positY,0];
	/*
	if (SurfaceisWater _pos) then
	{
    	 _pos = getpos (leader _group);
  };
  */

	_wp = _group addWaypoint [_pos, 0];
	_wp setWaypointType "MOVE";
	_wp setWaypointFormation var_console_valid_formation;
	_wp setWaypointBehaviour var_console_valid_attitude;
  _wp setWaypointSpeed var_console_valid_vitesse;

	call compile format["
	_marker = createMarkerLocal [""WaypMark%1"",_pos];
	_marker setMarkerTextLocal ""WP %1"";
	_marker setMarkerTypeLocal ""mil_Dot"";
	_marker setMarkerSizeLocal [1, 1];
	_marker setMarkerDirLocal 0;
	_marker setMarkerColorLocal ""ColorRed"";
	_marker setMarkerAlphaLocal 0.5;
	",_n];
	
  if (_way>0) then {_angle=_angle+ (360 / _nmax) ;} else {_angle=_angle- (360 / _nmax);};
 	// ordre de mouvement et retour de boucle
	sleep 0.1;
	_n=_n+1;
  };

_wp setWaypointType "CYCLE";
sleep 3;
for "_n" from 0 to _nmax do
{
  call compile format["deletemarkerlocal ""WaypMark%1""",_n];
  sleep 0.1; 
};


if (true) exitWith {};
