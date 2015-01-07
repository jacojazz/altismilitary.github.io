disableSerialization;
ShortCut=0;
vts_command_history_index=-1;

//Update functions (only fo debug, because it send some publicvariable with code
if (vts_debug) then {
	[] execvm "functions\vtsfunctions.sqf";
	[] execvm "aar\vts_aar_functions.sqf";
	[] execvm "mods\custom_functions.sqf";
	[] execvm "mods\custom_precommandlines.sqf";
	vts_fnc_spawn_group = compile preprocessFileLineNumbers "functions\fnc_spawn_group.sqf";
	vts_fnc_spawn_vehicle = compile preprocessFileLineNumbers "functions\fnc_spawn_vehicle.sqf";
	vts_fnc_spawn_crew = compile preprocessFileLineNumbers "functions\fnc_spawn_crew.sqf";	
	[] execvm "functions\vtsfunctionsgroup.sqf";
	[] execvm "functions\vhs_functions.sqf";
};



//LaserDisplay CloseDisplay 500;
cpudialog=createDialog "VTS_RscComputer";

waituntil{!isnull (finddisplay 8000)};

if !(isnil "vts_cpuscaling") then 
{
	ctrlsettext [11556,"UI scaling : On"];
	["VTS_RscComputer",vts_cpuscaling] call vts_resizeui;
};

//Gestion des properties
if (isnil "vts_object_property") then {vts_object_property=[];};
if ((count vts_object_property)>0) then
{
	[true] spawn vts_property_showpanel;
} else
{
	[true] spawn vts_property_close;
};

//Replace the map where it was last time used (ergonomic improvement!)
if !(isnil "vtsgmmapcenterpos") then 
{
	_map=(finddisplay 8000) displayctrl 105;
	_map ctrlMapAnimAdd [0, vtsgmmapscale, vtsgmmapcenterpos];
	ctrlMapAnimCommit _map;
};



if(player getvariable ["vts_gm_hidden",false]) then
{
_display = finddisplay 8000;
_bt = _display displayctrl 10603;
_bt CtrlSetTextColor [1,0,0,1];
};

if (ShortCut != 0) then
{

_display = finddisplay 8000;
_control = _display displayctrl 101;
_details = _display displayCtrl 102;
};

// ---------------------------------------------- CONSOLE TR

