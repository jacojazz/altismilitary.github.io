//Init functions and stuff
T_INIT = false;
T_Server = false; T_Client = false; T_JIP = false;

if (playersNumber east + playersNumber west + playersNumber resistance + playersNumber civilian > 0) then { T_MP = true } else { T_MP = false };

if (isServer) then
{
  T_Server = true;
  if (!(isNull player)) then { T_Client = true };
  T_INIT = true;
} else {
  T_Client = true;
  if (isNull player) then
  {
      T_JIP = true;
      [] spawn { waitUntil { !(isNull player) }; T_INIT = true };
  } else {
      T_INIT = true;
  };
};

waitUntil { T_INIT };

//Debug on / off
vts_debug=false;
//vts_debug=true;

//Networktype
//1=p2p
//2=s2c (seems to be unstable)
vts_nettype=1;



//Run custom init script
[] execvm "mods\custom_init.sqf";


//Black curtain for the init
if (hasinterface) then {0 cutText ["","BLACK FADED",100]; };

//Mission script for Arma game version :
vtsarmaversion=GetNumber (missionConfigFile >> "vts_armaversion");

//No run in SP except if debug is one (bad workshop integration...)
if (!ismultiplayer && !vts_debug) exitwith 
{
	_txt="Error : The mission must be run in multiplayer only";
	_task = player createSimpleTask [_txt];
	_task setTaskState "Failed";
	_task setSimpleTaskDescription [_txt,_txt,_txt];
	endMission "END4";
};

//Headless client detection
if (isnil "VTS_HC_AI") then 
{
	VTS_HC_AI=objnull;
};
if (!isDedicated && !hasinterface) then 
{
	VTS_HC_AI=player;
	publicVariable "VTS_HC_AI";
};



//Security check for the HC (Headless client) slot
//Not yet in A3

//Arma 2 require function manager module to be loaded
if (vtsarmaversion==2) then
{	
	_grp = createGroup sideLogic;
	_fm = _grp createUnit ["FunctionsManager", [0,0,0], [],0,"NONE"];
};

//Preprocess function for optimized run
buildingPosCount = compile preprocessfilelinenumbers "functions\buildingPosCount.sqf";
getBuildingdID = compile preprocessFile "functions\fnc_getBuildID.sqf";
Dlg_FillListBoxLists = compile preprocessfilelinenumbers "Computer\computerdlg.sqf";
Dlg_FillTypeListBoxLists = compile preprocessfilelinenumbers "Computer\computertypedlg.sqf";
Dlg_GenerateList = compile preprocessfilelinenumbers "Computer\generatelist.sqf";
Dlg_StoreParams=compile preprocessfilelinenumbers "Computer\StoreParams.sqf";
VTS_takeonestringfrom=compile preprocessfilelinenumbers "functions\takeonestringfrom.sqf";
//gmgps_players = compile preprocessFileLineNumbers "computer\console\gps_rt.sqf";
//New way for player marker, maybe more reliable
gmgps_players = compile preprocessFileLineNumbers "computer\console\gps_players.sqf";
gmgps_all = compile preprocessFileLineNumbers "Computer\console\gps_new.sqf";
gmgps_unit = compile preprocessFileLineNumbers "Computer\console\gps_unit.sqf";
SPON_formatNumber = compile preprocessFileLineNumbers "functions\SPON_formatNumber.sqf";
vts_fnc_spawn_group = compile preprocessFileLineNumbers "functions\fnc_spawn_group.sqf";
vts_fnc_spawn_vehicle = compile preprocessFileLineNumbers "functions\fnc_spawn_vehicle.sqf";
vts_fnc_spawn_crew = compile preprocessFileLineNumbers "functions\fnc_spawn_crew.sqf";
vts_gethelptext = compile preprocessFileLineNumbers "computer\vts_helptext.sqf";
_script=[] execVM "functions\KRON_Strings.sqf";waitUntil {scriptDone _script};
_script=[] execVM "shop\shop_functions.sqf";waitUntil {scriptDone _script};
_script=[] execvm "functions\vtsfunctions.sqf";waitUntil {scriptDone _script};
_script=[] execvm "aar\vts_aar_functions.sqf";waitUntil {scriptDone _script};
_script=[] execvm "mods\custom_functions.sqf";waitUntil {scriptDone _script};
_script=[] execvm "mods\custom_precommandlines.sqf";waitUntil {scriptDone _script};
_script=[] execvm "functions\respawnfunctions.sqf";waitUntil {scriptDone _script};
_script=[] execvm "functions\vtsfunctionsgroup.sqf";waitUntil {scriptDone _script};
_script=[] execvm "functions\vtsfunctiontogroupmember.sqf";waitUntil {scriptDone _script};
//_script=[server] execvm "\ca\modules\arty\data\scripts\init.sqf"; waitUntil {scriptDone _script};

