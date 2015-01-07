vtsspawnonsquad_genlist=
{
	_groupunits=[];
	vtsspawnonsquad_units=[];
	_units=units (group player);
	for "_i" from 0 to (count _units)-1 do
	{
		_u=_units select _i;	
		//_type=" | "+gettext (configFile >> "CfgVehicles" >> (typeof _u) >> "displayname" );
		_type="";
		if (vehicle _u!=_u) then {_type=" > "+gettext (configFile >> "CfgVehicles" >> (typeof (vehicle _u)) >> "displayname" );};
		_groupunits set [count _groupunits,(name _u)+_type];
		vtsspawnonsquad_units set [count vtsspawnonsquad_units,_u];
	};
	[1500,_groupunits] call Dlg_FillListBoxLists;
};

vtsspawnonsquad_ui=
{
	createdialog "VTS_rscgroupteleport";
	[] call vtsspawnonsquad_genlist;
	waituntil {sleep 0.1;isnull (finddisplay 8006)};
	deletemarkerlocal vtsspawnonsquad_marker;
	vtsspawnonsquad_marker=nil;
};

vtsspawnonsquad_tpselect=
{
	private ["_unit"];
	_unit=vtsspawnonsquad_units select (lbCurSel ((finddisplay 8006) displayCtrl 1500));
	if (group _unit!=group player) exitwith {hint "!!! You are not in the same squad anymore !!!";};
	if (!(alive _unit) or (isnull _unit)) exitwith {hint "!!! The selected member is no more alive !!!";};
	
	closedialog 8006;
	[_unit] spawn vtsspawnonsquad_tp;
};

vtsspawnonsquad_select=
{
	private ["_unit"];
	_unit=vtsspawnonsquad_units select (lbCurSel ((finddisplay 8006) displayCtrl 1500));
	if (!(alive _unit) or (isnull _unit) or (group _unit!=group player)) exitwith {[] call vtsspawnonsquad_genlist;};
	
	_markercolor = switch (side _unit) do 
	{
		case west: {"ColorBlue"};
		case east: {"ColorRed"};
		case resistance: {"ColorGreen"};
		case civilian: {"ColorOrange"};
		default {"ColorBlack"};
	};
	
	((finddisplay 8006) displayCtrl 1600) ctrlsettext ("Spawn on "+name _unit);
	
	if (isnil "vtsspawnonsquad_marker") then 
	{
		vtsspawnonsquad_marker=createmarkerlocal ["vtsspawnongroupmarker",getposatl _unit];
		vtsspawnonsquad_marker setmarkertypelocal "mil_join";
		vtsspawnonsquad_marker setMarkerTextLocal (name _unit);
		vtsspawnonsquad_marker setMarkerSizeLocal [1,1];
		vtsspawnonsquad_marker setMarkerColorLocal _markercolor;
	}
	else
	{
		vtsspawnonsquad_marker setmarkerposlocal getposatl _unit;
		vtsspawnonsquad_marker setMarkerTextLocal (name _unit);
		vtsspawnonsquad_marker setMarkerSizeLocal [1,1];
		vtsspawnonsquad_marker setMarkerColorLocal _markercolor;
	};
	((finddisplay 8006) displayCtrl 1200) ctrlMapAnimAdd [0.5, 0.025, (getposatl _unit)];
	ctrlMapAnimCommit ((finddisplay 8006) displayCtrl 1200);
};

vtsspawnonsquad_tp=
{

	disableserialization;
	if !(isnil "vts_tptogroupinprogress") exitwith {hint "!!! You are already beeing Spawned !!!";};

	private ["_leader","_display","_lockctrl"];
	_leader=_this select 0;

	if (_leader==player) exitwith {hint "!!! You can't spawn on yourself !!!";};
	
	if ((player distance _leader)<50) exitwith {hint "!!! You are to close from this member !!!";};

	player playactionnow "sitdown";
	_display = findDisplay 46;
	_lockctrl=_display displayAddEventHandler ["KeyDown","true"];
	
	if (vehicle _leader!=_leader) then
	{
		_vehicle=vehicle _leader;
		if ((_vehicle emptyPositions "cargo")<1) exitwith {hint "!!! No space available in the member's vehicle cargo !!!";};
		hint "Spawning you to the member's vehicle . . .";
		cutText ["","BLACK OUT",1];
		

		_code={};
		call compile format["_code={if ((group _this)==group player) then {systemchat ""VTS Group spawning : %1 is spawning on %2"";};};",name player, name _leader];
		[_code,_leader] call vts_broadcastcommand;
		
		vts_tptogroupinprogress=true;
		sleep 1;
		if ((isnull _vehicle) or !(alive _vehicle) or ((_vehicle emptyPositions "cargo")<1)) exitwith 
		{
			cutText ["","BLACK IN",2];
			hint "!!! Member's vehicle not available anymore !!!";
			vts_tptogroupinprogress=nil;
			_display displayRemoveEventHandler ["KeyDown",_lockctrl];
		};
		player moveincargo _vehicle;
		closedialog 8006;
		cutText ["","BLACK IN",2];
		hint "Done";
		vts_tptogroupinprogress=nil;
		_display displayRemoveEventHandler ["KeyDown",_lockctrl];
		("GROUPSPAWN: "+(name player)+" spawned on " +(name _leader))  call vts_addlog;
	}
	else
	{
		_pos=[];
		_posleader=(getposasl  _leader);
		if (surfaceiswater _posleader) then
		{
			_pos=_posleader;
		}
		else
		{
			_pos=_posleader findEmptyPosition [5,100,(typeof player)];
			if ((count _pos)<1) then {_pos=_posleader;};
		};
		_smoke_left="SmokeShell" createVehicle _pos;
		//_smoke_right="SmokeShell" createVehicle _pos;
		hint "Spawning you";
		vts_tptogroupinprogress=true;
		[] spawn 
		{
			sleep 2;
			hint "Spawning you .";
			sleep 2;
			hint "Spawning you . .";
			sleep 2;
			hint "Spawning you . . .";
		};


		_code={};
		call compile format["_code={if ((group _this)==group player) then {systemchat ""VTS Group spawning : %1 is spawning on %2"";};};",name player, name _leader];		
		[_code,_leader] call vts_broadcastcommand;
		
		
		sleep 7;
		cutText ["","BLACK OUT",1];
		sleep 1;
		_dir=(([_posleader select 0,_posleader select 1] select 0) - ([_pos select 0,_pos select 1] select 0)) atan2 (([_posleader select 0,_posleader select 1] select 1) - ([_pos select 0,_pos select 1] select 1));
		player setposasl _pos;
		player setdir _dir;
		closedialog 8006;
		deletevehicle _smoke_left;
		vts_tptogroupinprogress=nil;
		_display displayRemoveEventHandler ["KeyDown",_lockctrl];
		("GROUPSPAWN: "+(name player)+" spawned on " +(name _leader))  call vts_addlog;
		/*
		_smoke_left attachto [player,[0,0,0],"leftfoot"];
		_smoke_right attachto [player,[0,0,0],"leftright"];
		[_smoke_left,_smoke_right] spawn 
		{
			sleep 0.1;
			deletevehicle (_this select 0);
			deletevehicle (_this select 1);
			vts_tptogroupinprogress=nil;
		};
		*/
		cutText ["","BLACK IN",2];
		hint "Done";
	};
};