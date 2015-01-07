// --------------------------------- Script1

// Il s'agit d'un script vide. Mettez-y ce que vous voulez, en gardant l'entête! * This script is empty. Write whatever you want, but keep the first strings!

// ===========================================
// Ne pas enlever! *DO NOT remove!*
// Nom de l'unité *Name of the unite


// Voilà, c'est à vous!!! * It is now up to you!!!*
sleep 1;


_unite = _this select 0;


private ["_wp","_group"];
if ((typeName _unite)=="GROUP") then {_group = _unite} else {_group = group _unite};


_wp=_group addwaypoint [[markpos_x,markpos_y,0],0];
_wp setWaypointType "Move";
_wp setWaypointBehaviour var_console_valid_attitude;
_wp setWaypointSpeed var_console_valid_vitesse;
_wp setWaypointFormation var_console_valid_formation;

if (true) exitWith {};
