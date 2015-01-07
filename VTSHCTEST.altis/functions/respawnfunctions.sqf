vts_respawn_variable_state="vts_unconcious_state";
vts_respawn_variable_dead="vts_dead_state";
vts_respawn_variable_dragger="vts_unconcious_dragger";
vts_respawn_variable_dragging="vts_unconcious_draging";
vts_respawn_anim_injured="AinjPpneMstpSnonWrflDnon_injuredHealed";
vts_repsawn_anim_drag="AcinPknlMstpSrasWrflDnon";
//action grabdrag
//action released

//Check if the player can interact (unconcious or dead)
vts_respawn_abletointeract=
{
	private ["_unit","_bool"];
	_unit=_this select 0;
	_bool=true;
	if ((_unit getvariable [vts_respawn_variable_state,false]) or (_unit getvariable [vts_respawn_variable_dead,false])) then {_bool=false;};
	_bool;
};

//Launch on joining
vts_enablevtsrespawn=
{
	private ["_unit"];
	//Add eventhandler on respawn (keeped on player death
	_unit = _this select 0;
	
	_unit addeventhandler ["Respawn",
	{
	waituntil {(alive player) && !(isnull player)};_this call vts_respawn_onrespawn;
	player addaction ["Release","functions\respawndragoff.sqf",[],101,false,false,"","[_this,_this] call vts_respawn_istoreleaseself"];
	}
	];
	
	_unit addeventhandler ["Killed",
	{
		
		if (lineIntersects [[(getposasl player select 0),(getposasl player select 1),(getposasl player select 2)+1],[(getposasl player select 0),(getposasl player select 1),(getposasl player select 2)-2],player,vehicle player]) then 
		{
			vts_death_pos=getposatl player;
			if (surfaceiswater vts_death_pos) then {vts_death_pos=getposasl player;};
		} 
		else {vts_death_pos=[];};
	}
	];
	
	//Handle self release
	_unit addaction ["Release","functions\respawndragoff.sqf",[],101,false,false,"","[_this,_this] call vts_respawn_istoreleaseself"];
	//Try to get the position of the body while moving so we can have an accurate respawn in building or whatever
	//_unit addeventhandler ["Killed",{vts_respawn_position=getposatl player;}];
	
	if (isnil "vts_unitcurrentlifecount") then {vts_unitcurrentlifecount=pa_revivecount;};	
	
	//No respawn revive
	//if ((pa_revivetype==4) or (pa_revivetype==3)) then {vts_unitcurrentlifecount=9999};
	
	//Check player on ground to enable JIP revive / drag action
	{
		if (_x getvariable [vts_respawn_variable_state,false]) then
		{
				[_x] call vts_respawn_addactions;
				_x switchmove "AmovPpneMstpSrasWrflDnon";
		};
	} foreach playableunits;
	
};

vts_respawn_storeloadoutloop=
{

	while{!isnull player} do 
	{
		//No loadout save when dead (not working) or in revive animation (not working too, dunno why)
		if (alive player)  then 
		{	
			//No loadout save when in a vehicle (some bug its seems)
			//if (vehicle player==player) then
			//{
				if !(player getvariable [vts_respawn_variable_state,false]) then
				{
					//player sidechat "saving loadout";
					_loadoutsave={
					vtsloadout = [player] call vts_getloadout;
					};
					//Using spawn to not break the loop if the loadout save is bugging
					[] spawn _loadoutsave;
				};
			//};
		};
		sleep 60;  
	};

};

vts_respawn_istorevive=
{
	private ["_b","_wounded","_healer"];
	_b=false;
	_wounded=_this select 1;
	_healer=_this select 0;
	if !(isplayer _wounded) exitwith {_b};
	if ([_healer] call vts_respawn_abletointeract) then
	{
		if ((pa_revivetype==1) or (pa_revivetype==2 && getnumber(configfile >> "CfgVehicles" >> (typeof _healer) >> "attendant")==1) or (pa_revivetype==3) or (pa_revivetype==4 && getnumber(configfile >> "CfgVehicles" >> (typeof _healer) >> "attendant")==1))  then
		{
			if ((isnull (_wounded getVariable [vts_respawn_variable_dragger,objnull])) && (_wounded getVariable [vts_respawn_variable_state,false]) && (((visiblePositionASL _wounded) distance (getposasl _healer))<2.5) && (_wounded!=_healer) ) then {_b=true;};
		};
	};
	_b;
};

