//Run on client (And HC too)
_hb=0;
while {true} do
{
	
	//Event every 1 seconds
	if (_hb mod 1==0) then
	{
		if (hasinterface) then 
		{
			if (!(isserver) && ( (servercommandavailable "#kick") or (missionNamespace getvariable ["vts_isallowedgm",false]) ) ) then
			{
				if (isnil "vts_computerkeypressed") then 
				{
					vts_loggedadmin=true;
					vts_computerkeypressed = (finddisplay 46) displayaddeventhandler ["keyup","_result = _this call vts_OpenComputer"]; 
					if (count actionkeys "teamswitch" == 0) then {[playerside, "hq"] sidechat "Please bind a key to Teamswitch (default T) to use the menus"};	
					hintc "VTS : Logged as admin, Gamemaster shortcut activated (Teamswitch key)";
					if !(isnil "bis_fnc_iscurator") then {[{[_this] call vts_EnableZeus;},player] call vts_broadcastcommand;};
					playsound "computer";
				};
				
			};
			if (!(isserver) && !( (servercommandavailable "#kick") or (missionNamespace getvariable ["vts_isallowedgm",false]) ) ) then
			{
				if !(isnil "vts_loggedadmin") then
				{
					vts_loggedadmin=nil;
					systemchat "VTS : Logged Off";
					playsound "computer";
					(finddisplay 46) displayRemoveEventHandler ["keyup",vts_computerkeypressed];
					if !(isnil "bis_fnc_iscurator") then {[{[_this] call vts_DisableZeus;},player] call vts_broadcastcommand;};
					vts_computerkeypressed=nil;
					gps_valid=0;
					gps_eni_valid=0;
				};
			};
		};
	};
	
	//Event every 120 seconds
	if (_hb mod 120==0) then
	{
		//Heartbeat script

		  //Keeping date uptodate for JIP player
		  Sync_time = date;
		  publicvariable "Sync_time";
		
	  
		//Let see if a group have no unit alive, then we will destroy it to free ressource for moar ennemy (arma 2 is limited to 177 group) !
	  
		  _numgroup = count allGroups;
		  //{ if ((_x!=vtsdummygroup) and (_x!=vtsdummygrouphidden)) then {deleteGroup _x}; } forEach allGroups;
		  //Can only destroy empty and local group
		  {deleteGroup _x} forEach allGroups;
		  
		  
		  if (_numgroup>165) then
		  {
			//Hint the Game master about too much group create in the area
			call compile format["if ([player] call vts_getisGM) then {hint ""!!! Warning you have %1 groups on 177 maximum allowed !!!"";};",_numgroup];
		  };

			
	};
	_hb=_hb+1;
	sleep 1;  
};	