console_loggedin={
choix_page=2 ;
// sleep 0.5 ;


/*
_j = 9980;
while {_j<=10055} do {
call compile format ["ctrlShow [%1,false];",_j];_j=_j+1};

_j=100;
while {_j<111} do {
call compile format ["ctrlShow [%1,false]",_j];_j=_j+1};
ctrlShow [200,false];

_j = 10056;
while {_j<=10200} do {
call compile format ["ctrlShow [%1,false];",_j];_j=_j+1};
*/

//Display server framerate
[] spawn vts_updateserverfps;
//Display group numbers
[] spawn vts_updateservergroupnum;

[] spawn updateradiusbuttons;

//Populate VTS_boutons
ctrlShow [10900,true];
ctrlShow [10901,true];
ctrlShow [10902,true];
ctrlShow [10903,true];
// on montre le combos command line
ctrlShow [10606,true];
ctrlShow [10300,true];

//On cache la validation de fin de mission
ctrlShow [10560,false];
ctrlShow [10561,false];
//Validation de send to base
ctrlShow [10755,false];

//Hide functions only usable in arma 3 version
if (vtsarmaversion<3) then
{
	ctrlShow [10234,false];
};

//Show current filter
ctrlSetText [10046,sideobjectfilter];

// 53 54 55 = VTS_boutons de navigation
ctrlShow [10053,true];
ctrlShow [10055,true];

// la carte
ctrlShow [105,true];



//Le bouton back to dm
if (isnull (player getvariable ["GMCONTROL",objnull])) then {ctrlShow [19000,false];};

_j = 10200;
while {_j<=10400} do {
call compile format ["ctrlShow [%1,true];",_j];_j=_j+1};

vtsmapkeyctrl=false;
vtsmapkeyshift=false;

Unitsavewait=0;
Typesavewait=0;
Campsavewait=0;
//Initialisation des combos box
_n = [1] execVM "computer\console\boutons\console_valid_attitude.sqf";// waitUntil {scriptDone _n};
interfaceorder = [1] execVM "computer\console\boutons\console_valid_mouvement.sqf";// waitUntil {scriptDone _n};
_n = [1] execVM "computer\console\boutons\console_valid_vitesse.sqf";// waitUntil {scriptDone _n};
_n = [0] execVM "computer\console\boutons\console_valid_moral.sqf";// waitUntil {scriptDone _n};
_n = [0] execVM "Computer\console\boutons\console_valid_brume_altitude.sqf";// waitUntil {scriptDone _n};
_n = [0] execVM "Computer\console\boutons\console_valid_brume_density.sqf";// waitUntil {scriptDone _n};
_n = [0] execVM "computer\console\boutons\console_valid_orientation.sqf";// waitUntil {scriptDone _n};
interfaceformation = [1] execVM "computer\console\boutons\console_valid_formation.sqf";// waitUntil {scriptDone _n};
_n = [1] execVM "computer\console\boutons\joueur_tp.sqf";// waitUntil {scriptDone _n};
_n = [0] execVM "computer\console\boutons\script_commande.sqf";// waitUntil {scriptDone _n};
_n = [1] execVM "computer\console\boutons\console_valid_music.sqf";// waitUntil {scriptDone _n};
_n = [1] execVM "computer\console\boutons\console_valid_audio_env.sqf";// waitUntil {scriptDone _n};
_n = [1] execVM "computer\console\boutons\console_valid_colors.sqf";// waitUntil {scriptDone _n};
_n = [1] execVM "computer\console\boutons\console_valid_pre_com_line.sqf";// waitUntil {scriptDone _n};
_n = [1] execVM "computer\console\boutons\console_valid_pre_init_line.sqf";// waitUntil {scriptDone _n};
_n = [1] execVM "computer\console\boutons\console_valid_arty.sqf";// waitUntil {scriptDone _n};
_n = [1] execVM "computer\console\boutons\console_valid_ammunition.sqf";
_n = [1] execVM "computer\console\boutons\console_valid_populate.sqf";
_n = [1] execVM "computer\console\boutons\console_valid_weaponchange.sqf";
_n = [1] execVM "computer\console\boutons\console_valid_showtexttype.sqf";
_n = [1] execVM "computer\console\boutons\console_valid_painter_color.sqf";
interfacecustomgroup = [1] execVM "computer\console\boutons\console_valid_customgroup.sqf";
_n = [0] execVM "computer\boutons\pluie_action.sqf";// waitUntil {scriptDone _n};
_n = [0] execVM "computer\boutons\cloud_action.sqf";
_n = [0] execVM "computer\boutons\heure_action.sqf";// waitUntil {scriptDone _n};
_n = [0] execVM "computer\boutons\wind_action.sqf";
_n = [1] execVM "computer\console\boutons\console_valid_dice.sqf";// waitUntil {scriptDone _n};

//_n = [0] execVM "computer\console\boutons\console_joueur_scripteur.sqf";// waitUntil {scriptDone _n};

//Initialisation du spawner
_MydualList = globalcamp_side;
if (isnil "Sidesave") then {Sidesave=0;};
_Newlist=[];

for "_i" from 0 to (count _MydualList)-1 do
{
	_CurItem=_MydualList select _i;
	_pic="";
	if (_CurItem=="WEST") then {_pic="#(rgb,8,8,3)color(0.3,0.3,1.0,1)";};
	if (_CurItem=="EAST") then {_pic="#(rgb,8,8,3)color(0.9,0.3,0.3,1)";};
	if (_CurItem=="RESISTANCE") then {_pic="#(rgb,8,8,3)color(0.3,0.8,0.3,1)";};
	if (_CurItem=="CIVILIAN") then {_pic="#(rgb,8,8,3)color(0.85,0.55,0.2,1)";};
	if (_CurItem=="OBJECT") then {_pic="#(rgb,8,8,3)color(0.5,0.5,0.5,1)";};
	_Newlist set [count _Newlist,[_CurItem,_CurItem,_pic]];
};

[10206, _Newlist,Sidesave] spawn Dlg_FillListBoxLists;


vts_gmtips=[
"You can create/move your camera anytime by holding SHIFT and DOUBLE CLICKING on the mini-map",
"You can teleport yourself anywhere on the map holding ALT and DOUBLE CLCIKING on the mini-map",
"You can open open the Property panel of any unit by holding CTRL and DOUBLE CLIKING on it on the mini-map",
"You can delete all DEAD/DESTROYED ONLY units by pressing DEL on the mini-map",
"You can delete all VTS objects/units by holding CTRL and pressing DEL on the mini-map",
"You can change your working brush radius by holding CTRL and using the MOUSE WHEEL on the mini-map",
"You can assign the current selected order by DOUBLE CLICKING on a unit/group on mini-map",
"In the unit property panel, you can also apply the property to the group by clicking on OBJECT PROPERTIES button",
"Custom group are shared through all factions/side, henche you can spawn EAST side BLUFOR units",
"Adding an unit to an empty custom group, automatically make the custom group available in the GROUP section",
"Custom group are shared between all game masters",
"You can press H to display the available shortcuts while in CAMERA mode or 3D spawning mode",
"You can delete sound source with SHIFT + DEL while aiming at its center of origin",
"You can delete map painting with SHIFT + DEL while aiming at its center of origin",
"Objectives are side specific, to spawn an objective for the BLUFOR select WEST side first in the spawner, etc..."
];

ctrlsettext [200,"Tip: "+(vts_gmtips select (floor(random (count vts_gmtips))))];	

};




// ---------------------------------------------- On s'occupe de la page d'accueil

if (ShortCut == 0) then
{
  ctrlShow [100,false];
	ctrlShow [101,false];

  [] spawn console_loggedin;
};