//Create briefing
player createDiarySubject ["VTS Mission","VTS Mission"];
player createDiaryRecord ["VTS Mission",["VTS Help",([] call vts_gethelptext)]];


//******************
//** MOD AUTODECT **
//******************

//Are we using ace ?
ACEMOD=isClass (configFile >> "CfgPatches" >> "ace_main");
if (ACEMOD) then
{
	player globalchat "ACE mod detected : Intializing done.";  
  //No ace tracking markers please
  ace_sys_tracking_markers_enabled = false;
  //No nuclear fallout (not much fun)
  ACE_NukeFallout=false;
  //Enable Ace Lifter
  RAV_LIFTER = true;
  //Enable wounding systems
   if (isServer) then {ace_sys_wounds_enabled = true;publicVariable "ace_sys_wounds_enabled"};
};
//Are we using ace radio and ai talk ?
if (isclass (configfile >> "CfgVehicles" >> "ACE_AITalk_Logic")) then {ace_sys_aitalk_enabled = true;};
if (isclass (configfile >> "CfgVehicles" >> "ACE_RadioTalk_Logic")) then {ace_sys_aitalk_radio_enabled = true;};

//Are we using TFR 
if (isclass (configfile >> "CfgPatches" >> "task_force_radio")) then
{
	//Radiobackpack can be buy on the shop and we don't need them on respawn
	tf_no_auto_long_range_radio = true;
	//We don't need encryption for Different Side combined ops and for PVP player can still try to found the good frequency
	tf_west_radio_code = "_vts";
	tf_east_radio_code = "_vts";
	tf_guer_radio_code = "_vts";
};
//Disable viewdist cheat
if (isclass (configfile >> "CfgPatches" >> "viewdistance")) then
{
	//tawvd_addon_disable = true;	
	tawvd_disablenone = true;
};

//Enable INIDBI if detected
if (isclass (configfile >> "CfgPatches" >> "inidbi")) then
{
	call compile preProcessFile "\inidbi\init.sqf";
};

//******************
//******************
//******************


diag_log format ["############################# %1 #############################", missionName];

//*********************
//*ParamArray variable*
//*********************
pa_westplayable=paramsArray select 0;
pa_eastplayable=paramsArray select 1;
pa_guerplayable=paramsArray select 2;
pa_civplayable=paramsArray select 3;

pa_emptyarray1=paramsArray select 4;

pa_startingammo=paramsArray select 5;
pa_revivetype=paramsArray select 6;
pa_revivecount=paramsArray select 7;
pa_revivetimeout=paramsArray select 8;
pa_distanceview=paramsArray select 9;
pa_terraingrid=paramsArray select 10;
pa_nightlight=paramsArray select 11;

pa_emptyarray2=paramsArray select 12;

pa_westfriendlyto=paramsArray select 13;
pa_eastfriendlyto=paramsArray select 14;
pa_resistancefriendlyto=paramsArray select 15;

pa_emptyarray3=paramsArray select 16;

pa_allowclasschange=paramsArray select 17;
pa_allowgroupchange=paramsArray select 18;
pa_allowgroupleadermarker=paramsArray select 19;
pa_allowteleporttoleader=paramsArray select 20;
pa_allowplayername=paramsArray select 21;
pa_serversidemods=paramsArray select 22;

pa_emptyarray4=paramsArray select 23;

pa_aiautomanage=paramsArray select 24;
pa_aiaimshake=paramsArray select 25;

pa_emptyarray5=paramsArray select 26;

pa_shopinitalbalance=paramsArray select 27;
pa_shopallunlocked=paramsArray select 28;
pa_shopunlockmethod=paramsArray select 29;
pa_shopfreeloadouttypes=paramsArray select 30;
pa_shopshowonlynakedweapon=paramsArray select 31;

pa_emptyarray6=paramsArray select 32;

