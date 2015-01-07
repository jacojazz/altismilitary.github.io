diag_log ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> player_init.sqf";
//Init player script
private "_unit";
_unit=_this select 0;


if (_unit==player) then
{
   //remove  damage to avoid death by collision sigh...
   _unit allowdamage false;
   _unit enablesimulation false;
   
  //loading info
  [] spawn vts_waitloadingclassinfo;
   
   //Loaded World sync ?
   [] spawn
   {
		waituntil{sleep 1;!isnil "vts_loadedworld"};
		if (vts_loadedworld!=worldName) then
		{
			while {true} do
			{
				hintC format["!!! Warning loaded world are different between Server : %1 and Client : %2 !!! Make sure addons are correctly synced/installed",vts_loadedworld,worldname];
				sleep 5;
			};
		};
   };
  //Wait for the server to be done
  waituntil {sleep 3;!(isnil "vts_serverready")};
  
  //Shitty workaround code to avoid drowning on connect coz BIS ...
  if (vtsarmaversion>2) then {call compile "_unit setOxygenRemaining 1.0;";};
  _unit enablesimulation true;
  
  if (hasinterface) then 
  {
	waituntil {sleep 1;!(isnull (findDisplay 46))};
	0 cutText ["","BLACK IN",1];
  };

  //Processing all inits localy on client
  [false] call vts_processobjectsinit;  
  
  //Check JIP players IDs
  [1] call vts_setupplayerid;
 
  //x_spawn are the dummy sign_sphere while _respawn are the markers
  //Intializing the markers
  if (pa_moverespawnmarkerstobases == 1) then 
  {

	_westpos=getpos west_spawn;
	_eastpos=getpos east_spawn;
	_guerpos=getpos guer_spawn;
	_civpos=getpos civ_spawn;  
	

	if ((count vts_serverready)>0) then
	{
		_spawnbase=objnull;
		call compile format["_spawnbase = %1_spawn;",side _unit];
		_time=time+10;
		
		if (!isDedicated && hasinterface) then {
			waitUntil {sleep 0.01;((_spawnbase distance vts_serverready)<1000) or (time>_time)};
		};
	
		_westpos=vts_serverready;
		_eastpos=vts_serverready;
		_guerpos=vts_serverready;
		_civpos=vts_serverready;
	};

    "respawn_west" setMarkerPosLocal [_westpos select 0, _westpos select 1, 0.9];
    "respawn_east" setMarkerPosLocal [_eastpos select 0, _eastpos select 1, 0.9];
    "respawn_guerrila" setMarkerPosLocal [_guerpos select 0, _guerpos select 1, 0.9];
    "respawn_civilian" setMarkerPosLocal [_civpos select 0, _civpos select 1, 0.9];
    "west_base" setMarkerPosLocal [_westpos select 0, _westpos select 1, 0.9];
    "east_base" setMarkerPosLocal [_eastpos select 0, _eastpos select 1, 0.9];
    "civ_base" setMarkerPosLocal [_civpos select 0, _civpos select 1, 0.9];
    "guer_base" setMarkerPosLocal [_guerpos select 0, _guerpos select 1, 0.9];
    "west_resp" setMarkerPosLocal [_westpos select 0, _westpos select 1, 0.9];
    "east_resp" setMarkerPosLocal [_eastpos select 0, _eastpos select 1, 0.9];
    "civ_resp" setMarkerPosLocal [_civpos select 0, _civpos select 1, 0.9];
    "guer_resp" setMarkerPosLocal [_guerpos select 0, _guerpos select 1, 0.9];
  	//"respawn_west" setMarkerPos getMarkerpos "base";
  	
  }
  else
  {
  	//Initialise revive script (this next line is needed for revive script)
  
    "west_base" setMarkerPosLocal [getpos west_spawn select 0, getpos west_spawn select 1, 0.9];
    "east_base" setMarkerPosLocal [getpos east_spawn select 0, getpos east_spawn select 1, 0.9];
    "civ_base" setMarkerPosLocal [getpos civ_spawn select 0, getpos civ_spawn select 1, 0.9];
    "guer_base" setMarkerPosLocal [getpos guer_spawn select 0, getpos guer_spawn select 1, 0.9];
    "west_resp" setMarkerPosLocal [getpos west_spawn select 0, getpos west_spawn select 1, 0.9];
    "east_resp" setMarkerPosLocal [getpos east_spawn select 0, getpos east_spawn select 1, 0.9];
    "civ_resp" setMarkerPosLocal [getpos civ_spawn select 0, getpos civ_spawn select 1, 0.9];
    "guer_resp" setMarkerPosLocal [getpos guer_spawn select 0, getpos guer_spawn select 1, 0.9];
    
  };

  //Handle eventhandlers association if needed
  [_unit] spawn vts_addeventhandlers;
  
  //Handle vts logistic stuff
  [_unit] spawn vts_isMovablePlayerInit;
  
  //Sync the date
  setdate Sync_time;
  //Overcast (also handle rain update)
  [vtscloud] call vts_SetCloud;

  //Fog
  brume call vts_setfog;
  
  //Wind
  setwind vtswind;

  //Sync game color
  "colorCorrections" ppEffectAdjust colorsarray;
  "colorCorrections" ppEffectCommit 3;

  
  //First we teleport him on respawn, 

  _spawnbase=objnull;
  //call compile format["_spawnbase = ""%1_Base"";",side _unit];
  call compile format["_spawnbase = %1_spawn;",side _unit];
  //_spawn_pos=getMarkerPos _spawnbase;
  _spawn_pos=visiblePosition _spawnbase;
  
  _unit setvelocity [0,0,0];
  if ((surfaceIsWater _spawn_pos) or ((ASLToATL visiblePositionASL _spawnbase select 2)>2)) then 
  {
	//If spawn above water, make them spaw inside the spawn tent
	_unit setPosASL (visiblePositionASL _spawnbase);
  }
  else
  {
	_unit setposatl [((_spawn_pos select 0)-5)+random 10,((_spawn_pos select 1)-5)+random 10,0.5];
  };

  
  //_unit playmovenow "AmovPercMstpSnonWnonDnon_exerciseKneeBendA";
  
  //_unit setposatl [getposatl _unit select 0,getposatl _unit select 1,(getposatl _unit select 2)+1];
  _unit setvelocity [0,0,1];
  
  _unit allowdamage true;
  _unit enablesimulation true;
  
  //Clean drowningsecurity running script if needed
  if !(isnil "vts_drownsecurity") then {terminate vts_drownsecurity;};
  
 // sleep 0.15;
  
//Strip player of weapons if mission setting up for
 //If no weapons then 
  if (pa_startingammo==0) then
  {
    
    //hint format ["%1",_unit];
    [_unit] spawn vts_stripunitweapons;
  }; 
  
  
  //Add action menu to  change class ingame
 // _condition="((_this distance west_respawn_tent)<5) or ((_this distance east_respawn_tent)<5) or ((_this distance guer_respawn_tent)<5) or ((_this distance civ_respawn_tent)<5)";
 // _actionId = player addAction ["Change class","Computer\console\selectclass.sqf", "", 1, false, false, "", _condition];
	if (pa_allowclasschange==1) then
	{
   west_respawn_tent addAction ["Change class","Computer\console\selectclass.sqf",west];
   east_respawn_tent addAction ["Change class","Computer\console\selectclass.sqf",east];
   guer_respawn_tent addAction ["Change class","Computer\console\selectclass.sqf",resistance];
   civ_respawn_tent addAction ["Change class","Computer\console\selectclass.sqf",civilian];
	}; 
	if (pa_allowgroupchange==1) then
	{
	   west_respawn_tent addAction ["Squad Manager","functions\groupmanager.sqf"];
	   east_respawn_tent addAction ["Squad Manager","functions\groupmanager.sqf"];
	   guer_respawn_tent addAction ["Squad Manager","functions\groupmanager.sqf"];
	   civ_respawn_tent addAction ["Squad Manager","functions\groupmanager.sqf"];	
	};  
	
	if (pa_allowteleporttoleader==1) then
	{
	   west_respawn_tent addAction ["Spawn on squad","functions\tptosquadmember.sqf"];
	   east_respawn_tent addAction ["Spawn on squad","functions\tptosquadmember.sqf"];
	   guer_respawn_tent addAction ["Spawn on squad","functions\tptosquadmember.sqf"];
	   civ_respawn_tent addAction ["Spawn on squad","functions\tptosquadmember.sqf"];	
	};
	
	if (pa_allowplayername==1) then 
	{
		[player] spawn vts_readfriendlyname;
	};
	
	player reveal [west_respawn_tent,4];
	player reveal [east_respawn_tent,4];
	player reveal [guer_respawn_tent,4];
	player reveal [civ_respawn_tent,4];
  /*
  //ACE player frustration saver 
  if (ACEMOD) then 
  {
    player addweapon "ACE_GlassesGasMask_US";
    player addweapon "ACE_GlassesBalaklava";
    player addweapon "ACE_Earplugs";
  };
  */
  
  
  //Sync terrain destruction
  //[] spawn vts_syncdestroyedterrain;


  
  //Sync timer
  [] spawn vts_timer_jip;
  
  //Freefall improvment
  if (vts_FreeFallImprovement) then {[] spawn vts_freefallkey;};
  
  //Give player the current game master
  _gm1=isnil "user1";
  _gm2=isnil "user2";
  if ((!_gm1) or (!_gm2)) then
  {
  
	//BreakClick security
    _breakclicksecurity = [] execVM "Computer\breackclicksecurity.sqf";
	_name1="";
	_name2="";
	if (isnil "user1") then {user1=objnull;};
	if (isnil "user2") then {user2=objnull;};
	if (alive user1) then {_name1=name user1};
	if (alive user2) then {_name2=name user2};
	
	_code={};
	_jointext=format["Current GAME MASTER(s) : %1 %2",_name1,_name2];
	
	if !(isnull VTS_HC_AI) then {_jointext=_jointext+"\nThe head less client for AI computation is ACTIVE";}
	else {_jointext=_jointext+"\nThe head less client for AI computation hasn't been detected";};
	if (pa_aiautomanage==1) then {_jointext=_jointext+"\nAI Smart waypoints management is ON."};
	call compile format["
    _code={cutText [""%1"",""PLAIN DOWN"",3];};
	",_jointext];
	//IS GM
    if ([player] call vts_getisGM) then 
    {
      //Advertissing player about a new GM
      [_code] call vts_broadcastcommand;

		//Setting HC units on connect for the Gamemaster
		//{player hcSetGroup [_x];} foreach allgroups;
		
		//Loading class ressource for the GM interface
		if (pa_serversidemods==0) then
		{
		//0 cutText ["","BLACK FADED",100]; 
			_loadddata=
			{
				sleep 5.0;
				_load = [] execvm "mods\config\generatingconfig.sqf";
			};
			[] spawn _loadddata;
		//waitUntil {scriptDone _load};  
		//0 cutText ["","BLACK IN",1];
		};
		
		//Add gm event to get server fps every x seconds and update the computer
		"vts_server_fps" addPublicVariableEventHandler {[_this select 1] call vts_updateserverfps;};
		"vts_server_groupsnum" addPublicVariableEventHandler {[_this select 1] call vts_updateservergroupnum;};
		//Informing GM UI
		_key="Please bind the TeamSwitch key";
		if (count (actionKeys "teamswitch")>0) then {_key=keyname ((actionKeys "teamswitch") select 0);};
		systemchat (("VTS GM Activated on key : ")+_key);			
		
		//Adding Zeus
		[]	spawn
		{
			sleep 1;
			if !(isnil "bis_fnc_iscurator") then {[{[_this] call vts_EnableZeus;},player] call vts_broadcastcommand;};
		};
    }
    else //NOT GM
    {
      [] spawn _code;
    };
  }
  else
  {
    cutText ["There is currently no GAME MASTER, the mission can't evolve !","PLAIN DOWN",3];
  };
  
  
  //Sync time at each server update to ensure a better sync for dawn & rise luminosity.
  "Sync_time" addPublicVariableEventHandler {setdate Sync_time;};
  
  //MP hint
  "vts_mphint" addPublicVariableEventHandler {hintsilent (_this select 1);};

  //Enable leader positioning if activated
  if (pa_allowgroupleadermarker==1) then
  {
	[] execvm "functions\leadermarkers.sqf";
  };
  
    //Sync music
	if (isnil "Musicvalid") then
	{
		Gomusic  = false;
		Musicvalid = "0";	
	}
	else
	{
		if (Musicvalid!="") then
		{
			if  ([Musicvalid,"vtsloop"] call KRON_StrInStr) then
			{
				[false,Musicvalid] call vts_playtensionmusic;
			}
			else
			{
				Gomusic  = True;
			};
		};
	};  

  //If the gesture mod is not loaded then activate the mission one
  if !(isClass (configFile >> "CfgPatches" >> "vts_gesture")) then
  {
	[] execvm "functions\vts_gesture.sqf";
  };  

  //Spawn the client heartbeat
  [] execvm "functions\client_heartbeat.sqf";
  
  
  //Launch mod scripts
  [] execVM "Mods\client_side_script.sqf";

  //Launch HC mod scripts and functions
  if (player==VTS_HC_AI) then 
  {
	[] execVM "Mods\headless_side_script.sqf";
	
	[] execVM "functions\hc_heartbeat.sqf";
	
	[] call vts_spawnlistener;

  };

  //Wair for the player to be on the ground to reinit its anim state (getting out of freefall)
  waitUntil {((getpos player) select 2)<10};
  sleep 3.0;
  player switchmove "";
  


};