vts_respawn_istodrag=
{
	private ["_b","_wounded","_healer"];
	_wounded=_this select 1;
	_healer=_this select 0;
	_b=false;
	if !(isplayer _wounded) exitwith {_b};
	if ([_healer] call vts_respawn_abletointeract) then
	{
		if ((isnull (_wounded getVariable [vts_respawn_variable_dragger,objnull])) && (_wounded getVariable [vts_respawn_variable_state,false]) && (((visiblePositionASL _wounded) distance (getposasl _healer))<2.5) && (_wounded!=_healer)) then 
		{
		_b=true;
		};
	};
	_b;
};

vts_respawn_istoreleaseother=
{
	private ["_b","_wounded","_healer"];
	_wounded=_this select 1;
	_healer=_this select 0;
	_b=false;
	if !(isplayer _wounded) exitwith {_b};
	if ([_healer] call vts_respawn_abletointeract) then
	{
		if (!(isnull (_wounded getVariable [vts_respawn_variable_dragger,objnull])) && (_wounded getVariable [vts_respawn_variable_state,false]) && (((visiblePositionASL _wounded) distance (getposasl _healer))<10) && (_wounded!=_healer) ) then 
		{
			if ((_wounded getVariable vts_respawn_variable_dragger)!=_healer) then
			{
				_b=true;
			};
		};
	};
	_b;
};

vts_respawn_istoreleaseself=
{
	private ["_b","_wounded","_healer"];
	_wounded=_this select 1;
	_healer=_this select 0;
	_b=false;
	if !(isplayer _wounded) exitwith {_b};
	if ([_healer] call vts_respawn_abletointeract) then
	{
		if !(isnull (_healer getVariable [vts_respawn_variable_dragging,objnull])) then 
		{
			_dragging=_healer getVariable vts_respawn_variable_dragging;
			if (((getposasl _dragging) distance (getposasl _healer))<10) then
			{
				_b=true;
			};
		};
	};
	_b;
};

vts_respawn_dragon=
{
	private ["_healer","_wounded"];
	//local to the reviver
	_healer=_this select 1;
	_wounded=_this select 0;	
	_wounded setvariable [vts_respawn_variable_dragger,_healer,true];
	_healer setvariable [vts_respawn_variable_dragging,_wounded,true];
	waituntil {!isnull (_wounded getvariable vts_respawn_variable_dragger)};
	if (vehicle _healer!=_healer) then {_healer switchmove "";};
	_healer playactionnow "grabdrag";	
	/*
	_wounded attachto [_healer,[0,1.10,0.10]];
	_wounded setdir 180;
	_wounded setposatl (getposatl _wounded);
	*/	
	if (isnil "vts_respawndrawanimsafety") then 
	{
		//player sidechat "handler anim drag";
		vts_respawndrawanimsafety=_healer addEventHandler ["AnimChanged",
		{
			_anim=(_this select 1);
			if (_anim=="helper_switchtocarryrfl" or _anim=="acinpknlmstpsraswrfldnon_acinpercmrunsraswrfldnon" ) then
			{
				(_this select 0) switchmove vts_repsawn_anim_drag;
			};
		}];
	};
	waitUntil	{(isnull _wounded) or !(alive _wounded) or isnull(_wounded getvariable [vts_respawn_variable_dragger,objnull])};
	if (vehicle _healer!=_healer) then {_healer switchmove "";};
	_healer removeEventHandler ["AnimChanged",vts_respawndrawanimsafety];
	vts_respawndrawanimsafety=nil;
	_healer playactionnow "released";
	detach _wounded;
};