pa_allowotherdms=paramsArray select 33;
pa_allowmultigm=paramsArray select 34;
pa_alloweveryonedms=paramsArray select 35;

//Force respawn marker to be setpos on base buildings
pa_moverespawnmarkerstobases=1;

//if (vts_debug) then {pa_alloweveryonedms=1;};

SetViewDistance	(pa_distanceview);
SetTerrainGrid	(pa_terraingrid/4);

//Sleep client to fix JIP "error no vehicle" name
if (!isServer) then 
{
  
  waitUntil {!(isNull player)};

  //A little sleep to be sure client run this after briefing (and so avoid init bug)
  sleep 0.5;
  //0 cutText ["","BLACK IN",1];
};

//Initialising global config
_config_global = [] execVM "mods\config\global_config.sqf"; waitUntil {scriptDone _config_global};



//*************************
//***Side friendly setup***
//*************************

private ["_westfriends","_eastfriends","_resistancefriends"];

_west=pa_westfriendlyto;
_east=pa_eastfriendlyto;
_resistance=pa_resistancefriendlyto;

switch (_west) do 
{
case 0: {_westfriends=[West]}; 
case 01: {_westfriends=[West,East]}; 
case 02: {_westfriends=[West,Resistance]};
case 012: {_westfriends=[West,East,Resistance]};
};

switch (_east) do 
{
case 1: {_eastfriends=[East]}; 
case 10: {_eastfriends=[East,West]}; 
case 12: {_eastfriends=[East,Resistance]};
case 102: {_eastfriends=[East,West,Resistance]};
};

switch (_resistance) do 
{
case 2: {_resistancefriends=[Resistance]}; 
case 20: {_resistancefriends=[Resistance,West]}; 
case 21: {_resistancefriends=[Resistance,East]};
case 201: {_resistancefriends=[Resistance,West,East]};
};

//West side first
if (West in _westfriends) then {West setFriend [West,1]} else {West setFriend [West,0]};
if (East in _westfriends) then {West setFriend [East,1]} else {West setFriend [East,0]};
if (Resistance in _westfriends) then {West setFriend [Resistance,1]} else {West setFriend [Resistance,0]};
//East
if (West in _eastfriends) then {East setFriend [West,1]} else {East setFriend [West,0]};
if (East in _eastfriends) then {East setFriend [East,1]} else {East setFriend [East,0]};
if (Resistance in _eastfriends) then {East setFriend [Resistance,1]} else {East setFriend [Resistance,0]};
//Resistance
if (West in _resistancefriends) then {Resistance setFriend [West,1]} else {Resistance setFriend [West,0]};
if (East in _resistancefriends) then {Resistance setFriend [East,1]} else {Resistance setFriend [East,0]};
if (Resistance in _resistancefriends) then {Resistance setFriend [Resistance,1]} else {Resistance setFriend [Resistance,0]};

//Civilian bugfix for arma 3
if (vtsarmaversion==3) then
{
	civilian setfriend [West,0.75];
	civilian setfriend [East,0.75];
	civilian setfriend [Resistance,0.75];
};

//Disable saving
enableSaving [false, false];


if (pa_nightlight==0) then 
{
  _date=date;
  setdate [2010,3,26,_date select 3,_date select 4];
};

check3d  = false;
From3D = false;
vts3DAttach = false;
breakclic = 0; 
placingdone = 0; 
scriptrun = 0;
	
killscript = false;

runclientcode = false;
istakecontrol = false;
effectoldcolor=0;

/*
if (isnil "vts_serverready") then 
{
	player globalchat "[VTS : Server initializing . . . ]";
	vts_serverready=[];
	"vts_serverready" addPublicVariableEventHandler {player globalchat "[VTS : Server initialized ! ]";};
};
*/

if (isnil "colorsarray") then 
{
  colorsarray=[1, 1, 0, [0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 1], [0.0, 0.0, 0.0, 0.0]];
};


//Because publicvariable are send on client connection, let's not override them if the client got them from the server

if (isnil "vts_idnum") then {vts_idnum=0;};

{
	call compile format["
	if (isnil ""vts_shopunlocklist_%1"") then 
	{
		vts_shopunlocklist_%1=[];
	};
	if (isnil ""vts_shopbalance_%1"") then {vts_shopbalance_%1=pa_shopinitalbalance;};
	if (pa_shopallunlocked==0) then 
	{
		if (isnil ""vts_shopallunlocked_%1"") then {vts_shopallunlocked_%1=false;};
	}
	else 
	{
		if (isnil ""vts_shopallunlocked_%1"") then {vts_shopallunlocked_%1=true;};
	};
	",_x];
} foreach [west,east,resistance,civilian];



if (pa_shopunlockmethod==0) then {vts_shopunlockmethod=false} else {vts_shopunlockmethod=true};

//Defining Game master unit
vts_game_masters = ["user1","user2","HC_AI"];
vts_game_master_assistants = ["user2"];

//Generatin a spawn position, so the VTS can work on any map without any modification
if (isServer) then
{

	 
	vts_loadedworld=worldName;
	publicVariable "vts_loadedworld";
  
	_worldsize=getnumber (configfile >> "CfgWorlds" >> worldname >> "mapSize");
	_loc=[(_worldsize/2),(_worldsize/2)];
    _location=nearestLocations [_loc,["Name","Strategic","StrongpointArea","FlatArea","FlatAreaCity","FlatAreaCitySmall","CityCenter","Airport","NameMarine","NameCityCapital","NameCity","NameVillage","NameLocal","Hill","ViewPoint","RockArea","BorderCrossing","VegetationBroadleaf","VegetationFir","VegetationPalm","VegetationVineyard"],5000];
    _nlocation=(count _location);
	
    if (_nlocation>0) then
    {

      _nrandomlocation=floor(random count _location);
      _loc=locationposition (_location select ((_nrandomlocation)));
      _loc=_loc findEmptyPosition[5,500]; 
	};
	if (count _loc<1) then	
	{

		_loc=[(_worldsize/2),(_worldsize/2)];
	};
	//Position generated
	if (vts_generate_spawn_position) then
	{
      west_spawn setpos _loc;
      east_spawn setpos _loc;
      guer_spawn setpos _loc;
      civ_spawn setpos _loc;
      west_respawn_tent setpos (getpos west_spawn);
	}
	//Static position check if in water
	else
	{
		if (isnil "vts_SetPosAtop") then {waituntil {sleep 0.1;!isnil "vts_SetPosAtop"};};
		
		west_spawn setposasl ([(getmarkerpos "respawn_west")] call vts_SetPosAtop);
		east_spawn setposasl ([(getmarkerpos "respawn_east")] call vts_SetPosAtop);
		guer_spawn setposasl ([(getmarkerpos "respawn_guerrila")] call vts_SetPosAtop);
		civ_spawn setposasl ([(getmarkerpos "respawn_civilian")] call vts_SetPosAtop);
		west_respawn_tent setposasl ([(getmarkerpos "respawn_west")] call vts_SetPosAtop);
		east_respawn_tent setposasl ([(getmarkerpos "respawn_east")] call vts_SetPosAtop);
		guer_respawn_tent setposasl ([(getmarkerpos "respawn_guerrila")] call vts_SetPosAtop);
		civ_respawn_tent setposasl ([(getmarkerpos "respawn_civilian")] call vts_SetPosAtop);
	};
      //east_respawn_tent setpos _loc;
      //guer_respawn_tent setpos _loc;
      //civ_respawn_tent setpos _loc;
    
	/*
	else
	{
		
		_code={
			while (true) do
			{
				player globalChat "!!! NO VALID LOCATION FOUND, ISLAND MAYBE NOT COMPATIBLE !!!";
				sleep 3.0;
			};
		};
		_loop=[_code] call vts_broadcastcommand;
		
		
	};*/
	
    radius=50;
	local_radius=radius;
    obj1=false;
    obj2=false;
    obj3=false;
    obj4=false;
    PublicVariable "obj1";
    PublicVariable "obj2";
    PublicVariable "obj3";
    PublicVariable "obj4";
    Sync_time = date;
    publicvariable "Sync_time";
  
    clientcode = nil;

   
    //Script related to operation maintenant run each heart beat
    _heatbeatscript = [] execVM "functions\server_heartbeat.sqf";
 
   

    
    //Gestion du PORTE AVION seulement si sur l'eau
    /*
    if (surfaceIsWater getpos carrier) then 
    {
      _createlhd= [carrier] execVM "CreateLHD.sqf";
      waitUntil {scriptDone _createlhd};
    //Mise à jour des markers de spawn
    _carrierpos = LHDPOS;
    _carrierdir = LHDDIR;
    "carriermarker" setMarkerPosLocal [_carrierpos select 0, _carrierpos select 1];
    "carriermarker" setMarkerDirLocal _carrierdir;
    }
    else
    {
      deletevehicle carrier;
      "carriermarker" setMarkerSize [100,100];
    };
    */
	
	
    //Checking players varname and attribute them
	[0] call vts_setupplayerid;

    //if dedicated, we launch the listener too
    if (isDedicated) then 
	{
		[] call vts_broadcastcommandlistener;
		[] call vts_serverbroadcastcommandlistener;	
	};
    
    //Launching the Spawn listener
	[] call vts_spawnlistener;
	
    
    //Player can spawn now, just adding a delay so the spawn position have time to be refresh on clients machine
    vts_serverready=[];
	if (vts_generate_spawn_position) then
	{
      vts_serverready=_loc;
	};
    publicvariable "vts_serverready";
	player globalchat "[VTS : Server initialized ! ]";
	
	//Launching mods script
	[] execVM "Mods\server_side_script.sqf";

		
};
	


if (isplayer player) then
{
  //run the client listener
  [] call vts_broadcastcommandlistener;
  if (isserver) then {[] call vts_serverbroadcastcommandlistener;};

  _gamemaster=objnull;
  _intro=true;

	
  if !([player] call vts_getisGM) then
  {
  //Disable other respawn marker if not on your side
    if (playerside==west) then {"east_resp" setMarkerTypeLocal "Empty";"guer_resp" setMarkerTypeLocal "Empty";"civ_resp" setMarkerTypeLocal "Empty";};
    if (playerside==east) then {"west_resp" setMarkerTypeLocal "Empty";"guer_resp" setMarkerTypeLocal "Empty";"civ_resp" setMarkerTypeLocal "Empty";};
    if (playerside==resistance) then {"west_resp" setMarkerTypeLocal "Empty";"east_resp" setMarkerTypeLocal "Empty";"civ_resp" setMarkerTypeLocal "Empty";};
    if (playerside==civilian) then {"west_resp" setMarkerTypeLocal "Empty";"east_resp" setMarkerTypeLocal "Empty";"guer_resp" setMarkerTypeLocal "Empty";};
     
  //Check Disabled side 
  if (pa_westplayable==0 and playerside==west) then {["!!! You have been kicked !!! this side is disabled : West"] spawn vts_SideDisabled;_intro=false;};
  if (pa_eastplayable==0 and playerside==east) then {["!!! You have been kicked !!! this side is disabled : East"] spawn vts_SideDisabled;_intro=false;};
  if (pa_guerplayable==0 and playerside==resistance) then {["!!! You have been kicked !!! this side is disabled : Resistance"] spawn vts_SideDisabled;_intro=false;};
  if (pa_civplayable==0 and playerside==civilian) then {["!!! You have been kicked !!! this side is disabled : Civilian"] spawn vts_SideDisabled;_intro=false;};
  };
  
  
  //Check if the GM can have the role of another one
  if ((vehiclevarname player) in vts_game_masters) then 
  {
	_currentgmname=player;
    if (pa_allowmultigm==0) then
    {
      _currentgmname=server getvariable ("currentgmname"+format["%1",vehiclevarname player]);
      if (isnil "_currentgmname") then
      {
        server setvariable [("currentgmname"+format["%1",vehiclevarname player]),name player,true];
      }
      else
      {
        if ((name player!=_currentgmname) && (pa_alloweveryonedms!=1)) then
        {
          [format["!!! You have been kicked !!! Only %1 can be the game master for this session",_currentgmname]] spawn vts_SideDisabled;
          _intro=false;
        };
      };
    };
  };
  //Check if the second GM role is open
  if (((vehiclevarname player) in vts_game_master_assistants) && (pa_allowotherdms==0) && (pa_alloweveryonedms!=1)) then
  {
          ["!!! You have been kicked !!! the assistant slot is currently disabled"] spawn vts_SideDisabled;
          _intro=false;	
  };

  //Play intro if nothing wrong
  if (_intro) then {_intro = [] execVM "functions\intro.sqf";}; 
  
  //enable color modification
  "colorCorrections" ppEffectEnable TRUE;
  
  //JIP shop state
  if (T_JIP) then
  {
	vts_shopjip=player;
	publicVariableServer "vts_shopjip";
  };
  
  //Enable communication menu
  if (vtsarmaversion<3) then
  {
		_supportdata=(missionConfigFile >> "CfgCommunicationMenu");
		_commmenu = [["User menu", false]];
		for "_i" from 0 to (count _supportdata)-1 do
		{
			_cfg=_supportdata select _i;
			_add=true;
			if (((configname _cfg)=="vtsgroupmanager") && (pa_allowgroupchange!=1)) then
			{
				_add=false;
			};
			if (_add) then 
			{
			_commmenu=_commmenu+[[gettext (_cfg>> "text"),[(_i+2)],"",-5,[["expression",gettext (_cfg>> "expression")]],"1","1"]] ;
			};
		};  
		BIS_MENU_GroupCommunication = _commmenu;
	}
	else
	{
		_supportdata=(missionConfigFile >> "CfgCommunicationMenu");
		_commmenu=[];
		for "_i" from 0 to (count _supportdata)-1 do
		{
			_cfg=_supportdata select _i;
			_add=true;
			if (((configname _cfg)=="vtsgroupmanager") && (pa_allowgroupchange!=1)) then
			{
				_add=false;
			};
			if (_add) then 
			{
			_commmenu=_commmenu+[[str(_i+1),gettext (_cfg>> "text"),"",gettext (_cfg>> "expression"),"1","","",""]] ;
			//[player,(configname _cfg)] call bis_fnc_addcommMenuitem;
			};
		};
		//_test=[[1,"View distance up","","if (viewdistance + 500 <= 10000) then {setviewdistance (viewdistance + 500)}; hint (""View distance set to "" + str viewdistance)","1","","",""],[2,"View distance down","","if (viewdistance - 500 >= 1000) then {setviewdistance (viewdistance - 500)}; hint (""View distance set to "" + str viewdistance)","1","","",""],[3,"Fix head bug","","[this] execVM ""functions\headbug.sqf"";","1","","",""],[4,"Group manager interface","","[] call vtsgroup_opendialog;","1","","",""]];
		player setvariable ["BIS_fnc_addCommMenuItem_menu",_commmenu];
		[] call bis_fnc_refreshcommMenu;
	};
};


check_Go2marker = false;

//_srv_heli_boucle = [] execVM "functions\heli\srv_heli_boucle.sqf";
_acc_time = [] execVM "functions\acctime.sqf";


// variables

//NEW VARS SINCE 4.0

vts_buildingpatroldelay=300;
vts_fillinteriorpercent=15;
vts_gpsrefresh=10;
vts_gpsrefreshplayer=1;
vts_aiaccuracymodifier=pa_aiaimshake; //Divider

vts_transportpickuptimeout=300;
vts_transportrespawning=true;

vts_server_spawningdone=true;

if (isnil "vts_server_fps") then  {vts_server_fps=round(diag_fps);};


if (isnil "vtso_num") then {vtso_num=0;};

//Dummy
vts_smallworkdummy=gettext(missionConfigFile>> "vts_sys_smallworkdummy");
vts_dummy3darrow=gettext(missionConfigFile>> "vts_sys_dummy3darrow");
vts_weaponholder=gettext(missionConfigFile>> "vts_sys_weaponholder");

//Because only vehicle can have processedinit jip (they are networkable)
vts_dummyvehicle=gettext(missionConfigFile>> "vts_sys_dummyvehicle");

//Compo
vts_compofence=gettext(missionConfigFile>> "vts_sys_compofence");
vts_compolowwall=gettext(missionConfigFile>> "vts_sys_compolowwall");
vts_compofireplace=gettext(missionConfigFile>> "vts_sys_compofireplace");
vts_compobuildingnest=gettext(missionConfigFile>> "vts_sys_compobuildingnest");
vts_compobuildingmash=gettext(missionConfigFile>> "vts_sys_compobuildingmash");
vts_compoflag=gettext(missionConfigFile>> "vts_sys_compoflag");
vts_emptyhelipad=gettext(missionConfigFile>> "vts_sys_emptyhelipad");
vts_crater=gettext(missionConfigFile>> "vts_sys_crater");

//Explosives
vts_lowexplosive=gettext(missionConfigFile>> "vts_sys_lowexplosive");
vts_mediumexplosive=gettext(missionConfigFile>> "vts_sys_mediumexplosive");
vts_highexplosive=gettext(missionConfigFile>> "vts_sys_highexplosive");

//Parachutes
vts_vehicleparachute=gettext(missionConfigFile>> "vts_sys_vehparachute");
vts_parachute=gettext(missionConfigFile>> "vts_sys_parachute");

spawn_x=0.0;
spawn_y=0.0;
spawn_z=0.0;

rot_y=0.0;

spawn_x2=0.0;
spawn_y2=0.0;
spawn_z2=0.0;

rot_y2=0.0;

sideobjectfilter="";

console_nom="";
console_init="";

vts_build_spawn=false;

vts_fromfreecam=false;
vts_stopcam=true;
vts_cameraheight=5;
vts_cameravectorup=[[0,0,0],[0,0,0]];

if (isnil "vts_genericmarker") then 
{
	vts_genericmarker=0;
};

//Cleaned
 
if (isnil "heure") then {heure = 9;}; 
if (isnil "pluie") then {pluie = 0 ;}; 
if (isnil "brume") then {brume = [0,0] ;};
if (isnil "vtscloud") then {vtscloud = 0 ;}; 
if (isnil "vtswind") then {vtswind = [1,1,false];}; 
 
 
distanceobj = 0 ; 
temps = 0 ; 
vtskincooldown=0;

// variables VTS_boutons

valid_pluie = 0 ;
pluie_valid = "0" ;
pluie_affiche = pluie ;

valid_cloud = 0 ;
cloud_valid = "0" ;
cloud_affiche = vtscloud ;

valid_brume = 0 ;
brume_valid = "0" ;
brume_affiche = brume ;

valid_wind = 0 ;
wind_valid = "0" ;


if (isnil "valid_heure") then {valid_heure = 9;}; 
if (isnil "heure_valid") then {heure_valid = "9";};


if (isnil "vtsmissionpreset_index") then {vtsmissionpreset_index=0;};


// ---- Variables console TR

console_valid_side = 0;
console_valid_camp = 0;
console_valid_type = 0;
console_valid_attitude = 1;
console_valid_mouvement = 0;
console_valid_vitesse = 0;
console_valid_moral = 0.5;
console_unit_moral = 0.5;
local_console_unit_moral = console_unit_moral;
console_valid_orientation = 0;
console_valid_unite = 0;
var_hom_solo = 0;
var_v_solo = 0 ;
marqueur_tr = 0;
joueur_scripteur = 1;
gps_valid = 0;
gps_eni_valid = 0;
script_commande = 0;


joueursolo_telep = 1 ;
code_joueurX = "";
nom_joueurX = name player;


// --------- init de certaines variables jeu

boucle_cinema = true ; 
exercice_okreussi = false ;



  
//Player stuff post processing
if (isplayer player) then
{
	 if ([player] call vts_getisGM) then
	{

		//[] execVM "computer\console\gps_rt.sqf";
		//[] execVM "computer\console\gps_new.sqf";
		[] spawn gmgps_players;
		[] spawn gmgps_all;
		
		if (hasinterface) then
		{
			waituntil {!isnull (finddisplay 46);};
			vts_computerkeypressed = (finddisplay 46) displayaddeventhandler ["keyup","_result = _this call vts_OpenComputer"];   
			if (count actionkeys "teamswitch" == 0) then {[playerside, "hq"] sidechat "Please bind a key to Teamswitch (default T) to use the menus"};
		};
	      
	};
	
	NORRN_CAM_NVG = false;
	radius = 50;
	local_radius=radius;
	[player] execvm "player_init.sqf";
};

//Server stuff post processing
if (isserver) then
{
    // If addons are to be serverside checked
  
    //Loading class ressource for the GM interface
    if (pa_serversidemods==1) then
    {
    //0 cutText ["","BLACK FADED",100]; 
	//Add a bit before loading config so the server / player can figure out which addons are loaded (because we don't use addons in misson.sqm , they are not precached)
	_loaddata=
	{
		sleep 5.0;
		_load = [] execvm "mods\config\generatingconfig.sqf";
    //waitUntil {scriptDone _load};  
	};
	[] spawn _loaddata;
    //0 cutText ["","BLACK IN",1];
    };

};

//Init UPSMON data (Server / HC check are inside)
[] execvm "scripts\Init_UPSMON.sqf";


if (true) exitWith {};