vts_respawn_dragoff=
{
	private ["_healer","_wounded","_dragger"];
	//local to the reviver
	_healer=_this select 1;
	_wounded=_this select 0;	
	if (_healer==_wounded) then
	{
		_wounded=_healer getVariable vts_respawn_variable_dragging;
	};
	_dragger=_wounded getvariable [vts_respawn_variable_dragger,objnull];
	_wounded setvariable [vts_respawn_variable_dragger,objnull,true];
	_healer setvariable [vts_respawn_variable_dragging,objnull,true];
	if !(isnull _dragger) then {_dragger setvariable [vts_respawn_variable_dragging,objnull,true];};
	waitUntil {isnull (_wounded getvariable vts_respawn_variable_dragger)};
	if (vehicle _healer!=_healer) then {_healer switchmove "";};
	_healer playactionnow "released";
	detach _wounded;
};

vts_respawn_canrespawn=
{
	private ["_wounded","_b"];
	//local to the wounded
	_wounded=_this select 0;
	_b=false;
	if (isnull (_wounded getVariable [vts_respawn_variable_dragger,objnull])) then
	{
		_b=true;
	};
	_b;
};

vts_respawn_addactions=
{
	private ["_unit"];
	_unit=_this select 0;
	_unit addaction ["Revive","functions\respawnrevive.sqf",[],100,false,false,"","[_this,_target] call vts_respawn_istorevive"];
	_unit addaction ["Drag","functions\respawndragon.sqf",[],101,false,false,"","[_this,_target] call vts_respawn_istodrag"];
	_unit addaction ["Release","functions\respawndragoff.sqf",[],101,false,false,"","[_this,_target] call vts_respawn_istoreleaseother"];
};

vts_respawn_debug=
{
	private ["_dummy"];
	_dummy=_this select 0;
	[_dummy] call vts_respawn_waitingforrevive;
	[_dummy] call vts_respawn_addactions;
};

vts_respawn_norevive=
{
	private ["_unit","_body"];
	//_script=[] execvm "functions\respawnfunctions.sqf";
	//waitUntil {scriptDone _script};
	_unit=_this select 0;
	_body=_this select 1;
	//_unit sidechat "respawn";
	//Handling life count;
	if (pa_revivetype>0)  then
	{
		if (vts_unitcurrentlifecount!=0 && pa_revivetype!=4 && pa_revivetype!=3) then 
		{
			//Some live left
			vts_unitcurrentlifecount=vts_unitcurrentlifecount-1;
			if (vts_unitcurrentlifecount<0) then {vts_unitcurrentlifecount=0;};			
			//Teleporting the player to base
			_base=objnull;
			call compile format["_base=%1_spawn;",side group _unit];
			_posbase=(getpos _base) findEmptyPosition [0.1,10];
			_txt="";
			_log="";
			if (vts_unitcurrentlifecount<1000) then 
			{
				_txt=format["Respawning : %1 Live(s) remaining",vts_unitcurrentlifecount];
				_log=format ["LIFE: %1 is "+_txt,name _unit];
			}
			else
			{
				_txt="Respawning";
				_log=format ["LIFE: %1 is "+_txt,name _unit];
			};
			_log call vts_addlog;
			titleText  [_txt,"BLACK FADED",0];
			hint _txt;
			if (count _posbase<1) then {_posbase=(getposatl _base)};
			//Small sleep to make sure the character is initialized by the engine (I don't know WTF happen there)
			sleep 0.5;
			if ((surfaceiswater _posbase) or ((ASLToATL visiblePositionasl _base select 2)>2)) then
			{
				_unit setposasl [((getposasl _base) select 0),((getposasl _base) select 1),((getposasl _base) select 2)+1];
			}
			else
			{
				_unit setposatl _posbase;
			};
			if (pa_startingammo==0) then {sleep 1.0;[_unit] call vts_stripunitweapons;};
			sleep 1.0;
			titleText  [_txt,"BLACK IN", 7.5];
			
		

		}
		else
		{
			if (!isnil "currentspectactescript") then {terminate currentspectactescript;};
			//No lifes left, spectator mode
			vts_unitcurrentlifecount=0;
			
			("DEATH: "+(name _unit)+" is definitely dead")  call vts_addlog;
			_unit setcaptive true;
			_unit playActionNow "Die";
			removeallweapons _unit;
			[_unit] joinsilent grpnull;
			_unit setvariable [vts_respawn_variable_dead,true,true];
			//Disable ACRE when dead
			if !(isnil "acre_api_fnc_setSpectator") then
			{
				[true] spawn acre_api_fnc_setSpectator;
			};
			//Giving as target the spawn base so the player don't go buging in the sea (yet)
			if !(isnil "currentspectactescript")  then {closedialog 0;terminate currentspectactescript;sleep 0.25;};
			currentspectactescript=[_unit, _unit, "null"] execVM "spectator\specta.sqf";
			_spectateid=_unit addaction ["Spectate","spectator\actionspecta.sqf"];
			
			[_spectateid,_unit] spawn 
			{
				waitUntil {sleep 0.1;!((_this select 1) getvariable [vts_respawn_variable_dead,false])};
				(_this select 1) removeaction (_this select 0);				
			};
			
			//Avoid unit dying in loop underwater (when the base is above water)
			if ((surfaceiswater getposatl _unit) && (count vts_death_pos<1)) then
			{
				sleep 0.5;
				_base=objnull;
				call compile format["_base=%1_spawn;",side group _unit];
				_unit setposasl [((getposasl _base) select 0),((getposasl _base) select 1),((getposasl _base) select 2)+1];
			};
			
			_deadeventhandler=_unit addeventhandler["fired",{deletevehicle (_this select 6);}];
			_deadanimhandler=_unit addeventhandler["AnimChanged",{_check={sleep 0.5;if (((_this select 0) selectionPosition "Neck" select 2)>0.5) then {(_this select 0) playActionNow "Die";};};_this spawn _check;}];
			_deaddamagehandler=_unit addeventhandler["Dammaged",{(_this select 0) setdamage 0;}];
			_deadreloadhandler= (finddisplay 46) displayaddeventhandler ["keydown", "
			if ((_this select 1)in (actionKeys ""ReloadMagazine"")) then {
				player setdamage 1;
			};
			"];
			
			while {(alive _unit) && (_unit getVariable [vts_respawn_variable_dead,false])} do
			{
				//Not allowed in a vehicle
				if (vehicle _unit!=_unit) then
				{
					moveout _unit;
					_unit playActionNow "Die";
				};
				sleep 1;
			};
			
			if !(isnil "acre_api_fnc_setSpectator") then
			{
				[false] spawn acre_api_fnc_setSpectator;
			};
			
			_unit removeeventhandler ["fired",_deadeventhandler];
			_unit removeeventhandler ["AnimChanged",_deadanimhandler];
			_unit removeeventhandler ["Dammaged",_deaddamagehandler];
			(finddisplay 46) displayRemoveEventHandler ["keydown",_deadreloadhandler];
			
		};
	}
	else
	{
		titleText ["Respawning","BLACK IN", 7.5];

	};
};

vts_respawn_forcerespawnaction=
{
	vts_respawndelay=0;
};

vts_respawn_forcerespawn=
{
	private ["_unit"];
	_unit=_this select 0;
	//_unit sidechat "forcedrespawn";
	_unit setdamage 0;
	_unit playactionnow "agonyStop";
	//_unit switchmove "";
	vts_lastrespawndelay=nil;
	[_unit,objnull] call vts_respawn_norevive;
};

vts_respawn_waitingforrevive=
{
	private ["_unit","_deadeventhandler","_deadanimhandler","_deaddamagehandler","_deadreloadhandler","_vtsdyingaction","_code"];
	
	_unit=_this select 0;
	
	if (!isnil "vts_lastrespawndelay") then
	{
		//Been killed while been unconcious, restoring delay and drag var
		vts_respawndelay=vts_lastrespawndelay-(getnumber(missionconfigfile >> "respawndelay"));
		if (vts_respawndelay<0) then {vts_respawndelay=0;};
		_dragger=_unit getVariable [vts_respawn_variable_dragging,objnull];
		_unit setvariable [vts_respawn_variable_dragger,objnull,true];
		if !(isnull _dragger) then {_dragger setvariable [vts_respawn_variable_dragging,objnull,true];};
	}
	else
	{
		vts_respawndelay=pa_revivetimeout;
	};
	_unit setvariable [vts_respawn_variable_state,true,true];
	_unit setcaptive true;

	//_unit setUnconscious true;
	_unit setdamage 0.0;
	//Change stance to prone immediatly
	_unit switchmove "AmovPpneMstpSrasWrflDnon";
	//Force agony
	//_unit playactionnow "agonyStart";
	//Wait action agony done to lock control (local) with grabdragged action
	//_unit playaction "grabDragged";	
	_unit playmovenow vts_respawn_anim_injured;
	
	_deadeventhandler=_unit addeventhandler["fired",{deletevehicle (_this select 6);}];
	_deadanimhandler=_unit addeventhandler["AnimChanged",{_check={sleep 0.5;if (((_this select 0) selectionPosition "Neck" select 2)>0.5) then {(_this select 0) playmovenow vts_respawn_anim_injured;};};_this spawn _check;}];
	_deaddamagehandler=_unit addeventhandler["Dammaged",{(_this select 0) setdamage 0;}];
	_deadreloadhandler= (finddisplay 46) displayaddeventhandler ["keydown", "
	if ((_this select 1)in (actionKeys ""ReloadMagazine"")) then {
		player setdamage 1;
	};
	"];
	
	
	_vtsdyingaction=0;
	vts_respawnrevivedelay=0;
	
	if ((pa_revivetype!=4) && (pa_revivetype!=3)) then
	{
		_vtsdyingaction=_unit addaction ["<t color=""#ED2744"">Respawn</t>","functions\respawnforce.sqf",[],100,false,false,"","[_this,_target] call vts_respawn_canrespawn"]; 
	};
	//Add MP sync revive action
	_code={
	[_this] call vts_respawn_addactions;
	_this switchmove "AmovPpneMstpSrasWrflDnon";
	};
	[_code,_unit] call vts_broadcastcommand; 
	//then continue
	while {(alive _unit) and (vts_respawndelay>0) and (_unit getVariable vts_respawn_variable_state)} do
	{
		//Not allowed in a vehicle
		if (vehicle _unit!=_unit) then
		{
			moveout _unit;
			_unit playmovenow vts_respawn_anim_injured;
		};
		//Check if the dragger is not dead or stopped
		_dragger=_unit getVariable [vts_respawn_variable_dragger,objnull];
		
		if ((!isnull _dragger) && (alive _dragger) && (vehicle _dragger==_dragger)) then
		{
			_unit attachto [_dragger,[0,1.10,0.10]];
			_unit setdir 180;
			_unit setposatl (getposatl _unit);
		};
		
		if ((isnull _dragger) or (vehicle _dragger!=_dragger) or (!alive _dragger)) then
		{
			//_unit setvariable [vts_respawn_variable_dragger,objnull,true];
			detach _unit;
		};
		//No damage when injured
		if (damage _unit>0) then
		{
			_unit setdamage 0;
		};		
		//No timer when dragged
		if ([_unit] call vts_respawn_canrespawn) then
		{
			if (vts_respawnrevivedelay<1) then
			{
				_resptxt="";
				if ((pa_revivetype!=4) && (pa_revivetype!=3)) then
				{
					_resptxt=format["Respawning in : %1 s",vts_respawndelay];
				}
				else
				{
					_resptxt=format["Fatal bleeding in : %1 s",vts_respawndelay];
				};
				hintsilent _resptxt;
				vts_respawndelay=vts_respawndelay-1;
			}
			else
			{
				vts_respawnrevivedelay=vts_respawnrevivedelay-1;
			};
		};
		sleep 1;
		if (vts_respawndelay<0) then {vts_respawndelay=0;};
	};
	//End of the wounded ability
	if ((pa_revivetype!=4) && (pa_revivetype!=3)) then
	{
		_unit removeaction _vtsdyingaction;
	};
	_unit setcaptive false;
	_unit setvariable [vts_respawn_variable_state,false,true];	
	
	_unit removeeventhandler ["fired",_deadeventhandler];
	_unit removeeventhandler ["AnimChanged",_deadanimhandler];
	_unit removeeventhandler ["Dammaged",_deaddamagehandler];
	(finddisplay 46) displayRemoveEventHandler ["keydown",_deadreloadhandler];
	
	
	//_unit setUnconscious false;
	//Forcerespawn if the player revive delay is at 0 or used the respawn action
	if (vts_respawndelay==0) then 
	{
		[_unit] call vts_respawn_forcerespawn;
	}
	else
	//The player has been revived by someone or be killed again
	{
		
		//Check if the unit has been killed again while waiting for revive
		if (alive _unit) then
		{
			//Local to the wounded
			_healer=objnull;
			_array = nearestObjects [_unit, ["Man"], 5];
			if (count _array > 1) then {_healer = _array select 1;};	
			vts_unitcurrentlifecount=vts_unitcurrentlifecount-1;
			_txt=format["You have been revived by %1",name _healer];
			_log=format ["LIFE: %1 has been revived %2 ",name _unit,name _healer];
			if (vts_unitcurrentlifecount<1000) then
			{
				_txt=_txt+format["\n%1 Live(s) remaining",vts_unitcurrentlifecount];	
				_log=_log+format["%1 live(s) remaining",vts_unitcurrentlifecount];	;
			};
			_log call vts_addlog;
			titleText  [_txt,"WHITE IN",5];
			hint _txt;
			sleep 2.0;
			_unit setcaptive false;
			_unit playactionnow "agonyStop";
			vts_lastrespawndelay=nil;
		}
		else
		{
			vts_lastrespawndelay=vts_respawndelay;
		};
	};
};

vts_respawn_revive=
{
	private ["_healer","_wounded","_dragger","_pos","_healok","_healloop","_timetoheal","_code"];
	//local to the reviver
	_healer=_this select 1;
	_wounded=_this select 0;
	_healer playactionnow "medicstart";
	//Make sure the wounded is not dragged anymore
	_wounded setvariable [vts_respawn_variable_dragger,objnull,true];
	_healer setvariable [vts_respawn_variable_dragging,objnull,true];
	_dragger=_wounded getvariable [vts_respawn_variable_dragger,objnull];
	if !(isnull _dragger) then {_dragger setvariable [vts_respawn_variable_dragging,objnull,true];};
	detach _wounded;
	//_healer action ["heal",_wounded];
	_pos=getpos _healer;
	_healok=true;
	_healloop=0;
	_timetoheal=20;
	//Add the over time to the wounded
	hint format["You are trying to revive %1",name _wounded];
	_code={};
	call compile format["_code=
	{if (player==_this) then {vts_respawnrevivedelay=%1+5;hint ""%3 is trying to revive you"";};};
	",_timetoheal,vehiclevarname _wounded,name _healer];
	[_code,_wounded] call vts_broadcastcommand;
	//Then try to heal him
	while {(_healloop<=_timetoheal) && (_healok)} do
	{
		hintsilent format["You will revive %1 in %2",name _wounded,(_timetoheal-_healloop)];
		if (_pos distance (getpos _healer)>1) then {_healok=false;_healloop=_timetoheal;};
		_healloop=_healloop+1;
		sleep 1;
	};
	//Check if the player stayed long enough nearby
	if (_healok) then 
	{
		detach _wounded;
		_wounded setvariable [vts_respawn_variable_state,false,true];
		_wounded setdamage 0.0;			
		hint format["You revived %1",name _wounded];
		_healer playactionnow "medicstop";
	}
	else
	{
		hint format["You failed to revive %1",name _wounded];
	};
	
};

//Yeah that's bad, I need this, to fix the engine teleporting to z 0 by teleporting again the player a bit later :(
vts_respawn_accurateposrevive=
{
	private ["_unit","_pos","_dir"];
	_unit=_this select 0;
	_pos=_this select 1;
	_dir=_this select 2;
	sleep 0.5;
	_unit setdir _dir;
	if (surfaceiswater _pos) then
	{
		_unit setposasl _pos;		
	}
	else
	{
		_unit setposatl _pos;		
	};
	
};

vts_respawn_onrespawn=
{
	private ["_unit","_body","_dirbody","_posbody"];
	_unit=_this select 0;
	_body=_this select 1;
	_dirbody=direction _body;
	_posbody=getposatl _body;	
	if (surfaceiswater _posbody) then {_posbody=getposasl _body;};
	if (count vts_death_pos>0) then {_posbody=vts_death_pos;};
	
	//	Try to put the corpse ashore if dead underwater or on ground if in air (so forced respawn only happen if we can't found a correct terrain)
	if (((surfaceiswater _posbody) && ((_posbody select 2)<-0.5)) or ((_posbody select 2) > 100)) then
	{
		//if ((getposasl _body select 2)<-0.5) then {_unit setposasl [_posbody select 0,_posbody select 1,1];};
		//Using object class seem to find a good place on the beach out of water
		_location=_posbody findEmptyPosition [1,1000];
		if (count _location>0) then
		{
			_loop=0;
			_newpos=_location;
			_translatedir=((_newpos select 0) - (_posbody select 0)) atan2 ((_newpos select 1) - (_posbody select 1));
			//player sidechat format["%1",_translatedir];
			while {(surfaceiswater _newpos) && (_loop<500)} do
			{				
				_newpos=[(_newpos select 0)+2*sin _translatedir,(_newpos select 1)+2*cos _translatedir,(_newpos select 2)];
				_loop=_loop+1;
			};
			if !(surfaceiswater _newpos) then
			{
				_body setposatl [_newpos select 0,_newpos select 1,0.1];
				_posbody=[_newpos select 0,_newpos select 1,0.1];
			};
			//player sidechat str _loop;
		};
	};
	
	
	
	//If no revive left or in situation where revive can't be done (in water & in the sky);
	if ((vts_unitcurrentlifecount==0) or ((surfaceiswater _posbody) && ((_posbody select 2)<-0.5)) or ((_posbody select 2) > 100) ) then
	{
		//Check if no revive because no live
		if ((vts_unitcurrentlifecount==0)) then
		{
			//If lost his last live in a safe place, we let the body respawn there else we let it spawn at the respawn marker 
			if ((!(surfaceiswater _posbody) or ((_posbody select 2)>-0.5)) and !((_posbody select 2) > 100)) then
			{
				_unit setdir _dirbody;
				if (surfaceiswater _posbody) then
				{
					_unit setposasl _posbody;		
				}
				else
				{
					_unit setposatl _posbody;		
				};
				_body setposatl [-1000,-1000,0];
				[_unit,_posbody,_dirbody] spawn vts_respawn_accurateposrevive;
			};
		};
		//Let him respawn at the respawn marker, because where he is dead is not ok to let a revive animations
		_this spawn vts_respawn_norevive;
		
	}
	else
	//We move the player to death position and launch the revive functions
	{
		_unit setdir _dirbody;
		if (surfaceiswater _posbody) then
		{
			_unit setposasl _posbody;		
		}
		else
		{
			_unit setposatl _posbody;		
		};
		_body setposatl [-1000,-1000,0];
		_this spawn  vts_respawn_waitingforrevive;
		[_unit,_posbody,_dirbody] spawn vts_respawn_accurateposrevive;
		
	};
	

	
	
	//Clean up the body now
	[_body] spawn {sleep 3; deletevehicle (_this select 0);};
	
	//Reattribute loadout if in memory to the spawned player;
	if !(isnil "vtsloadout") then {[_unit,vtsloadout] call vts_setloadout;};
	
};