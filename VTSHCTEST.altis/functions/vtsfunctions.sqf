vts_freefallsafety=
{
	//systemchat "damage off";
	{player disableCollisionWith _x;} forEach playableUnits;
	waituntil 
	{
		sleep 1;
		_b=false;
		_pos=getposatl player;
		if (surfaceIsWater _pos) then {_pos=atltoasl _pos;};
		if (((_pos select 2)<500) or (((velocity player) select 2)>-30)) then 
		{_b=true;};
		_b;
	};
	{player enableCollisionWith _x;} forEach playableUnits;
	//systemchat "damage on";
};

vts_freefallkey=
{
	private ["_keyset","_kup","_kdown"];
	_keyset=false;
	if !(hasinterface) exitwith {};
	while {true} do 
	{
		if (vehicle player==player) then
		{
			if (((velocity player) select 2)<-30) then
			{
				if !(_keyset) then
				{
					_kdown=(finddisplay 46) displayaddeventhandler ["keydown",{_this call vts_freefallKeyDown}];					
					_keyset=true;
					hintsilent "VTS Free Fall Improvement : On";
					[] spawn vts_freefallsafety;
					sleep 3;
					hintsilent "";
				};
			}
			else
			{
				if (_keyset) then
				{
					(finddisplay 46) displayRemoveEventHandler ["keydown",_kdown];
					_keyset=false;	
					hintsilent "VTS Free Fall Improvement : Off";
					sleep 3;
					hintsilent "";					
				};
			};
			
		};
		sleep 3;
	};
};

vts_freefallKeyDown=
{
	if (((_this select 1) in (actionKeys "Stand")) or ((_this select 1) in (actionKeys "MoveUp"))) then
	{
		//systemchat "up down";
		_vel=velocity player;
		_vely=_vel select 2;
		_vely=_vely+0.5;
		if (_vely>-57) then {_vely=-57;};
		player setvelocity [_vel select 0,_vel select 1,_vely];
	};
	if (((_this select 1) in (actionKeys "Prone")) or ((_this select 1) in (actionKeys "MoveDown")) or ((_this select 1) in (actionKeys "Crouch"))) then
	{
		//systemchat "down down";
		_vel=velocity player;
		_vely=_vel select 2;
		_vely=_vely-0.5;
		if (_vely<-87) then {_vely=-87;};
		player setvelocity [_vel select 0,_vel select 1,_vely];
	};
		
};


vts_GetSideFromNumber=
{
	private ["_side","_nu"];
	_nu=_this select 0;
	switch (_nu) do
	{
		case 0:{_side=EASt;};
		case 1:{_side=WEST;};
		case 2:{_side=Resistance;};
		case 3:{_side=Civilian;};
		case 7:{_side=Civilian;};
	};
	_side;
};

vts_GetNumberFromSide=
{
	private ["_side","_nu"];
	_nu=_this select 0;
	switch (_nu) do
	{
		case EASt:{_side=0;};
		case WEST:{_side=1;};
		case Resistance:{_side=2;};
		case Civilian:{_side=3;};
		default {_side=7;};
	};
	_side;
};

vts_hideobject=
{
	private ["_obj","_state"];
	_obj=_this select 0;
	_state=_this select 1;
	_obj hideObject _state;
	_obj enablesimulation !_state;
	if (local _obj) then 
	{
		_obj setvariable ["vts_hidden",_state,true];
	};
};

//Allow GM UI on certain player, must run globally for local comparison
vts_EnableGM=
{
	private ["_unit","_type"];
	_unit=_this select 0;
	_type=_this select 1;
	if ([player] call vts_getisGM) then {((str _unit)+" Enable game master : "+(str _type)) call vts_gmmessage;};
	if !(local _unit) exitwith {};
	missionNamespace setvariable ["vts_isallowedgm",_type];
};

vts_SetBasePos=
{
	private ["_side","_pos","_posatop","_code","_serveronly"];
	_pos=_this select 0;
	_side=_this select 1;
	//Run only on server (in case of global call) execpt if called from a GM (we don't want to run that function on everybody)
	_serveronly=true;
	if (count _this>2) then {_serveronly=_this select 2;};
	
	
	if (_serveronly && !isserver) exitwith {};
	
	//Accurate position of the object
	if (typename _pos=="OBJECT") then 
	{
			_pos=getposasl _pos;
			_posatop=_pos;
	} 
	else
	//Find best height for 2D position 
	{
		_posatop=[[_pos select 0,_pos select 1]] call vts_SetPosAtop;
	};
	
	//Position for JIP
	vts_serverready=[];
	publicVariable "vts_serverready";
	
	call compile format["%1_respawn_tent setDamage 0;",_side];
	call compile format["%1_respawn_tent setposasl (_posatop);",_side];
	call compile format["%1_spawn setDamage 0;",_side];
	call compile format["%1_spawn setposasl (_posatop);",_side];
	//sleep 1;
	call compile format["
	""%1_Resp"" setMarkerPos _pos;
	""%1_Base"" setMarkerPos _pos;
	if (pa_moverespawnmarkerstobases == 1) then 
	{
	   _resp="""";
	   if (""%1"" ==""guer"") then {_resp=""respawn_guerrila""};
	   if (""%1"" ==""civ"") then {_resp=""respawn_civilian""};
	   if (""%1"" ==""east"") then {_resp=""respawn_east""};
	   if (""%1"" ==""west"") then {_resp=""respawn_west""};
		""%1_Resp"" setMarkerText ""Base"";
		_resp setMarkerPos _pos;
	};
	",_side];
	hint format["Base & Respawn %1 moved .",_side];
	
	_code=
    {
        if !([player] call vts_getisGM) then
        {
			//Disable other respawn marker if not on your side
			if (side group player==west) then {"east_resp" setMarkerTypeLocal "Empty";"guer_resp" setMarkerTypeLocal "Empty";"civ_resp" setMarkerTypeLocal "Empty";};
			if (side group player==east) then {"west_resp" setMarkerTypeLocal "Empty";"guer_resp" setMarkerTypeLocal "Empty";"civ_resp" setMarkerTypeLocal "Empty";};
			if (side group player==resistance) then {"west_resp" setMarkerTypeLocal "Empty";"east_resp" setMarkerTypeLocal "Empty";"civ_resp" setMarkerTypeLocal "Empty";};
			if (side group player==civilian) then {"west_resp" setMarkerTypeLocal "Empty";"east_resp" setMarkerTypeLocal "Empty";"guer_resp" setMarkerTypeLocal "Empty";};
        };
    };
    _sync=[_code] call vts_broadcastcommand;
};

vts_ShowObjectsOwner=
{
	if !(isserver) exitwith {};	
	private ["_players","_objects","_o","_id","_index"];
	_players=[];
	_objects=[];
	{
		if !(isnull _x) then {_players=_players+[owner _x,name _x];};
	} foreach playableUnits;
	{
		_id=owner _x;
		_index=_players find _id;
		if (_index>-1) then
		{
			_objects=_objects+[((typeof _x)+" @ "+(_players select (_index+1)))];
		};
	}
	foreach allMissionObjects "all";
	[{if ([player] call vts_getisgm) then {hintc str _this;};},_objects] call vts_broadcastcommand;
};

vts_weapononback=
{
	vts_weapononbackloop=true;
	player action ["switchweapon",player,player,999];
	/*
	while {!(isnil "vts_weapononbackloop")} do
	{
		player action ["switchweapon",player,player,999];
		sleep 0.25;
	};
	*/
};

vts_weapononhand=
{
	vts_weapononbackloop=nil;
	player action ["switchweapon",player,player,23];
};

vts_getvehicleclassdisplayname=
{
	private ["_class","_txt","_cvc"];
	_class=_this select 0;
	_txt="";
	_cvc=gettext (configfile >> "CfgVehicles" >> _class >> "vehicleclass");
	if (_cvc!="") then
	{
		_txt=gettext (configfile >> "CfgVehicleClasses" >> _cvc >> "displayname");
		_txt=_txt+" ";
	};
	_txt;
};

vts_checklimitedorientation=
{
	private ["_currentorientation","_initialorientation","_maxorientation","_minrange","_maxrange","_360","_Inrange"];
	//Based on 360°
	_currentorientation=direction (_this select 0);
	_initialorientation=_this select 1;
	if (_initialorientation>360) then {_initialorientation=_initialorientation-360;};
	if (_initialorientation<0) then {_initialorientation=_initialorientation+360;};
	
	_maxorientation=_this select 2;
	_minrange=0;
	_maxrange=0;
	_360=false;
	if (_initialorientation-_maxorientation<0) then {_minrange=360-(_initialorientation-_maxorientation);_360=true} else {_minrange=(_initialorientation-_maxorientation);};
	if (_initialorientation+_maxorientation>360) then {_maxrange=(_initialorientation+_maxorientation)-360;_360=true} else {_maxrange=(_initialorientation+_maxorientation);};
	_Inrange=false;
	if (_360) then 
	{
		if ((_currentorientation>=_minrange) or (_currentorientation<=_maxrange)) then 
		{
			_Inrange=true;
		};
	}
	else
	{
		if ((_currentorientation>=_minrange) && (_currentorientation<=_maxrange)) then 
		{
			_Inrange=true;
		};
	};
	//player sidechat format ["%1 %2 %3",_minrange,_maxrange,_currentorientation];
	_Inrange;
};

vts_sitonchair=
{
	private ["_objects","_chair","_random","_anim","_clientcode","_sitanimloop","_time","_lastvalidorientation","_chairvalid"];
	//_objects = nearestObject [[(getpos player select 0)+1*sin(direction player),(getpos player select 1)+1*cos(direction player),(getpos player select 2)],["FoldChair","Land_Chair_EP1","Land_CampingChair_V1_F","Land_CampingChair_V2_F"],1];
	_chair=cursorTarget;
	_chairvalid=false;
	if !(isnull _chair) then
	{
		if (
			[(typeof _chair),"chair"] call KRON_StrInStr
			)
		then
		{
			if (_chair distance player<3) then {_chairvalid=true;};
		};
		  
	};
	
	
	//if (player in _objects) then {_objects=_objects-[player];};

	if !(_chairvalid) exitwith 
	{
		hint "!!! Sit on chair : No chair has been found in your aim sight !!!";	
	};
	/*
	if (count _objects<1) exitwith 
	{
		hint "!!! Sit on chair : No chair has been found in front of you !!!";	
	};
	*/

	//_chair=_objects select 0;
	
	_random = round(random 2);
	_anim = "";
	if (vtsarmaversion==2) then
	{
		switch (_random) do
		{
		  case 0 : {_anim="sykes_c0briefing"};
		  case 1 : {_anim="rodriguez_c0briefing"};
		  case 2 : {_anim="cooper_c0briefing"};
		};
	};

	if (vtsarmaversion==3) then
	{
		switch (_random) do
		{
		  case 0 : {_anim="HubSittingChairA_idle1"};
		  case 1 : {_anim="HubSittingChairA_idle2"};
		  case 2 : {_anim="HubSittingChairA_idle3"};
		};
	};
	
	
	call compile "_clientcode={(_this select 0) switchMove (_this select 1);(_this select 0) disableCollisionWith (_this select 2);};";
	if (vtsarmaversion<3) then {_clientcode={(_this select 0) switchMove (_this select 1);};};
	[_clientcode,[player,_anim,_chair]] call vts_broadcastcommand;
	
	
	player setDir (direction _chair)+180;
	//need a fu***ing sleep else when no weapon the position offest is not correct at the frame....
	sleep 0.1;
	
	player setposasl [(_chair modeltoworld [0,-0.15,0]) select 0, (_chair modeltoworld [0,-0.15,0]) select 1, getposasl _chair select 2];
	
	_action=[player,"Stand up", 
	{
	vts_sitanimloop=false;player removeAction (_this select 2);
	_clientcode={(_this select 0) switchMove "";};
	[_clientcode,[player]] call vts_broadcastcommand;
	}, [], 1,true,true, "", "_this == player"] call vts_AddAction;
	
	vts_sitanimloop=true;
	_sitanimloop={
	_chair=(_this select 1);
	_time=0;
	_lastvalidorientation=((direction _chair)+180);
	while {vts_sitanimloop} do
	{
		_time=_time+1;
		sleep 0.1;
		if !([player,((direction _chair)+180),20] call vts_checklimitedorientation) then 
		{
			player setDir _lastvalidorientation;
			player setposasl [(_chair modeltoworld [0,-0.15,0]) select 0, (_chair modeltoworld [0,-0.15,0]) select 1, getposasl _chair select 2];
		};
		
		_lastvalidorientation=(direction player);
		
		if (_time mod 300==0) then 
		{
			player setposasl [(_chair modeltoworld [0,-0.15,0]) select 0, (_chair modeltoworld [0,-0.15,0]) select 1, getposasl _chair select 2];
			player setDir (direction _chair)+180;		
			[(_this select 0),[player,(_this select 3),(_this select 1)]] call vts_broadcastcommand;
		};
		if ((player distance _chair)>1.0)  then 
		{
			vts_sitanimloop=false;
			_clientcode={(_this select 0) switchMove "";};
			[_clientcode,[player]] call vts_broadcastcommand;
			player removeaction (_this select 2);
		};
	};
	};
	[_clientcode,_chair,_action,_anim] spawn _sitanimloop;
	
	
	
};

vts_showtext_display=
{
	private ["_txt","_code"];
	_txt=[(ctrlText 10931),"""",""""""] call KRON_Replace;
	_code={};
	switch (vts_showtexttype) do
	{
		case "Typed":
		{
			_code="";
			call compile format["
			_code={if (hasinterface) then {[[""%1"",""""]] spawn bis_fnc_typetext;};};
			",_txt,"<t align = 'left' shadow = '1'>%1</t>"];
		};
		case "Title Center":
		{
			call compile format["
			_code={if (hasinterface) then {[""%1""] spawn bis_fnc_dynamictext;};};
			",_txt];
		};
		case "Text Bottom Left":
		{
			call compile format["
			_code={if (hasinterface) then {[""%1""] spawn bis_fnc_titletext;};};
			",_txt];
		};
		case "Pop-up":
		{
			call compile format["
			_code={if (hasinterface) then {[""%1"",""Notification""] spawn bis_fnc_guimessage;};};
			",_txt];
		};	
		case "HQ West (West players only)":
		{
			call compile format["
			_code={if (side player==west) then {[West,""HQ""] sidechat ""%1"";};};
			",_txt];
		};	
		case "HQ East (East players only)":
		{
			call compile format["
			_code={if (side player==East) then {[East,""HQ""] sidechat ""%1"";};};
			",_txt];
		};	
		case "HQ Resistance (Resistance players only)":
		{
			call compile format["
			_code={if (side player==resistance) then {[resistance,""HQ""] sidechat ""%1"";};};
			",_txt];
		};
		case "HQ Civilian (Civilian players only)":
		{
			call compile format["
			_code={if (side player==Civilian) then {[Civilian,""HQ""] sidechat ""%1"";};};
			",_txt];
		};		
		case "UAV":
		{
			_uavtxt=_txt;
			_txt="";
			vtsuavclic1=false;
			vtsuav_x=0;
			vtsuav_y=0;
			vtsuav_z=0;
			onMapSingleClick "
			vtsuav_x = _pos select 0;
			vtsuav_y = _pos select 1;
			vtsuav_z = _pos select 2 ;
			vtsuavclic1 = true;
			[] call Dlg_StoreParams;
			onMapSingleClick """";" ;
			for "_j" from 10 to 0 step -1 do 
			{
				format["Click On Map %1, or wait for cancellation",_j] spawn vts_gmmessage;
				sleep 1;
				if (vtsuavclic1) then
				{
					"" spawn vts_gmmessage;
					_j=0;
					vtsuavclic1 = false;
					_txt=_uavtxt;

				};
				vtsuavclic1 = false;
			}; 
				sleep 0.1;
				"" spawn vts_gmmessage;

			
			call compile format["
			_code={if (hasinterface) then {_uav=[[%2,%3],""%1""] spawn bis_fnc_establishingshot;waituntil {scriptdone _uav};enablesaving [false,false];};};
			",_txt,vtsuav_x,vtsuav_y];
		};
		case "Title Center with black screen":
		{
			call compile format["
			cutText [""%1"",""BLACK OUT"",0.01];sleep 5;cutText [""%1"",""BLACK IN"",0.01];
			",_txt];
		};
		case "Title Center with White screen":
		{
			call compile format["
			cutText [""%1"",""WHITE OUT"",0.01];sleep 5;cutText [""%1"",""WHITE IN"",0.01];
			",_txt];
		};		
		
	};
	if ((_txt!="") or (vts_showtexttype=="UAV")) then
	{
		(vts_showtexttype+" text displayed on all clients") spawn vts_gmmessage; 
		[_code] call vts_broadcastcommand;
	};
};

vts_getnearestbuilding=
{
	private ["_housefound"];
	/*
	_objsfound=nearestObjects [(_this select 0),["house"],500];
	//player sidechat str _objsfound;
	_housefound=objnull;
	for "_n" from 0 to (count _objsfound)-1 do
	{
		_curbuilding=_objsfound select _n;
		//player sidechat str _curbuilding;
		if ((_curbuilding) call buildingPosCount>0) then
		{
			if (isnull _housefound) then 
			{
				_housefound=_curbuilding;
				_n=(count _objsfound)-1;
			};
		};
	};
	//player sidechat str _housefound;
	*/
	_housefound=nearestbuilding (_this select 0);
	_housefound;
};

vts_checkvar=
{
	private ["_vartocheck","_vartypetoset"];
	_vartocheck=_this select 0;
	_vartypetoset=_this select 1;
	call compile format["if (isnil ""%1"") then {%1=_vartypetoset;};",_vartocheck];
};


vts_getweaponsuppressor=
{	
	private ["_suppressor","_weaponname","_compatibleitems"];
	_suppressor="";
	_weaponname=_this select 0;
	_compatibleitems=getarray (configFile >> "CfgWeapons" >> _weaponname >> "WeaponSlotsInfo" >> "MuzzleSlot" >> "compatibleItems" );
	//player sidechat str _compatibleitems;
	for "_l" from 0 to (count _compatibleitems)-1 do
	{
		_curitem=_compatibleitems select _l;
		if (count (configFile >> "CfgWeapons" >> _curitem >> "ItemInfo" >> "AmmoCoef" >> "audiblefire") <= 0.7 ) then 
		{
			_suppressor=_curitem;
			_l=(count _compatibleitems)-1;
		};
		
	};
	_suppressor;	
};


vts_getweaponflashlight=
{
	private ["_flashlight","_weaponname","_compatibleitems"];
	_flashlight="";
	_weaponname=_this select 0;
	_compatibleitems=getarray (configFile >> "CfgWeapons" >> _weaponname >> "WeaponSlotsInfo" >> "PointerSlot" >> "compatibleItems" );
	//player sidechat str _compatibleitems;
	for "_l" from 0 to (count _compatibleitems)-1 do
	{
		_curitem=_compatibleitems select _l;
		if (count (configFile >> "CfgWeapons" >> _curitem >> "ItemInfo" >> "FlashLight" ) > 0 ) then 
		{
			_flashlight=_curitem;
			_l=(count _compatibleitems)-1;
		};
		
	};
	_flashlight;	
};

vts_getweaponlaser=
{
	private ["_laser","_weaponname","_compatibleitems"];
	_laser="";
	_weaponname=_this select 0;
	_compatibleitems=getarray (configFile >> "CfgWeapons" >> _weaponname >> "WeaponSlotsInfo" >> "PointerSlot" >> "compatibleItems" );
	//player sidechat str _compatibleitems;
	for "_l" from 0 to (count _compatibleitems)-1 do
	{
		_curitem=_compatibleitems select _l;
		if (count (configFile >> "CfgWeapons" >> _curitem >> "ItemInfo" >> "Pointer" ) > 0 ) then 
		{
			_laser=_curitem;
			_l=(count _compatibleitems)-1;
		};
		
	};
	_laser;
};

vts_property_light=
{
	private ["_lightmode"];
	_lightmode=_this select 0;
	if ((count vts_object_property)>0) then
	{
		vts_object_modified=[vts_object_property];
		_code={};
		call compile format["_code=
		{
			{
				if (local _x) then
				{
					if (_x == vehicle _x) then 
					{
						_x removePrimaryWeaponItem ((primaryWeaponItems _x)  select 1);
						if (""%1""==""forceon"") then
						{
							_lightitem=[(primaryweapon _x)] call vts_getweaponflashlight;
							_x addPrimaryWeaponItem _lightitem;
						};

						_x enableGunLights ""%1"";
					} 
					else 
					{
						_vehicle =  vehicle _x;
						if (_x == driver _vehicle) then {
							if (""%1"" == ""forceon"") then {
								_x action [""LightOn"", _vehicle];
							} else {
								_x action [""LightOff"", _vehicle];
							};
						};
					};
				};
			} foreach (_this select 0);
		};", _lightmode];
		[_code,vts_object_modified] call vts_broadcastcommand;

		(str (vts_object_property)+" light " + _lightmode) call vts_gmmessage;
		_refreshpane={sleep 0.25;[true] call vts_property_showpanel;};
		[] spawn _refreshpane;
	};
};

vts_property_gunlaser=
{
	private ["_lasermode"];
	_lasermode=_this select 0;
	if ((count vts_object_property)>0) then
	{
		vts_object_modified=[vts_object_property];
		_code={};
		call compile format["
		_code=
		{
			{
				if (local _x) then
				{
					_x removePrimaryWeaponItem ((primaryWeaponItems _x)  select 1);
					if (%1) then
					{
						_laseritem=[(primaryweapon _x)] call vts_getweaponlaser;
						_x addPrimaryWeaponItem _laseritem;
					};
				
					_x enableIRLasers %1;
				};
			} foreach (_this select 0);
		};", _lasermode];
		
		[_code,vts_object_modified] call vts_broadcastcommand;

		(str (vts_object_property)+" laser " + format["%1",_lasermode]) call vts_gmmessage;
		_refreshpane={sleep 0.25;[true] call vts_property_showpanel;};
		[] spawn _refreshpane;
	};
};

vts_property_suppressor=
{
	private ["_suppressormode"];
	_suppressormode=_this select 0;
	
	if ((count vts_object_property)>0) then
	{
		vts_object_modified=[vts_object_property];
		_code={};
		call compile format["
		_code=
		{
			{
				if (local _x) then
				{
					_x removePrimaryWeaponItem ((primaryWeaponItems _x)  select 0);
					if (""%1""==""on"") then
					{
						_silenceritem=[(primaryweapon _x)] call vts_getweaponsuppressor;
						_x addPrimaryWeaponItem _silenceritem;
					};
				};
			} foreach (_this select 0);
		};", _suppressormode];
		
		[_code,vts_object_modified] call vts_broadcastcommand;

		(str (vts_object_property)+" suppressor " + _suppressormode) call vts_gmmessage;
		_refreshpane={sleep 0.25;[true] call vts_property_showpanel;};
		[] spawn _refreshpane;
	};
};


vts_property_revive=
{
	if (count _this>0) then {vts_object_property=[_this select 0];};
	if ((count vts_object_property)>0) then
	{
		vts_object_modified=[vts_object_property];
		_code=
		{
			{
				if ((local _x) && (isplayer _x)) then
				{
					_x setUnconscious false;
					_x setdamage 0;
					_x setCaptive false;
					if !(isnil "vts_unitcurrentlifecount") then {if (vts_unitcurrentlifecount>0) then {vts_unitcurrentlifecount=vts_unitcurrentlifecount+1;};};
					if !(isnil "vts_respawn_variable_state") then {_x setvariable[vts_respawn_variable_state,false,true];};
					if !(isnil "vts_respawn_variable_dead") then {_x setvariable[vts_respawn_variable_dead,false,true];};
					_x playactionnow "agonyStop";
					if (player==_x) then {_txt="You have been revived by a GM";hint _txt;titleText  [_txt,"WHITE IN",5];};
					//Enable ACRE if was disabled
					if !(isnil "acre_api_fnc_setSpectator") then
					{
						[false] spawn acre_api_fnc_setSpectator;
					};
	
				};
				[_x] spawn 
				{
					sleep 3;
					(_this select 0) switchmove "";	
				};

			} foreach (_this select 0);
		};
		[_code,vts_object_modified] call vts_broadcastcommand;

		(str (vts_object_property)+" been revived and treated") call vts_gmmessage;
		_refreshpane={sleep 0.25;[true] call vts_property_showpanel;};
		[] spawn _refreshpane;
	};
};

vts_property_removeweapons=
{
	if ((count vts_object_property)>0) then
	{
		vts_object_modified=[vts_object_property];
		_code=
		{
			{
				if (local _x) then
				{
					removeallweapons _x;
				};
			} foreach (_this select 0);
		};
		[_code,vts_object_modified] call vts_broadcastcommand;

		(str (vts_object_property)+" been striped from weapons & magazines") call vts_gmmessage;
		_refreshpane={sleep 0.25;[true] call vts_property_showpanel;};
		[] spawn _refreshpane;
	};
};

vts_property_init=
{
	if ((count vts_object_property)>0) then
	{
		_inittoadd=vts_property_initselected;
		if (_inittoadd=="init") exitwith {("Please select a valid init") call vts_gmmessage;};
		vts_object_modified=[vts_object_property,_inittoadd];
		publicVariable "vts_object_modified";
		_code=
		{
			{
				if ((isserver) && !(isplayer _x)) then
				{
					[_x,(vts_object_modified select 1)] call vts_setobjectinit;
				};
			} foreach (vts_object_modified select 0);
			if (isserver) then {[] call vts_processobjectsinit;};
		};
		[_code] call vts_broadcastcommand;

		(str (vts_object_property)+" init has been modified with + """+_inittoadd+"""") call vts_gmmessage;
		_refreshpane={sleep 0.25;[true] call vts_property_showpanel;};
		[] spawn _refreshpane;
	};
};

vts_property_nvgoggle=
{
	private ["_nvmode"];
	_nvmode=_this select 0;
	
	if ((count vts_object_property)>0) then
	{
		vts_object_modified=[vts_object_property];
		_code={};
		call compile format["
		_code=
		{
			{
				if (local _x) then
				{
					if (""%1""==""on"") then
					{
						_x addweapon ""nvgoggles"";
					}
					else
					{
						if (vtsarmaversion<3) then
						{
							_x removeweapon ""nvgoggles"";
						}
						else
						{
							""
							_nv=[assignedItems _x,vts_NVGogglesList,""""""""] call vts_findmatchinarray;
							if (_nv!="""""""") then
							{
								_x unassignitem _nv;
								_x removeitem _nv;
							};
							"" call vts_C;
						};
					};
				};
			} foreach (_this select 0);
		};
		",_nvmode];
		[_code,vts_object_modified] call vts_broadcastcommand;

		(str (vts_object_property)+" night vision goggles: "+ _nvmode) call vts_gmmessage;
		_refreshpane={sleep 0.25;[true] call vts_property_showpanel;};
		[] spawn _refreshpane;
	};
};

vts_property_setfuel=
{
	if ((count vts_object_property)>0) then
	{
		_fuel=parsenumber ctrlText 10657;
		if (_fuel>1) then {_fuel=1.0;};
		if (_fuel<0) then {_fuel=0.0;};
		vts_object_modified=[vts_object_property,_fuel];
		_code=
		{	
			{
				if (local _x) then
				{
					vehicle _x setfuel (_this select 1);
				};
			} foreach (_this select 0);
		};
		[_code,vts_object_modified] call vts_broadcastcommand;

		(str (vts_object_property)+" fuel quantity changed to : "+str (vts_object_modified select 1)) call vts_gmmessage;
		_refreshpane={sleep 0.25;[true] call vts_property_showpanel;};
		[] spawn _refreshpane;
	};
};
vts_property_setdamage=
{
	if ((count vts_object_property)>0) then
	{
		/*
		_code=
		{
			
		};
		[_code] call vts_broadcastcommand;
		*/
		_damage=parsenumber ctrlText 10653; 
		{
			vehicle _x setdamage _damage;
		} foreach vts_object_property;
		(str (vts_object_property)+" damage changed to : "+str _damage) call vts_gmmessage;
		_refreshpane={sleep 0.25;[true] call vts_property_showpanel;};
		[] spawn _refreshpane;
	};
};

vts_property_setammo=
{
	if ((count vts_object_property)>0) then
	{
		_ammo=parsenumber ctrlText 10655;
		if (_ammo>1) then {_ammo=1.0;};
		if (_ammo<0) then {_ammo=0.0;};
		vts_object_modified=[vts_object_property,_ammo];
		_code=
		{
			{
				if (local _x) then
				{
					_ammo=(_this select 1);
					//if (_ammo>(vehicle _x getvariable ["vts_vehicleammo",1])) then {_ammo=(vehicle _x getvariable ["vts_vehicleammo",1]);};
					[ _x,_ammo] call vts_setammo ;
					 _x setvariable ["vts_vehicleammo",_ammo,true];
				};
			} foreach (_this select 0);
		};
		[_code,vts_object_modified] call vts_broadcastcommand;

		(str (vts_object_property)+" ammunition quantity changed to : "+str (vts_object_modified select 1)) call vts_gmmessage;
		_refreshpane={sleep 0.25;[true] call vts_property_showpanel;};
		[] spawn _refreshpane;
	};
};

vts_property_surrender=
{
	if ((count vts_object_property)>0) then
	{
		vts_object_modified=[vts_object_property];
		_code=
		{
			{
				if (local _x) then
				{
				  if !(isplayer _x) then 
				  {
					_surrender=
					{
						_unit=_this select 0;
						 moveout _unit;
						 _unit setcaptive true;
						 _pos=getposatl _unit;
						 _ground=createVehicle [vts_weaponholder, _pos, [], 0, "NONE"];
						 _ground setposatl _pos;
						 _weaps=weapons _unit;
						 for "_i" from 0 to (count _weaps)-1 do
						 {
							_item=_weaps select _i;
							_ground addweaponcargoglobal [_item,1];
						 };
						 _mags=magazines _unit;
						 for "_i" from 0 to (count _mags)-1 do
						 {
							_item=_mags select _i;
							_ground addmagazinecargoglobal [_item,1];
						 };	
						removeallweapons _unit;
						_unit setvehicleammo 0;
						_unit action ["surrender",_unit];
						_unit disableAI "MOVE";
						_unit disableAI "ANIM";
						_unit disableAI "TARGET";
						_unit disableAI "AUTOTARGET";
					};
					if (_x iskindof "Man") then 
					{
						[_x] call _surrender;
					}
					else
					{
						{[_x] call _surrender;} foreach crew _x;
					};
				  };
				};
			} foreach (_this select 0);
		};
		[_code,vts_object_modified] call vts_broadcastcommand;

		(str (vts_object_property)+" surrendered") call vts_gmmessage;
		_refreshpane={sleep 0.25;[true] call vts_property_showpanel;};
		[] spawn _refreshpane;
	};
};


vts_property_fleeing=
{
	if ((count vts_object_property)>0) then
	{
		_flee=parsenumber ctrlText 10671;
		if (_flee>1) then {_flee=1.0;};
		if (_flee<0) then {_flee=0.0;};
		vts_object_modified=[vts_object_property,_flee];
		_code=
		{
			{
				if (local _x) then
				{
				  _x allowFleeing (_this select 1);
				  _x setvariable ["vts_fleeingset",(_this select 1),true];
				};
			} foreach (_this select 0);
		};
		[_code,vts_object_modified] call vts_broadcastcommand;

		(str (vts_object_property)+" cowardice changed to : "+str (vts_object_modified select 1)) call vts_gmmessage;
		_refreshpane={sleep 0.25;[true] call vts_property_showpanel;};
		[] spawn _refreshpane;
	};
};

vts_property_skill=
{
	if ((count vts_object_property)>0) then
	{
		_skill=parsenumber ctrlText 10669;
		if (_skill>1) then {_skill=1.0;};
		if (_skill<0) then {_skill=0.0;};
		vts_object_modified=[vts_object_property,_skill];
		_code=
		{
			{
				if (local _x) then
				{
				 [_x,(_this select 1)] call vts_setskill;
				 {
					[_x,(_this select 1)] call vts_setskill;
				 } forEach crew _x;
				};
			} foreach (_this select 0);
		};
		[_code,vts_object_modified] call vts_broadcastcommand;

		(str (vts_object_property)+" skill changed to : "+str (vts_object_modified select 1)) call vts_gmmessage;
		_refreshpane={sleep 0.25;[true] call vts_property_showpanel;};
		[] spawn _refreshpane;
	};
};

vts_property_setfheight=
{
	if ((count vts_object_property)>0) then
	{
		vts_object_modified=[vts_object_property,parsenumber ctrlText 10659];
		_code=
		{
			{
				if (local _x) then
				{
					vehicle _x flyinheight (_this select 1);
					vehicle _x setvariable ["vts_flyinheight",(_this select 1),true];
				};
			} foreach (_this select 0);
		};
		[_code,vts_object_modified] call vts_broadcastcommand;

		(str (vts_object_property)+" flight altitude changed to : "+str (vts_object_modified select 1)) call vts_gmmessage;
		_refreshpane={sleep 0.25;[true] call vts_property_showpanel;};
		[] spawn _refreshpane;
	};
};

vts_property_changestance=
{
	private ["_stance"];
	_stance=_this select 0;
	if ((count vts_object_property)>0) then
	{
		vts_object_modified=[vts_object_property];
		_code={};
		call compile format["
		_code=
		{
			{
				if (local _x) then
				{
					_x setUnitPos ""%1"";
				};
			} foreach (_this select 0);
		};
		",_stance];
		[_code,vts_object_modified] call vts_broadcastcommand;

		(str (vts_object_property)+" stance forced to : "+_stance) call vts_gmmessage;
		_refreshpane={sleep 0.25;[true] call vts_property_showpanel;};
		[] spawn _refreshpane;
	};
};

vts_property_unitorgroup=
{
	if (isnil "vts_property_group") then
	{
		vts_property_group=vts_property_group_selected ;
		if ((count units vts_property_group)>0) then
		{
			vts_object_property=units vts_property_group_selected;
			"Properties are now applied on the selected unit and its group" call vts_gmmessage;
		};
		
	}
	else
	{
		vts_property_group=nil;
		vts_object_property=[vts_object_property_selected];
		"Properties are now applied only on the selected unit" call vts_gmmessage;
	};
	_refreshpane={sleep 0.25;[true] call vts_property_showpanel;};
	[] spawn _refreshpane;
};

vts_property_setlocked=
{
	if ((count vts_object_property)>0) then
	{
		_locked=true;
		_currentlock=locked vehicle (vts_object_property select 0);
		if (typename _currentlock=="SCALAR") then 
		{
			if (_currentlock<0 or _currentlock>1) then
			{
				_currentlock=true;
			}
			else
			{
				_currentlock=false;
			};
		};
		if (_currentlock) then {_locked=false;};
		
		vts_object_modified=[vts_object_property,_locked];
		_code=
		{
			{
				if (local _x) then
				{
						vehicle _x lock (_this select 1);	
				};
			} foreach (_this select 0);
		};
		[_code,vts_object_modified] call vts_broadcastcommand;

		(str (vts_object_property)+" locked status set to : "+str (vts_object_modified select 1)) call vts_gmmessage;
		_refreshpane={sleep 0.25;[true] call vts_property_showpanel;};
		[] spawn _refreshpane;
	};
};


vts_property_showpanel=
{
	private ["_silent","_object","_txtinfo","_curammo","_currentlock"];
	if (({alive _x} count vts_object_property)<1) exitwith {[true] spawn vts_property_close;};
	
	_silent=false;
	if (count _this>0) then {_silent=_this select 0;};
	
	if !(_silent) then {"Properties panel opened" spawn vts_gmmessage;};	
	
	_object=vts_object_property select 0;	
	vts_selected = _object;
	_txtinfo="\n\n";
	if (isplayer _object) then
	{
		_txtinfo=_txtinfo+"\n------ Player ------";
	}
	else
	{
		_txtinfo=_txtinfo+"\n------ AI unit ------";
	};
	if (isnil "vts_property_group") then
	{
		if (name _object!="Error: No unit") then
		{
		_txtinfo=_txtinfo+"\nName :\n"+name _object;
		}
		else
		{
		_txtinfo=_txtinfo+"\nName :\n"+gettext (configfile >> "CfgVehicles" >> (typeof _object) >> "Displayname");
		};
	}
	else
	{
				_txtinfo=_txtinfo+("\nGroup Name : \n"+str(group _object));
	};
	_txtinfo=_txtinfo+"\nClass type :\n"+typeof _object;
	_txtinfo=_txtinfo+"\nVarName : "+vehiclevarname _object;
	if !(isnil "vts_property_group") then 
	{
		_txtinfo=_txtinfo+("\nGroup size : "+str(count units group _object));
	};
	
	ctrlsettext [10650,_txtinfo];
	
	ctrlShow [10623,false];



	ctrlEnable [10650,false];

	ctrlsettext [10653,str([damage vehicle _object,2] call vts_numberprecision)];

	_curammo=(_object getvariable ["vts_vehicleammo",1]);
	if !(someammo _object) then {_curammo=0.0;};
	ctrlsettext [10655,str ([(_curammo),2] call vts_numberprecision)];
	
	ctrlsettext [10657,str([(fuel vehicle _object),2] call vts_numberprecision)];
	
	ctrlsettext [10659,str ([(_object getvariable ["vts_flyinheight",(getpos _object select 2)]),2] call vts_numberprecision)];
	
	_currentlock=locked vehicle _object;
	if (typename _currentlock=="SCALAR") then 
	{
		if (_currentlock<0 or _currentlock>1) then
		{
			_currentlock=true;
		}
		else
		{
			_currentlock=false;
		};
	};
	ctrlsettext [10660,"Locked : "+str (_currentlock)];
	
	if (isnil "vts_property_group") then
	{
		ctrlsettext [10661,"Object properties :"];
	}
	else
	{
		ctrlsettext [10661,"Group properties :"];
	};
	
	ctrlsettext [10669,str (_object getvariable ["vts_skillset",0.3])];

	ctrlsettext [10671,str (_object getvariable ["vts_fleeingset",0.0])];
	
	for "_i" from 10649 to 10681 do
	{
		if (((_i==10675) && (pa_revivetype==0))) then
		{}	else {ctrlShow [_i,true];}
		
	};	
};


vts_property_close=
{
	private ["_silent"];
	_silent=false;
	if (count _this>0) then {_silent=_this select 0;};

	if !(_silent) then {"Properties panel closed" spawn vts_gmmessage;};
	
	vts_object_property=[]; 
	ctrlShow [10623,true];
	
	for "_i" from 10649 to 10681 do
	{
		ctrlShow [_i,false];
	};
};

vts_setammo=
{
	private ["_vehicle","_ratio","_type"];
	_vehicle=_this select 0;
	_ratio=_this select 1;
	_type=typeOf _vehicle;

	if (_type iskindof "Man") then
	{
		//As infantry weapon can change, so we can't use class setting
		//Pooling what magazine are compatible to him
		_weaps=weapons _vehicle;
		_compmags=[];
		{
			_mag=getarray (configfile >> "CfgWeapons" >> _x >> "magazines");
			if (count _mag>0) then 
			{
				_compmags=_compmags+_mag;
			};
		} forEach _weaps;
		//player sidechat str _compmags;
		
		_variousmags=[];
		_mags=magazines _vehicle;
		{
			if ((_x in _compmags) or (_ratio==0)) then 
			{
				_vehicle removemagazine _x;
			} 
			else 
			{
				_variousmags set [count _variousmags,_x];
				_vehicle removemagazine _x;
			};
		} foreach _mags;
		
		{
			_mag=getarray (configfile >> "CfgWeapons" >> _x >> "magazines");
			if (count _mag>0) then
			{
				_magtype=getnumber (configfile >> "CfgMagazines" >> (_mag select 0) >> "type");
				_ammocount=8;
				if (_magtype!=256) then {_ammocount=3;};
				for "_c" from 1 to _ammocount do
				{
					_vehicle addmagazine (_mag select 0); 
				};

			};
		} foreach _weaps;	
		
		_vehicle setvehicleammo _ratio;
		
		{
			_vehicle addmagazine _x; 
		} forEach _variousmags;
	}
	else
	{
		//No weapon change possible on vehicle, so the class setting is ok (and we are using turrets which complicate it much)
		_vehicle setvehicleammo 0;
		
		_magazines=getArray(configFile >> "CfgVehicles" >> _type >> "magazines");

		if ((count _magazines)>0) then 
		{
			_removed = [];
			{
				if !(_x in _removed) then 
				{
					_vehicle removeMagazines _x;
					_vehicle removeMagazinesturret [_x,[-1]];
					//player sidechat str _x;
					_removed=_removed + [_x];
				};
			} forEach _magazines;
			{
				_vehicle addMagazine _x;
				_vehicle addMagazineturret [_x,[-1]];
				//player sidechat str _x;
			} forEach _magazines;
		};

		_count=count (configFile >> "CfgVehicles" >> _type >> "Turrets");

		if (_count>0) then 
		{
			for "_i" from 0 to (_count-1) do 
			{

				_config=(configFile >> "CfgVehicles" >> _type >> "Turrets") select _i;
				_magazines=getArray(_config >> "magazines");
				_removed=[];
				{
					if !(_x in _removed) then 
					{
						_vehicle removeMagazinesturret [_x,[_i]];	
						//player sidechat str _x;					
						_removed=_removed+[_x];
					};
				} forEach _magazines;
				{
					_vehicle addMagazineturret [_x,[_i]];
					//player sidechat str _x;
				} forEach _magazines;
				_sub_count=count (_config >> "Turrets");
				if (_sub_count> 0) then 
				{
					for "_o" from 0 to (_sub_count-1) do 
					{
						_configsub=(_config >> "Turrets") select _o;
						_magazinessub=getArray(_configsub >> "magazines");
						_removedsub=[];
						{
							if !(_x in _removedsub) then 
							{
								_vehicle removeMagazinesturret [_x,[_i,_o]];
								//player sidechat str _x;
								_removedsub=_removedsub+[_x];
							};
						} forEach _magazinessub;
						{
							_vehicle addMagazineturret [_x,[_i,_o]];
							//player sidechat str _x;
						} forEach _magazinessub;
					};
				};
			};
		};
		_vehicle setVehicleAmmo _ratio;
	};
	
};

vts_copytasks=
{
	private ["_source","_target","_tasks","_targettask"];
	_source=_this select 0;
	_target=_this select 1;
	
	_tasks=simpletasks _source;
	_targettask=simpletasks _target;
	
	//delete target tasks
	for "_t" from 0 to (count _targettask)-1 do
	{
		_curtask=_targettask select _t;
		_target removeSimpleTask _curtask;
	};
	//copy task to avoid issue
	for "_t" from 0 to (count _tasks)-1 do
	{
		_curtask=_tasks select _t;
		_task = _target createSimpleTask[""];
		_task setSimpleTaskDestination ( taskDestination _curtask); 
		_task setSimpleTaskDescription taskDescription _curtask;
		_task setTaskState taskState _curtask;
		_obj = nearestObject [(taskDestination _curtask),vts_smallworkdummy];
		if !(isnull _obj) then {_obj setVariable ["task",_task];};
	};
};
//Landing & unload waypoint function
vts_wpland=
{
	private ["_unit","_code","_sync"];
	_unit=_this select 0;
	landingunit=_unit;
	_code=
	{
		{
			if (local leader _this) then 
			{
				_land="LAND";
				if ((vehicle _x iskindof "Helicopter") && (surfaceiswater getposatl vehicle _x)) then
				{
					_land="GET OUT";
				};
				vehicle _x land _land;
				dostop vehicle _x;
			};
		} foreach units _this;
	};
	_sync=[_code,landingunit] call vts_broadcastcommand;
};
vts_wplandunload=
{
	private ["_unit","_code","_sync"];
	_unit=_this select 0;
	unloadingunit=_unit;
	_code=
	{
		_vehiclescrew=[];
		_vehicles=[];
		_paradone=[];
		{
			if ((vehicle _x!=_x) && !((vehicle _x) in _vehicles)) then
			{
				_vehicles set [count _vehicles,vehicle _x];
				_vehiclescrew=_vehiclescrew+(crew vehicle _x);
			};
		} foreach units _this;
		{
			if (((vehicle _x) iskindof "Air") && ((getpos (vehicle _x) select 2)>125)) then
			{
				
				{
					if ((local _x) && !(isplayer _x) && !(isplayer leader _x)) then 
					{
						if ((group leader _x)!=(group leader _this)) then 
						{

							if !( _x in _paradone) then
							{
								
								_paradone set [count _paradone,_x];
								unassignVehicle _x;
								moveout _x;
								sleep 1.0;
								[_x] spawn vts_freefall;
								{deletewaypoint _x;} foreach (waypoints group leader _x);
								_wp=(group leader _x) addwaypoint [(getpos leader _x),0];
								_wp setWaypointType "MOVE";
							};

						};
					};
				
				} foreach _vehiclescrew;
			}
			else
			{
				if (local leader _this) then 
				{
					_land="LAND";
					if ((vehicle _x iskindof "Helicopter") && (surfaceiswater getposatl vehicle _x)) then
					{
						_land="GET OUT";
					};
					vehicle _x land _land;
					dostop vehicle _x;
				};
				{
					if (local _x) then 
					{
						if ((group leader _x)!=(group leader _this)) then 
						{
							unassignVehicle _x;
							{deletewaypoint _x;} foreach (waypoints group leader _x);
							_wp=(group leader _x) addwaypoint [(getpos leader _x),0];_wp setWaypointType "MOVE";};
					};
				} foreach _vehiclescrew;
			};
		} foreach units _this;
	};
	_sync=[_code,unloadingunit] call vts_broadcastcommand;
};

//Just for fun;
vts_nitro=
{
	
	private ["_vehicle","_force","_step","_time"];
	_vehicle=vehicle player;
	_force=0.5;
	_step=0.1;
	_time=3;
	if !(isnil "vts_nitroon") exitwith {vts_nitrotime=vts_nitrotime+(_time/_step);};
	vts_nitrotime=(_time/_step);
	vts_nitroon=true;
	while {(vts_nitrotime>0) && (driver _vehicle==player) } do
	{
		_vel=velocity _vehicle;
		_dir=direction _vehicle;
		_speed=_force;
		if ((getposatl _vehicle select 2)<0.5) then
		{			
			_vehicle setvelocity [(_vel select 0)+(sin _dir*_speed),(_vel select 1)+ (cos _dir*_speed),(_vel select 2)];
		};
		hint "Engine: Injecting N2O";
		sleep _step;
		vts_nitrotime=vts_nitrotime-1;
	};
	hint "Engine: Cooling down";
	vts_nitroon=nil;
	
};
/*
[player] call vts_enablevehiclenitro
*/
vts_enablevehiclenitro=
{
	private ["_unit"];
	_unit=_this select 0;
	if (_unit!=player) exitwith {};
	//if (_unit getvariable ["vts_nitro",false]) exitwith {};
	
	_unit setvariable ["vts_nitro",true];
	[_unit,"Nitro (Fast forward key x1)",{[player] call vts_nitro;},"",10000,false,false,"CarFastForward","(vehicle player!=player) && (driver vehicle player==player) && (vehicle player iskindof ""Car"")"] call vts_AddAction;
};

vts_freefall=
{
	private ["_unit","_vehicleparachute","_paraveh"];
	_unit=_this select 0;
	
	_vehicleparachute=vts_vehicleparachute;
	_paraveh=vts_parachute;
	
	//wait before treating unit, if they are spawned simulation could be disabled
	waituntil {sleep 0.1;simulationEnabled _unit};
	
	if (vtsarmaversion<3) then
	{
		_unit setvariable ["bis_fnc_halo_now",true];  
		_chute = _unit execVM "functions\fn_halo_new.sqf";
	};
	if (vtsarmaversion==3) then
	{
		
		if !(_unit iskindof "Man") then {_paraveh=_vehicleparachute;};
		
		if (isclass (configfile >> "cfgvehicles" >> _paraveh)) then
		{
				
			//_unit addbackpack _para;
			if (!(isplayer _unit) or !(_unit iskindof "Man")) then
			{
				_openchute=
				{
					_unit=_this select 0;
					_paraveh=_this select 1;
					_alt=true;
					_openheight=375;
					_openrandom=50;
					
					
					while {_alt} do
					{
						
						_pos=getposatl _unit;
						if (surfaceiswater _pos) then {_pos=getposasl _unit};
						sleep 0.25;
						if (((_pos select 2)<(_openheight+random(_openrandom))) or (isnull _unit) or !(alive _unit)) then {_alt=false;};
					};
					if !(isnull _unit) then
					{				
						if (alive _unit) then 
						{
							//_unit action ["openparachute",_unit];
							_parv=_paraveh createvehicle [random(100),random(100),1000];
							//player sidechat str _parv;
							_pos=getposatl _unit;
							if (surfaceiswater _pos) then {_pos=getposasl _unit};							
							_parv setpos _pos;
							if (_unit iskindof "Man") then
							{
								_unit assignasdriver _parv;
								_unit moveindriver _parv;
							}
							else
							{
								_unit attachto [_parv,[0,0,0]];
								[_parv,_unit] spawn 
								{
									_vehheight=(((boundingBox (_this select 1)) select 1) select 2)-(((boundingBox (_this select 1)) select 0) select 2);
									//player sidechat str _vehheight;
									waituntil {
									sleep 0.1;
									!(alive (_this select 0)) or (((getpos (_this select 1)) select 2)<3);
									};
									detach (_this select 1);
									sleep 5;
									if (alive (_this select 0)) then {deleteVehicle (_this select 0);};
								};
							};
						};
					};
				};
				[_unit,_paraveh] spawn _openchute;
			};
		};
	};
};

vts_uieditormod=
{
	private ["_display","_key","_shift","_ctrl","_alt"];
	disableSerialization;
	_display=_this select 0;
	_key=_this select 1;
	_shift=_this select 2;
	_ctrl=_this select 3;
	_alt=_this select 4;
	
	
	if !(isnil "vts_uieditorctrl") then
	{

		_mod=1;
		if (_shift) then {_mod=3};
		_posupdate=0.005*_mod;
		_ctrlpos=ctrlPosition vts_uieditorctrl;
		_add=false;
		//player sidechat str _ctrlpos;
		if (_key==200) then
		{
			//up
			if (_alt) then
			{
				vts_uieditorctrl ctrlSetPosition [(_ctrlpos select 0),(_ctrlpos select 1)-_posupdate,(_ctrlpos select 2),(_ctrlpos select 3)+_posupdate];
			}
			else
			{
				if (_ctrl) then
				{
					vts_uieditorctrl ctrlSetPosition [(_ctrlpos select 0),(_ctrlpos select 1),(_ctrlpos select 2),(_ctrlpos select 3)-_posupdate];
				}
				else
				{
					vts_uieditorctrl ctrlSetPosition [(_ctrlpos select 0),(_ctrlpos select 1)-_posupdate,(_ctrlpos select 2),(_ctrlpos select 3)];
				};
			};
			_add=true;
		};
		if (_key==208) then
		{
			//down
			if (_alt) then
			{
				vts_uieditorctrl ctrlSetPosition [(_ctrlpos select 0),(_ctrlpos select 1),(_ctrlpos select 2),(_ctrlpos select 3)+_posupdate];
			}
			else
			{
				if (_ctrl) then
				{
					vts_uieditorctrl ctrlSetPosition [(_ctrlpos select 0),(_ctrlpos select 1)+_posupdate,(_ctrlpos select 2),(_ctrlpos select 3)-_posupdate];
				}
				else
				{
					vts_uieditorctrl ctrlSetPosition [(_ctrlpos select 0),(_ctrlpos select 1)+_posupdate,(_ctrlpos select 2),(_ctrlpos select 3)];
				};
			};
			_add=true;
			
		};
		if (_key==203) then
		{
			//left
			if (_alt) then
			{
				vts_uieditorctrl ctrlSetPosition [(_ctrlpos select 0)-_posupdate,(_ctrlpos select 1),(_ctrlpos select 2)+_posupdate,(_ctrlpos select 3)];
			}
			else
			{	
				if (_ctrl) then
				{
					vts_uieditorctrl ctrlSetPosition [(_ctrlpos select 0),(_ctrlpos select 1),(_ctrlpos select 2)-_posupdate,(_ctrlpos select 3)];
				}
				else
				{
					vts_uieditorctrl ctrlSetPosition [(_ctrlpos select 0)-_posupdate,(_ctrlpos select 1),(_ctrlpos select 2),(_ctrlpos select 3)];
				};
			};
			_add=true;
		};
		if (_key==205) then
		{
			//right
			if (_alt) then
			{
				vts_uieditorctrl ctrlSetPosition [(_ctrlpos select 0),(_ctrlpos select 1),(_ctrlpos select 2)+_posupdate,(_ctrlpos select 3)];
			}
			else
			{
				if (_ctrl) then
				{
					vts_uieditorctrl ctrlSetPosition [(_ctrlpos select 0)+_posupdate,(_ctrlpos select 1),(_ctrlpos select 2)-_posupdate,(_ctrlpos select 3)];
				}
				else
				{
					vts_uieditorctrl ctrlSetPosition [(_ctrlpos select 0)+_posupdate,(_ctrlpos select 1),(_ctrlpos select 2),(_ctrlpos select 3)];
				};
			};
			_add=true;
		};
		if (_key==31 && _ctrl) then
		{
			//Enter
			hint "Modification copied to clipboard";
			_saving="";
			for "_i" from 0 to (count vts_uieditorctrlmodified)-1 do
			{
				_ctrl=vts_uieditorctrlmodified select _i;
				_data="idc = "+([str _ctrl,"Control #",""] call KRON_Replace)+";
				x = "+str(ctrlPosition _ctrl select 0)+";
				y = "+str(ctrlPosition _ctrl select 1)+";
				w = "+str(ctrlPosition _ctrl select 2)+";
				h = "+str(ctrlPosition _ctrl select 3)+";
				
				";
				_saving=_saving+_data;
			};
			copytoclipboard _saving;
		};
		if (_add) then
		{
			if !(vts_uieditorctrl in vts_uieditorctrlmodified) then {vts_uieditorctrlmodified set [count vts_uieditorctrlmodified,vts_uieditorctrl];};
		};
		vts_uieditorctrl ctrlCommit 0;
		
	};
};

vts_uieditor=
{
	private ["_dialog","_display","_cfgui","_d"];
	disableSerialization;
	vts_uieditorctrlmodified=[];
	//_dialog=_this select 0;
	//_cfgdisplayid=getnumber (missionconfigfile >> _dialog >> "IDD");
	//_display=(finddisplay _cfgdisplayid);
	_d=8000;
	_dialog="VTS_RscComputer";
	
	if ((count _this) >0) then 
	{
		_dialog=_this select 0;
		_d=getnumber (missionconfigfile >> _dialog >> "IDD");
	};
	
	
	
	_display=(finddisplay _d);
	
	hint "Editing On : Mouse over then Arrows (+ Shift for speed),Alt to Incease size, Ctrl to reduce size, Ctrl + S to copy to clipboard pos update";
	
	_cfgui=(missionconfigfile >> _dialog >> "Controls");
	for "_i" from 0 to ((count _cfgui)-1) do
	{
		_idc=getnumber ((_cfgui select _i) >> "idc");
		_ctrl=_display displayctrl _idc;
		_ctrl ctrlEnable true;
		//_ctrl ctrlSetTooltip "Move";
		_ctrl ctrlAddEventHandler ["MouseButtonClick","vts_uieditorctrl=(_this select 0);"]; 
	};
	_display displayAddEventHandler ["KeyDown","_this call vts_uieditormod;"];
	
};

vts_scalecpuui=
{
	if !(isnil "vts_cpuscaling") then
	{
		vts_cpuscaling=nil;
		[] call Dlg_StoreParams;
		closedialog 8000;
		[] execvm "computer\cpu_dialog.sqf";
	} 
	else
	{
		vts_cpuscaling=[0.65,0.05,0.1];
		ctrlsettext [11556,"UI scaling : On"];
		["VTS_RscComputer",vts_cpuscaling] call vts_resizeui;
	};
};

//Update dialog scale
/*
["VTS_RscComputer",1] call vts_resizeui;
*/
vts_resizeui=
{
	private ["_dialog","_ratiox","_ratioy","_offsetx","_offsety","_cfgdisplayid","_cfgui","_idcarray","_idcdouble"];
	disableserialization;
	_dialog=_this select 0;
	_ratiox=((_this select 1) select 0);
	_ratioy=((_this select 1) select 0)*(((SafezoneW)+(safezoneX))/((safezoneH)+(safezoneY)));
	_offsetx=(_this select 1) select 1;
	_offsety=(_this select 1) select 2;
	_cfgdisplayid=getnumber (missionconfigfile >> _dialog >> "IDD");
	_cfgui=(missionconfigfile >> _dialog >> "Controls");
	_idcarray=[];
	_idcdouble=[];
	for "_i" from 0 to ((count _cfgui)-1) do
	{
		_idc=getnumber ((_cfgui select _i) >> "idc");
		if (_idc in _idcarray) then {_idcdouble set [count _idcdouble,_idc];}
		else
		{
			_idcarray set [count _idcarray,_idc];
		};
		_ctrl=(finddisplay _cfgdisplayid) displayctrl _idc;
		_idcpos=ctrlPosition _ctrl;
		_ctrl ctrlsetposition [((_idcpos select 0)+_offsetx)*(SafezoneW * _ratiox)+(safezoneX * _ratiox),((_idcpos select 1)+_offsety)*(safezoneH * _ratioy)+( safezoneY * _ratioy),(_idcpos select 2)*(safezoneW * _ratiox),(_idcpos select 3)*(safezoneH * _ratioy)];
		if (ctrltype _ctrl==0 or ctrltype _ctrl==1 or ctrltype _ctrl==2 or ctrltype _ctrl==4 or ctrltype _ctrl==5) then 
		{
			_size=getnumber ((_cfgui select _i) >> "sizeex");
			if (_size==0) then {_size=getnumber ((_cfgui select _i) >> "size")};
			_ctrl ctrlSetFontHeight (_size / ((getResolution select 5)/_ratioy));
		};
		_ctrl ctrlCommit 0;
	};
	if (count _idcdouble>0) then 
	{
		hintc format["Error in reformating interface duplicated IDC : %1",_idcdouble];
	};
};

vts_perf=
{
	private ["_fnc_dump","_t1"];
	_fnc_dump=
	{
	player globalchat str _this;
	diag_log str _this; 
	};
	_t1 = diag_tickTime; 
	call _this;
	(diag_tickTime - _t1) call _fnc_dump;
};

vts_perfstart=
{
	vts_perflasttick = diag_tickTime;
};

vts_perfstop=
{
	private ["_fnc_dump"];
	_fnc_dump=
	{
	player globalchat str _this;
	//diag_log str _this; 
	};
	(diag_tickTime - vts_perflasttick) call _fnc_dump;
};

vts_addlog=
{
	if (isnil "vts_lastlog") then {vts_lastlog=""};
	if (_this!="vts_lastlog") then
	{
		//Protection against addlog run for the same log on different machine
		vts_lastlog=_this;
		publicvariable "vts_lastlog";
		
		if (isnil "vts_gmlogs") then {vts_gmlogs="  ";};
		vts_gmlogs=vts_gmlogs+_this+"
		";
		publicvariable "vts_gmlogs";
		
	};
};

vts_showlogs=
{
	private ["_ctrl"];
	[] call Dlg_StoreParams;
	createDialog "VTS_rsccommandhelp";
	waituntil {!(isnull (finddisplay 8001))};
	_ctrl=(finddisplay 8001) displayCtrl 10301;
	vts_commandlinehelprefresh=
	{
		_ctrl=(finddisplay 8001) displayCtrl 10301;
		if (isnil "vts_gmlogs") then {vts_gmlogs=""};
		_ctrl ctrlSetText vts_gmlogs;
	};
	[] call vts_commandlinehelprefresh;
};

vts_commandlinehelp=
{
	createDialog "VTS_rsccommandhelp";
	vts_commandlinehelprefresh=
	{
		[] execvm "Computer\commandlinehelp.sqf";
	};
	[] call vts_commandlinehelprefresh;
};

vts_timer_clock=
{
	private ["_display"];
	if (vts_timer_clock_active) exitwith {};
	
	disableSerialization;
	_display=(uiNamespace getVariable "vts_counter_dialog_id");
	vts_timer_clock_active=true;
	while {vts_timer_seconds>=0 && vts_timer_clock_active} do
	{
		_minutes=floor(vts_timer_seconds/60);
		_seconds=round(((vts_timer_seconds/60)-floor(vts_timer_seconds/60))*60);
		_minutes=str(_minutes);
		if (count (toarray _minutes)<2) then {_minutes="0"+_minutes;};
		_seconds=str(_seconds);
		if (count (toarray _seconds)<2) then {_seconds="0"+_seconds;};
		//player sidechat format["%1:%2",_minutes,_seconds];
		((uiNamespace getVariable "vts_counter_dialog_id") displayCtrl  2332) ctrlSetText (_minutes+":"+_seconds);
		if (vts_timer_seconds<21) then 
		{
			if ((vts_timer_seconds mod 2)==0) then
			{
				((uiNamespace getVariable "vts_counter_dialog_id") displayCtrl  2331) ctrlsettext "#(argb,8,8,3)color(0,0,0,0.5)";
			}
			else
			{
				((uiNamespace getVariable "vts_counter_dialog_id") displayCtrl  2331) ctrlsettext "#(argb,8,8,3)color(0.75,0,0,0.5)";
			};
		};
		
		sleep 1;
		if (isnil "vts_timer_freeze") then {vts_timer_freeze=false;};
		if !(vts_timer_freeze) then 
		{
			if (isserver) then {vts_timer_seconds=vts_timer_seconds-1;publicvariable "vts_timer_seconds";};
		};
	};
	19457 cutFadeOut 0.5;
	//End of timer count
	if (vts_timer_seconds==-1) then
	{
		if ([player] call vts_getisGM) then
		{
			"!!! Timer finished : Out of time !!!" call vts_gmmessage; 
		};
		if (isserver) then {"TIMER: Out of time" call vts_addlog;};
		if (isserver) then {publicvariable "vts_timer_seconds"};
		vts_timer_clock_active=false;
	};
	
	//player sidechat "end timer";
};

vts_timer_set=
{
	private ["_display","_go"];
	disableSerialization;
	if (isnil "vts_timer_clock_active") then {vts_timer_clock_active=false;};
	vts_timer_seconds=_this select 0;
	//player sidechat format["%1",vts_timer_seconds];
	_display=(uiNamespace getVariable "vts_counter_dialog_id");
	_go=false;
	["_display",objnull] call vts_checkvar;
	if (isnull _display) then
	{
		_go=true;
	};
	if (isDedicated) then
	{
		_go=true;
	};
	if (_go) then
	{
		19457 cutrsc ["VTS_Counter_Dialog","plain"];
		[] spawn vts_timer_clock;
	};
	
};


vts_timer_start=
{
	private ["_time","_code"];
	if (isnil "vts_timer_freeze") then {vts_timer_freeze=false;publicvariable "vts_timer_freeze";};

	_time=0;
	call compile format ["_time=%1;",(ctrlText 10925)];
	_code={};
	call compile format["
	_code={[%1] spawn vts_timer_set;};
	",_time];
	[_code] call vts_broadcastcommand;
	"Timer launched on all clients" call vts_gmmessage;

};

vts_timer_jip=
{
	if (isnil "vts_timer_seconds") exitwith {};
	if (vts_timer_seconds>0) then 
	{
		[vts_timer_seconds] spawn vts_timer_set;
	};
};

vts_timer_pause=
{
	if !(vts_timer_freeze) then 
	{
		vts_timer_freeze=true;
		publicvariable "vts_timer_freeze";
		"Timer frozen on all clients" call vts_gmmessage;
	}
	else
	{
		vts_timer_freeze=false;
		publicvariable "vts_timer_freeze";
		"Timer resumed on all clients" call vts_gmmessage;		
	};
};

vts_timer_stop=
{
	private ["_code"];
	_code={19457 cutFadeOut 0.5;vts_timer_seconds=-2;vts_timer_clock_active=false;};
	[_code] call vts_broadcastcommand;
	"Timer closed on all clients" call vts_gmmessage;
};

//Create marker on player connection
vts_jipobjectmarker=
{
	private ["_objects"];
	_objects=allMissionObjects "all";
	for "_i" from 0 to (count _objects)-1 do
	{
		_o=_objects select _i;
		_var=[_o] call vts_getchildren;
		if ((count _var)>0) then
		{
			{
				//Marker if string
				if (typename _x=="STRING") then
				{
					[_o,_x] call vts_createbbmarker;
				};
			} foreach _var;
		};
	};
};
if (isserver) then {publicvariable "vts_jipobjectmarker";};

//Add an marker overide to use BB marker to display other kind of marker (viewable by everybody)
vts_createbbmarkeroverride=
{
	private ["_obj","_markervar"];
	_obj=_this select 0;
	_markervar=_this select 1;
	_obj setvariable ["vts_bbmov",_markervar,true];
};

//Creating a marker based on the BB of an object (only viewable by gm execpt if its overriden)
vts_createbbmarker=
{
	private ["_obj","_mname","_pos","_mmarker","_override","_gmonly","_isgm","_dir"];
	_obj=_this select 0;
	_mname=_this select 1;
	_pos=visiblePositionasl _obj;
	if (count _this>2) then {_pos=_this select 2;};
	_dir=direction _obj;
	if (count _this>3) then {_dir=_this select 3;};
	
	//systemchat str _pos;
	_mmarker=objnull;
	
	_gmonly=true;
	_isgm=[player] call vts_getisGM;
	
	//Overriden marker are display for everybody currently (need to add an option in the marker override option to define if we display it to everybody)
	_override=_obj getvariable ["vts_bbmov",nil];
	if !(isnil "_override") then {_gmonly=false;};
	
	//systemchat format["%1 %2 %3", _gmonly,_isgm,_local];
	if ((_gmonly && _isgm) or !(_gmonly)) then
	{	
		_mmarker = createMarkerlocal [_mname,_pos];
		
		if ((_gmonly && _isgm) or !(_gmonly)) then
		{
			if (isnil "_override") then
			{
				_mmarker setMarkershapelocal "rectangle";
				_mmarker setMarkerColorlocal "ColorYellow";
				_mx=(((boundingBox _obj) select 1) select 0)-(((boundingBox _obj) select 0) select 0);
				_my=(((boundingBox _obj) select 1) select 1)-(((boundingBox _obj) select 0) select 1) ;
				_mmarker setMarkerSizelocal [_mx/2,_my/2];
				_mmarker setmarkerdirlocal _dir;
			}
			else
			{
				_mmarker setMarkerSizelocal  (_override select 0);
				_mmarker setMarkerShapelocal (_override select 1);
				_mmarker setMarkerBrushlocal (_override select 2);
				_mmarker setMarkerColorlocal (_override select 3);
				_mmarker setMarkerAlphalocal (_override select 4);		
			};
		};
		
		if (local _obj) then {[_obj,_mmarker] call vts_setchild;};
	};
		
};
if (isserver) then {publicvariable "vts_createbbmarker";};

//Retrieve the current valid custom groups
vts_gmgetactivecustomgroup=
{
	private ["_customgrouplist","_array"];
	_customgrouplist=[];
	{
		if !(isnil _x) then
		{
			_array=[];
			//get string array
			call compile format["_array=%1;",_x];
			//player sidechat typename _array;
			//convert string to array
			call compile format["_array=%1;",_array];
			//player sidechat typename _array;
			
			call compile format["if (count _array>0) then {_customgrouplist set [count _customgrouplist,""%1""];};",_x],;
		};
	} foreach vts_custom_group_list;
	_customgrouplist;
};

//Add current selected object to a custom group
vts_gmgrouparraytostring=
{
	private ["_groupstring"];
	_groupstring="";
	if (count _this>0) then
	{
		for "_i" from 0 to (count _this)-1 do
		{
			if (_i==0) then {_groupstring=_groupstring+"[";};
			
			call compile format ["_groupstring=_groupstring+""'%1'""",_this select _i];
			if (_i<(count _this)-1) then {_groupstring=_groupstring+",";};
			if (_i==(count _this)-1) then {_groupstring=_groupstring+"]";};
		};
	}
	else
	{
		_groupstring="[]";
	};
	_groupstring;
};

vts_gmgroupstringtoarray=
{
	private ["_array"];
	_array=[];
	call compile format["_array=%1;",_this];
	_array;
};

//Reset the custom group;
vts_gmclearcustomgroup=
{
	private ["_currentcustomgroup","_customgroup","_feedback","_grouparray"];
	_currentcustomgroup=console_valid_customgroup;
	_customgroup="[]";
	_feedback="";
	call compile format["if (isnil ""Custom_Group_%1"") then {Custom_Group_%1=""[]"";_customgroup=Custom_Group_%1;} else {_customgroup=Custom_Group_%1;};",_currentcustomgroup];
	_grouparray=_customgroup call vts_gmgroupstringtoarray;
	if (count _grouparray>0) then
	{
		call compile format["
		Custom_Group_%1=""[]"";publicvariable ""Custom_Group_%1"";
		[""---- Custom Group ----"",""Custom_Group_%1"","""",""Group"",Custom_Group_%1] spawn vts_displaysselectedpawninfo;
		",_currentcustomgroup];
		_feedback="Custom Group "+str(_currentcustomgroup)+" has been reset and removed from the groups list";
		if (local_var_console_valid_type=="Group") then {lbSetCurSel [10305,(lbCurSel 10305)];};
		
	}
	else
	{
		_feedback="Custom Group "+str(_currentcustomgroup)+" is currently empty";
	};
	_feedback call vts_gmmessage;
	ctrlsettext [200,_feedback];
};

vts_gmremoveobjecttocustomgroup=
{
	private ["_currentcustomgroup","_customgroup","_feedback","_grouparray"];
	_currentcustomgroup=console_valid_customgroup;
	_customgroup="[]";
	_feedback="";
	call compile format["if (isnil ""Custom_Group_%1"") then {Custom_Group_%1=""[]"";_customgroup=Custom_Group_%1;} else {_customgroup=Custom_Group_%1;};",_currentcustomgroup];
	_grouparray=_customgroup call vts_gmgroupstringtoarray;	
	if (count _grouparray>0) then
	{
		_feedback=str(_grouparray select ((count _grouparray)-1))+" has been removed from Custom Group "+str(_currentcustomgroup);
		_grouparray set [((count _grouparray)-1),-1];
		_grouparray=_grouparray-[-1];
		//player sidechat format["%1",_grouparray];
		call compile format["
		Custom_Group_%1=(_grouparray call vts_gmgrouparraytostring);publicvariable ""Custom_Group_%1"";
		[""---- Custom Group ----"",""Custom_Group_%1"","""",""Group"",Custom_Group_%1] spawn vts_displaysselectedpawninfo;
		",_currentcustomgroup];
		//Update group list
		if ((local_var_console_valid_type=="Group") && (count _grouparray<1)) then {lbSetCurSel [10305,(lbCurSel 10305)];};
	}
	else
	{
		_feedback="Custom Group "+str(_currentcustomgroup)+" is currently empty";
	};
	_feedback call vts_gmmessage;
	ctrlsettext [200,_feedback];
};

//Add the current selected unit to the selected custom group
vts_gmaddobjecttocustomgroup=
{
	private ["_feedback"];
	_feedback="";
	if (local_var_console_valid_type=="Man" or local_var_console_valid_type=="Air" or local_var_console_valid_type=="Land" or local_var_console_valid_type=="Ship") then
	{
		_currentcustomgroup=console_valid_customgroup;
		_customgroup="[]";
		call compile format["if (isnil ""Custom_Group_%1"") then {Custom_Group_%1=""[]"";_customgroup=Custom_Group_%1;} else {_customgroup=Custom_Group_%1;};",_currentcustomgroup];
		_grouparray=_customgroup call vts_gmgroupstringtoarray;
		_grouparray set [count _grouparray,local_console_unit_unite];
		//player sidechat format["%1",_grouparray];
		call compile format["
		Custom_Group_%1=(_grouparray call vts_gmgrouparraytostring);publicvariable ""Custom_Group_%1"";
		[""---- Custom Group ----"",""Custom_Group_%1"","""",""Group"",Custom_Group_%1] spawn vts_displaysselectedpawninfo;
		",_currentcustomgroup];
		_feedback="Object "+local_console_unit_unite+" has been added to custom group "+str(_currentcustomgroup)+". The group is now available in the group list.";
	}
	else
	{
		_feedback="!!! You can't add items from the "+local_var_console_valid_type+" type in a custom group !!!";
	};
	_feedback call vts_gmmessage;
	ctrlsettext [200,_feedback];
};

//Return all turrets & mag of a vehicles  thanks to Denisko
vts_funcGetTurretsWeapons = {
     private ["_result", "_getAnyMagazines", "_findRecurse", "_class"];
     _result = [];
     _getAnyMagazines = {
         private ["_weapon", "_mags"];
         _weapon = configFile >> "CfgWeapons" >> _this;
         _mags = [];
         {
             _mags = _mags + getArray (
                 (if (_x == "this") then { _weapon } else { _weapon >> _x }) >> "magazines"
             )
         } foreach getArray (_weapon >> "muzzles");
         _mags
     };
     _findRecurse = {
         private ["_root", "_class", "_path", "_currentPath"];
         _root = (_this select 0);
         _path = +(_this select 1);
         for "_i" from 0 to count _root -1 do {
             _class = _root select _i;
             if (isClass _class) then {
                 _currentPath = _path + [_i];
                 {
                     _result set [count _result, [_x, _x call _getAnyMagazines, _currentPath, str _class]];
                 } foreach getArray (_class >> "weapons");
                 _class = _class >> "turrets";
                 if (isClass _class) then {
                     [_class, _currentPath] call _findRecurse;
                 };
             };
         };
     };
     _class = (
         configFile >> "CfgVehicles" >> (
             switch (typeName _this) do {
                 case "STRING" : {_this};
                 case "OBJECT" : {typeOf _this};
                 default {nil}
             }
         ) >> "turrets"
     );
     [_class, []] call _findRecurse;
     _result;
 };

//Display info on the windows cpu
vts_displaysselectedpawninfo=
{
	private ["_pict","_desc","_unitname","_unitcamp","_type","_unitspawn","_desc"];
	_pict="";
	_desc="---- Selected spawn ----";
	
	if (count _this>0) then {_desc=_this select 0;};
	["nom_console_valid_unite",""] call vts_checkvar;
	_unitname=nom_console_valid_unite;
	if (count _this>1) then {_unitname=_this select 1;};
	["local_var_console_valid_camp",""] call vts_checkvar;
	_unitcamp=local_var_console_valid_camp;
	if (count _this>2) then {_unitcamp=_this select 2;};
	["local_var_console_valid_type",""] call vts_checkvar;
	_type=local_var_console_valid_type;
	if (count _this>3) then {_type=_this select 3;};
	["local_console_unit_unite",""] call vts_checkvar;
	_unitspawn=local_console_unit_unite;
	if (count _this>4) then {_unitspawn=_this select 4;};	

	if (_unitspawn=="") exitwith {};
	
	_desc=_desc+"<br/>";
	
	//player sidechat format["%1 %2 %3 %4",_desc,_unitname,_unitcamp,_unitspawn];
	
	_desc=_desc+_unitname;
	
	if (_type=="Man" or _type=="Land" or _type=="Air" or _type=="Ship" or _type=="Static" or _type=="Empty" or _type=="Object" or _type=="Logistic" or _type=="Building") then
	{
		_desc=_desc+"<br/>Alias :<br/>"+GetText(Configfile >> "CfgVehicles" >> _unitspawn >> "DisplayName");
	};
	if (_type=="Group") then
	{
		if ([_unitspawn,1] call KRON_StrLeft=="[") then
		{
			_array=[];
			call compile format["_array=%1;",_unitspawn];
			if (count _array>0) then
			{
				_desc=_desc+"<br/><br/>Group composition :<br/>";
				{
					_desc=_desc+gettext(configfile >> "CfgVehicles" >> _x >> "DisplayName")+"<br/>";
				} foreach _array;
			}
			else
			{
				_desc=_desc+"<br/><br/>Custom group is empty<br/>";
			};
			
		}
		else
		{
			_cfg="";
			call compile format ["_arpos=(%1_group find ""%2"");if (_arpos<0) then {_arpos=0;};_cfg=%1_GroupConfig select _arpos;",_unitcamp,_unitspawn];
			_desc=_desc+"<br/>Alias :<br/>"+GetText(_cfg >> "name");
			_desc=_desc+"<br/><br/>Group composition :<br/>";
			_n=0;
			_cfgunit=(_cfg >> "unit"+str(_n));
			while {isclass _cfgunit} do
			{
				_class=gettext (_cfgunit >> "vehicle");
				_desc=_desc+gettext(configfile >> "CfgVehicles" >> _class >> "DisplayName")+"<br/>";
				_n=_n+1;
				_cfgunit=(_cfg >> "unit"+str(_n));
			};
		};
	};
	
	if (_type=="Land" or _type=="Air" or _type=="Ship" or _type=="Static" or _type=="Empty") then
	{
		_pict=Gettext (configfile >> "CfgVehicles" >> _unitspawn >> "picture");
		if (_pict!="") then {_desc=_desc+"<br/><br/><img size='5' image='"+_pict+"' />";};	
			
		_vehiturrets=GetArray (configfile >> "CfgVehicles" >> _unitspawn >> "Weapons");
		_vehiturrets=_vehiturrets+(_unitspawn call vts_funcGetTurretsWeapons);
		if (count _vehiturrets>0) then
		{
			_desc=_desc+"<br/><br/>Weapons : <br/>";
			for "_i" from 0 to (count _vehiturrets)-1 do
			{
				_turret=_vehiturrets select _i;
				if (typename _turret=="ARRAY") then {_turret=(_vehiturrets select _i) select 0;};
				_desc=_desc+(gettext (ConfigFile>> "CfgWeapons" >> _turret >>"displayname"))+"<br/>";
			};
		};
		
	};
	if (_type=="Man") then
	{
		_weaps=GetArray (configfile >> "CfgVehicles" >> _unitspawn >> "weapons");
		if (count _weaps>0) then
		{
			_desc=_desc+"<br/><br/>Weapons : <br/>";
			for "_i" from 0 to (count _weaps)-1 do
			{
				_weap=_weaps select _i;
				_desc=_desc+(gettext (ConfigFile>> "CfgWeapons" >> _weap >>"displayname"))+"<br/>";
			};
		};
	};
	if (_type=="Logistic") then
	{
		_weapsnum=count (configfile >> "CfgVehicles" >> _unitspawn >> "TransportWeapons");
		if (_weapsnum>0) then
		{
			_desc=_desc+"<br/><br/>Weapons : <br/>";
			for "_i" from 0 to (_weapsnum-1) do
			{
				_weap=gettext (((configfile >> "CfgVehicles" >> _unitspawn >> "TransportWeapons") select _i) >> "weapon" );
				_desc=_desc+(gettext (ConfigFile>> "CfgWeapons" >> _weap >> "displayname"))+"<br/>";
			};
		};
		_magsnum=count (configfile >> "CfgVehicles" >> _unitspawn >> "TransportMagazines");
		if (_magsnum>0) then
		{
			if (_weapsnum<1) then {_desc=_desc+"<br/>";};
			_desc=_desc+"<br/>Magazine : <br/>";
			for "_i" from 0 to (_magsnum-1) do
			{
				_mag=gettext (((configfile >> "CfgVehicles" >> _unitspawn >> "TransportMagazines") select _i) >> "magazine" );
				_desc=_desc+(gettext (ConfigFile>> "CfgMagazines" >> _mag >> "displayname"))+"<br/>";
			};
		};		
	};	
	//ctrlsettext [10623,_desc];
	if !(isnil "vts_cpuscaling") then 
	{
		_ratioy=(vts_cpuscaling select 0)*(((SafezoneW)+(safezoneX))/((safezoneH)+(safezoneY)));
		_size=(1.0*(((SafezoneW)+(safezoneX))/((safezoneH)+(safezoneY))) / ((getResolution select 5)/_ratioy));
		_desc=("<t size='"+str(_size)+"'>")+_desc+"</t>";
		
	};
	((finddisplay 8000) displayctrl 10623) ctrlSetStructuredText (parsetext _desc);
};

//Display friendly name when neabry to recognize them
vts_readfriendlyname=
{
	if (difficultyEnabled "friendlyTag") exitwith {};
	while {true} do
	{
		_obj=cursorTarget;
		if !(isnull _obj) then
		{
			if (alive _obj) then
			{
				if (((side group _obj)==side group player) or {captive player} or {captive _obj}) then
				{
					if (_obj iskindof "AllVehicles") then
					{
						_reconizedistance=21;
						if !(_obj iskindof "Man") then {_reconizedistance=11;};
						if ((_obj distance player)<_reconizedistance) then
						{
							_name=name _obj;
							if (_name!="Error: No unit") then
							{				
								10	cuttext ["\n\n\n\n\n"+_name,"PLAIN",0.01];
							};
						};		
					};
				};
			};
		};
		sleep 0.1;
	};
};

//Setup player list and ID
vts_setupplayerid=
{
	private ["_player","_type"];
	_type=_this select 0;
	//Initial server execution
	if (_type==0) then
	{
		
		if (isnil "vts_player_list") then
		{
			vts_player_list=vts_game_masters;
			for "_i" from 0 to (count playableUnits)-1 do
			{
				_player=playableUnits select _i;
				//player sidechat vehiclevarname _player;
				if (({_x==(vehiclevarname _player)} count vts_game_masters)<1) then
				{
					if (({_x==(name _player)} count vts_player_list)<1) then
					{
						vts_player_list=vts_player_list+[(name _player)];
						_init=format["_spawn setvehiclevarname ""user%1"";if (local _spawn) then {user%1=_spawn;publicvariable ""user%1"";};[_spawn] spawn vts_ZeusProcessInit;",count vts_player_list];
						[_player,_init] call vts_setobjectinit;
					};
				};
			}; 
			
			//Share to player the current list
			publicvariable "vts_player_list";
			//player sidechat str vts_player_list;
			//Apply init 
			[] call vts_processobjectsinit;
		};
	};
	//Player joining execution
	if (_type==1) then
	{
		//player sidechat vehiclevarname player;
		if (({_x==(vehiclevarname player)} count vts_game_masters)<1) then
		{
			//Not already in list add him 
			_findpos=(vts_player_list find (name player));
			if (_findpos<0) then
			{
				_vts_player_list=vts_player_list;
				_vts_player_list=_vts_player_list+[(name player)];
				_init=format["_spawn setvehiclevarname ""user%1"";if (local _spawn) then {user%1=_spawn;publicvariable ""user%1"";};[_spawn] spawn vts_ZeusProcessInit;",count _vts_player_list];
				[player,_init] call vts_setobjectinit;
				vts_player_list=_vts_player_list;
				publicvariable "vts_player_list";
				//Sync with everyone
				[] call vts_processobjectsinit;
				 
			}
			else
			{
				//Already in the list just refresh ID and sync if JIP 
				if (vehicleVarName player!="user"+(str (_findpos+1))) then
				{
					_init=format["_spawn setvehiclevarname ""user%1"";if (local _spawn) then {user%1=_spawn;publicvariable ""user%1"";};[_spawn] spawn vts_ZeusProcessInit;",(_findpos+1)];
					[player,_init] call vts_setobjectinit;
					//Sync with everyone
					[] call vts_processobjectsinit;
				};
			};
		};
	};
};
if (isserver) then {publicvariable "vts_setupplayerid";};

//Handle fog stuff
vts_setfog=
{
	private ["_transitime"];
	_transitime=10;
	if (count _this>2) then {_transitime=_this select 2;};
	if (vtsarmaversion<3) then
	{
		_transitime setfog (_this select 0);
	}
	else
	{
		_fog=_this select 0;
		_alt=_this select 1;	
		if (_alt==0 or _fog==0) then
		{
			_transitime setfog [_fog,0.0049333,0];
		}
		else
		{
			_decay=5;
			_newdecay=(_fog/_alt)*_decay;
			_newalt=_alt;
			_newfog=_fog/_decay;
			//hint format["f %1 d %2 a %3",_newfog,_newdecay,_newalt];
			_transitime setfog [_newfog,_newdecay,_newalt];
		};
	};
};
//Handle spawn init & jip init
vts_setobjectinit=
{
	private ["_obj","_init","_currentinit"];
	_obj=_this select 0;
	_init=_this select 1;
	_currentinit=_obj getvariable ["vts_objectinit",[]];
	//Avoid duplicate init script
	if !(_init in _currentinit) then {_currentinit set [count _currentinit,_init];};
	_obj setvariable ["vts_objectinit",_currentinit,true];
};
if (isserver) then {publicvariable "vts_setobjectinit";};

vts_processobjectsinit=
{	
	private ["_listobjects","_spawn","_state"];

	//Use false or any statement to not broadcast the process again
	//First processinit ? (jip or entering)
	if (isnil "vts_initeventhandlerok") then 
	{
		vts_processinit=false;
		vts_initeventhandlerok=true;
		"vts_processinit" addPublicVariableEventHandler {if (vts_processinit) then {[false] call vts_processobjectsinit;vts_processinit=false;};};
	}
	else
	{
		if (count _this<1) then
		{
			//player sidechat "broadcast";
			vts_processinit=true;
			publicvariable "vts_processinit";
		};
	};
	
	_listobjects=allMissionObjects "all";
	for "_i" from 0 to (count(_listobjects))-1 do
	{
		_obj=_listobjects select _i;
		_initdone=_obj getvariable ["vts_objectinitdone",0];
		_init=_obj getvariable ["vts_objectinit",[]];
		
		if (isnil "_init") then {_init=[];};
		if (count _init>0) then
		{
			_initdoneupdate=0;
			for "_t" from _initdone to (count _init)-1 do
			{
				_initdoneupdate=_initdoneupdate+1;
				_selectedinit=_init select _t;
				_spawn=_obj;
				//player sidechat _init;
				call compile _selectedinit;
			};
			if (_initdoneupdate>0) then
			{
				_initdone=_initdone+_initdoneupdate;
				_obj setvariable ["vts_objectinitdone",_initdone];
			};
		};
		//JIP stuff
		if (count _this>0) then
		{
			if (isplayer _obj) then 
			{
				//GM invisible on JIP is GM hidden
				if (_obj getvariable ["vts_gm_hidden",false]) then
				{
					_obj allowDamage false;
					_obj hideObject true;
				};
			};
			//Handle hidden object via script
			_state=_obj getvariable ["vts_hidden",false];
			if (_state) then
			{
				_obj hideObject _state;
				_obj enablesimulation _state;
			};
		};
	};
	if (vts_debug) then {player globalchat "VTS_DEBUG : Processing entities synchronisation"};
};
if (isserver) then {publicvariable "vts_processobjectsinit";};

//Handle networkable spawn
vts_initiatespawn=
{
	private ["_checklocality"];
	_checklocality=true;
	if (count _this > 0) then {_checklocality=_this select 0;};	
	vts_spawnarray=[_checklocality] call vts_getspawnsetuparray;
	//player sidechat format["%1",vts_spawnarray]; 		

	if ([] call vts_IsSpawnHandler) then
	{
		[vts_spawnarray] call vts_spawnbuilder;
	}
	else
	{
		publicvariable "vts_spawnarray";
	};
	
};

//Display minimap help for GM
vts_minimaphelp=
{
	private ["_txt"];
	
	_txt="Mini map shortcuts :\n
	Double click = Apply current order to a group\n
	Shift + Double click = Jump on camera view\n
	Alt + Double click = Teleport yourself\n
	Ctrl + Double click = Open\Close unit properties\n
	Ctrl + Mouse wheel = Change brush radius\n
	Delete = Delete deads objects under the brush\n
	Shift + Delete = Delete objects under the brush\n
	Ctrl + Delete = Delete objects under the brush
	";
	_txt spawn vts_gmmessage;
};

//Remove all weapons
vts_stripunitweapons=
{
	private ["_unittostrip"];
	_unittostrip=_this select 0;
	removeAllWeapons _unittostrip;
	removebackpack _unittostrip;
	//Also remove NV googles
	if (vtsarmaversion>2) then
	{
		call compile "_unittostrip unassignItem ""NVGoggles"";_unittostrip removeitem ""NVGoggles"";";
		call compile "removeheadgear _unittostrip;";
		call compile "removevest _unittostrip;";
		call compile "removeGoggles _unittostrip;";			
		call compile "{_unittostrip unassignItem _x} foreach assigneditems _unittostrip;";
	}
	else
	{
		_unittostrip removeWeapon "NVGoggles";
	};
	removeAllItems _unittostrip;
};

//Get the nearest objects in 2D
vts_nearestobjects2d=
{
	private ["_pos","_filter","_radius","_fulllist","_listairdepth","_2dlist","_count"];
	_pos=_this select 0;
	_filter=_this select 1;
	_radius=_this select 2;
	
	_fulllist= nearestObjects [_pos,_filter,_radius+1000];

	//Near entities for faster search (and flying & deep should be alive unit)
	_listairdepth= _pos nearEntities   [_filter,_radius+5000];
	//Add missing flying air & depth units to the del 
	for "_i" from 0 to (count _listairdepth)-1 do
	{
		_obj=_listairdepth select _i;
		if !(_obj in _fulllist) then 
		{	
			_fulllist set [count _fulllist,_obj];
		};
		
	};
	
	_2dlist=[];
	
	_count=count _fulllist;
	for "_n" from 0 to (_count-1) do
	{
		_object=_fulllist select _n;
		if (([getposatl _object select 0,getposatl _object select 1] distance [_pos select 0, _pos select 1])<=_radius) then
		{
			_2dlist set [count _2dlist,_object];	
		};
	};	
	_2dlist;
};
//Get the nearest objects in 3D
vts_nearestobjects3d=
{
	private ["_n","_pos","_posasl","_object","_filter","_radius","_fulllist","_listairdepth","_3dlist","_count","_posasl2","_closer","_lastdist","_curdist"];
	_posasl=_this select 0;
	_filter=_this select 1;
	_radius=_this select 2;
	
	_pos=_posasl;
	if !(surfaceIsWater _pos) then {_pos=asltoatl _pos;};
	
	_fulllist= nearestObjects [_pos,_filter,_radius];
		
	_3dlist=[];	
	
	while {count _fulllist>0} do
	{
		_lastdist=10000;
		_closer=objnull;
		_count=count _fulllist;
		for "_n" from 0 to (_count-1) do
		{
			_object=_fulllist select _n;
			_posasl2=getposasl _object;		
			_curdist=[_posasl2 select 0,_posasl2 select 1,_posasl2 select 2] distance [_posasl select 0, _posasl select 1, _posasl select 2];
			if ((_curdist min _lastdist)==_curdist) then
			{
				_closer=_object;
				_lastdist=_curdist;
			};			
		};
		_fulllist=_fulllist-[_closer];
		_3dlist set [count _3dlist,_closer];
		//player sidechat str _closer;
		
	};
	//player sidechat str _3dlist;
	_3dlist;
	
};
//Temp
/*
rez=
{
	_id=idc;
	_x=x;
	_y=y;
	_w=w;
	_h=h;	
	
	if (_w>0.5) then {_w=0.5};
	if (_h>0.020) then 
	{
		_y=_y+((_h/2)-(0.020/2));
		_h=0.020;
	};
	
	//Test d'interface
	_ctrlpos=ctrlPosition ((finddisplay 8000) displayctrl _id);
	((finddisplay 8000) displayctrl _id) ctrlsetPosition [_x,_y,_w,_h];
	_txt=format["idc=%1; x=%2; y=%3; w=%4; h=%5;",_id,_x,_y,_w,_h];
	copytoclipboard _txt;
};
*/

//Update computer fps value for GM
vts_updateserverfps=
{
	private ["_fps"];
	_fps=vts_server_fps;
	
	if (isnil "vts_hclient_fps") then {vts_hclient_fps=9999};
	if !(isnil "VTS_HC_AI") then {if (isnull VTS_HC_AI) then {vts_hclient_fps=9999};};
	_hcfps=vts_hclient_fps;
	
	if (count _this>0) then {_fps=_this select 0;};
	
	if !(isdedicated) then
	{
		if (dialog) then
		{
			_bgcolor=[0,1,0,0.25];
			if (_fps<20) then {_bgcolor=[1,0.65,0,0.6];};
			if (_fps<10) then {_bgcolor=[1,0,0,0.6];};
			((finddisplay 8000) displayctrl 10624) ctrlSetBackgroundColor _bgcolor;
			ctrlsettext [10624,"Server FPS: "+str(_fps)];
			
			_hcbgcolor=[0,1,0,0.25];
			if (_hcfps<20) then {_hcbgcolor=[1,0.65,0,0.6];};
			if (_hcfps<10) then {_hcbgcolor=[1,0,0,0.6];};
			((finddisplay 8000) displayctrl 10636) ctrlSetBackgroundColor _hcbgcolor;
			if (_hcfps==9999) then {_hcfps=0;};
			ctrlsettext [10636,"HC FPS: "+str(_hcfps)];			
		};
	};	
};
//Update group numbers to GM (144 group max per side)
vts_updateservergroupnum=
{
	private ["_grptxt"];
	_grptxt=vts_server_groupsnum;
	if (count _this>0) then {_grptxt=_this select 0;};
	
	if !(isdedicated) then
	{
		if (dialog) then
		{
			_bfor=vts_server_groupsnum select 0;
			_ofor=vts_server_groupsnum select 1;
			_rfor=vts_server_groupsnum select 2;
			_cfor=vts_server_groupsnum select 3;
			_bforu=vts_server_groupsnum select 4;
			_oforu=vts_server_groupsnum select 5;
			_rforu=vts_server_groupsnum select 6;
			_cforu=vts_server_groupsnum select 7;
			ctrlsettext [10626,str(_bfor)];
			ctrlsettext [10627,str(_ofor)];
			ctrlsettext [10628,str(_rfor)];
			ctrlsettext [10629,str(_cfor)];
			ctrlsettext [10632,str(_bforu)];
			ctrlsettext [10633,str(_oforu)];
			ctrlsettext [10634,str(_rforu)];
			ctrlsettext [10635,str(_cforu)];
			_bbgcolor=[0,0,1,0.25];
			_obgcolor=[1,0,0,0.25];
			_rbgcolor=[0,1,0,0.25];
			_cbgcolor=[1,0.5,0,0.25];
			((finddisplay 8000) displayctrl 10632) ctrlSetBackgroundColor _bbgcolor;
			((finddisplay 8000) displayctrl 10633) ctrlSetBackgroundColor _obgcolor;
			((finddisplay 8000) displayctrl 10634) ctrlSetBackgroundColor _rbgcolor;
			((finddisplay 8000) displayctrl 10635) ctrlSetBackgroundColor _cbgcolor;			
			if (_bfor>125) then {_bbgcolor=[0,0,1,1];};
			if (_ofor>125) then {_obgcolor=[1,0,0,1];};
			if (_rfor>125) then {_rbgcolor=[0,1,0,1];};
			if (_cfor>125) then {_cbgcolor=[1,0.5,0,1.0];};
			((finddisplay 8000) displayctrl 10626) ctrlSetBackgroundColor _bbgcolor;
			((finddisplay 8000) displayctrl 10627) ctrlSetBackgroundColor _obgcolor;
			((finddisplay 8000) displayctrl 10628) ctrlSetBackgroundColor _rbgcolor;
			((finddisplay 8000) displayctrl 10629) ctrlSetBackgroundColor _cbgcolor;
		};
	};	
};

//Clear all waypoints
vts_clearwaypoints=
{
	private ["_group"];
	_group=_this select 0;
	while {(count waypoints _group)!=0} do
	{
		deleteWaypoint [_group,0];
	};
};

//init spawn function to track spawn varname over the network
vts_spawninit=
{
	private ["_object","_inittxt"];
	_object=_this select 0;
	_inittxt="";
	/*
	if !(this iskindof "CAManBase") then
	{
		{
		call compile format["_x setvehiclevarname ""vts_%1"";vts_%1=_x;publicvariable ""vts_%1"";",vtso_num];
		vtso_num=vtso_num+1;
		} foreach crew this;
	};
	if (vehicle this!=this) then
	{
		if (vehicleVarName (vehicle this)=="") then
		{
			call compile format["(vehicle this) setvehiclevarname ""vts_%1"";vts_%1=(vehicle this);publicvariable ""vts_%1"";",vtso_num];
			vtso_num=vtso_num+1;
		};
	};
	*/
	_inittxt=format[";_spawn setvehiclevarname ""vts_%1"";[_spawn] spawn vts_ZeusProcessInit; if (local _spawn) then {vts_%1=_spawn;publicvariable ""vts_%1"";};",vtso_num];
	vtso_num=vtso_num+1;
	_inittxt;
};


//filter vest and equipment to avoid rebreather for random use
vts_islandequipment=
{
	private ["_vest","_goodvest"];
	_vest=_this select 0;
	_goodvest=true;
	if ([_vest,"breath"] call KRON_StrInStr) then
	{
		_goodvest=false;
	};
	_goodvest;
};

//filter unit to be sur man is not a air or diver or placeholder
vts_islandman=
{
	private ["_man","_goodman"];
	_man=_this select 0;
	_goodman=true;
	
	if (([_man,"pilot"] call KRON_StrInStr) or ([_man,"crew"] call KRON_StrInStr) or ([_man,"diver"] call KRON_StrInStr) or ([_man,"target"] call KRON_StrInStr) or ([_man,"compet"] call KRON_StrInStr) or ([_man,"master"] call KRON_StrInStr)) then
	{
		_goodman=false;
	};
	_goodman;
};

vts_retrieveunitinfo=
{
	private ["_object","_txtinfo","_skill"];
	_object=_this select 0;

	if (isnull _object) exitwith
	{	
		//ctrlSetText [10623,"------ No data ------"];
	};	
	
	_txtinfo="";
	if (isplayer _object) then
	{
		_txtinfo=_txtinfo+"------ Player ------";
	}
	else
	{
		_txtinfo=_txtinfo+"------ AI unit ------";
	};
	if (name _object!="Error: No unit") then
	{
	_txtinfo=_txtinfo+"<br/>Name :<br/>"+name _object;
	}
	else
	{
	_txtinfo=_txtinfo+"<br/>Name :<br/>"+gettext (configfile >> "CfgVehicles" >> (typeof _object) >> "Displayname");
	};
	_txtinfo=_txtinfo+"<br/>Class type :<br/>"+typeof vehicle _object;
	_txtinfo=_txtinfo+"<br/>VarName : "+vehiclevarname _object;
	_txtinfo=_txtinfo+format["<br/>Side : %1",side _object];
	_txtinfo=_txtinfo+format["<br/>Health : %1 ",round(((damage _object)-1)*100)*-1]+"%";
	_skill=_object getvariable ["vts_skillset",nil];
	if (isnil "_skill") then 
	{
		if !(local _object) then
		{
			_txtinfo=_txtinfo+"<br/>Skill : Unknow Remote unit";
		}
		else
		{
			_txtinfo=_txtinfo+format["<br/>Skill : %1/1.0 ",skill _object];
		};
	}
	else {_txtinfo=_txtinfo+format["<br/>Skill : %1/1.0 ",_skill];};
	_txtinfo=_txtinfo+"<br/>";
	_txtinfo=_txtinfo+"<br/>Behaviour : "+behaviour _object;
	_txtinfo=_txtinfo+"<br/>Combat mode : "+combatMode _object;
	_txtinfo=_txtinfo+"<br/>Formation : "+formation _object;
	_txtinfo=_txtinfo+"<br/>Waypoint : "+waypointtype [group _object,currentWaypoint group _object];
	_txtinfo=_txtinfo+"<br/>Speed : "+speedMode _object;
	
	_txtinfo=_txtinfo+"<br/>";	
	
	_txtinfo=_txtinfo+format["<br/>Group : %1 <br/>%2 member(s)",group _object,count units group _object];
	_txtinfo=_txtinfo+format["<br/>Group member(s) :<br/>",(count units group _object)-1];
	
	{
		if (alive _x) then
		{
			if (isplayer _x) then
			{
				_txtinfo=_txtinfo+(name _x)+format["~%1",round(((damage _x)-1)*100)*-1]+"%<br/>";
			} else
			{
				_txtinfo=_txtinfo+(typeof vehicle _x)+format["~%1",round(((damage _x)-1)*100)*-1]+"%<br/>";
			};
			
		};
	} foreach units group _object;
	
	//ctrlSetText [10623,_txtinfo];
	if !(isnil "vts_cpuscaling") then 
	{
		_ratioy=(vts_cpuscaling select 0)*(((SafezoneW)+(safezoneX))/((safezoneH)+(safezoneY)));
		_size=(1.0*(((SafezoneW)+(safezoneX))/((safezoneH)+(safezoneY))) / ((getResolution select 5)/_ratioy));
		_txtinfo=("<t size='"+str(_size)+"'>")+_txtinfo+"</t>";
		
	};	
	((finddisplay 8000) displayctrl 10623) ctrlSetStructuredText (parsetext _txtinfo);
};

//Functions when gm is moving mouse on map
vts_gmmapmousemoving=
{
	private ["_xpos","_ypos","_mappos","_objects","_mappos2d","_object","_brush","_lastdist","_maxdist"];
	//Auto set focus on map
	ctrlSetFocus (_this select 0);
	
	//Check locality issue with radius
	if (local_radius!=radius) then
	{
		radius=local_radius;
	};
	//Store map pos on mouse move
	if (isnil "vtsmapkeyctrl") then {vtsmapkeyctrl=false;};
	if !(vtsmapkeyctrl) then {_this call vts_gmmapstorepos;};
	
	_xpos=_this select 1;
	_ypos=_this select 2;
	_mappos=(_this select 0) ctrlMapScreenToWorld  [_xpos,_ypos];
	vts_gmmapcursorworldpos=_mappos;
	
	//Nearobject is good but its taking a 3D sphere :(
	//_object=nearestObject [[_mappos select 0,_mappos select 1],"AllVehicles"];
	//Using a nearentities should be big enough while beein perfomant (well I hope so)
	//Then I need to get the nearest entity in 2D to the pos click. Using a 500 meters 3D radius to get aircraft.
	_objects=_mappos nearEntities ["Land",50];
	//_objects=_objects+(_mappos nearEntities [["Air","Ship"],1000]);
	_objects=_objects+(_mappos nearEntities [["Air","Ship"],5000]);
	//Check for dead vehicles too (or not, since we can't regenerate a dead vehicle)
	/*
	_vehicles=vehicles;
	for "_i" from 0 to (count _vehicles)-1 do
	{
		_veh=(_vehicles select _i);
		if !(alive _veh) then
		{
			if (_veh distance _mappos<=50) then
			{
				if !(_veh in _objects) then 
				{
					_objects set [count _objects,_veh];
				};
			};
		};
	};
	*/

	
	_mappos2d=[_mappos select 0,_mappos select 1];
	_lastdist=100000;
	_maxdist=50;
	_object=objnull;
	for "_i" from 0 to (count _objects)-1 do
	{
		
		_curobject=_objects select _i;
		_curdist=[(getposatl _curobject) select 0,(getposatl _curobject) select 1] distance _mappos2d;
		if ( ((_curdist min _lastdist)==_curdist) && (_curdist<=_maxdist) ) then {_object=_curobject; _lastdist=_curdist};				
	};
	//Sharing it for other functions
	vtsmouseoverobject=_object;
	
	//Brush
	deleteMarkerLocal "vtsbrush";
	_brush = createMarkerLocal ["vtsbrush",_mappos];
	_brush setMarkerShapeLocal "ELLIPSE";
	_brush setMarkerColorLocal "Colorblack";
	_brush setMarkerBrushLocal "SolidBorder";
	_brush setMarkerAlphaLocal 0.25;
	_brush setmarkersizelocal [radius,radius];	
	
	if (isnil "gps_eni_valid") then {gps_eni_valid=0;};
	
	if (!(isnull _object) && (gps_eni_valid!=0)) then
	{
		if (_object iskindof "CAManBase" or _object iskindof "Air" or _object iskindof "Ship" or _object iskindof "LandVehicle") then
		{
			vts_gmlastobjectmouseover=_object;
			if (true) then
			{
				for "_i" from 0 to vtsmouveovergroupmarkers do
				{
					deleteMarkerLocal ("vtsmouveovergroup"+str(_i));
				};
				
				for "_w" from 0 to vtsmouveoverwpmarkers do
				{
					deleteMarkerLocal ("vtsmouveoverwp"+str(_w));
				};
				deletemarkerlocal "vtsmouveovertarget";
				
				//Group selection
				vtsmouveovergroupmarkers=0;
				{					
					_unitpos=getPosATL _x;
					_marker_pos = createMarkerLocal ["vtsmouveovergroup"+(str(vtsmouveovergroupmarkers)),_unitpos];
					_marker_pos setMarkerShapeLocal "ELLIPSE";
					_marker_pos setMarkerColorLocal "Colorblack";
					_marker_pos setMarkerBrushLocal "Border";
					_marker_pos setMarkerAlphaLocal 0.5;
					_marker_pos setmarkersizelocal [5.0,5.0];
					vtsmouveovergroupmarkers=vtsmouveovergroupmarkers+1;
				} foreach units group _object;
				
				//Show destination only for AI
				if !(isplayer _object) then
				{
					vtsmouveoverwpmarkers=0;
					_wp_lastpos=[getPosATL _object select 0,getPosATL _object select 1];
					{
						_obj_pos_x=_wp_lastpos select 0;
						_obj_pos_y=_wp_lastpos select 1;
						_movepos=waypointPosition _x;
						if ((_movepos select 0)!=0 && (_movepos select 1)!=0) then
						{
							_movepos_x=_movepos select 0;
							_movepos_y=_movepos select 1;
							_marker_line = createMarkerLocal [("vtsmouveoverwp"+str(vtsmouveoverwpmarkers)),[_obj_pos_x,_obj_pos_y]];
							_marker_line setMarkerShapeLocal "RECTANGLE";
							_marker_line setMarkerColorLocal "Colorblack";
							_marker_line setMarkerAlphaLocal 0.5;
							_marker_line setMarkerBrushLocal "SolidBorder";
							_marker_line setmarkerposlocal [(([_obj_pos_x,_obj_pos_y] select 0) + ([_movepos_x,_movepos_y] select 0)) / 2, (([_obj_pos_x,_obj_pos_y] select 1) + ([_movepos_x,_movepos_y] select 1)) / 2];
							_marker_line setmarkerdirlocal (([_obj_pos_x,_obj_pos_y] select 0) - ([_movepos_x,_movepos_y] select 0)) atan2 (([_obj_pos_x,_obj_pos_y] select 1) - ([_movepos_x,_movepos_y] select 1));
							_marker_line setmarkersizelocal [1.0, ([_obj_pos_x,_obj_pos_y] distance [_movepos_x,_movepos_y]) / 2];
							vtsmouveoverwpmarkers=vtsmouveoverwpmarkers+1;
							_marker_pos = createMarkerLocal [("vtsmouveoverwp"+str(vtsmouveoverwpmarkers)),_movepos];
							_marker_pos setMarkerShapeLocal "ELLIPSE";
							_marker_pos setMarkerColorLocal "Colorred";
							_marker_pos setMarkerBrushLocal "SolidBorder";
							_marker_pos setMarkerAlphaLocal 0.5;
							_marker_pos setmarkersizelocal [5.0,5.0];
							vtsmouveoverwpmarkers=vtsmouveoverwpmarkers+1;
							_wp_lastpos=_movepos;
						};
					} foreach waypoints group _object;
				};
				
				//Unit specific
				_markertarget = createMarkerLocal ["vtsmouveovertarget",getPosATL _object];
				_markertarget setMarkerShapeLocal "ELLIPSE";
				_markertarget setMarkerColorLocal "ColorBlack";
				_markertarget setMarkerBrushLocal "SolidBorder";
				_markertarget setMarkerAlphaLocal 0.35;
				_markertarget setmarkersizelocal [6.0,6.0];
				
				[_object] spawn vts_retrieveunitinfo;
			};
		};

	}
	//Clean
	else
	{
		if (isnil "vtsmouveoverwpmarkers") then {vtsmouveoverwpmarkers=0;};
		for "_w" from 0 to vtsmouveoverwpmarkers do
		{
			deleteMarkerLocal ("vtsmouveoverwp"+str(_w));
		};
		if (isnil "vtsmouveovergroupmarkers") then {vtsmouveovergroupmarkers=0;};
		for "_i" from 0 to vtsmouveovergroupmarkers do
		{
			deleteMarkerLocal ("vtsmouveovergroup"+str(_i));
		};
		deletemarkerlocal "vtsmouveovertarget";		
		[objnull] spawn vts_retrieveunitinfo;
	};
	
		
};

//Functions when GM is double clicking in the computer map
vts_gmmapdblclick=
{	
	private ["_xcursor","_ycursor","_shiftkey","_ctrlkey","_altkey","_mappos"];
	//player sidechat format["%1",_this];
	_xcursor=_this select 2;
	_ycursor=_this select 3;
	_shiftkey=_this select 4;
	_ctrlkey=_this select 5;
	_altkey=_this select 6;
	_mappos=(_this select 0) ctrlMapScreenToWorld  [_xcursor,_ycursor];
	
	//Teleport GM
	if (_altkey && !(_shiftkey ) && !(_ctrlkey)) then 
	{
		player setposasl ([_mappos,true] call vts_SetPosAtop);
	};	
	
	//Place Camera 
	if (!(_altkey) && (_shiftkey) && !(_ctrlkey)) then 
	{
		["VTScamtarget",objnull] call vts_checkvar;
		if !(isnil "VTS_Freecam") then {vts_stopcam=true;waituntil {sleep 0.01;isnull VTS_Freecam};};
		[VTScamtarget,[_mappos select 0,_mappos select 1,([[_mappos select 0,_mappos select 1]] call vts_SetPosAtop) select 2]] execVM "Computer\VTS_FreeCam.sqf";
	};	
	
	//Edit object property 
	if (!(_altkey) && !(_shiftkey) && (_ctrlkey)) then 
	{
		_object=vtsmouseoverobject;
		if (!(isnull _object) && (_object iskindof "CAManBase" or _object iskindof "Air" or _object iskindof "Ship" or _object iskindof "LandVehicle")) then
		{
			if (_object in vts_object_property) then
			{
				[] call vts_property_close;
			}
			else
			{
				if (isnil "vts_property_group") then
				{
					vts_object_property=[_object];
				}
				else
				{
					vts_object_property=[_object];
					_units=units group _object;
					for "_i" from 0 to (count _units)-1 do
					{
						_unit=_units select _i;
						if !(_unit in vts_object_property) then {vts_object_property set [count vts_object_property,_unit];};
					};
				};
				vts_property_group_selected=group _object;
				vts_object_property_selected=_object;
				[] call vts_property_showpanel;
			};
		};
	};			
	
	//Apply order
	if (!(_shiftkey) && !(_ctrlkey) && !(_altkey) && (breakclic==0)) then
	{
		_object=vtsmouseoverobject;
		if (!(isnull _object) && (_object iskindof "CAManBase" or _object iskindof "Air" or _object iskindof "Ship" or _object iskindof "LandVehicle") && !(isplayer _object)) then
		{
			breakclic=1;
			_group = group _object;
			_count=0;
			{
			  _count=_count+1;
			  call compile format["_marker=createMarkerLocal [""Gmarker%1"",getPosATL _x]; _marker setMarkerTypeLocal ""mil_Dot"";_marker setMarkerSizeLocal [1, 1]; _marker setMarkerAlphaLocal 0.5; _marker setMarkerColorLocal ""ColorGreen"";",_count];
			} foreach units _group;      
			 [_group] execVM "Computer\console\updateorders.sqf";	
			sleep 1.5;
			//clean marker
			while {_count>0} do
			{
			  call compile format["deletemarker ""Gmarker%1"";",_count];
			  _count=_count-1;
			};
		};
	};
};

//Mouse button up
vts_gmmapmousebuttonup=
{

	
};

//Key down
vts_gmmapkeydown=
{
	private ["_key"];
	_key=_this select 1;
	//Holding CTRL?
	if (_key==29 or _key==157) then {vtsmapkeyctrl=true;};
	//Holding shift?
	if (_key==42 or _key==54) then {vtsmapkeyshift=true;};
};
//Key up
vts_gmmapkeyup=
{
	private ["_key"];
	//player sidechat format["%1",_this];
	_key=_this select 1;
	//Holding CTRL?
	if (_key==29 or _key==157) then {vtsmapkeyctrl=false;};
	//Holding shift?
	if (_key==42 or _key==54) then {vtsmapkeyshift=false;};

	//Del key used
	if ((_key==14 or _key==211) && (vtsmapkeyshift or vtsmapkeyctrl)) then {[vts_gmmapcursorworldpos,radius] execvm "computer\console\delete.sqf";};
	if ((_key==14 or _key==211) && (!vtsmapkeyshift &&  !vtsmapkeyctrl)) then {[vts_gmmapcursorworldpos,radius,true] execvm "computer\console\delete.sqf";};
};

//Mouse Z change on map
vts_gmmapmousez=
{
	private ["_zmove"];
	//Then if ctrl is pressed, change radius
	//player sidechat format["%1",_this];
	_zmove=_this select 1;
	if (vtsmapkeyctrl) then
	{
		if (_zmove>0) then 
		{
			radius=[0,false] call vts_radiuschange;[] call updateradiusbuttons;
		};
		if (_zmove<0) then 
		{
			radius=[1,false] call vts_radiuschange;[] call updateradiusbuttons;
		};
		_vtsgmmapscale=vtsgmmapscale;
		_vtsgmmapcenterpos=vtsgmmapcenterpos;
		(_this select 0) ctrlMapAnimAdd [0, _vtsgmmapscale, _vtsgmmapcenterpos];
		ctrlMapAnimCommit (_this select 0);
	};
	
};

//Update gm map pos var
vts_gmmapstorepos=
{
	private ["_xi","_yi","_wi","_hi","_x","_y","_w","_h","_xdif","_ydif","_wdif","_hdif","_xpos","_ypos","_mappos"];
	_xi=getnumber (missionconfigfile >> "VTS_RscComputer" >> "controls" >> "Map" >> "x");
	_yi=getnumber (missionconfigfile >> "VTS_RscComputer" >> "controls" >> "Map" >> "y");
	_wi=getnumber (missionconfigfile >> "VTS_RscComputer" >> "controls" >> "Map" >> "w");
	_hi=getnumber (missionconfigfile >> "VTS_RscComputer" >> "controls" >> "Map" >> "h");
	
	_x=ctrlPosition (_this select 0) select 0;
	_y=ctrlPosition (_this select 0) select 1;
	_w=ctrlPosition (_this select 0) select 2;
	_h=ctrlPosition (_this select 0) select 3;
	
	
	_xdif=(_xi-_x);
	_ydif=(_yi-_y);
	_wdif=(_wi-_w);
	_hdif=(_hi-_h);
	
	
	//player sidechat format["%1 ",[_wdif,_hdif]];
	

	
    _xpos=0;
	_ypos=0;
	
	//Trying to fix the mapanim not working correctly after a map position scale changed :/ sigh
	if !(isnil "vts_cpuscaling") then
	{
		
		//_xpos=(_x-_xdif+_w-_wdif)-((_w+(_wdif))/2);
		//_ypos=(_y-_ydif+_h-_hdif)-((_h+(_hdif))/2);
		
		_ratiox=(vts_cpuscaling select 0);
		_ratioy=(vts_cpuscaling select 0)*(((SafezoneW)+(safezoneX))/((safezoneH)+(safezoneY)));
        _offestx=(vts_cpuscaling select 1)*(SafezoneW)+(safezoneX);
		_offesty=(vts_cpuscaling select 2)*(safezoneH)+(safezoneY);
		
		//_xpos=(_xi+_wi)-(_wi/2)*(SafezoneW*_ratiox)+(safezoneX*_ratiox);
		//_ypos=(_yi+_hi)-(_hi/2)*(safezoneH*_ratioy)+(safezoneY*_ratioy);
		
		//_xpos=_xpos+(_xpos*_ratiox);
		//_ypos=_xpos+(_xpos*_ratiox);
		
		
		//_xpos=_xpos*(SafezoneW * _ratiox)+(safezoneX * _ratiox);
		//_ypos=_ypos*(safezoneH * _ratioy)+( safezoneY * _ratioy);
		
		//_xpos=((_x+_w)-(_w/2))*(SafezoneW * _ratiox)+(safezoneX * _ratiox);
		//_ypos=((_y+_h)-(_h/2))*(safezoneH * _ratioy)+( safezoneY * _ratioy);
		_xpos=((_x+_w)-(_w/2))+(((_x+_w)-(_w/2))*((_wdif)))*(vts_cpuscaling select 0);
		_ypos=((_y+_h)-(_h/2))+(((_y+_h)-(_h/2))*((_hdif)))*((vts_cpuscaling select 0)*(((SafezoneW)+(safezoneX))/((safezoneH)+(safezoneY))));
		
				
		//player sidechat format["%1",[((_x+_w)-(_w/2)),_ypos,_xdif/100,_ydif/100]];
	}
	else
	{
		_xpos=(_x+_w)-(_w/2);
		_ypos=(_y+_h)-(_h/2);
	};
	
	
	
	
	_mappos=(_this select 0) ctrlMapScreenToWorld  [_xpos,_ypos];
	
	if (_mappos select 0!=0 && _mappos select 1!=0) then 
	{
		vtsgmmapcenterpos=_mappos;
		vtsgmmapscale=ctrlMapScale (_this select 0);
	};
	
};

//Return if the group (or leader when in fast mode) is inside or top of a building
vts_isgroupinbuilding=
{
	private ["_isinbuilding","_groupunits","_param","_groupnum"];
	_isinbuilding=false;
	_groupunits=units (_this select 0);
	_param="";
	if (count _this>1) then {_param=_this select 1;};
	if (_param=="FAST") then {_groupunits=[leader (_this select 0)];};
	
	_groupnum=0;
	
	{
		if (((vehicle _x) iskindof "Man") && (alive _x)) then
		{
			_objectsabove=lineIntersectsWith[[getposasl _x select 0,getposasl _x select 1,(getposasl _x select 2)+1],[getposasl _x select 0,getposasl _x select 1,(getposasl _x select 2)+10],_x,vehicle _x,true];
			_ceiling=false;
			if (count _objectsabove>0) then {if ((_objectsabove select 0) iskindof "Static" ) then {_ceiling=true;};};
			_posz=(getposatl _x) select 2;
			if (surfaceiswater (getposatl _x)) then {_posz=(getposasl _x) select 2;};
			
			if (((_posz>2.5) && (_posz<75)) or (_ceiling)) then
			{
			_groupnum=_groupnum+1;
			};
		};
	} foreach _groupunits;
	if (_groupnum>(({alive _x} count (_groupunits))/3)) then 
	{
		_isinbuilding=true;
		if (vtsai_debug) then {player sidechat "AI group in building !";};
	};
	_isinbuilding;
};


//Add eventhandlers (needed for player init or when class changed, Only run on first connection or player change class)
vts_addeventhandlers=
{
	private ["_unit"];
	_unit=_this select 0;
	_unit addMPEventHandler["mpkilled",
	{
		if ((name (_this select 0))!="Error: No unit") then
		{
			_ai="PLAYER ";
			if !(isplayer (_this select 1)) then 
			{
				_ai="AI "
			};
			_log=format["DEATH: %1 (%2) killed by %3 (%5%4)",name (_this select 0), Side group (_this select 0),name (_this select 1), Side group (_this select 1),_ai];
			if !(difficultyEnabled "DeathMessages") then
			{
				if ([player] call vts_getisGM) then 
				{
					if (gps_valid>0) then {player globalchat _log;};
				};
			};
			if (local (_this select 0)) then {_log call vts_addlog;};

		};
	}
	];
	
  //VTS Respawn +- revive
  if (pa_revivetype>0) then
  {
	if (isnil "vts_storeloadoutloop") then {vts_storeloadoutloop=[] spawn vts_respawn_storeloadoutloop;};
	[_unit] spawn vts_enablevtsrespawn;
  };
  //Basic respawn, still we need to save and reload loadout after respawn
  if (pa_revivetype==0) then
  {
	if (isnil "vts_storeloadoutloop") then {vts_storeloadoutloop=[] spawn vts_respawn_storeloadoutloop;};
	//Need to check loadout for respawn
	_unit addEventHandler ["killed", {[] spawn {waituntil{sleep 1;alive player};if !(isnil "vtsloadout") then {[] spawn {_lastloadout=vtsloadout;sleep 1;[player,_lastloadout] call vts_setloadout;};};};}]; 
  };
  
	if (pa_aiautomanage>0) then
	{
		[_unit] execvm "functions\ai_engaged.sqf";
	};
  
  if ([_unit] call vts_getisGM) then
  {
	_cpuaction=vehicle (_unit) addaction ["Computer (Teamswitch key)","Computer\cpu_dialog.sqf",player, 1, false, false,"","player in (crew (vehicle player))"];
	_unit addEventHandler ["Respawn", {cdkilled = execVM "computer\gm_killed.sqf"}] ;
  };
 
	//Activate Fast rope feature
	if (vts_FastRopeEnabled) then
	{
		[] call vts_fastrope;
		_unit addEventHandler ["Respawn", {[] call vts_fastrope;}];
	};
	//Activate Lifting feature
	if (vts_HelicopterLiftEnabled) then
	{  
		[] call vts_helicopterlift;
		_unit addEventHandler ["Respawn", {[] call vts_helicopterlift;}];
	};
	//Save loadout on death to apply it on respawn (not yet implemented correctly... Missing headgear etc, GG BIS)
	//_unit addEventHandler ["killed",{vtsloadout = [player] call vts_getloadout;}];
	
	if !(isnil "vts_spymode_active") then 
	{
		[(_this select 0),"Torn disguise",{_this call vts_spyremoveuniform},[],0,true,true,"",""] call vts_addaction;
		vts_spymode_active=(_this select 0) addEventHandler ["Respawn", {if !(isnil "vts_spymode_active") then {[(_this select 0),"Torn disguise",{_this call vts_spyremoveuniform},[],0,true,true,"",""] call vts_addaction;};}];
	};
};

//Addweapon and its magazine to the people from the specified side in the specified radius
vts_randomizeweapon=
{
	private ["_pos","_weapons","_vests","_unitside","_radius","_list"];
	_pos=_this select 0;
	_weapons=_this select 1;
	_vests=_this select 2;
	_unitside=_this select 3;
	_radius=_this select 4;
	
	//player sidechat format["%1",_weapons];
	//Now we got the primary weapons on the mission, let's unload and equip our units with the newsstuff;
	_list = [_pos,["CAManBase"],_radius] call vts_nearestobjects2d;
	
	for "_i" from 0 to ((count _list)-1) do
	{
		_unit=_list select _i;
		_sameside=(side _unit==_unitside);
		//player sidechat format["%1 for %2 : %3",_unitside,side _unit,_sameside];
		if (_sameside) then
		{
			if (local _unit && alive _unit && !(captive _unit)) then
			{			
				//Cleaning weapon & mag first
				if (primaryweapon _unit!="") then
				{
					_currentweapon=primaryweapon _unit;
					_currentmags=getarray (Configfile >> "CfgWeapons" >> _currentweapon >> "magazines");
					{_unit removeMagazines _x} foreach _currentmags;
					_unit removeweapon _currentweapon;
				};
				//IF Arma 3 check if they have a vest, if no, add one
				if (vtsarmaversion>2) then
				{
					//Usie call compile to avoid issue with those custom
					call compile " 
					if (vest _unit=="""") then
					{
						_newvest=_vests select (floor(random (count _vests)));
						_unit addvest _newvest;
					};
					";
				};
				//Adding the new weapon
				_newweapon=_weapons select (floor(random (count _weapons)));
				_newmags=getarray (Configfile >> "CfgWeapons" >> _newweapon >> "magazines");
				_unit addMagazine (_newmags select 0);
				_unit addweapon _newweapon;
				for "_i" from 0 to 7 do	{_unit addMagazine (_newmags select 0);};
				
				//Forcing switching to primaryweapon
				_unit selectWeapon _newweapon;
				_unit switchmove "";
			};

		};
	};	
};

//Retrieve a pos atop of something if detected (usefull for puting stuff on building, sea carrier etc...) return an ASL position
vts_SetPosAtop=
{
	private ["_pos","_buildingonly","_altitudemax","_step","_newpos","_buildings","_foundpos","_objignore"];
	//_start = diag_tickTime;
	_pos=_this select 0;
	//2D pos?
	if (count _pos<3) then {_pos=[_pos select 0,_pos select 1,0];};
	//Enforce 2D position so raycast is simpler to handle
	_pos=[_pos select 0,_pos select 1,0];
	//Check for top of building only or terrain (tree rocks etc)?
	_buildingonly=false;
	if (count _this>1) then {_buildingonly=_this select 1;};
	
	_altitudemax=20000;
	if (count _this>2) then {_altitudemax=_this select 2;};
	
	_step=0.25;
	if (count _this>3) then {_step=_this select 3;};
	
	_objignore=player;
	if (count _this>4) then {_objignore=_this select 4;};
	
	//Converting pos to ASL (used in line intersect)
	_newpos=_pos;
	if !(surfaceiswater _pos) then
	{
		_newpos=ATLToASL _pos;
	};
	
	//Checking if there is building at this position
	_buildings=lineIntersectsWith [[_newpos select 0,_newpos select 1,(_newpos select 2)+_altitudemax],[_newpos select 0,_newpos select 1,0],_objignore]; 
	if ((({_x iskindof "All"} count _buildings)<1) && _buildingonly) exitwith {_newpos;};
	
	
	//Being the check at the highest building (if present) to speed up the process (when building is high in the sky)
	if (count _buildings>0) then {_newpos=[_newpos select 0,_newpos select 1,(getposasl (_buildings select ((count _buildings)-1))) select 2];};
	
	_foundpos=[];
	//Detecting Z height if any
	for "_i" from _step to _altitudemax step _step do 
	{
		if (lineIntersects [[_newpos select 0,_newpos select 1,(_newpos select 2)+_altitudemax],[_newpos select 0,_newpos select 1,(_newpos select 2)+_i],_objignore] ) then
		{
			_foundpos=[_newpos select 0,_newpos select 1,(_newpos select 2)+_i];
		}
		else
		{
			_i=_altitudemax;
		};
	};
	if (count _foundpos>0) then
	{
		_newpos=[_foundpos select 0,_foundpos select 1,(_foundpos  select 2)+_step];
	};
	//_stop = diag_tickTime;
	//hint format ["%1",_stop - _start];
	_newpos;
};

//Retrive best pos for a floating object (get closest collision under and return it) so we can align it to the ground, return ASL pos
vts_GetPosOnCol=
{
	private ["_obj","_height","_pos","_newpos","_step","_loop","_nextpos","_curpos","_terrainheight","_heightrefobj"];
	_obj=_this select 0;
	_height=1;
	if (count _this>1) then {_height=_this select 1;};
	_step=0.1;
	if (count _this>2) then {_step=_this select 2;};
	_heightrefobj=_obj;
	if (count _this>3) then {_heightrefobj=_this select 3;};
	
	_pos=getposasl _obj;
	_posref=getposasl _heightrefobj;
	_terrainheight=getTerrainHeightASL _pos;
	_newpos=_pos;
	
	_curpos=[_pos select 0,_pos select 1,(_posref select 2)+_height];
	_n=0;
	_loop=true;
	while {_loop} do
	{
		 _n=_n+1;
		_nextpos=[_curpos select 0,_curpos select 1,(_curpos select 2)-_step];
		if ((lineIntersects [_curpos,_nextpos,_obj])) then
		{
			_newpos=_curpos;
			_loop=false;
		};
		if ((terrainIntersectASL [_curpos,_nextpos])) then
		{
			_newpos=_curpos;
			_loop=false;
		};	
		if ((_nextpos select 2)<=_terrainheight) then
		{
			_newpos=_curpos;
			_loop=false;
		};
		if ((_obj!=_heightrefobj) && ((_nextpos select 2)<=((_posref select 2)-_height))) then
		{
			_newpos=_curpos;
			_loop=false;
		};
		_curpos=_nextpos;		
	};
	//systemchat str _n;
	_newpos;
};

vts_tensionmusicplaying=
{
	private ["_n"];
	_n=count vtstensiontrack;
	vtstensiontrackpos=vtstensiontrackpos+1;
	if (vtstensiontrackpos>=_n) then {vtstensiontrackpos=0;};
	playmusic [((vtstensiontrack select vtstensiontrackpos) select 1),0.00];
	//_sleep=0.1;
	//sleep 1.0;
};

vts_gmmessage=
{
	private ["_gmtxt","_log"];
	_gmtxt=_this;
	_log=false;
	if ((typename _this)=="ARRAY") then
	{
		_gmtxt=_this select 0;
		if (count _this>1) then {_log=_this select 1;};
	};
	
	if (_gmtxt!="") then
	{	
		//No more needed with the hint displayed on camera
		/*
		if (((positionCameraToWorld [0,0,0]) distance player)<5) then 
		{
			hintSilent _gmtxt;
		}
		else
		{
			player globalchat ("[VTS] "+_gmtxt);
		};
		*/
		hintSilent _gmtxt;
		playsound ["computer",true];
	}
	else
	{
		//No "" else it break up display :(
		//hintSilent "";
		playsound ["computerok",true];
	};
	if (_log) then
	{
		_gmtxt call vts_addlog;
	};	
};

vts_tensionmusicgenerate=
{
	private ["_track","_tensiontrack02","_tensiontrack03","_tensiontrack04","_tensiontrack05","_tensiontrack06"];
	_track=_this select 0;
	
	
	_tensiontrack02=[[0,"tension01_01"]];
	_tensiontrack03=[[0,"tension02_01"]];
	_tensiontrack04=[[0,"tension03_02"],[0,"tension03_02"],[0,"tension03_01"]];
	_tensiontrack05=[[0,"tension04_01"],[0,"tension04_01"],[0,"tension04_02"],[0,"tension04_01"],[0,"tension04_02"],[0,"tension04_03"]];
	_tensiontrack06=[[0,"tension05_01"]];
	
	switch (_track) do
	{
		case ("vtsloopexplore01"): {vtstensiontrack=_tensiontrack05;};

	};
	
	vtstensiontrackpos=0;
	publicvariable "vtstensiontrack";
	publicvariable "vtstensiontrackpos"
};

vts_playtensionmusic=
{
	private ["_track","_playall","_code"];
	//hint "Now playing a looping tension track on all players";
	_track=_this select 1;
	_playall=_this select 0;
	[_track] call vts_tensionmusicgenerate;
	_code={};
	//Loop only available for Arma 3 using call compile to avoid script load error on Arma 2
	if (vtsarmaversion>2) then
	{
	call compile "
	_code={
		removeAllMusicEventHandlers ""MusicStop"";
		0 fademusic 1;
		playmusic [((vtstensiontrack select 0) select 1),0.00];
		addMusicEventHandler [""MusicStop"",{[] call vts_tensionmusicplaying;}];
		
	}
	";
	}
	else
	{
		0 fademusic 1;
		playmusic [((vtstensiontrack select 0) select 1),0.00];
	};
	if (_playall) then
	{
		hint format["Now loop playing : %1 on all players",Musicvalid];
		[_code] call vts_broadcastcommand;
	}
	else
	{
		[] spawn _code;
	};
};

vts_playmusicall=
{
	3 fademusic 0;
	//New method for loops
	if  ([Musicvalid,"vtsloop"] call KRON_StrInStr) then
	{
		[true,Musicvalid] call vts_playtensionmusic;
	}
	else
	{
		//Old method, using a trigger to run the music
		if (console_valid_music > 1) then 
		{
			(format["Now playing : %1 on all players",Musicvalid]) call vts_gmmessage;
		};
		if (console_valid_music == 1) then 
		{
		hint "Music stop : on all players";
		};
		
		_code={};
		call compile format["
		_code=
		{
		if (vtsarmaversion>2) then
		{
			""removeAllMusicEventHandlers """"MusicStop"""";"" call vts_C;
		};
		0.5 fademusic 0;
		sleep 0.5;
		playmusic [""%1"",0];
		3 fademusic 1;
		};",Musicvalid];
		
		[_code] call vts_broadcastcommand;
	};
};

vts_numberprecision=
{
	private ["_num","_reduce"];
	_num=_this select 0;
	_reduce=10^(_this select 1);
	_num=(round(_num* _reduce))/_reduce;
	_num;
};
vts_numbertotext=
{
	private ["_numberText"];
	_numberText=[_this select 0] call SPON_formatNumber;
	_numberText;
};

vts_getloadout=
{
	private ["_unittogetloadout","_loadout"];
	_unittogetloadout=_this select 0;
	_loadout=[];
	if (vtsarmaversion>2) then 
	{
	_loadout=[_unittogetloadout,["repetitive"]] call compile preprocessFileLineNumbers "functions\get_loadout.sqf";
	}
	else
	{
	_loadout=[weapons _unittogetloadout,magazines _unittogetloadout];
	};
	_loadout;
};

vts_setloadout=
{
	private ["_unittoload","_loadout","_posasl"];
	_unittoload=_this select 0;
	_loadout=_this select 1;
	_waitloadoutscriptdone=false;
	if (count _this>2) then {_waitloadoutscriptdone=_this select 2;};
	_posasl=getposatl _unittoload;
	if (vtsarmaversion>2) then 
	{	
		vtsscriptsetloadout=[_unittoload,_loadout] execVM "functions\set_loadout.sqf"; 
		
		_checkpos={
		_pos=_this select 0;
		_unit=_this select 1;
		_script=_this select 2;
		
		_time=time+2;
		waituntil {(time>_time) or (scriptdone _script)};
		_unit setposatl _pos;
		};
		[_posasl,_unittoload,vtsscriptsetloadout] spawn _checkpos;
		if (_waitloadoutscriptdone) then {waituntil {scriptdone vtsscriptsetloadout};};
	}
	else
	{
		removeAllWeapons _unittoload;
		{
			_unittoload addmagazine _x;
		} foreach (_loadout select 1);
		{
			_unittoload addweapon _x;
		} foreach (_loadout select 0);
	};		
	
};


vts_getchildren={
	private ["_obj","_var","_array"];
	_obj=_this select 0;
	_array=[];
	_var=_obj getvariable "vts_children";
	if (!isnil "_var") then 
	{
		if (count _var>0) then {_array=_var;};
	};
	_array
};

vts_setchild=
{
	private ["_obj","_child","_var","_array"];
	_obj=_this select 0;
	_child=_this select 1;
	_var=_obj getvariable "vts_children";
	_array=[];
	if !(isnil "_var")	then {_array=_var;};
	_array set [count _array,_child];
	_obj setvariable ["vts_children",_array,true];
};

vts_updatenamefilter=
{
	private ["_filter","_txt"];
	_filter=ctrlText 10046;
	_txt="";
	if (_filter=="") then 
	{
		_txt="Filter disabled";
	}
	else
	{
		_txt=format["Filter set to : %1",_filter],
	};
	 _txt spawn vts_gmmessage;
	[0] execVM "computer\console\boutons\console_valid_type.sqf";
};

updateradiusbuttons=
{
  ctrlSetText [10904, format ["Radius %1 >",local_radius]];
  ctrlSetText [10400, format ["Del (%1m)",local_radius]];
  ctrlSetText [10398, format ["Fill with cur. side(%1m)",local_radius]];
  ctrlSetText [10044, format ["Destroy buildings (%1m)",local_radius]];
  ctrlSetText [10045, format ["Kill everything (%1m)",local_radius]];
  ctrlSetText [10394, format ["Roads (%1m)",local_radius]];
  ctrlSetText [10917, format ["Weap. (%1m)",local_radius]];
  //ctrlSetText [10900, format ["Populate with civs.(%1m)",local_radius]];
  _r=round(local_radius/10); if (_r<1) then {_r=1;};
  ctrlSetText [10049, format ["Artillery : %1 shells",_r,local_radius]];
  ctrlSetText [10920, format ["Ammunition spawn x%1",_r,local_radius]];
  ctrlSetText [10905, format ["Civ (%1m)",local_radius]];
  ctrlSetText [10923, format ["Remove deads (%1m)",local_radius]];
};

vts_setskill=
{
	private ["_unittoskill","_skilltoset","_minaimacc","_maxaimacc","_finalaimacc","_minaishake","_maxaishake","_finalaishake"];
	_unittoskill=_this;
	_skilltoset=console_unit_moral;
		
	
	if (typename _this=="ARRAY") then 
	{
		_unittoskill=_this select 0;
		if (count _this>1) then {_skilltoset=_this select 1;};
	};
	
	//player sidechat format["%1 to %2",_skilltoset,_unittoskill];
	//Toying with skill global then :
	//aimshake to make them spread more like a player aim
	//Courage to make them more reactive
	//Commanding to make them more cover efficient
	
	//player sidechat format["%1",_skilltoset];
	_unittoskill setvariable["vts_skillset",_skilltoset,true];
	
	_unittoskill setskill _skilltoset;
	
	_minaishake=0.05;
	_maxaishake=0.2;	
	_finalaishake=(_minaishake+(_skilltoset*((_maxaishake-_minaishake))))*(vts_aiaccuracymodifier/100);
	//player sidechat str _maxaishake;
	
	_minaimacc=0.1;
	_maxaimacc=0.5;	
	_finalaimacc=(_minaimacc+(_skilltoset*((_maxaimacc-_minaimacc))))*(vts_aiaccuracymodifier/100);	
	//player sidechat str _finalaimacc;
	
	_unittoskill setskill ["aimingAccuracy",_finalaimacc];
	_unittoskill setskill ["aimingShake",_finalaishake];
    _unittoskill setskill ["aimingSpeed",_finalaishake];

	//_unittoskill setskill ["general",_skilltoset];
	
    //_unittoskill setskill ["endurance",_skilltoset];
    //_unittoskill setskill ["spotDistance",_skilltoset];
    //_unittoskill setskill ["spotTime",_skilltoset];
    _unittoskill setskill ["courage",0.5+(_skilltoset/2)];
    //_unittoskill setskill ["reloadSpeed",_skilltoset];
    _unittoskill setskill ["commanding",0.5+(_skilltoset/2)];
		
};

vts_waitloadingclassinfo={

  while {isnil "vtsdataloaded"} do
  {
  ["Loading Game Data, please wait...", [1, 1, 1, 1], "taskcurrent",1] call vts_taskhint;
  sleep 5.0;
  };
  
  ["Game Data Loaded. Have Fun", [1, 1, 1, 1], "taskcurrent",1] call vts_taskhint;
  //"" spawn vts_gmmessage;
};

vts_taskhint=
{
	private ["_txt","_color","_type","_time"];
	_txt=_this select 0;
	_color=_this select 1;
	_type=_this select 2;
	_time=5;
	if (count _this>3) then {_time=_this select 3;};
	if (vtsarmaversion<3) then 
	{
		taskhint [_txt,_color,_type];
	}
	else
	{
		_type=tolower _type;
		switch (_type) do
		{
			case ("tasknew") : {_type="TaskCreated";};
			case ("taskcurrent") : {_type="TaskUpdated";};
			case ("taskdone") : {_type="TaskSucceeded";};
			case ("taskfailed") : {_type="TaskFailed";};			
		};
		[_type,["",_txt]] call bis_fnc_showNotification;
	};
};

vts_getisGM=
{
   private ["_object","_isDM"];
  
  if !(hasinterface) exitwith {false;};
  //Everybodys GM?
  if (pa_alloweveryonedms==1) exitwith {true;};
  //Admins
  if (!(isserver) && ( (serverCommandAvailable "#kick") or (missionNamespace getvariable ["vts_isallowedgm",false]) ) ) exitwith {true;};
  
  //Else...
  
  
  _object=_this select 0;
  _isDM=false;
  
  //GM unit
  if !(isnil "user1") then
  {
	  if (_object==user1)  then {_isDM=true;};
	  
	  //GM in a control of another unit
	  _gmable=_object getvariable "GMABLE";
	  if ((_object!=user1) and !(isnil "_gmable")) then {_isDM=true;};

	  //Debug test as player
	  //_isDM=false;  
  };
  if !(isnil "user2") then
  {
	  if (_object==user2)  then {_isDM=true;};
	  
	  //GM in a control of another unit
	  _gmable=_object getvariable "GMABLE";
	  if ((_object!=user2) and !(isnil "_gmable")) then {_isDM=true;};

	  //Debug test as player
	  //_isDM=false;  
  };  
  _isDM;
};
if (isserver) then {publicvariable "vts_getisGM";};

vts_destroyterrain=
{
	private ["_pos","_rad","_sync","_n","_distancemin","_objs","_validobjs"];
	if !(isserver) exitwith {};
    _pos=_this select 0;
    _rad=_this select 1;
    _sync=_this select 2;
	_n=0;
	
	_distancemin=0;
	
    _objs=nearestObjects [_pos,[],_rad];
	_validobjs=[];
	
	/*
	_lastposobj=[0,0,0];
	for "_i" from 0 to (count _objs)-1 do
	{
		_obj=_objs select _i;
		_curpos=getposatl _obj;
		if ((_curpos distance _lastposobj)>_distancemin) then
		{
			_validobjs set [count _validobjs,_obj];
			
		};
		_lastposobj=_curpos;
	};
	*/
	_validobjs=_objs;
	
    {
		
	   if (!(_x isKindOf "AllVehicles") && !(_x isKindof "ReammoBox")) then 
	   {
			  
			  _posobj=getposatl _x;
			  _hitpart=[];
			  _destype="";
			  if (isclass (configfile >> "cfgvehicles" >> (typeof _x)))  then 
			  {
				_hitpart=getArray(configfile >> "cfgvehicles" >> (typeof _x) >> "replacedamagedhitpoints");
				_destype=gettext(configfile >> "cfgvehicles" >> (typeof _x) >> "destrtype");
			  };
			  
			  /*
			  if (count _hitpart<1) then {_x setdamage 1;};
			  
			  if ((count _hitpart>0) && (_sync)) then
			  {
				  for "_i" from 0 to (count _hitpart)-1  do 
					{
						_part=gettext (configfile >> "cfgvehicles" >> (typeof _x) >> "HitPoints" >> (_hitpart select _i) >> "convexcomponent");
						_x sethit [_part,1];
					};
			  };
			  */
			  _destroy=false;
			  
			  if (_n mod 40==0) then {_destroy=true;};
			  if ((count _hitpart>0) or (_destype=="DestructDefault")) then {_destroy=true;};
			  if ((_n mod 5==0) && (_destype=="DestructTree" or _destype=="DestructWall")) then {_destroy=true;};
			  
			  if (_destroy) then
			  {
				  _explo=["LaserBombCore",1,false];
				  if ((count _hitpart>0) or (_destype=="DestructDefault")) then {_explo=["BombCore",5,false];};
				  for "_n" from 1 to (_explo select 1) do
				  {
				  _ex=(_explo select 0);
				  _bo=_ex createVehicle _posobj;
				  _bo setposatl _posobj;
				  if !(_explo select 2) then
					{
						_bo setVelocity [0,0,-10];
					}
					else
					{
						_bo setdamage 1;
					};
				  };
			  };	
			  
			if ((isserver) && (round(random 10)==10)) then 
			{
			_crater = vts_crater createVehicle _posobj;
			//_crater setdir (random 360);
			};	
			_n=_n+1;
			
		};
			
    } foreach _validobjs;
	


    
    if (isserver && _sync) then 
    {
      if (isnil "syncdestroyed") then {syncdestroyed=[];};
      syncdestroyed=syncdestroyed+[[_pos,_rad]];publicvariable "syncdestroyed";
    };
};		
if (isserver) then {publicvariable "vts_destroyterrain";};		

vts_syncdestroyedterrain=
{
	private ["_num"];
  if (isnil "syncdestroyed") exitwith {};
  _num=(count syncdestroyed)-1;
  
  for [{_x=0},{_x<=_num},{_x=_x+1}] do
  {
    _boom=syncdestroyed select _x;
    _pos=_boom select 0;
    _rad=_boom select 1;
    [_pos,_rad,false] call vts_destroyterrain;
  };

};
if (isserver) then {publicvariable "vts_syncdestroyedterrain";};	

vts_radiuschange=
{
	private ["_radius","_incr","_cap","_brushsizemin","_brushsizemax","_radmax","_radmin"];
_radius=0;
_incr=_this select 0;
_cap=false;
_brushsizemin=5;
_brushsizemax=2500;

_radmax=_brushsizemax;
_radmin=_brushsizemin;
//Cap max radius to avoid loop (for shortcut)
if ((count _this) >1) then {_radmax=_brushsizemin;_radmin=_brushsizemax;};
//Less
if (_incr==0) then
{
  switch (radius) do
  {
  case 5:{_radius=_radmax};
  case 15:{_radius=5};
  case 25:{_radius=15};
  case 50:{_radius=25}; 
  case 75:{_radius=50};
  case 100:{_radius=75};
  case 175:{_radius=100};
  case 250:{_radius=175};
  case 500:{_radius=250};
  case 800:{_radius=500}; 
  case 1200:{_radius=800};
  case 1800:{_radius=1200};
  case 2500:{_radius=1800};
  };
}
//More
else
{
  switch (radius) do
  {
  case 5:{_radius=15};
  case 15:{_radius=25};
  case 25:{_radius=50};
  case 50:{_radius=75};
  case 75:{_radius=100}; 
  case 100:{_radius=175};
  case 175:{_radius=250};
  case 250:{_radius=500};
  case 500:{_radius=800};
  case 800:{_radius=1200}; 
  case 1200:{_radius=1800}; 
  case 1800:{_radius=2500}; 
  case 2500:{_radius=_radmin};
  };
};
	//Update marker if existing
	"vtsbrush" setmarkersizelocal [_radius,_radius];	
if (_radius==0) then {_radius=radius;};
//Using another radius for spawn & patrol (to avoid conflict between radius when the host is also a player)
local_radius=_radius;
_radius;
};

vts_deletevehicle={
	private ["_todel","_deadonly","_save","_children","_x"];
  _todel=_this select 0;
  _deadonly=false;
  if (count _this >1) then {_deadonly=_this select 1;};
  
  if (!(_deadonly) or (_deadonly && !(alive _todel))) then
  {
	  _save=_todel getvariable ["vtsmissionpreset_i",-1];
	  if (_save>-1) then 
	  {
		call compile ("vtsmissionpreset_"+(str _save)+"=nil;publicVariable ""vtsmissionpreset_"+(str _save)+""";");
	  };
	  
	  _children=[_todel] call vts_getchildren;
	  if (count _children>0) then
	  {
		{
			switch true do
			{
			case (typename _x=="OBJECT"): {deleteVehicle _x;};
			case (typename _x=="STRING"): {deletemarker _x;deletemarkerlocal _x;};
			};
		} foreach _children;
	  };
	  //Don't delete player (now we can in arma3)
	  deleteVehicle _todel;
	};
};

//Return an networkable array (no var, only text & number)
vts_getspawnsetuparray={
	private ["_array","_checklocality"];
	_checklocality=false;
	if (count _this > 0) then {_checklocality=_this select 0;};
	_array=[_checklocality] call vts_storespawnsetup;
	call compile format["_array=%1;",_array];
	//hint format["%1",_array];
	_array;
};

//Get current spawn setup
vts_storespawnsetup={
   private ["_spawntype","_checklocality","_currentspawnsetup"];
	_spawntype=0;
	if !(isnil "var_console_valid_type") then {if (var_console_valid_type=="Building") then {_spawntype=2;};};
	_checklocality=true;
	if (count _this>0) then {_checklocality=_this select 0;};
	//If the server is also a player, we use it's local var to avoid conflict with spawn from other GMs
	
	if ((isserver) && !(isDedicated) && (_checklocality)) then 
	{
		if !(isnil "local_From3D") then {From3D=local_From3D;};
		if !(isnil "local_var_console_valid_side") then {var_console_valid_side=local_var_console_valid_side;};
        if !(isnil "local_var_console_valid_camp") then {var_console_valid_camp=local_var_console_valid_camp;};
		if !(isnil "local_var_console_valid_type") then {var_console_valid_type=local_var_console_valid_type;};
        if !(isnil "local_console_unit_unite") then {console_unit_unite=local_console_unit_unite;};
		if !(isnil "local_console_valid_unite") then {console_valid_unite=local_console_valid_unite;};
        if !(isnil "local_var_console_valid_attitude") then {var_console_valid_attitude=local_var_console_valid_attitude;};
        if !(isnil "local_var_console_valid_vitesse") then {var_console_valid_vitesse=local_var_console_valid_vitesse;};
        if !(isnil "local_var_console_valid_mouvement") then {var_console_valid_mouvement=local_var_console_valid_mouvement;};
        if !(isnil "local_console_unit_moral") then {console_unit_moral=local_console_unit_moral;};
        if !(isnil "local_var_console_valid_formation") then {var_console_valid_formation=local_var_console_valid_formation;};
        if !(isnil "local_console_unit_orientation") then {console_unit_orientation=local_console_unit_orientation;};
        if !(isnil "local_radius") then {radius=local_radius;};
        if !(isnil "local_spawn_x") then {spawn_x=local_spawn_x;};
		if !(isnil "local_spawn_y") then {spawn_y=local_spawn_y;};
		if !(isnil "local_spawn_z") then {spawn_z=local_spawn_z;};
        if !(isnil "local_spawn_x2") then {spawn_x2=local_spawn_x2;};
		if !(isnil "local_spawn_y2") then {spawn_y2=local_spawn_y2;};
		if !(isnil "local_spawn_z2") then {spawn_z2=local_spawn_z2;};
        if !(isnil "local_console_nom") then {console_nom=local_console_nom;};
        if !(isnil "local_console_init") then {console_init=local_console_init;};
		if !(isnil "local_vts3DAttach") then {vts3DAttach=local_vts3DAttach;};
	};
	
	
    _currentspawnsetup=[_spawntype,
                        From3D,
                        var_console_valid_side,
                        var_console_valid_camp,
                        var_console_valid_type,
                        console_unit_unite,
                        console_valid_unite,
                        var_console_valid_attitude,
                        var_console_valid_vitesse,
                        var_console_valid_mouvement,
                        console_unit_moral,
                        var_console_valid_formation,
                        round(console_unit_orientation),
                        radius,
                        [spawn_x,spawn_y,spawn_z],
                        [spawn_x2,spawn_y2,spawn_z2],
                        console_nom,
                        [console_init,"""",""""""]call KRON_Replace,
						vts3DAttach
                        ];       

  _currentspawnsetup;  

}; 

//Restore a spawn setup (logically, not in the interface)
vts_restorespawnsetup={
  private ["_cur"];
  _cur=_this select 0;
  
  From3D=_cur select 1;
  var_console_valid_side=_cur select 2;
  var_console_valid_camp=_cur select 3;
  var_console_valid_type=_cur select 4;
  console_unit_unite=_cur select 5;
  console_valid_unite=_cur select 6;
  var_console_valid_attitude=_cur select 7;
  var_console_valid_vitesse=_cur select 8;
  var_console_valid_mouvement=_cur select 9;
  console_unit_moral=_cur select 10;
  var_console_valid_formation=_cur select 11;
  console_unit_orientation=_cur select 12;
  radius=_cur select 13;
  spawn_x=(_cur select 14) select 0;
  spawn_y=(_cur select 14) select 1;
  spawn_z=(_cur select 14) select 2;
  spawn_x2=(_cur select 15) select 0;
  spawn_y2=(_cur select 15) select 1;
  spawn_z2=(_cur select 15) select 2;
  console_nom=_cur select 16;
  console_init=[_cur select 17,"""""",""""] call KRON_Replace;
  vts3DAttach=false;
  if (count _cur>18) then {vts3DAttach=_cur select 18;};
 
};

//Add action function
//Remove the action after use (Object removeAction (_this select 2);) when _this is the argument sent to the script
vts_AddAction={

  private ["_object","_action","_script","_arguments","_priority","_showWindow","_hideOnUse","_shortcut","_condition"];
  _object=_this select 0;
  _action=_this select 1;
  _script=_this select 2;
  if (count _this > 3) then {_arguments = _this select 3};
  if (count _this > 4) then {_priority = _this select 4};
  if (count _this > 5) then {_showWindow = _this select 5};
  if (count _this > 6) then {_hideOnUse = _this select 6};
  if (count _this > 7) then {_shortcut = _this select 7};
  if (count _this > 8) then {_condition = _this select 8};
  if (isNil "_arguments") then {_arguments = []};
  if (isNil "_priority") then {_priority = 100};
  if (isNil "_showWindow") then {_showWindow = TRUE};
  if (isNil "_hideOnUse") then {_hideOnUse = TRUE};
  if (isNil "_shortcut") then {_shortcut = ""};
  if (isNil "_condition") then {_condition = "TRUE"};

  //player sidechat "addaction";
  _action = _object addaction [_action,"functions\vts_addaction.sqf",_arguments,_priority,_showWindow,_hideOnUse,_shortcut,_condition];
  _object setvariable [format["vtsaction_%1",_action],_script,true]; 
  _action;
};
if (isserver) then {publicvariable "vts_AddAction";};

//Execute action function
vts_ExecuteAction={
	private ["_object","_caller","_id","_script"];
  //hint format["%1",_this];
  _object=_this select 0;
  _caller=_this select 1;
  _id=_this select 2;
  
  _script=_object getVariable (format["vtsaction_%1",_id]);
  _this call _script; 
};

//Create a hostage behavior Local to the hostage
vts_isHostagebehavior={
	private ["_hostage","_loop","_help"];
	_hostage=_this select 0;
	_loop=true;
	_help=false;
	_hb=0;
	while {(!isnull _hostage) and (alive _hostage) and (_loop)} do
	{
	
	    //_hostage action ["Surrender",_hostage]; 
		if (((eyepos _hostage select 2)-(getposasl _hostage select 2))>1.5 && (_hb>0)) then {_hostage playactionnow "sitdown";};
		if !(captive _hostage) then {_loop=false;};
		/*
		{
		   if (!isnull _x) then
		   {
		   //player sidechat format["%1",(_hostage knowsabout _x)];
			if (((_hostage knowsabout _x)>3) && (!captive _x) && ( (_hostage getVariable "vts_unitside") getFriend (side _x)>=0.6)) then 
			  {	
				
				if !(isplayer (leader group _hostage)) then
				{
					_help=true;
				};
				_loop=false;
				
			  };


		  };
		} foreach playableUnits;
		*/
		//hint "hostage";

		sleep 3;
		/*
		if (isplayer (leader group _hostage)) then
		{
			_loop=false;
		};
		*/
		//New check on follow since hostage stay captive what ever happen now
		if !(isnull (_hostage getvariable ["vts_dofollow",objnull])) then
		{
			_loop=false;
		};
		_hb=_hb+1;
	};
	if ((alive _hostage) and (!isnull _hostage)) then 
	{
		vtsunituptaded=_hostage;
		_code="";
		if (_help) then
		{
			_code=_code+"
			vtsunituptaded sidechat ""Help me !"";
			if (local vtsunituptaded) then 
			{
				_newgroup = creategroup (vtsunituptaded getVariable ""vts_unitside"");
				[vtsunituptaded] joinsilent _newgroup;
			};
			";
		};
		_code=_code+"
		vtsunituptaded setBehaviour ""COMBAT"";
		vtsunituptaded setcaptive true;
		vtsunituptaded forcespeed -1;
		vtsunituptaded playactionnow ""gear"";
		vtsunituptaded switchmove """";
		";
		call compile format["_code={%1};",_code];
		publicvariable "vtsunituptaded";
		[_code] call vts_broadcastcommand;
	};
};


vts_isHostage={
	private ["_hostage","_typeof"];
  _hostage=_this select 0;
  _typeof=typeof _hostage;
  if !(_typeof iskindof "Man") exitwith {if ([player] call vts_getisGM) then {"!!! Hostage Fail : Object is not a Man !!!" call vts_gmmessage;};};
  if (local _hostage) then {	_hostage setVariable ["vts_unitside",(side group _hostage),true];};
  _hostage allowFleeing 0;
  _hostage setcaptive true;
  removeAllWeapons _hostage;
  _hostage setBehaviour "CARELESS";
  _hostage disableai "FSM";
  _hostage addMPEventHandler ["MPkilled","if (isserver) then {format[""INFO : Hostage killed : %1 by %2 "",name (_this select 0),name (_this select 1)] call vts_addlog;};if ([player] call vts_getisGM) then {hintc format[""INFO : Hostage killed : %1 by %2 "",name (_this select 0),name (_this select 1)]} else {hint format[""%1 has been killed"",name (_this select 0)];};"];
  [_hostage,"""Follow Me""",{[(_this select 0)] joinsilent grpnull;(_this select 1) playactionnow "gesturefollow";(_this select 1) groupchat "Follow me";(_this select 0) setvariable ["vts_dofollow",(_this select 1),true];(_this select 0) forcespeed -1;(_this select 0) setcaptive true;},[],100,true,true,"","alive _target"] call vts_addaction;
  [_hostage,"""Stay here""",{(_this select 1) playactionnow "gestureFreeze";(_this select 1) groupchat "Stay here";(_this select 0) setvariable ["vts_dofollow",objnull,true];(_this select 0) forcespeed 0;},[],100,true,true,"","alive _target"] call vts_addaction;
  _hostage forcespeed 0;
  //Behavior
  if (local _hostage) then 
  {
	[_hostage] spawn vts_isHostagebehavior;
	[_hostage] spawn vts_Isfollowing;
	/*
	[_hostage] spawn {
		_hostage=_this select 0;
		waituntil {sleep 3;unitready _hostage};
		_hostage playactionnow "sitdown";
		}
		*/
	};
  
  if ([player] call vts_getisGM) then {"Hostage unit created" call vts_gmmessage;};
};
if (isserver) then {publicvariable "vts_isHostage";};

vts_isVIPtoCaptureCheck=
{
	private ["_type","_unit","_arround","_pos","_surrender","_control","_around","_i","_fcontrol","_ocontrol","_o","_distance","_firer","_flos","_olos","_loop"];
	_unit=_this select 0;
	_surrender=false;
	_loop=true;
	
	while {alive _unit && _loop && !(_unit getvariable ["vts_capturevipok",false])} do
	{
		_flos=false;
		_olos=false;
		_control=[0,0];
		_around=(position _unit) nearEntities  ["CAManBase",20];
		for "_i" from 0 to (count _around)-1 do
		{
			_o=_around select _i;
			if (alive _o) then
			{
				_fcontrol=0;
				_ocontrol=0;
				if ((side group _o) getfriend (side group _unit)<0.6) then 
				{					
					if ([_o,_unit] call vts_CanSee) then
					{
						_olos=true;
						_ocontrol=1-(damage _o);
						if ([_unit,_o] call vts_isfacing) then {_flos=true;};
					};
				}
				else 
				{
					if !(lineIntersects [eyepos _o,eyepos _unit,vehicle _o,vehicle _unit]) then
					{
						_fcontrol=1-(damage _o);
					};
				};
				_distance=(_unit distance _o); 
				switch (true) do
				{
					case (_distance<=10) : {_ocontrol=_ocontrol*3;_fcontrol=_fcontrol*3;};
					case (_distance<=20) : {_ocontrol=_ocontrol*2;_fcontrol=_fcontrol*2;};
					default {_ocontrol=_ocontrol*1;_fcontrol=_fcontrol*1;};
				};
				_control=[(_control select 0)+_fcontrol,(_control select 1)+_ocontrol];
				
			};
		};
		_control=[(_control select 0)-(damage _unit),(_control select 1)];
		if (vts_debug) then {systemchat str _control;};

		if (((_control select 1)>(_control select 0)) && _olos && _flos) then
		{
			_loop=false;
		};
		sleep 2;
	};
	
	_surrender=true;
	if (_surrender) then
	{
		_unit setvariable ["vts_capturevipok",true,true];	
		moveout _unit;
		_unit setcaptive true;
		if (alive _unit) then
		{
			_pos=getposatl _unit;
			_ground=createVehicle [vts_weaponholder, _pos, [], 0, "NONE"];
			_ground setposatl _pos;
			_weaps=weapons _unit;
			for "_i" from 0 to (count _weaps)-1 do
			{
			_item=_weaps select _i;
			_ground addweaponcargoglobal [_item,1];
			};
			_mags=magazines _unit;
			for "_i" from 0 to (count _mags)-1 do
			{
			_item=_mags select _i;
			_ground addmagazinecargoglobal [_item,1];
			};			
			removeallweapons _unit;
			removeallitems _unit;
			_unit setunitpos "down";
			_unit forcespeed 0;
			dostop _unit;
			//_unit disableai "FSM";
			_unit setBehaviour "CARELESS";
		};
	};
};

vts_isVIPtoCaptureCheckNeutralize=
{
	private ["_b","_target","_interact"];
	_target=_this select 0;
	_interact=_this select 1;
	_b=false;
	if !(alive _target) exitwith {_b;};
	if !(_target getvariable ["vts_capturevipok",false]) then 
	{
		if ((_target distance _interact)<3) then 
		{
			if !(lineIntersects [(eyepos _target),(eyepos _interact)]) then
			{
				_b=true;
			};
		};
	};
	_b;
};

vts_isVIPtoCapture={
	private ["_hostage","_typeof"];
  _hostage=_this select 0;
  _typeof=typeof _hostage;
  if !(_typeof iskindof "Man") exitwith {if ([player] call vts_getisGM) then {"!!! HVT to capture Fail : Object is not a Man !!!" call vts_gmmessage;};};
  if (local _hostage) then {	_hostage setVariable ["vts_unitside",(side group _hostage),true];};
  _hostage addMPEventHandler ["MPkilled","if (isserver) then {format[""INFO : VIP killed : %1 by %2 "",name (_this select 0),name (_this select 1)] call vts_addlog;};if ([player] call vts_getisGM) then {hintc format[""INFO : VIP killed : %1 by %2 "",name (_this select 0),name (_this select 1)]} else {hint format[""%1 has been killed"",name (_this select 0)];};"];
  [_hostage,"""Follow Me""",{[(_this select 0)] joinsilent grpnull;(_this select 1) playactionnow "gesturefollow";(_this select 1) groupchat "Follow me";(_this select 0) setvariable ["vts_dofollow",(_this select 1),true];(_this select 0) forcespeed -1;(_this select 0) setcaptive true;},[],100,true,true,"","alive _target && (_target getvariable [""vts_capturevipok"",false])"] call vts_addaction;
  [_hostage,"""Stay here""",{(_this select 1) playactionnow "gestureFreeze";(_this select 1) groupchat "Stay here";(_this select 0) setvariable ["vts_dofollow",objnull,true];(_this select 0) forcespeed 0;},[],100,true,true,"","alive _target && (_target getvariable [""vts_capturevipok"",false])"] call vts_addaction;
  [_hostage,"Neutralize",{(_this select 0) setvariable ["vts_capturevipok",true,true];(_this select 1) playActionNow "ThrowGrenade";},[],100,true,true,"","[_target,_this] call vts_isVIPtoCaptureCheckNeutralize"] call vts_addaction;
  //Behavior
  if (local _hostage) then 
  {
	[_hostage] spawn vts_isVIPtoCaptureCheck;
	[_hostage] spawn vts_Isfollowing;
  }; 
  if ([player] call vts_getisGM) then {"VIP to capture created" call vts_gmmessage;};
};
if (isserver) then {publicvariable "vts_isVIPtoCapture";};

//Create a IED behavior
vts_isIEDBehavior={
	private ["_IED","_loop","_dist"];
  _IED=_this select 0;
  _IED setvariable ["vts_IEDEnabled",true,true];
  _loop=true;
  _dist=7.5+random(10);
  while {(!isnull _IED) and (_IED getvariable "vts_IEDEnabled") and (_loop)} do
  {
  
    {
       if !(isnull _x) then
       {
        if (((speed _x)>6) and ((_IED distance vehicle _x)<_dist) and (!captive _x)) then 
          {
            [_IED] call vts_isIEDExplosion;
            _loop=false;
            
          };

      };
    } foreach playableUnits;
  //hint "hostage";
  sleep 2.5;
  };
  
};


vts_isIEDExplosion={
	private ["_IED"];
  _IED=_this select 0;
  if (_IED getvariable "vts_IEDEnabled") then 
  {
    //Kaboom
    //hint "kaboom";
    _IED setvariable ["vts_IEDEnabled",false,true];
    _bomb=vts_lowexplosive;
    _bombrandom=random(10);
    if (_bombrandom>5) then {_bomb=vts_mediumexplosive;};
    if (_bombrandom>8) then {_bomb=vts_highexplosive;};
    _kaboom= _bomb createvehicle (getpos _IED);    
	_kaboom setposatl (getposatl _IED);
	_kaboom setvelocity [0,0,-1];
	_kaboom setVectorup [0,10000,1]
  };
};


vts_isIEDDisable={
  
  private ["_IED","_target","_script","_success"];
  _IED=_this select 0;
  _target=_this select 1;
  _success=2;
  if ( (getnumber (configfile >> "CfgVehicles" >> (typeof _target) >> "candeactivatemines") )<1) then {_success=floor(random 3);};
  if (_success>1) then
  {
	  _IED removeAction (_this select 2);  
	  _target action ["RepairVehicle",_target];
	  if (_IED getvariable "vts_IEDEnabled") then
	  {
		_IED setvariable ["vts_IEDEnabled",false,true];
		hint "Explosive device disabled";
		_script={};
		call compile format["_script={if (isserver) then {""INFO : %1 disarmed by %2"" call vts_addlog;}; if ([player] call vts_getisGM) then {hintc ""INFO : %1 disarmed by %2"";} else {hint ""%1 : Explosive device disarmed"";}; };",[_IED] call vts_getDisplayname,name _target];
		[_script] call vts_broadcastcommand;
	  }
	  else
	  {
		hint "Explosive device already disabled";
	  };
  }
  else
  {
	_script={};
	call compile format["_script={if (isserver) then {""INFO : %1 blown, failed to be disarmed by %2"" call vts_addlog;}; if ([player] call vts_getisGM) then {hintc ""INFO : %1 blown, failed to be disarmed by %2"";} else {hint ""%1 : Blowned up"";}; };",[_IED] call vts_getDisplayname,name _target];
	[_script] call vts_broadcastcommand;  
	_IED setdamage 1;
  };
  
};


vts_isIED={
	private ["_IED"];
  _IED=_this select 0;
  
  [_IED,"Disable explosive device",{_this call vts_isIEDDisable;},[],100,true,true,"","(_target getvariable ""vts_IEDEnabled"") && ((_target distance _this)<5)"] call vts_addaction;
  //Behavior
  if (local _IED) then {
   [_IED] spawn vts_isIEDBehavior;
    _IED addEventHandler ["Killed","[(_this select 0)] call vts_isIEDExplosion;"];
  };  
  if ([player] call vts_getisGM) then {"IED object created" call vts_gmmessage;};
};
if (isserver) then {publicvariable "vts_isIED";};


//Sabotaged
vts_isSabotaged={

	private ["_object","_target","_script"];
  _object=_this select 0;
  _target=_this select 1;
  _object setvariable ["vts_issabotagable",false,true];
  _script={};
  hint format["%1 has beend sabotaged",name _object];
  _target action ["RepairVehicle",_target];
  call compile format["_script={if (isserver) then {""INFO : %1 sabotaged by %2"" call vts_addlog;}; if ([player] call vts_getisGM) then {hintc ""INFO : %1 sabotaged by %2"";} else {hint ""%1 has been sabotaged"";}; };",[_object] call vts_getDisplayname,name _target];
  
  [_script] call vts_broadcastcommand;
  _object setdamage 0.5;    
};


vts_isSabotagable={
	private ["_object"];
  _object=_this select 0;
  if (local _object) then {	_object setvariable ["vts_issabotagable",true,true];};
  [_object,"Sabotage",{_this call vts_isSabotaged;},[],100,true,true,"","(_target getvariable ""vts_issabotagable"") && ((_target distance _this)<5)"] call vts_addaction;
  if ([player] call vts_getisGM) then {"Sabotagable object created" call vts_gmmessage;};
};
if (isserver) then {publicvariable "vts_isSabotagable";};

//Spawn spawned unit in air and execut the freefall script on them (handling vehicle, static and soldier with parachute)
vts_isParachuted=
{
	private ["_object","_altitude"];
	_object=_this select 0;
	_altitude=_this select 1;
	if (local _object) then
	{
		_object setpos [getposatl _object select 0,getposatl _object select 1,_altitude];
		[_object] spawn vts_freefall;
	};
	if ([player] call vts_getisGM) then {"Object(s) spawned and parachuted" call vts_gmmessage;};
};
if (isserver) then {publicvariable "vts_isParachuted";};


vts_isClueOk=
{
private ["_object","_target","_script","_txt"];
  _object=_this select 0;
  _target=_this select 1;
  _txt=_object getvariable ["vts_iscluetext",""];
  _script={};
  if (_txt!="") then {([_object] call vts_getDisplayname) hintc _txt};
  hint format ["%1 clue has been examined",name _object];
  _target action ["TakeFlag",_target];
  call compile format["_script={if (isserver) then {""INFO : %1 clue examined by %2"" call vts_addlog;}; if ([player] call vts_getisGM) then {hint ""INFO : %1 clue examined %2"";} else {hint ""%1 clue has been examined"";}; };",[_object] call vts_getDisplayname,name _target];
  [_script] call vts_broadcastcommand;	
};

vts_isClue={
  private ["_object","_txt"];
  _object=_this select 0;
  _txt=_this select 1;
  if (local _object) then {	_object setvariable ["vts_iscluetext",_txt,true];};
  [_object,"Examine clue",{_this call vts_isClueOk;},[],100,true,true,"","((_target distance _this)<5)"] call vts_addaction;
  if ([player] call vts_getisGM) then {"Clue object created" call vts_gmmessage;};
};
if (isserver) then {publicvariable "vts_isClue";};

vts_getboundingboxsize=
{
	private ["_bbox","_bbsize"];
	_bbox=boundingBox (_this select 0);
	_bbsize=(((_bbox select 1) select 0)-((_bbox select 0) select 0))*(((_bbox select 1) select 1)-((_bbox select 0) select 1))*(((_bbox select 1) select 2)-((_bbox select 0) select 2));
	_bbsize;
};

vts_isMovableUpdateAction=
{
	private ["_cursor","_unit","_var","_playeractions","_obj","_i","_id","_index","_checkdone"];
	//[] call vts_perfstart;
	_unit=_this select 0;
	if (vehicle _unit!=_unit) exitwith {};
	_cursor=cursorTarget;
	_checkdone=false;
	if !(isnull _cursor) then
	{
		if ((_cursor iskindof "LandVehicle") or (_cursor iskindof "Air") or (_cursor iskindof "Ship")) then
		{
			if ((_unit distance _cursor)<7.5) then
			{
				_var=_cursor getVariable ["vts_movableincargo",[]];
				_checkdone=true;
				_playeractions=vts_isMovablePlayerActions;
				//Clean actions
				for "_i" from 0 to (count _playeractions)-1 step 2 do
				{
					_id=_playeractions select _i;
					_obj=_playeractions select (_i+1);
					if !(_obj in _var) then
					{
						vts_isMovablePlayerActions=vts_isMovablePlayerActions-[_id,_obj];
						_unit removeAction _id;
					};
				};	
				if (count _var>0) then 
				{
					//Add missing actions
					for "_i" from 0 to (count _var)-1 do
					{
						_obj=_var select _i;
						if !(_obj in _playeractions) then 
						{
							_id=[_unit,"<t color=""#4fff8b"">Unload "+([_obj] call vts_getDisplayname)+"</t>",{_this call vts_isMovableUnload;},[_cursor,_obj],0,true,true,"","[_this] call vts_isMovableCanUnload"] call vts_addaction;
							vts_isMovablePlayerActions=vts_isMovablePlayerActions+[_id,_obj];
						};
					};			
				};
			};
		};
	};
	//Clean all actions if no valid vehicles has been detected
	
	if !(_checkdone) then
	{
		
		_playeractions=vts_isMovablePlayerActions;
		//hint str _playeractions;
		for "_i" from 0 to (count _playeractions)-1 step 2 do
		{
			_id=_playeractions select _i;
			_obj=_playeractions select (_i+1);
			vts_isMovablePlayerActions=vts_isMovablePlayerActions-[_id,_obj];
			_unit removeAction _id;
		};	
	};
	
	//[] call vts_perfstop;
};



vts_isMovablePlayerInit=
{
	if (isnil "vts_isMovablePlayerActions") then
	{
		vts_isMovablePlayerActions=[];
	};
	vts_isMovablePlayerInitLoop=true;
	while {vts_isMovablePlayerInitLoop} do
	{
		[player] call vts_isMovableUpdateAction;
		sleep 0.25;
	};
};

vts_isMovableHideObject=
{
	private ["_obj"];
	_obj=_this;
	[_obj,true] call vts_hideobject;
	if (local _obj) then
	{
		_obj setposasl [0,0,1337];
	};
};

vts_isMovableUnHideObject=
{
	private ["_obj"];
	_obj=_this;
	[_obj,false] call vts_hideobject;
};

vts_isMovableCanUnload=
{
	private ["_b","_unit"];
	_b=false;
	_unit=_this select 0;
	if (vehicle _unit!=_unit) exitwith {false;};
	if (isnull (_unit getvariable ["vts_isMovableO",objnull])) then 
	{
		_b=true;
	};
	_b;
};

vts_isMovableUnload=
{
	private ["_target","_caller","_arg","_obj","_vehicle","_var"];
	_target=_this select 0;
	_caller=_this select 1;
	_arg=_this select 3;
	_vehicle=_arg select 0;
	_obj=_arg select 1;
	_var=_vehicle getVariable ["vts_movableincargo",[]];
	if (count _var>0) then
	{
		_var=_var-[_obj];
		_vehicle setVariable ["vts_movableincargo",_var,true];
	};
	//[{_this call vts_isMovableUnHideObject;},_obj] call vts_broadcastcommand;
	("MOVABLE: "+(name _caller)+" UNLOADED "+([_obj] call vts_getDisplayname)+" from "+([_vehicle] call vts_getDisplayname)) call vts_addlog;
	hint (([_obj] call vts_getDisplayname)+" Unloaded from "+([_vehicle] call vts_getDisplayname));
	[_obj,_caller,-1,[],true] call vts_isMovableDrag;
};

vts_isMovableLoadIn=
{
	private ["_unit","_target","_script","_pos","_var","_vehicle"];
	_unit=_this select 1;	
	_target=(_unit getvariable ["vts_isMovableO",objnull]);
	_vehicle=[_unit,_target] call vts_isMovableGetVehicleInFront;
	if (isnull _vehicle) exitwith {hint "!!! Cannot load cargo into this vehicle !!!";};
	
	_script=_this select 2;

	_var=_vehicle getVariable ["vts_movableincargo",[]];
	if !(_target in _var) then
	{
		_target setvariable ["vts_isMovable",0,true];
		_unit setvariable ["vts_isMovableO",objnull,true];		
		_unit forcewalk false;
		_unit removeaction vts_movableidmove;
		_unit removeaction vts_movableidload;	
		_target attachto [_unit,[0,0,13337]];
		detach _target;
		_target setvelocity [0,0,0];
		_var set [count _var,_target];
		_vehicle setvariable ["vts_movableincargo",_var,true];
		[{_this call vts_isMovableHideObject;},_target] call vts_broadcastcommand;
		hint (([_target] call vts_getDisplayname)+" loaded into "+([_vehicle] call vts_getDisplayname));
		_unit playactionnow "PutDown";
		("MOVABLE: "+(name _unit)+" LOADED "+([_target] call vts_getDisplayname)+" in "+([_vehicle] call vts_getDisplayname)) call vts_addlog;
	};
	
};

vts_isMovableGetVehicleInFront=
{
	private ["_veh","_vehlist","_unit","_playerpos","_distance","_filter"];
	_unit=_this select 0;
	_veh=objnull;
	_filter=_this select 1;
	_playerpos=(_unit modeltoworld [0,3,0]);
	_playerpos=[_playerpos select 0,_playerpos select 1,(getposasl _unit) select 2];
	_vehlist=[_playerpos,["Air","LandVehicle","Ship"],5] call vts_nearestobjects3d;
	if (_filter in _vehlist) then
	{
		_vehlist=_vehlist-[_filter];
	};
	if (count _vehlist>0) then
	{
		_veh=_vehlist select 0;
		if !(alive _veh) then {_veh=objnull;};
	};
	_veh;
};

vts_isMovableCanLoadIn=
{
	private ["_b","_veh","_bboxtarget","_bboxcurrent","_target"];
	//[] call vts_perfstart;
	_b=false;
	_unit=_this select 0;
	_target=(_unit getvariable ["vts_isMovableO",objnull]);
	_veh=[_unit,(_unit getvariable ["vts_isMovableO",objnull])] call vts_isMovableGetVehicleInFront;
	if (!(isnull _veh) && !(isnull _target)) then
	{
		_bboxtarget=[_veh] call vts_getboundingboxsize;
		_bboxcurrent=[_target] call vts_getboundingboxsize;
		//systemchat ("carry: "+(str _bboxcurrent)+" target: "+(str _bboxtarget));
		if ((_bboxcurrent*2)<=_bboxtarget) then
		{
			_b=true;
		};
	};
	//[] call vts_perfstop;
	_b;
};

vts_isMovableDrag=
{
	private ["_unit","_target","_newpos","_bbox","_dir","_initialdist","_script","_forcecorrectpos","_arg"];
	_target=_this select 0;
	_unit=_this select 1;	
	_script=_this select 2;
	_arg=_this select 3;
	_forcecorrectpos=false;
	if (count _this>4) then 
	{
		_forcecorrectpos=_this select 4;
	};
	
	[{_this disableCollisionWith player;{_x disableCollisionWith _this} forEach vehicles;_this call vts_isMovableUnHideObject;},_target] call vts_broadcastcommand;
	
	_target setvariable ["vts_isMovable",1,true];
	_unit setvariable ["vts_isMovableO",_target,true];
	_dir=(direction _target)-(direction _unit);
	if !(_forcecorrectpos) then
	{
		_target attachto [_unit];
	}
	else
	{
		_target attachto [_unit,[0,((((boundingBox _target) select 0) select 1)*-1)+1,(((boundingBox _target) select 0) select 2)*-1]];
	};
	vts_movableidmove=[_unit,"<t color=""#fbb7b7"">Release "+([_target] call vts_getDisplayname)+"</t>",{_this call vts_isMovableRelease;},[],0,true,true,"","[_this] call vts_isMovableCanRelease"] call vts_addaction;
	vts_movableidload=[_unit,"<t color=""#f98af1"">Load "+([_target] call vts_getDisplayname)+" into Vehicle</t>",{_this call vts_isMovableLoadIn;},[],0,true,true,"","[_this] call vts_isMovableCanLoadIn"] call vts_addaction;
	_unit playactionnow "takeflag";
	_bbox=boundingBox _target;
	//_unit playactionnow "grabdrag";
	while {(vehicle _unit==_unit) && (_target==(_unit getvariable ["vts_isMovableO",objnull])) && (alive _unit)} do
	{
		_newpos=[_target,1,0.1,_unit] call vts_GetPosOnCol;
		if !(surfaceIsWater _newpos) then
		{
			_newpos=asltoatl _newpos;
		};
		//Limit down col for water purpose
		_newpos=(_unit worldtomodel _newpos);
		if !(((getposasl _unit) select 2)<0) then
		{
			_target attachto [_unit,[_newpos select 0,_newpos select 1,(_newpos select 2)-((_bbox select 0) select 2)]];
		};
		_target setdir _dir;
		_unit action ["switchweapon",_unit,_unit,999];
		_unit forcewalk true;
		sleep 0.1;
	};
	if (!(alive _unit) or (vehicle _unit!=_unit)) then 
	{
		_target setvariable ["vts_isMovable",0,true];
		_unit setvariable ["vts_isMovableO",objnull,true];
		detach _target;
		_unit forcewalk false;
		_unit removeAction vts_movableidmove;
		_unit removeAction vts_movableidload;
	};
};

vts_isMovableRelease=
{
	private ["_unit","_target","_script","_pos","_newpos","_damage"];
	_unit=_this select 1;	
	_target=(_unit getvariable ["vts_isMovableO",objnull]);
	_script=_this select 2;
	if !(isnull _target) then
	{
		_target setvariable ["vts_isMovable",0,true];
		_unit setvariable ["vts_isMovableO",objnull,true];	
		_pos=getposasl _target;
		_damage=damage _target;
		detach _target;
		_unit removeaction vts_movableidmove;
		_unit removeaction vts_movableidload;
		_newpos=[_target,1,0.1,_unit] call vts_GetPosOnCol;
		_target setposasl _newpos;
		_target setvelocity [0,0,0];
		//Dirty Damage fixer... sight
		[_target,_damage] spawn {sleep 0.5;(_this select 0) setDamage (_this select 1);};
		//_unit playactionnow "released";
		_unit forcewalk false;
		[{player enableCollisionWith _this;{_x enableCollisionWith _this} forEach vehicles;},_target] call vts_broadcastcommand;
		//player setposasl _newpos;
	};
};

vts_isMovableCanRelease=
{
	private ["_target","_unit","_b"];
	_unit=_this select 0;
	_target=(_unit getvariable ["vts_isMovableO",_unit]);
	_b=false;
	if (((_target getvariable ["vts_isMovable",-1])==1) && (_target!=_unit)) then
	{
		_b=true;
	};
	_b;
};

vts_isMovableCanDrag=
{
	private ["_target","_unit","_b","_distance","_bbox"];
	_unit=_this select 0;
	_target=_this select 1;
	if (vehicle _unit!=_unit) exitwith {false;};
	if (count (crew _target)>0) exitwith {false;};
	_b=false;
	//[] call vts_perfstart;
	_bbox=boundingBox _target;
	_distance=2+((((_bbox select 1) select 0)*((_bbox select 1) select 1))/2);
	if (((_target getvariable ["vts_isMovable",-1])==0) && (isnull (_unit getvariable ["vts_isMovableO",objnull])) && ((_unit distance _target)<=_distance) ) then
	{
		_b=true;
	};
	//[] call vts_perfstop;
	_b;
};

vts_isMovable={
  private ["_object"];
  _object=_this select 0;
  if (local _object) then {	_object setvariable ["vts_isMovable",0,true];};
  [_object,"<t color=""#e1c7ff"">Move "+([_object] call vts_getDisplayname)+"</t>",{_this call vts_isMovableDrag;},[],1,true,true,"","[_this,_target] call vts_isMovableCanDrag"] call vts_addaction;
};
if (isserver) then {publicvariable "vts_isMovable";};

//Create Pickup Behavior
vts_isPickableGetit=
{

  private ["_object","_target","_script"];
  _object=_this select 0;
  _target=_this select 1;
  _script={};
  hint format["%1 picked up",[_object] call vts_getDisplayname];
  _target action ["RepairVehicle",_target];
  call compile format["_script={if (isserver) then {""INFO : %1 Picked up by %2"" call vts_addlog;}; if ([player] call vts_getisGM) then {hintc ""INFO : %1 Picked up by %2"";} else {hint ""%1 picked up"";}; };",[_object] call vts_getDisplayname,name _target];
  
  [_script] call vts_broadcastcommand;
  deleteVehicle _object; 
  
};


vts_isPickable={

  private ["_object"];
  _object=_this select 0;
  [_object,"Pickup object",{_this call vts_isPickableGetit;},[],100,true,true,"","((_target distance _this)<5)"] call vts_addaction;
  if ([player] call vts_getisGM) then {"Pickable object created" call vts_gmmessage;};
};
if (isserver) then {publicvariable "vts_isPickable";};

//Create Target Behavior
vts_isTarget={
  
  private ["_object"];
  _object=_this select 0;
  _object addMPEventHandler ["MPKilled","if (isserver) then {format[""INFO : %1, Target destroyed by %2"",[(_this select 0)] call vts_getDisplayname,name (_this select 1)] call vts_addlog;}; if ([player] call vts_getisGM) then {hintc format[""INFO : %1, Target destroyed by %2"",[(_this select 0)] call vts_getDisplayname,name (_this select 1)];} else {hint format[""%1, target destroyed"",[(_this select 0)] call vts_getDisplayname];}; "];
  if ([player] call vts_getisGM) then {"Target object created" call vts_gmmessage;};
};
if (isserver) then {publicvariable "vts_isTarget";};

//Stealableuniform
vts_isStealableUniform=
{
   private ["_unit","_typeof"];
  _unit=_this select 0;
  _typeof=typeof _unit;
  if !(_typeof iskindof "Man") exitwith {if ([player] call vts_getisGM) then {"!!! Has stealable uniform Fail : Object is not a Man !!!" call vts_gmmessage;};};
  if (local _unit) then {	_unit setVariable ["vts_unitside",(side group _unit),true];};
  [_unit,"Disguise as",{_this call vts_spystealuniform},[],100,true,true,"","!(alive _target) && ((typename (_target getVariable [""vts_unitside"",objnull]))!=""object"")"] call vts_addaction;
  if ([player] call vts_getisGM) then {"Unit with stealable uniform created" call vts_gmmessage;};
};
if (isserver) then {publicvariable "vts_isStealableUniform";};

//Follow loop
vts_followloop=
{
	private ["_follower","_target","_stancepos","_stance","_speed","_dist","_pos","_newgrp","_oldgrp"];
	_follower=_this select 0;
	_target=_follower getVariable ["vts_dofollow",objnull];
	if !(isnull _target) then
	{
		//Change group of the follower to make sure he doesn't run away or have cover pathfinding with the target
		if ((side group _target)!= (side group _follower)) then
		{
			_oldgrp=group _follower;
			_newgrp=creategroup (side group _target);
			[_follower] joinsilent _newgrp;
			deletegroup _oldgrp;
		};
		if !(alive _target) exitwith 
		{
			if (vehicle _follower!=_follower) then {_follower leaveVehicle (vehicle _follower);moveout _follower;};
			_follower setvariable ["vts_dofollow",objnull,true];
		};
		
		//On foot behavior
		if (vehicle _follower==_follower) then 
		{
			
			_dist=_follower distance _target;
			
			if (_dist>10) then {_speed=100} else {_speed=2};
			if (_dist>5) then 
			{
				//Anti stuck (stupid animation lovering and raising weapon loop)
				//if (speed _follower<0.5) then {_follower switchmove "";};
					
				
				_follower forcespeed _speed;
				_pos=getposatl _target;
				_follower domove [(_pos select 0)-2.5+(random 5),(_pos select 1)-2.5+(random 5),(_pos select 2)];
			};
			_stancepos=(eyepos _target select 2)-(getposasl _target select 2);
			//player sidechat str _stancepos;
			switch (true) do
			{
				case (_stancepos<0.5) : {_stance="DOWN"};
				case (_stancepos<1.3) : {_stance="UP"};
				default {_stance="UP";};
			};		
			_follower setunitpos _stance;	
		};
		
		if ((vehicle _target)!=_target) then
		{
			if ((vehicle _follower)!=(vehicle _target)) then 
			{
				if (_dist<20) then 
				{
					if (((vehicle _target) emptyPositions "cargo")>0) then 
					{
						_follower action ["getincargo",(vehicle _target)];
						sleep 1.0;
						_follower moveincargo (vehicle _target);
					};
				};
			};
		};
		//Check if follower is in vehicle then when not in the same vehicle as target (or when he exit)
		if (vehicle _follower!=_follower) then
		{
			if (vehicle _follower!=vehicle _target) then {_follower leaveVehicle (vehicle _follower);moveout _follower;};
		};
	};
	
	
};
if (isserver) then {publicvariable "vts_followloop";};

//Follow behavior
vts_Isfollowing=
{
   private ["_follower","_target"];
	_follower=_this select 0;
	if (count _this>1) then 
	{
		_target=_this select 1;
		_follower setvariable ["vts_dofollow",_target,true];
	};
	while {alive _follower && !(isnull _follower)} do 
	{
		[_follower] spawn vts_followloop;
		sleep 5;
	};
	
};
if (isserver) then {publicvariable "vts_Isfollowing";};

//Create VIP Behavior
vts_isVIP={

	private ["_object","_typeof"];

	  _object=_this select 0;
	  _typeof=typeof _object;
	  if !(_typeof iskindof "Man") exitwith {if ([player] call vts_getisGM) then {"!!! VIP Fail : Object is not a Man !!!" call vts_gmmessage;};};    
		_object disableai "FSM";
	   _object addMPEventHandler ["MPKilled","if (isserver) then {format[""INFO : %1, VIP Killed by %2"",name (_this select 0),name (_this select 1)] call vts_addlog;};if ([player] call vts_getisGM) then {hintc format[""INFO : %1, VIP Killed by %2 "",name (_this select 0),name (_this select 1)]} else {hint format[""%1, has been killed"",name (_this select 0)];};"];
	   if (_typeof iskindof "Man")  then
	   {
		[_object,"""Follow Me""",{[(_this select 0)] joinsilent grpnull;(_this select 1) playactionnow "gesturefollow";(_this select 0) setvariable ["vts_dofollow",(_this select 1),true];(_this select 1) groupchat "Follow me";},[],100,true,true,"","alive _target"] call vts_addaction;
		[_object,"""Stay here""",{(_this select 1) playactionnow "gestureFreeze";(_this select 0) setvariable ["vts_dofollow",objnull,true];(_this select 1) groupchat "Stay here";},[],100,true,true,"","alive _target"] call vts_addaction;
	   };
	   if (local _object) then {[_object] spawn vts_Isfollowing;};
		if ([player] call vts_getisGM) then {"VIP unit created" call vts_gmmessage;};
};
if (isserver) then {publicvariable "vts_isVIP";};

//Create Shop Behavior
vts_isShop={

  private ["_object","_side"];
  _object=_this select 0;
  _side=_this select 1;
  _object setvariable ["vts_shopside",_side];
  [_object,"Open the shop",{_this execvm "shop\shop_dialog.sqf";},[],100,true,true,"","(alive _target) && (vehicle player==player)"] call vts_addaction;
  if ([player] call vts_getisGM) then {"Shop object created" call vts_gmmessage;};
  
  if (typename _side=="STRING") then
  {
	call compile format["
	if (isnil ""vts_shopunlocklist_%1"") then
	{	
		vts_shopunlocklist_%1=[];
		if (isserver) then {publicVariable ""vts_shopunlocklist_%1"";};
	};
	if (isnil ""vts_shopevent_%1"") then
	{
		[""%1""] call vts_shopaddevent;
		vts_shopevent_%1=true;
	};
	if (pa_shopallunlocked==0) then 
	{
		if (isnil ""vts_shopallunlocked_%1"") then {vts_shopallunlocked_%1=false;};
	}
	else 
	{
		if (isnil ""vts_shopallunlocked_%1"") then {vts_shopallunlocked_%1=true;};
	};	
	if (isserver) then 	{publicVariable ""vts_shopallunlocked_%1"";};
	if (isnil ""vts_shopbalance_%1"") then 
	{
		vts_shopbalance_%1=pa_shopinitalbalance;
	};
	if (isserver) then {publicVariable ""vts_shopbalance_%1"";};
	",_side];
  };

  
};
if (isserver) then {publicvariable "vts_isShop";};

//Get Cfgtype
vts_getClassCfgType={
  private ["_class","_cfgtype"];
  _class=_this select 0;
  _cfgtype="";
  
  
  if (isclass (configFile >> "CfgVehicles" >> _class)) then {_cfgtype="CfgVehicles";};
  if (isclass (configFile >> "CfgAmmo" >> _class)) then {_cfgtype="CfgAmmo";};
  if (isclass (configFile >> "CfgMagazines" >> _class)) then {_cfgtype="CfgMagazines";};
  if (isclass (configFile >> "CfgWeapons" >> _class)) then {_cfgtype="CfgWeapons";}; 
  
  
  _cfgtype;
};

//Get Class CFG
vts_getClassCfg=
{
	private ["_class","_classcfg","_classtype"];
  _class=_this select 0;
  _classcfg=nil;
  _classtype=[_class] call vts_getClassCfgType;
  
  _classcfg=(configFile >> _classtype >> _class);
  
  _classcfg;
};

//Get Displayname
vts_getDisplayname={
	private ["_obj","_classname","_cfg","_displayname"];
	_obj=_this select 0;
	_classname="";
	if (typename _obj=="STRING") then {_classname=_obj} else {_classname=typeof _obj};
	_cfg=[_classname] call vts_getClassCfgType;
	_displayname="";
	_displayname=getText (configfile >> _cfg >> _classname >> "displayname");
	_displayname;
};

//GM ID helper
vts_showid={


  while {gps_eni_valid==1} do
  {
    _object=cursorTarget;
    if !(isnull _object) then
    {
      //titleText [format["%1",_object], "PLAIN",1];
      0 cutText["","PLAIN DOWN"];
      0 cutText [format["%1",_object],"PLAIN DOWN",0];
    };
    sleep 1;
  };  
  0 cutText["","PLAIN DOWN"];
};

//Vehicle transport script
vts_isTransportTaxi=
{
	private ["_object","_oldgroup","_pos"];
	_object=_this select 0;
	if (!(_object iskindof "AllVehicles") or (_object iskindof "CAManBase")) exitwith {};
	_oldgroup=objnull;
	if (count _this>1) then {_oldgroup=_this select 1;};
	if (((local _object) && (_object iskindof "LandVehicle" or _object iskindof "Helicopter"  or _object iskindof "Ship") && (count crew _object>0)) or !(isnull _oldgroup))then
	{
		
		_side=side _object;
		if !(isnull _oldgroup) then {_side=side _oldgroup;};
		
		//Only AI driver to open more seat and turret to players
		_pos=getposasl _object;
		sleep 1;	
		{moveout _x;deletevehicle _x;} foreach (crew _object);
		_object setvelocity [0,0,0];
		_object setposasl ([_pos,true,20000,0.25,_object] call vts_SetPosAtop);
		_object setvelocity [0,0,1];
		_object setDamage 0;
		_driverclass=(gettext (configfile >> "CfgVehicles" >> (typeof _object) >> "crew"));
		_driver = (creategroup _side) createunit [_driverclass,[0,0,10000],[],0,"None"];
		_driver assignasdriver _object;
		_driver moveindriver _object;
		
		_driver setBehaviour "CARELESS";
		
		_object setvariable ["vtstranportdriver",_driver,true];
		_object setvariable ["vtstranportbasepos",(getpos _object),true];
		
		_object lockdriver true;
		_object lockturret[[0],true];
		_object lockturret[[1],true];
		_object lockturret[[2],true];
		
		_object engineOn false;
		
		//Check if the vehicle is stuck until death carry it away (only for land & ship vehicles)
		if !(_object iskindof "Helicopter") then
		{
			[_object] spawn vts_isTransportVehicleCheckIfstuck;
		};
		
		//Add the vehicle to the list of available transport
		if (isnil "vtstransportvehiclearray") then {vtstransportvehiclearray=[]};
		if !(_object in vtstransportvehiclearray) then {vtstransportvehiclearray set [count vtstransportvehiclearray,_object];};
		publicvariable "vtstransportvehiclearray";
		
	};
	//Global 
	[_object,"Select a destination",{[_this] call vts_isTransportVehicleAddorder;},[],100,false,false,"","(alive _target) && (_this in _target)"] call vts_addaction;
	[_object,"Stop it now",{[_this] call vts_isTransportStopItNow;},[],110,false,false,"","(alive _target) && (_this in _target) && (speed _target>6)"] call vts_addaction;
	[_object,"[Leader] Change RTB destination",{[_this] call vts_isTransportVehicleChangeRTBposition;},[],90,false,false,"","(alive _target) && (_this in _target) && (leader _this==_this)"] call vts_addaction;
	
	//If the radio trigger for extraction doesnt exist on the playerside, we create it.
	
	if (isnil "vtstransportvehicletrigger") then
	{
		vtstransportvehicletrigger=createTrigger  ["EmptyDetector",[-10,-10,0]];
		vtstransportvehicletrigger setTriggerArea[1,1,0,false];
		vtstransportvehicletrigger setTriggerType "NONE";
		vtstransportvehicletrigger setTriggerActivation ["JULIET","PRESENT",true];
		vtstransportvehicletrigger setTriggerStatements ["this", "[] spawn vts_istransportvehicletrigger", ""];
		[side player,"HQ"] sidechat "Transport vehicles are available on Radio Juliet";
	};
	//Feed back to GM saying the vehicle is ready
	if ([player] call vts_getisGM) then {"Transport Vehicle created" call vts_gmmessage;};
	
};
if (isserver) then {publicvariable "vts_isTransportTaxi";};

vts_isTransportStopItNow={
	private ["_array","_vehicle","_wp"];
	_array=_this select 0;
	_vehicle=_array select 0;
	_wp=[group _vehicle,currentwaypoint group _vehicle];
	_wp setwaypointposition [[(getposatl _vehicle select 0),(getposatl _vehicle select 1)],0];
};
	
vts_getvehiclecapacity=
{
	private ["_vehicle","_cargoonly","_vehicleclass","_capacity","_turrets","_turretcount","_cargo"];
	_vehicle=(_this select 0);
	_cargoonly=false;
	if (count _this>1) then {_cargoonly=_this select 1};
	
	_vehicleclass=typeof _vehicle;
	_capacity=0;
	if (getnumber (configfile >> "CfgVehicles" >> _vehicleclass >> "hasdriver") > 0) then 
	{
		_capacity=_capacity+1;
	};
	_turrets=[_vehicleclass,[]] call bis_fnc_getturrets;
	_turretcount=count _turrets;
	if (typename _turretcount!="SCALAR") then {_capacity=_capacity+_turretcount};
	_cargo=0;
	for "_t" from 0 to (getnumber (configfile >> "CfgVehicles" >> _vehicleclass >> "transportsoldier") - 1) do 
	{
		_cargo=_cargo+1;
		_capacity=_capacity+1;
	};
	if (_cargoonly) then {_capacity=_cargo;};
	_capacity;
};

vts_istransportvehicletrigger=
{
	private ["_correctvehicles","_targetvehicle","_lastdist"];
	//Checking availability of vehicles
	if (isnil "vtstransportvehiclearray") then {vtstransportvehiclearray=[];};
	_correctvehicles=[];
	{
		if ((side _x==side player) && (alive driver _x) && (fuel _x!=0) && (canmove _x)) then 
		{
			if ((([_x] call vts_getvehiclecapacity)>(count crew _x)) && (isnull (_x getvariable ["vtstranportbusy",objnull]))) then
			{
				_correctvehicles set [count _correctvehicles,_x];
			};
		
		};
	} foreach vtstransportvehiclearray;
	//If none exit
	if (count _correctvehicles < 1) exitwith {[side player,"HQ"] sidechat "No transport currently available";};
	//Check the nearest vehicle
	_targetvehicle=objnull;
	_lastdist=100000;
	{
		_dist=_x distance player;
		if ((_dist min _lastdist)==_dist)  then {_targetvehicle=_x; _lastdist=_dist};
	} foreach _correctvehicles;
	
	if !(visibleMap) then {openMap [true, false];};
	vtstransportmapclick=true;
	_targetvehicle sidechat "Need a taxi ? Give me the pickup coordinates on the map";
	onMapSingleClick "
	vtstransportpos=_pos;
	onMapSingleClick """";
	vtstransportmapclick=false;
	openMap [false, false];
	";	
	waituntil {!visibleMap};
	if (vtstransportmapclick) then
	{
		vtstransportmapclick=false;
		onMapSingleClick "";
		_targetvehicle sidechat "Nevermind";
	}
	else
	{	
		while {(count (waypoints (group driver _targetvehicle))) > 0} do
		{
		 deleteWaypoint ((waypoints (group driver _targetvehicle)) select 0);
		};
		_targetvehicle setvariable ["vtstranportbusy",player,true];
		_wp = (group driver _targetvehicle) addwaypoint [vtstransportpos, 0];	
		_wp setWaypointBehaviour "CARELESS";
		_wp setwaypointspeed "FULL";
		_wp setwaypointcombatmode "GREEN";
		_wpscripted = (group driver _targetvehicle) addwaypoint [vtstransportpos, 0];
		_wpscripted setWaypointType "Scripted";
		_wpscripted setWaypointScript "functions\vtstransportwp.sqs this";
		_targetvehicle setVariable ["vtswaypointname","Pickup",true];			
		
		_txt=format["Copy, on my way to %1. ETA : %2",mapGridPosition vtstransportpos, [_targetvehicle,vtstransportpos] call vts_isTransportVehicleGetEta];
		_code={};
		vtstransportvehiclepickup=_targetvehicle;
		publicvariable "vtstransportvehiclepickup";
		call compile format["
		_code={
		if (group player==group (vtstransportvehiclepickup getvariable ""vtstranportbusy"")) then {vtstransportvehiclepickup sidechat ""%1"";};
		if (local vtstransportvehiclepickup) then {vtstransportvehiclepickup land ""NONE"";[vtstransportvehiclepickup] spawn vts_istransportVehiclePickUpBehavior;};
		};
		",_txt];
		[_code] call vts_broadcastcommand;
		
			
	};
};

vts_isTransportVehicleChangeRTBposition=
{
	private ["_array"];
	_array=_this select 0;
	vtstransportvehicle=_array select 0;
	if !(visibleMap) then {openMap [true, false];};
	vtstransportmapclick=true;
	vtstransportvehicle vehicleChat "Give me the new coordinates for the RTB destination";
	onMapSingleClick "
	vtstransportmapclick=false;
	vtstransportpos=_pos;
	onMapSingleClick """";
	openMap [false, false];
	";	
	waituntil {!visibleMap};
	if ((vtstransportvehicle iskindof "Ship") && !(surfaceiswater vtstransportpos)) then
	{
		vtstransportvehicle vehicleChat "I can't sail on ground";
		vtstransportmapclick=true;
	};
	if ((vtstransportvehicle iskindof "LandVehicle") && (surfaceiswater vtstransportpos)) then
	{
		vtstransportvehicle vehicleChat "I can't drive on water";
		vtstransportmapclick=true;
	};		
	if (vtstransportmapclick) then
	{
		vtstransportmapclick=false;
		onMapSingleClick "";
		vtstransportvehicle vehicleChat "Nevermind";
	}
	else
	{
		vtstransportvehicle setvariable ["vtstranportbasepos",vtstransportpos,true];
		vtstransportvehicle vehicleChat "Roger, RTB position has been changed";
	};
};

vts_isTransportVehicleGetEta=
{
	private ["_currentvehicle","_postogo","_dist","_vehiclespeed","_travelmalus","_avtime","_mins","_secs","_etatext"];
	_currentvehicle=_this select 0;
	_postogo=_this select 1;
	_dist=(getpos _currentvehicle) distance _postogo;
	_vehiclespeed=getnumber (configfile >> "CfgVehicles" >> (typeof _currentvehicle) >> "MaxSpeed");
	_vehiclespeed=round(_vehiclespeed*1000)/3600;
	_travelmalus=0.35;
	if (_currentvehicle iskindof "Helicopter") then {_travelmalus=0.65;};
	_avtime=(_dist/(_vehiclespeed*_travelmalus));
	_mins=0;
	_secs=0;
	if (_avtime>60) then
	{
	_mins=round(_avtime/60);
	_secs=round(_avtime mod 60);
	}
	else
	{
		_mins=0;
		_secs=round(_avtime);
	};
	_etatext=format["%1m%2",_mins,_secs];
	_etatext;
};


vts_isTransportVehicleAddorder=
{
	private ["_array","_vehicle","_canmove"];
	_array=_this select 0;
	vtstransportvehiclecaller=_array select 1;
	_vehicle=_array select 0;
	_canmove=true;
	if !(alive driver _vehicle) then
	{
		_driver=_vehicle getvariable["vtstranportdriver",objnull];
		if (isnull _driver) then {hint "There is no driver available !";_canmove=false;};
		if !(alive _driver) then {hint "The driver is dead !";_canmove=false;};
		vtstransportvehicledriverout=_driver;
		vtstransportvehicleout=_vehicle;
		publicvariable "vtstransportvehicledriverout";
		publicvariable "vtstransportvehicleout";
		_code={
			if (local vtstransportvehicledriverout or local vtstransportvehicleout) then
			{
				vtstransportvehicleout lockdriver false;
				vtstransportvehicledriverout assignasdriver vtstransportvehicleout;
				vtstransportvehicledriverout moveindriver vtstransportvehicleout;
				vtstransportvehicleout lockdriver true;
			};
		};
		[_code] call vts_broadcastcommand;
	};
	if (_canmove) then
	{
		if !(visibleMap) then {openMap [true, false];};
		vtstransportmapclick=true;
		_vehicle vehiclechat "Give me the coordinates on the map";
		onMapSingleClick "
		vtstransportpos=_pos;
		onMapSingleClick """";
		vtstransportmapclick=false;
		openMap [false, false];
		";
		waituntil {!visibleMap};
		if ((_vehicle iskindof "Ship") && !(surfaceiswater vtstransportpos)) then
		{
			_vehicle vehicleChat "I can't sail on ground";
			vtstransportmapclick=true;
		};
		if ((_vehicle iskindof "LandVehicle") && (surfaceiswater vtstransportpos)) then
		{
			_vehicle vehicleChat "I can't drive on water";
			vtstransportmapclick=true;
		};		
		if (vtstransportmapclick) then
		{
			vtstransportmapclick=false;
			onMapSingleClick "";
			_vehicle vehicleChat "Nevermind";
		}
		else
		{
			while {(count (waypoints (group driver _vehicle))) > 0} do
			{
			 deleteWaypoint ((waypoints (group driver _vehicle)) select 0);
			};
			_wp = (group driver _vehicle) addwaypoint [vtstransportpos, 0];	
			_wp setWaypointBehaviour "CARELESS";
			_wp setwaypointspeed "FULL";
			_wp setwaypointcombatmode "GREEN";
			_wpscripted = (group driver _vehicle) addwaypoint [vtstransportpos, 0];
			_wpscripted setWaypointType "Scripted";
			_wpscripted setWaypointScript "functions\vtstransportwp.sqs this";
			_vehicle setVariable ["vtswaypointname","Move",true];
			
			_text=format["Roger, oscar mike. Moving to : %2. ETA : %1",[_vehicle,vtstransportpos] call vts_isTransportVehicleGetEta,mapGridPosition vtstransportpos];
			
			vtstransportvehiclemove=_vehicle;	
			publicvariable "vtstransportvehiclemove";
			_code={};
			call compile format["
			_code={
			if (player in vtstransportvehiclemove) then {vtstransportvehiclemove vehicleChat ""%1"";};
			if (local vtstransportvehiclemove) then {vtstransportvehiclemove land ""NONE"";[vtstransportvehiclemove] spawn vts_istransportVehicleMovebehavior;};
			};
			",_text];
			[_code] call vts_broadcastcommand;
			
			_vehicle setvariable ["vtstranportbusy",player,true];
			
		};
	};
};



vts_isTransportVehicleBacktoBase=
{
	private ["_transportbasepos","_vehicle","_wp","_wpscripted"];
	_vehicle=_this select 0;
	while {(count (waypoints (group driver _vehicle))) > 0} do
	{
		deleteWaypoint ((waypoints (group driver _vehicle)) select 0);
	};
	_transportbasepos=_vehicle getvariable "vtstranportbasepos";
	_vehicle land "NONE";
	_wp = (group driver _vehicle) addwaypoint [_transportbasepos, 0];	
	_wp setWaypointBehaviour "CARELESS";
	_wp setwaypointspeed "FULL";
	_wp setwaypointcombatmode "GREEN";
	_wpscripted = (group driver _vehicle) addwaypoint [_transportbasepos, 0];
	_wpscripted setWaypointType "Scripted";
	_wpscripted setWaypointScript "functions\vtstransportwp.sqs this";
	_vehicle setVariable ["vtswaypointname","Base",true];
	//Make the vehicle available
	_vehicle setvariable ["vtstranportbusy",objnull,true];
};

vts_istransportVehicleMovebehavior=
{
	private ["_currentwaypointposition","_vehicle","_loop","_playerinside"];
	_vehicle=_this select 0;
	_currentwaypointposition=waypointPosition [(group driver _vehicle),(currentwaypoint (group driver _vehicle))];
	_loop=true;
	_playerinside=false;
	while {(_loop) && (alive _vehicle) && (alive driver _vehicle) && (canmove _vehicle) && (fuel _vehicle!=0)} do
	{
		//Check if player are still inside
		_playerinside=false;
		{if (isplayer _x) then {_playerinside=true};} foreach crew _vehicle;
		
		//Wait until no more player inside to go back to pickup point
		if !(_playerinside) then 
		{
			_loop=false;
		};
		//If the vehicle didn't went to the waypoint (mean the player changed the destination mid run)
		_actualwaypointposition=waypointPosition  [(group driver _vehicle),(currentwaypoint (group driver _vehicle))];
		if (((_currentwaypointposition select 0)!=(_actualwaypointposition select 0)) && ((_currentwaypointposition select 1)!=(_actualwaypointposition select 1))) then
		{
			//If the unit is not ready it mean it hasn't rechead its destination (maybe it was cancelled by another order) we stop the loop then the behavior can be different
			if !(unitready _vehicle) then
			{
				_loop=false;
			};
		};
		sleep 3.0;
		
	};
	//If the loop is done and no player inside then go back to base, else if player still inside, mean a new order has been given we still end the loop for perf reason
	if !(_playerinside) then 
	{
		[_vehicle] spawn vts_isTransportVehicleBacktoBase;
	};
	//player sidechat "End of transport Move Behavior loop";
};

vts_istransportVehiclePickUpBehavior=
{
	private ["_currentwaypointposition","_vehicle","_loop","_caller"];
	_vehicle=_this select 0;
	_currentwaypointposition=waypointPosition [(group driver _vehicle),(currentwaypoint (group driver _vehicle))];
	_loop=true;	
	_caller=_vehicle getvariable ["vtstranportbusy",objnull];
	while {(alive _vehicle) && _loop && (alive driver _vehicle) && (canmove _vehicle) && (fuel _vehicle!=0)} do
	{

		//If the vehicle didn't went to the waypoint (mean the player changed the destination mid run)
		_actualwaypointposition=waypointPosition  [(group driver _vehicle),(currentwaypoint (group driver _vehicle))];
		if (((_currentwaypointposition select 0)!=(_actualwaypointposition select 0)) && ((_currentwaypointposition select 1)!=(_actualwaypointposition select 1))) then
		{
				if (!unitready _vehicle) then
				{
				_loop=false;
				};
		};	
		if (unitready _vehicle) then {_loop=false;};
		//player sidechat "loop...";
		sleep 3.0;
	};

	//Unit has reached it's destination, waiting for player or leave after timeout
	if (unitready _vehicle && (alive driver _vehicle) && (alive _vehicle) && (canmove _vehicle) && (fuel _vehicle!=0)) then
	{
		_playerinside=false;
		_loop=true;
		//5 minutes before RTB
		_timeout=time+vts_transportpickuptimeout;
		//Check if some player are inside
		_currentwaypointposition=waypointPosition [(group driver _vehicle),(currentwaypoint (group driver _vehicle))];
		while {(alive driver _vehicle) && (alive _vehicle) && (canmove _vehicle) && (fuel _vehicle!=0) && _loop} do
		{
			{if (isplayer _x) then {_playerinside=true;};} foreach crew _vehicle;
			if ((time>_timeout) or (_playerinside)) then {_loop=false;};
			_actualwaypointposition=waypointPosition  [(group driver _vehicle),(currentwaypoint (group driver _vehicle))];
			if (((_currentwaypointposition select 0)!=(_actualwaypointposition select 0)) && ((_currentwaypointposition select 1)!=(_actualwaypointposition select 1))) then
			{
					_loop=false;
			};				
			sleep 3.0;
		};
		//If no player after timeout > bac to base, else greeting and let them use the actions
		if (!(_playerinside) && (time>(_timeout+3))) then
		{
			[_vehicle] spawn vts_isTransportVehicleBacktoBase;
			if !(isnull _caller) then 
			{
				vtstransportvehicle=_vehicle;	
				publicvariable "vtstransportvehicle";
				_code={};
				call compile format["
				_code={if (group player==group %1) then {vtstransportvehicle sideChat ""I can't wait further, I'm RTB. Oscar mike !"";};};
				",(vehiclevarname _caller)];
				[_code] call vts_broadcastcommand;	
			};	
		}
		else
		{
			if !(isnull _caller) then 
			{
				vtstransportvehicle=_vehicle;	
				publicvariable "vtstransportvehicle";
				_code={vtstransportvehicle vehiclechat "I'm waiting for your instructions";};
				[_code] call vts_broadcastcommand;	
			};	
		};
	};
	//Inform caller player if taxi is broken
	if (!(alive driver _vehicle) or !(alive _vehicle) or !(canmove _vehicle) or (fuel _vehicle==0)) then
	{
		if !(isnull _caller) then 
		{
			vtstransportvehicle=_vehicle;	
			publicvariable "vtstransportvehicle";
			_code={};
			call compile format["
			_code={if (group player==group %1) then {[side player,""HQ""] sideChat ""Bad luck ! Your taxi on the way is out of service, try to call another one"";};};
			",(vehiclevarname _caller)];
			[_code] call vts_broadcastcommand;	
		};
	};	
	//player sidechat "End of transport PickUp Behavior loop";
};

vts_isTransportVehicleCheckIfstuck=
{
	private ["_lastpos","_vehicle","_loop","_stuckcount","_lastwpname","_currentwpname"];
	_vehicle=_this select 0;
	_loop=true;
	_lastpos=getpos _vehicle;
	_stuckcount=0;
	_lastwpname="";
	_currentwpname="";
	while {(alive _vehicle) && (fuel _vehicle!=0) && _loop} do
	{
		_currentpos=getpos _vehicle;
		if ((_currentpos distance _lastpos)<0.5) then
		{
			if !(unitready _vehicle) then
			{
				//Unstuck the vehicle if the driver is in an alive
				if (alive driver _vehicle) then
				{
					//Unstuck if a nearby collision is detected
					_stuckcount=_stuckcount+1;
					if (_stuckcount>1) then
					{
						[_vehicle] spawn vts_istransportvehicleUnstuck;
						_stuckcount=0;
					};
				};
			}
			else
			{
			_stuckcount=0;
			};

		}
		else
		{
		_stuckcount=0;
		};
		//Update last know position
		_lastpos=getpos _vehicle;
		//Track last waypoint name while unit is alive (when dead can't retrieve any more
		if (alive driver _vehicle) then 
		{
			_currentwpname=_vehicle getVariable ["vtswaypointname",""];
			if (_currentwpname!="") then
			{
				_lastwpname=_currentwpname;
			};
		};
		//Check if the vehicle can't move, tire broken or vehicle upside down, usualy the AI leave it so driver seat !alive but driver unit still alive
		if ((!alive driver _vehicle) && (alive (_vehicle getvariable "vtstranportdriver"))) then
		{
			//Set the vehicle back on track
			_vehicle setpos (getpos _vehicle);
			//Repaire tires while keeping the current damage value
			_vehicle setdamage (damage _vehicle);
			//Then we put the the driver back in
			_vehicle lockdriver false;
			(_vehicle getvariable "vtstranportdriver") assignasdriver _vehicle;
			(_vehicle getvariable "vtstranportdriver") moveindriver _vehicle;
			_vehicle lockdriver true;
			//We should heal the crew too, poor player... handling the bad AI driving :(
			{_x setdamage 0;} foreach crew _vehicle;
		};
		
		//Check if the vehicle is alone with a driver in the wild  or dead
		if (!(alive driver _vehicle) or !(canmove _vehicle) or !(alive _vehicle)) then
		{
			if (_lastwpname=="Base" or _lastwpname=="Pickup") then
			{
				_loop=false;
			};
		};
	
		sleep 3.0;
	};
	//Respawn the vehicle at base if it has been destroyed on the way back to base
	if ((!(alive _vehicle) or !(alive driver _vehicle) or !(canmove _vehicle)) && ((_lastwpname=="Base") or (_lastwpname=="Pickup"))) then
	{
		_vehicle engineOn false;
		if (vts_transportrespawning) then
		{
			_class=typeof _vehicle;
			_newtaxi=_class createvehicle (_vehicle getvariable "vtstranportbasepos");
			vtsistransportvehiclegroup=group (_vehicle getvariable "vtstranportdriver");
			[_newtaxi,"[this,vtsistransportvehiclegroup] spawn vts_isTransportVehicle;"] call vts_setobjectinit;
			[] call vts_processobjectsinit;
		};
	};
	//player sidechat "End of Check Stuck loop";
};

//Try to unstuck a vehicle by pushing it to the rear
vts_istransportvehicleUnstuck=
{
	private ["_newpos","_vehicle"];
	_vehicle=_this select 0;
	
	_newpos=getpos _vehicle findEmptyPosition[ 5 , 250 , (typeof _vehicle) ];
	if (count _newpos>1) then
	{
		_vehicle setdir (direction _vehicle+90);
		_vehicle setpos [_newpos select 0,_newpos select 1,(_newpos select 2)+1.5];
	};
	
	//_vehicle setpos [getpos _vehicle select 0,getpos _vehicle select 1,(getpos _vehicle select 2)+1.5];
	//_vehicle setVelocity [10*sin((direction _vehicle)-180),10*cos((direction _vehicle)-180),0];
};

vts_istransportVehiclewaypoint=
{
	private ["_group","_vehicle","_wpindex","_wpname","_caller"];
	_group=_this select 0;	
	_vehicle=vehicle (leader _group);
	if !(local  _vehicle) exitwith {};
	
	_wpindex=currentwaypoint _group;
	_wpname=_vehicle getVariable ["vtswaypointname",""];
	//hint format["wp %1",_wpname];
	
	_caller=_vehicle getvariable ["vtstranportbusy",objnull];
	if (_wpname=="Base") then
	{
		if (_vehicle iskindof "Helicopter") then
		{
			_vehicle land "LAND";
		}
		else
		{
			_vehicle engineon false;
		};
		_vehicle setdamage 0;
		_vehicle setFuel 1.0;
		driver _vehicle setdamage 0;
	};
	if (_wpname=="Move") then
	{
		_txt="";
		if (_vehicle iskindof "Helicopter") then
		{
			_vehicle land "GET IN";			
			waituntil {sleep 0.1;landResult _vehicle != "NotReady"};
			if (landResult _vehicle=="NotFound") then
			{
				_txt = "I can't land here, it's too dangerous give me another LZ";
			}
			else
			{
				_txt = "Here we are, be ready";
			};
		}
		else
		{
			_txt = "Here we are, you are good to go !";
		};
		
		if (_txt!="") then
		{
			vtstransportvehicle=_vehicle;
			publicvariable "vtstransportvehicle";
			_code={};
			call compile format["
			_code={if (player in vtstransportvehicle) then {vtstransportvehicle vehicleChat ""%1"";};};
			",_txt];
			[_code] call vts_broadcastcommand;
		};
	};
	if (_wpname=="Pickup") then
	{	
		_txt="";
		if (_vehicle iskindof "Helicopter") then
		{
			_vehicle land "GET IN";			
			waituntil {sleep 0.1;landResult _vehicle != "NotReady"};
			if (landResult _vehicle=="NotFound") then
			{
				_txt = "Taxi can't land here, it's too dangerous give me another LZ";
			}
			else
			{
				_timestr=str(round (vts_transportpickuptimeout/60))+" minutes";
				if (vts_transportpickuptimeout<60) then {_timestr=str(round (vts_transportpickuptimeout))+" seconds";};
				_txt =format["Taxi is landing, hurry up to board or I'll leave in %1 !",_timestr];
			};
		}
		else
		{
			_timestr=str(round (vts_transportpickuptimeout/60))+" minutes";
			if (vts_transportpickuptimeout<60) then {_timestr=str(round (vts_transportpickuptimeout))+" seconds";};
			_txt = format["Taxi at destination, hurry up to board or I'll leave in %1 !",_timestr];
		};
		if !(isnull _caller) then 
		{
			vtstransportvehicle=_vehicle;	
			publicvariable "vtstransportvehicle";
			_code={};
			call compile format["
			_code={if (group player==group %1) then {vtstransportvehicle sideChat ""%2"";};};
			",(vehiclevarname _caller),_txt];
			[_code] call vts_broadcastcommand;
		};
		_vehicle setvariable ["vtstranportbusy",objnull,true];
	};
};

//Functions  to clone a group
vts_clonegroup=
{
	private ["_group","_pos","_n","_spawn_x","_spawn_y","_spawn_z","_spawnv_x","_spawnv_y","_spawnv_z"];
	_group=_this select 0; //grp to clone
	_pos=_this select 1; //Position to clone the grp	

	
			_class="";
			_side=side _group;
			_newgroup=creategroup _side;

			_groupunit=units _group;
			_originalvehicles=[];
			_vehicles=[];
			_workvehicle=objnull;
			_code=nil;
	  
	  //I need an array of all the vehicle of the original group for coyping them
	  _n=1;
	  while {_n<=count _groupunit} do
	  {
		 _unit=_groupunit select (_n-1);
		 if (vehicle _unit!=_unit) then
		 {
		   if !((vehicle _unit) in _originalvehicles) then
		   {
			 _originalvehicles set [count _originalvehicles,vehicle _unit];
		   };
		 };
		 _n=_n+1;
	  };
	  //hint format["%1",_originalvehicles];
	  
	  //Then i create my cloned vehicles at my new position
	  _spawn_x=_pos select 0;
	  _spawn_y=_pos select 1;
	  _spawn_z=_pos select 2;
	  
	  _spawnv_x=_spawn_x;
	  _spawnv_y=_spawn_y;
	  _spawnv_z=_spawn_z;
	  
	  _n=1;
	  while {_n<=count _originalvehicles} do
	  {
		 
		_class=typeof (_originalvehicles select (_n-1));
		_veh = _class createVehicle [_spawnv_x,_spawnv_y,_spawnv_z];
		
		_vehicles set [count _vehicles,_veh];
		
		_spawnv_x=_spawn_x+5;
		_spawnv_y=_spawn_y+5;
		_n=_n+1;
	};
	  
	  //Lets' clone each of the unit in the group
	  while {(count _groupunit)>0} do
	  {
	  
		 //First we copy the unit 
		 _unit=_groupunit select 0;

		 _class=typeof _unit;
		 _temp_group=creategroup _side;
		 _clonedunit=_temp_group createUnit [_class,[_spawn_x,_spawn_y,_spawn_z],[],0,"FORM"];
		 [_clonedunit] joinsilent _newgroup;
		 //Skill set
		 [_clonedunit,(Skill _unit)] call vts_setskill;
		 //Loadout copy
		 _loadout=[_unit] call vts_getloadout;
		 [_clonedunit,_loadout] call vts_setloadout;
		 
		 _clonedunit setUnitRank rank _unit;
		 _spawn_x=_spawn_x+2;
		 _spawn_y=_spawn_y+2;
		
		if (vehicle _clonedunit!=_clonedunit) then {_clonedunit switchmove "";};
		
		//Then the vehicule he is in. 
		//Checking if the unit is in a vehicule
		 if (vehicle _unit!=_unit) then
		 {
		
		   //Checking if the vehicule has already been created
		   if ((count _vehicles)>0) then
		   {
			 _index=_originalvehicles find vehicle _unit;
			_workvehicle=_vehicles select _index; 
			};
		 

		 //Lets reassign its seat for the new vehicles;
		 _vehiok=false;
		 if (_unit == Driver (vehicle _unit)) then {_clonedunit assignasdriver _workvehicle; _clonedunit moveindriver _workvehicle;_vehiok=true;};
		 if (_unit == Gunner (vehicle _unit)) then {_clonedunit assignasgunner _workvehicle;_clonedunit moveingunner _workvehicle;_vehiok=true;};
		 if (_unit == Commander (vehicle _unit)) then {_clonedunit assignascommander _workvehicle;_clonedunit moveincommander _workvehicle;_vehiok=true;};
		 //Else lets cargo him and pray for it that there is enough space
		 if !(_vehiok) then {_clonedunit assignAsCargo _workvehicle;_clonedunit moveincargo _workvehicle;};
		 _vehiok=false;
		 
		};
	   
			 
		 _workvehicle=objnull;
		 _code=nil;
		 _groupunit=_groupunit-[_unit];
	   };
	   
		//Set varname and process init
		_vehiclegroup=[];
		{
			if (vehicle _x!=_x) then
			{
				if !((vehicle _x) in _vehiclegroup) then
				{
					[(vehicle _x),([(vehicle _x)] call vts_spawninit)] call vts_setobjectinit;
					_vehiclegroup set [count _vehiclegroup,(vehicle _x)];
				};
			};
			[_x,([_x] call vts_spawninit)] call vts_setobjectinit;
		} foreach units _newgroup;
		
		[] call vts_processobjectsinit;
};

vts_broadcastcommand=
{
	private ["_codetorun","_arg"];
	
	
	_codetorun=_this select 0;;
	_arg="";
	if (count _this>1) then {_arg=_this select 1;};
	
	if (vts_nettype==1) then
	{
			vtsnetcommand=_this;
			publicVariable "vtsnetcommand";
			_arg spawn _codetorun;
	}
	else
	{
		if (isserver) then 
		{
			vtsnetcommand=_this;
			publicVariable "vtsnetcommand";
			_arg spawn _codetorun;
		}
		else
		{
			vtsservernetcommand=_this;
			publicVariableServer "vtsservernetcommand";
		};
	};
	if (vts_debug) then {player globalchat "VTS_DEBUG : Broadcast"};	
};

vts_broadcastedcommand=
{
	private ["_arg"];
	_arg="";
	if (count _this>1) then {_arg=_this select 1;};
	_arg spawn (_this select 0);
	if (vts_debug) then {player globalchat "VTS_DEBUG : Executing broadcasted command"};
};

vts_broadcastcommandlistener=
{
	"vtsnetcommand" addPublicVariableEventHandler 
	{
		(_this select 1) call vts_broadcastedcommand;
	};
};

vts_serverbroadcastcommandlistener=
{
	"vtsservernetcommand" addPublicVariableEventHandler 
	{
		vtsnetcommand=(_this select 1);
		publicVariable "vtsnetcommand";
		_arg="";
		if (count (_this select 1)>1) then {_arg=(_this select 1) select 1;};
		_arg spawn ((_this select 1) select 0);
		if (vts_debug) then {player globalchat "VTS_DEBUG : Executing broadcasted command"};
	};
};

vts_IsSpawnHandler=
{
	private ["_SpawnHandler","_HCon"];
	_SpawnHandler=false;
	_HCon=false;
	if !(isnil "VTS_HC_AI") then
	{
		if (!(isnull VTS_HC_AI) && !((name VTS_HC_AI)=="Error: No vehicle")) then {_HCon=true};
	}
	else
	{
		VTS_HC_AI=objnull;
	};
	if (_HCon && (player==VTS_HC_AI)) then 
	{
		_SpawnHandler=true;
	};
	if (!_Hcon && isserver)  then
	{
		_SpawnHandler=true;
	};
	//player groupchat ("ok"+(str _SpawnHandler));
	_SpawnHandler;
};

vts_spawnbuilder=
{
	if ([] call vts_IsSpawnHandler) then
	{		
		//diag_log "spawn handler";
		[(_this select 0)] call vts_restorespawnsetup;
		_spawn=[] execVM "Computer\console\spawn_rt.sqf";
		//check if script done success or error to reinit the variable
		waituntil{scriptdone _spawn};
		//Broadcast spawn status to people to inform them spawning is done
		vts_server_spawningdone=true;
		publicvariable "vts_server_spawningdone";
	};
};

vts_spawnlistener=
{
	"vts_spawnarray" addPublicVariableEventHandler 
	{
		[(_this select 1)] spawn vts_spawnbuilder;
		//player sidechat "spawn";
		//diag_log "spawn";
	};
};

vts_DamageSecurityTempo=
{
	sleep 5;
	private ["_veh","_applyvelfix"];
	_veh=(_this select 0);
	_applyvelfix=true;
	if (count _this>1) then {_applyvelfix=_this select 1;};
	_veh allowDamage true;
	_veh enablesimulation true;
	if ((local _veh) && _applyvelfix) then {sleep 0.25;_veh setvelocity [(velocity _veh select 0),(velocity _veh select 1),(velocity _veh select 2)-1];};
};


vts_NoVelocity=
{
	private "_v";
	_v=_this select 0;

	while {(!isnull _v) and (alive _v)} do
	{
	_v setVelocity[0,0,0];
	};
};

vts_OpenComputer=
{
	private "_keypressed";
	_keypressed = _this select 1;
	if (_keypressed in actionKeys "teamswitch") then 
	{
		if (dialog) then 
		{
			[] call Dlg_StoreParams;
			closeDialog 0
		}
		else
		{
			[] execVM "Computer\cpu_dialog.sqf";
		};
	  
	};
};

vts_SideDisabled=
{
	private ["_txt","_task"];
	_txt=_this select 0;
	removeAllWeapons player;
	_task = player createSimpleTask [_txt];
	_task setTaskState "Failed";
	_task setSimpleTaskDescription [_txt,_txt,_txt];
	player remoteControl driver player; player switchCamera "INTERNAL";
	disableUserInput false;
	for "_j" from 10 to 0 step -1 do 
		{
	  //call compile format["cutText [""%1"", ""BLACK FADED"",0];",_txt];
	  call compile format["cutText ["""", ""BLACK FADED"",0];",_txt];
	  sleep 1;
	  };
	disableUserInput false;
	endmission "END4";
};

vts_SetRain=
{
	private ["_pluie","_transtime"];
	_pluie=_this select 0;
	_transtime=10;
	if (count _this>1) then {_transtime=_this select 1;};
	if (vtsarmaversion<3) then 
	{	
		_transtime setrain _pluie;
	}
	else
	{
		_transtime setrain _pluie;
	};
		
};

vts_SetCloud=
{
	private ["_cloud"];
	_cloud=_this select 0;
	if (vtsarmaversion<3) then 
	{	
		1 setOvercast _cloud;
	}
	else
	{
		skipTime -24;
		86400 setOvercast _cloud;
		skipTime 24;
		sleep 0.1; 
		call compile "simulWeatherSync;";
		if !(isnil "brume") then {(brume+[0]) call vts_setfog;};
		if !(isnil "pluie") then {[pluie,0] call vts_SetRain;};
	};
};

vts_SetHour=
{
	private ["_hour"];
	_hour=_this select 0;
	setdate [date select 0, date select 1, date select 2, _hour, date select 4];
};

vts_MissionsSuccess=
{	
	private "_code";
	"Mission terminated : Success" spawn vts_gmmessage;
	_code=
	{
	cutText ["Mission successfully completed","black out",5];
	sleep 8;
	endmission "END1";
	};
	[_code] call vts_broadcastcommand;
};

vts_MissionFail=
{
	private "_code";
	"Mission terminated : Fail" spawn vts_gmmessage;
	_code=
	{
	cutText ["Mission failed","black out",1];
	sleep 4;
	endmission "LOSER";
	};
	[_code] call vts_broadcastcommand;
};

vts_MissionsSuccessConfirm=
{
	ctrlsettext [200,"Please confirm the Success of the mission"];
	"Please confirm the Success of the mission" spawn vts_gmmessage;
	ctrlShow [10557,false];
	ctrlShow [10560,true];
	sleep 3.0;
	ctrlShow [10560,false];
	ctrlShow [10557,true];
};

vts_MissionFailConfirm=
{
	ctrlsettext [200,"Please confirm the Fail of the mission"];
	"Please confirm the Fail of the mission" spawn vts_gmmessage;
	ctrlShow [10558,false];
	ctrlShow [10561,true];
	sleep 3.0;
	ctrlShow [10561,false];
	ctrlShow [10558,true];
};

vts_PlayerstoBaseConfirm=
{
	ctrlsettext [200,"Please confirm moving player to their base"];
	"Please confirm moving player to their base" spawn vts_gmmessage;
	ctrlShow [10756,false];
	ctrlShow [10755,true];
	sleep 3.0;
	ctrlShow [10755,false];
	ctrlShow [10756,true];
};

vts_C=
{
	call compile _this;
};

vts_FC=
{
	private ["_ftext","_par1","_par2","_par3","_par4","_par5","_par6","_par7","_par8","_par9","_par10"];
	_ftext=_this select 0;
	_par1=_this select 1;
	_par2="";
	_par3="";
	_par4="";
	_par5="";
	_par6="";
	_par7="";
	_par8="";
	_par9="";
	_par10="";
	if (count _this>2) then {_par2=_this select 2;};
	if (count _this>3) then {_par3=_this select 3;};
	if (count _this>4) then {_par4=_this select 4;};
	if (count _this>5) then {_par5=_this select 5;};
	if (count _this>6) then {_par6=_this select 6;};
	if (count _this>7) then {_par7=_this select 7;};
	if (count _this>8) then {_par8=_this select 8;};
	if (count _this>9) then {_par9=_this select 9;};
	if (count _this>10) then {_par10=_this select 10;};
	call compile format[_ftext,_par1,_par2,_par3,_par4,_par5,_par6,_par7,_par8,_par9,_par10];
};

vts_SendPlayerToBase=
{
	hint "Teleporting you to your spawn... Done"; cutText ["","BLACK OUT",1];
	if (isplayer player) then
	{
		_unit=player;
		_side=side group _unit;
		_markername="";
		call compile format["_markername=""%1_Base"";",_side];
		_pos=getmarkerpos _markername;
		vehicle _unit setVelocity [0,0,0];
		moveout _unit;
		sleep 0.5;
		_unit setVelocity [0,0,0];
		_unit setposasl [((_pos select 0)-5)+random 10,((_pos select 1)-5)+random 10,(getTerrainHeightASL _pos)+0.5];
		_base=objnull;
		call compile format["_base=%1_spawn;",side group _unit];	
		if ((surfaceiswater _pos) or ((ASLToATL visiblePositionasl _base select 2)>2)) then
		{
			_unit setposasl [(visiblePositionASL _base select 0),(visiblePositionASL _base select 1),(visiblePositionASL _base select 2)+1];
		};
	};
	cutText ["","BLACK IN",1]	
};

vts_GetVehicleIcon=
{
	private ["_classname","_icon","_subicon","_picttype","_classtype"];
	_classname = _this select 0;
	_picttype="icon";
	_classtype="Man";
	if (count _this>1) then {_classtype=_this select 1;};
	if (_classtype=="Land" or _classtype=="Air" or _classtype=="Static" or _classtype=="Ship" or _classtype=="Empty") then {_picttype="picture";};
	_icon=getText (configFile >> "CfgVehicles" >> _classname >> _picttype); 
	_subicon=getText (configFile >> "CfgVehicleIcons" >> _icon); 
	if (_subicon!="") then {_icon=_subicon;};
	_icon;
};

vts_GetClassDisplayName=
{
	private ["_classname","_name","_type","_typeoverwrite","_cfg","_arpos"];
	_classname=_this select 0;
	
	if (typename _classname!="STRING") exitwith {""};
	
	_type="CfgVehicles";
	_typeoverwrite="";
	if ((count _this)>1) then {_typeoverwrite=_this select 1;};
	
	if (_typeoverwrite=="Faction") then {_type="CfgFactionClasses";};
	
	if (_typeoverwrite=="Group") then
	{
		if (_classname in vts_custom_group_list) then
		{
			_name="@"+_classname;
		}
		else
		{
			_cfg="";
			call compile format [
			"_arpos=(%1_group find ""%2"");
			if (_arpos>-1) then
			{
				_cfg=%1_GroupConfig select _arpos;
			}
			else
			{
				_cfg=(configfile >> """");
			};
			"
			,local_var_console_valid_camp,_classname];
			_name=GetText(_cfg >> "name");	
		};
	}
	else
	{		
		_name=gettext (configfile >> _type >> _classname >> "displayName");
	};
	
	if (_name!="") then {_classname=_name;};
	
	_classname;
};

vts_findmatchinarray=
{
	private ["_array1","_array2","_return"];
	_array1=_this select 0;
	_array2=_this select 1;
	_return=_this select 2;

	for "_i" from 0 to (count _array1)-1 do
	{
		if ((_array1 select _i) in _array2) exitwith 
		{
			_return=(_array1 select _i);
			_return;
		};
	};
	_return;	
};

vts_setHeight=
{
	private ["_obj","_pos","_height"];
	_obj=_this select 0;
	_height=_this select 1;
	if (local _obj) then
	{
		_pos=getposatl _obj;
		_obj setposatl [_pos select 0,_pos select 1,(_pos select 2)+_height];
		
	};
};
if (isserver) then {publicVariable "vts_setHeight";};

vts_cleanworld=
{
	private "_type";
	_type=_this select 0;	
	if (_type=="bodies") then 
	{
		{if ((vehicle _x==_x) && (((getposatl _x) select 2)<0.01)) then {deletevehicle _x;} else {deletevehicle _x;};} forEach alldeadmen;
	};
	if (_type=="wrecks") then 
	{
		{if !(alive _x) then {deletevehicle _x;};} forEach vehicles;
	};	
	if (_type=="items") then 
	{
		{deletevehicle _x;} forEach (allMissionObjects "WeaponHolder");
	};		
	("World cleaned from : "+_type) spawn vts_gmmessage;
};

vts_3DAttach=
{
	private ["_posasl","_object","_objs","_target","_obj","_dir","_dirtarget","_inherit","_angle"];
	_posasl=_this select 0;
	_object=_this select 1;
	_dir=direction _object;	

	if (count _this>2) then {_dir=_this select 2;};
	_dir=round _dir;
	//if (_dir>360) then {_dir=_dir-360;};
	//if (_dir<0) then {_dir=_dir+360;};
	//player sidechat str round _dir;
	
	_target=objnull;
	
	_objs=[_posasl,["LandVehicle","Air","Ship"],10] call vts_nearestobjects3d;
	
	if (isnil "object3D") then {object3D=objnull;};
	for "_i" from 0 to (count _objs)-1 do 
	{
		_obj=_objs select _i;
		if (((typeof _obj)!=vts_dummy3darrow) && ((typeof _obj)!=vts_dummyvehicle) && (_obj!=_object) && (_obj!=object3D) ) then {_target=_obj;};
		if !(isnull _target) then {_i=count _objs};
	};
	
	if !(isnull _target) then
	{
		hint ("Object Binded to "+(typeof _target));
		//Optimize by attaching on the same object (real hiearchy is just killing the framerate)
		_inherit=_target getvariable ["vts_attachinherit",_target];	
		//_object setpos _posasl;		
		_object attachto [_inherit];
		_object setvariable ["vts_attachinherit",_inherit,true];
		_angle=_dir-(direction _inherit);
		//if (_angle>360) then {_angle=_angle-360;};
		//if (_angle<0) then {_angle=_angle+360;};
		_object setDir _angle;

		if (vtsarmaversion>2) then {call compile "_inherit disableCollisionWith _object;"};
		//player sidechat "ange: "+(str _angle)+" obj: "+( str _dir)+" inh: "+str (direction _inherit);
	}
	else
	{
		hint "!!! No object found to bind on !!!";
	};
	playsound "computer";
};

vts_animatedoor=
{
	_strinstr=
	{
		private ["_needle","_haystack","_needleLen","_hay","_found"];
		 _needle = _this select 1;
		 _haystack = toArray (_this select 0);
		 _needleLen = count toArray _needle; 
		 _hay = +_haystack;
		 _hay resize _needleLen; 
		 _found = false;
		 for "_i" from _needleLen to count _haystack do 
		 {
			 if (toString _hay == _needle) exitWith {_found = true};
			 _hay set [_needleLen, _haystack select _i];
			 _hay set [0, "x"]; _hay = _hay - ["x"] 
		 };
	 _found;
	 };
	 private ["_helico","_state","_doorlist","_cfg","_cname","_waitforanim","_animtime","_curtime","_animname","_ltime"];
	 _helico=_this select 0;
	 _state=_this select 1;
	 _waitforanim=false;
	 if (count _this>2) then {_waitforanim=_this select 2;};
	 
	 _cfg=(configFile >> "CfgVehicles" >> (typeof _helico) >> "AnimationSources");
	 _doorlist=[];
	 _animtime=0;
	 _animname="";
	 for "_i" from 0 to count (_cfg)-1 do
	 {
		_cname=configname (_cfg select _i);
		_curtime=getnumber ((_cfg select _i)>>"animPeriod");
		if ( ([_cname,"door"] call _strinstr) or ([_cname,"ramp"] call _strinstr) ) then
		{
				_doorlist set [count _doorlist,_cname];
				_curtime=getnumber ((_cfg select _i)>>"animPeriod");
				if ((_curtime max _animtime)==_curtime) then {_animtime=_curtime;_animname=_cname;};
		};
	 };
	 //systemchat str _doorlist;
	 if ((count _doorlist)>0) then
	 {
		{
			_helico animate [_x,_state];
			_helico animatedoor [_x,_state];
		} foreach _doorlist;
		if (_waitforanim) then 
		{
			_ltime=time+20;
			waituntil {sleep 0.1;(((_helico animationphase _animname)==_state) or (time>=_ltime))};
		};
	};
	
	
};

vts_fastropedraw=
{
	private ['_ropeY','_vecdir','_gen','_caller','_id','_initpos','_simu','_loop','_vx','_vy','_step','_time','_source','_possource','_poslink','_offset','_posoffset','_ropedist','_maxropedist','_dist'];
	_source=_this select 0;
	_gen=_this select 1;
	_offset=_source worldToModel getpos _gen;
	_loop=true;
	_simu=0.01;
	_ropeY=0.3;
	_maxropedist=vts_FastRopeLength;
	_time=time;
	//_gen switchmove "commander_apcwheeled2_out";
	//
	_gen spawn {waituntil {(vehicle _this==_this)};_this switchmove "commander_apcwheeled2_out";};
	while {_loop} do
	{
		
		_possource=visiblePositionASL _source;
		if !(surfaceiswater _possource) then {_possource=asltoatl _possource};
		_poslink=aimPos _gen;
		if !(surfaceiswater _poslink) then {_poslink=asltoatl _poslink};
		
		_posoffset=_source modeltoworld [(_offset select 0)/1.5,_offset select 1,_offset select 2];
		
		_vecdir=vectordir _gen;
		_vecdir=[(_vecdir select 0)*_ropeY,(_vecdir select 1)*_ropeY,(_vecdir select 2)*_ropeY];
		_poslink=[(_poslink select 0)+(_vecdir select 0),(_poslink select 1)+(_vecdir select 1),(_poslink select 2)];
		
		drawLine3D [[(_posoffset select 0),(_posoffset select 1),(_possource select 2)+1.0],[(_poslink select 0),(_poslink select 1),(_poslink select 2)],[0,0,0,1]];
		_dist=_gen distance _source;
		if ((_poslink select 2)+_dist<=_maxropedist) then {_ropedist=0;} else {_ropedist=((_poslink select 2)+_dist)-_maxropedist;};
		drawLine3D [[(_poslink select 0),(_poslink select 1),(_poslink select 2)],[(_poslink select 0),(_poslink select 1),_ropedist],[0,0,0,1]];
		//drawLine3D [[(_possource select 0),(_possource select 1),(_possource select 2)+0.5],[(_poslink select 0),(_poslink select 1),(_poslink select 2)],[0,0,0,1]];
		//drawLine3D [[(_possource select 0)+0.01,(_possource select 1)+0.01,_possource select 2],[(_poslink select 0)+0.01,(_poslink select 1)+0.01,(_poslink select 2)],[0,0,0,1]];
		//drawLine3D [[(_possource select 0)-0.01,(_possource select 1)-0.01,_possource select 2],[(_poslink select 0)+0.01,(_poslink select 1)+0.01,(_poslink select 2)],[0,0,0,1]];
		sleep _simu;
		if (((getpos _gen select 2)<0.5) or ((_time+10)<time) or (_dist>_maxropedist)) then {_loop=false;};
	};
	_gen switchmove "";
};

vts_fastropego=
{
	private ['_gen','_caller','_id','_initpos','_simu','_loop','_vx','_vy','_step','_time','_source','_possource','_poslink','_maxropedist'];
	
	_gen = _this select 0;
	//_caller = _this select 1;
	//_id = _this select 2;
	_source=vehicle _gen;
	if ((vehicle _source==_gen) or (driver _source==_gen)) exitwith {};
	moveout _gen;
	unassignVehicle _gen;
	//_gen removeAction _id;	
	_loop=true;
	_simu=0.01;
	_step=-6;
	_maxropedist=vts_FastRopeLength+1;
	_time=time;
	[{_this spawn vts_fastropedraw;},[_source,_gen]] call vts_broadcastcommand;
	while {_loop} do
	{
		sleep _simu;
		_vx=velocity _gen select 0;
		_vy=velocity _gen select 1;
		if (_vx>0) then {_vx=_vx-(_simu*-_step);} else {_vx=_vx+(_simu*-_step);};
		if (_vy>0) then {_vy=_vy-(_simu*-_step);} else {_vy=_vy+(_simu*-_step);};
		_gen setvelocity [_vx,_vy,_step];	
		if (((getpos _gen select 2)<0.5) or ((_time+10)<time) or ((_gen distance _source)>_maxropedist)) then {_loop=false;};		
	
	};

};

vts_fastropecargoallowropecheck=
{
	private '_b';
	_b=false;
	if (vehicle player!=player) then
	{
		if (driver vehicle player!= player) then
		{
			if ((vehicle player) iskindof 'Helicopter') then
			{
				_b=(vehicle player) getvariable ['vts_fastropeready',false];
			};
		};
	};
	_b;
};

vts_fastropepilotallowcheck=
{
	private ['_b','_s'];
	_b=false;
	if (vehicle player!=player) then
	{
		if ((driver vehicle player)==player) then
		{
			if ((vehicle player) iskindof 'Helicopter') then
			{
				_s=gettext (configfile >> 'cfgVehicles' >> (typeof (vehicle player)) >> 'simulation');
				if (_s=='helicopter' or _s=='helicopterx') then
				{
					if (getnumber (configfile >> 'cfgVehicles' >> (typeof (vehicle player)) >> 'transportsoldier')>0) then
					{
						if !((vehicle player) getvariable ['vts_fastropeready',false]) then 
						{
							_b=true;
						};
					};
				};
			};	
		};
	};	
	_b;
};

vts_fastropepilotdisallowcheck=
{
	private '_b';
	_b=false;
	if (vehicle player!=player) then
	{
		if ((driver vehicle player)==player) then
		{
			if ((vehicle player) iskindof 'Helicopter') then
			{
				if ((vehicle player) getvariable ['vts_fastropeready',false]) then 
				{
					_b=true;
				};
			};
		};
	};
	_b;
};

vts_FastropeEngage=
{
	private "_veh";
	_veh=(vehicle player);
	_veh setvariable ["vts_fastropeready",true,true];
	[{_this spawn vts_animatedoor;},[_veh,1]] call vts_broadcastcommand;
	
};

vts_FastropeDisengage=
{
	private "_veh";
	_veh=(vehicle player);
	_veh setvariable ["vts_fastropeready",nil,true];
	[{_this spawn vts_animatedoor;},[_veh,0]] call vts_broadcastcommand;
	
};

vts_fastrope=
{
	[player,"<t color=""#e9be40"">Rappel Down</t>",{_this spawn vts_fastropego;},[],100,false,false,"","[] call vts_fastropecargoallowropecheck"] call vts_AddAction;
	[player,"<t color=""#a3ff47"">Rappel Winch Down</t>",{[] spawn vts_FastropeEngage;},[],100,false,false,"","[] call vts_fastropepilotallowcheck"] call vts_AddAction;
	[player,"<t color=""#da1337"">Rappel Winch Up</t>",{[] spawn vts_FastropeDisengage;},[],100,false,false,"","[] call vts_fastropepilotdisallowcheck"] call vts_AddAction;
};


vts_velocitytransform=
{
	private ["_object","_target","_offset"];
	_object=_this select 0;
	_target=_this select 1;
	
	_pos1=visiblePositionASL _object;
	_vel1=velocity _object;
	_dir1=vectordir _object;
	_vup1=vectorup _object;
	

	_pos2=visiblePositionASL _target;
	_vel2=velocity _target;
	_dir2=vectordir _target;
	_vup2=vectorup _target;	
	while {alive _object} do
	{
		_offset=_target modeltoworld [20,0,0];
		//_object setVelocityTransformation [_pos1,_pos2,_vel1,_vel2,_dir1,_dir2,_vup1,_vup2,0.0];
		_object setVelocityTransformation [visiblePositionASL _object,[_offset select 0,_offset select 1,visiblePositionASL _target select 2],velocity _object,velocity _target, vectordir _object,vectordir _target,vectorUp _object,vectorUp _target,1];
		sleep 0.001;
	};
};

vts_velocityfollow=
{
	private ['_object','_target','_x','_y','_z','_offset'];
	_object=_this select 0;
	_target=_this select 1;
	//_offset=_this select 0;
	_offset=[0,0,-5];
	
	while {alive _object} do
	{
		_pos1=visiblePositionASL _object;
		_pos2=visiblePositionASL _target;
	
		_x=(_pos2 select 0)-(_pos1 select 0);

		_y=(_pos2 select 1)-(_pos1 select 1);
	
		_z=((_pos2 select 2)+(_offset select 2))-(_pos1 select 2);
		//player sidechat (str (_pos1 select 0))+" "+(str (_pos2 select 0));
		_object setvelocity [_x,_y,_z];
		//_object setvectordir (vectordir _target);
		//_object setvectorup (vectorup _target);
		sleep 0.01;
	};
};

vts_helicopterliftcheck=
{
	private ['_b','_s','_pos','_bbox','_bbsize','_var'];
	_b=false;
	_var=(vehicle player) getvariable ['vts_helicopterlifthookready',nil];
	if !(isnil '_var') then
	{
		if (speed (vehicle player)<20) then
		{
			//_pos=getposatl (vehicle player);
			_pos=getpos (vehicle player);
			//if (surfaceiswater _pos) then {_pos=atltoasl _pos;};
			if (_pos select 2<=25) then
			{	
				_b=true;
			};
		};
	};
	_b;
};

vts_helicopterliftreleasecheck=
{
	private '_b';
	_b=false;
	if (vehicle player!=player) then
	{
		if ((driver vehicle player)==player) then
		{
			if ((vehicle player) iskindof 'Helicopter') then
			{
				if !(isnull ((vehicle player) getvariable ['vts_liftattached',objnull])) then 
				{
					_b=true;
				};
			};
		};
	};
	_b;
};	

vts_helicopterliftdraw=
{
	private ['_gen','_caller','_id','_initpos','_simu','_loop','_vx','_vy','_step','_time','_source','_possource','_poslink'];
	_source=_this select 0;
	_gen=_this select 1;
	
	_loop=true;
	_simu=0.01;
	_time=time;
	while {_loop} do
	{
		_possource=visiblePositionASL _source;
		if !(surfaceiswater _possource) then {_possource=asltoatl _possource;};
		_poslink=visiblePositionASL _gen;
		if !(surfaceiswater _poslink) then {_poslink=asltoatl _poslink;};	
		drawLine3D [[(_possource select 0),(_possource select 1),(_possource select 2)+0.5],[(_poslink select 0),(_poslink select 1),(_poslink select 2)+1],[0,0,0,1]];
		sleep _simu;
		if (isnull (_gen getvariable ['vts_liftattached',objnull])) then {_loop=false;};
	};
};

vts_helicopterliftgo=
{
	private ['_attachoffset','_properrelease','_lifterror','_target','_objs','_obj','_pos','_veh','_loop','_speed','_dir','_v1','_v2','_mod','_n','_height','_targetbbox','_targetposasl','_vehposasl','_targettop','_targetbottom','_posfix','_hookstilldown','_playervehbbox'];
	
	_veh=vehicle player;
	_target=objnull;
	_objs=[getposasl _veh,['LandVehicle','Air','Ship','ReammoBox','ReammoBox_F'],3] call vts_nearestobjects2d;
	_mod=-1;

	_lifterror=
	{
		private '_txt';
		_txt=_this select 0;
		playsound ['vtslifterror',true];
		for '_i' from 0 to 4 do
		{
			sleep 0.1;
			vts_helicopterlifthudtxt=_txt;
			vts_helicopterlifthudcolor='#(argb,8,8,3)color(1,0,0,0.5)';
			sleep 0.1;
			vts_helicopterlifthudcolor='#(argb,8,8,3)color(1,0.5,0,0.5)';
			vts_helicopterlifthudtxt=nil;
		};
		vts_helicopterlifthudcolor=nil;
	};
	
	for "_i" from 0 to (count _objs)-1 do 
	{
		_obj=_objs select _i;
		if (((typeof _obj)!=vts_dummy3darrow) && ((typeof _obj)!=vts_dummyvehicle) && (_obj!=_veh) && (isnull (_obj getvariable ['vts_attachinherit',objnull]))) then {_target=_obj;};
		if !(isnull _target) then {_i=count _objs};
	};
	if !(isnull _target) then
	{
		_targetbbox=boundingBox _target;
		_playervehbbox=boundingbox _veh;
		_mtarget=(((_targetbbox select 1) select 0)-((_targetbbox select 0) select 0))*(((_targetbbox select 1) select 1)-((_targetbbox select 0) select 1))*(((_targetbbox select 1) select 2)-((_targetbbox select 0) select 2))*(getnumber (configfile >> 'cfgvehicles' >> (typeof _target)>> 'armor')+1);
		_mplayer=(((_playervehbbox select 1) select 0)-((_playervehbbox select 0) select 0))*(((_playervehbbox select 1) select 1)-((_playervehbbox select 0) select 1))*(((_playervehbbox select 1) select 2)-((_playervehbbox select 0) select 2))*(getnumber (configfile >> 'cfgvehicles' >> (typeof _veh)>> 'armor')+1);

		//player sidechat (str _mtarget) + " :t p: "+ (str _mplayer);

		if !(alive _target) exitwith 
		{
			['Hook damaged'] spawn _lifterror;
		};

		if (((_mplayer/2)<_mtarget) && vts_HelicopterLiftWeightCheck) exitwith 
		{
			['Too heavy to hook'] spawn _lifterror;
		};
		
		_targettop=((_targetbbox select 1) select 2);
		_targetbottom=((_targetbbox select 0) select 2);
		_posfix=getpos _target;
		_veh setvariable ['vts_liftattached',_target,true];
		_dir=direction _target;
		_pos=getposatl _target;
		if (surfaceiswater _pos) then 
		{	
			//Issue from AtltoAsl?
			_pos=atltoasl _pos;
			if ((_pos select 2)<0) then {_pos=[_pos select 0,_pos select 1,-0.5];};
		};
		_attachoffset=(_veh worldtomodel _pos);
		_target attachto [_veh,[0,0,(_attachoffset select 2)-(_targetbottom)+0.25]];
		[{if (local (_this select 1)) then {(_this select 1) setdir (_this select 0);};},[(_dir-(direction _veh)),_target]] call vts_broadcastcommand;
		_veh setvariable ['vts_helicopterlifthookready',nil,true];
		
		//player sidechat "o:"+str _pos;
		
		[{_this spawn vts_helicopterliftdraw;},[_target,_veh]] call vts_broadcastcommand;
			
		_hookstilldown=false;
		_properrelease=false;
		_loop=true;
		_n=1;
		while {_loop} do
		{
			_n=_n+1;
			if ((!alive _veh) or !(alive _target)) then 
			{
				_loop=false;
				_hookstilldown=false;
			};
			if (isnull (_veh getvariable ['vts_liftattached',objnull])) then
			{
				_loop=false;
				_hookstilldown=false;
				_properrelease=true;
			};
			_pos=getpos _target;
			_targetposasl=getposasl _target;
			_vehposasl=getposasl _veh;
			if (terrainIntersectASL [_vehposasl,[_targetposasl select 0,_targetposasl select 1,(_targetposasl select 2)+(_targetbottom+_targettop)-(_posfix select 2)]]) then
			{
				_hookstilldown=true;
				_loop=false;
			};
			if (lineIntersects [_vehposasl, [_targetposasl select 0,_targetposasl select 1,(_targetposasl select 2)-0.25], _veh, _target]) then
			{
				_hookstilldown=true;
				_loop=false;
			};
			if (((_pos select 2)+(_targetbottom+_targettop)-(_posfix select 2))<=20) then 
			{
				_height=round ((_pos select 2)+(_targetbottom+_targettop))/2;
				if (_height<1) then {_height=1;};
				_mod=_height;
			}
			else
			{
				_mod=-1;
			};
			if (_mod>0) then 
			{
				if ((_n mod _mod)==0) then 
				{
					playsound ['vtsliftbeep',true];
				};
			};
						
			sleep 0.1;
		};
		
		detach _target;		
		[{if (local (_this select 1)) then {(_this select 1) setvelocity (_this select 0);};},[(velocity _veh),_target]] call vts_broadcastcommand;
		
		if !(_properrelease) then
		{
			_v1=(velocity _veh select 0);
			if (_v1<0) then {_v1=_v1*-1};
			_v2=(velocity _veh select 1);
			if (_v2<0) then {_v2=_v2*-1};
			_speed=((_v1+_v2)/2)/2;
			_veh setvelocity [velocity _veh select 0,velocity _veh select 1,(velocity _veh select 2)-_speed];
		};
		_veh setvariable ['vts_liftattached',nil,true];
		
		if (_hookstilldown) then 
		{
			_veh setvariable ['vts_helicopterlifthookready',true,true];
			[] spawn vts_helicopterlifthookdowned;
		};
	}
	else
	{
		['Hooks not aligned'] spawn _lifterror;
	};
	
};

vts_helicopterlifthud_update=
{
	disableserialization;
	private ['_green','_green','_list','_object','_i','_target','_obj','_bkgpos','_greenpos','_targetpos','_targetworldpos','_dist','_scalex','_scaley','_bkgcenter','_x','_y','_relheight','_vehpos','_color']; 
	_display=_this select 0;
	_green=_this select 1;
	_target=objnull;
	_dist=20;
	_vehpos=getposatl (vehicle player);
	if (surfaceiswater _vehpos) then {_vehpos=atltoasl _vehpos;};
	_relheight=(_vehpos select 2)-((getpos (vehicle player)) select 2);
	_list = nearestObjects [[(getpos vehicle player) select 0, (getpos vehicle player) select 1,_relheight],['LandVehicle','Air','Ship','ReammoBox','ReammoBox_F'],_dist];
	for "_i" from 0 to (count _list)-1 do 
	{
		_obj=_list select _i;
		if (((typeof _obj)!=vts_dummy3darrow) && ((typeof _obj)!=vts_dummyvehicle) && (_obj!=(vehicle player)) && (isnull (_obj getvariable ["vts_attachinherit",objnull]))) then {_target=_obj;};
		if !(isnull _target) then {_i=count _list};
	};	
	if !(isnull _target) then 
	{
		_green ctrlshow true;
		_bkgpos = ctrlPosition (_display displayctrl 1200);
		_greenpos = ctrlPosition _green;
		_scalex= (_dist+1) / ((_bkgpos select 2)/2);
		_scaley= (_dist+1) / ((_bkgpos select 3)/2);
		_bkgcenter= [(_bkgpos select 0)+((_bkgpos select 2)/2)-((_greenpos select 2)/2),(_bkgpos select 1)+((_bkgpos select 3)/2)-((_greenpos select 3)/2)];
		
		_targetpos = (vehicle player) worldtomodel getposatl _target;
		
		_x=(_bkgcenter select 0)+((_targetpos select 0)/_scalex);
		if (_x<(_bkgpos select 0)) then {_x=(_bkgpos select 0);};
		if (_x>((_bkgpos select 0)+(_bkgpos select 2)-(_greenpos select 2))) then {_x=(_bkgpos select 0)+(_bkgpos select 2)-(_greenpos select 2);};
		_y=(_bkgcenter select 1)-((_targetpos select 1)/_scaley);
		if (_y<(_bkgpos select 1)) then {_y=(_bkgpos select 1);};
		if (_y>((_bkgpos select 1)+(_bkgpos select 3)-(_greenpos select 3))) then {_y=(_bkgpos select 1)+(_bkgpos select 3)-(_greenpos select 3);};
		
		_green ctrlsetPosition [_x,_y,_greenpos select 2,_greenpos select 3];
		_green ctrlCommit 0;
		

		_targetworldpos=getposasl _target;
		if (([_targetworldpos select 0,_targetworldpos select 1,0] distance [_vehpos select 0,_vehpos select 1,0])<=3) then
		{
			_color='#(argb,8,8,3)color(0,1,0,0.5)';
		}
		else
		{
			_color='#(argb,8,8,3)color(1,0.5,0,0.5)';
		};		
		if !(isnil "vts_helicopterlifthudcolor") then {_color=vts_helicopterlifthudcolor;};
		if !(isnil "vts_helicopterlifthudtxt") then 
		{
			(_display displayCtrl 1208) ctrlSetText vts_helicopterlifthudtxt;
		}
		else 
		{
			(_display displayCtrl 1208) ctrlSetText '';
		};
		_green ctrlsettext _color;
	}
	else
	{
		(_display displayCtrl 1208) ctrlSetText '';
		_green ctrlshow false;
	};
};

vts_helicopterhookdowncheck=
{
	private ['_b','_s','_pos','_bbox','_bbsize','_var'];
	_b=false;
	_var=(vehicle player) getvariable ['vts_helicopterlifthookready',nil];
	if (isnil '_var') then
	{
		if (vehicle player!=player) then
		{
			if ((driver vehicle player)==player) then
			{
				//if (speed (vehicle player)<20) then
				//{
					//_pos=getposatl (vehicle player);
					//_pos=getpos (vehicle player);
					//if (surfaceiswater _pos) then {_pos=atltoasl _pos;};
					//if (_pos select 2<=25) then
					//{
						if ((vehicle player) iskindof 'Helicopter') then
						{
							_s=gettext (configfile >> 'cfgVehicles' >> (typeof (vehicle player)) >> 'simulation');
							if (_s=='helicopter' or _s=='helicopterx') then
							{
								if (getnumber (configfile >> 'cfgVehicles' >> (typeof (vehicle player)) >> 'transportsoldier')>7) then
								{					
									_bbox=boundingBox (vehicle player);
									_bbsize=(((_bbox select 1) select 0)-((_bbox select 0) select 0))*(((_bbox select 1) select 1)-((_bbox select 0) select 1))*(((_bbox select 1) select 2)-((_bbox select 0) select 2));
									//player sidechat str _bbsize;
									if ((_bbsize>1000) or !(vts_HelicopterLiftWeightCheck)) then 
									{
										if (isnull ((vehicle player) getvariable ['vts_liftattached',objnull])) then 
										{
											_b=true;
										};
									};
								};
							};
						};	
					//};
				//};
			};
		};
	};
	_b;
};

vts_helicopterhookdown=
{
	(vehicle player) setvariable ['vts_helicopterlifthookready',true,true];
	[] spawn vts_helicopterlifthookdowned;
};

vts_helicopterhookupcheck=
{
	private ['_b','_var'];
	_var=(vehicle player) getvariable ['vts_helicopterlifthookready',nil];
	if !(isnil '_var') then
	{
		_b=true;
	}
	else
	{
		_b=false;
	};
	_b;
};

vts_helicopterhookup=
{
	
	(vehicle player) setvariable ['vts_helicopterlifthookready',nil,true];
};

vts_helicopterliftdrawnhookdowned=
{
	private ['_var','_veh','_lastpos','_curpos'];
	_veh=_this select 0;
	while {_var=_veh getvariable ['vts_helicopterlifthookready',nil];not isnil '_var'} do
	{
		_lastpos=_veh modeltoworld [0,0,-25];
		if !(surfaceiswater _lastpos) then {_lastpos=asltoatl _lastpos;};
		_curpos=visiblePositionASL _veh;
		if !(surfaceiswater _curpos) then {_curpos=asltoatl _curpos;};
		drawLine3D [[(_curpos select 0),(_curpos select 1),(_curpos select 2)+0.5],[(_lastpos select 0),(_lastpos select 1),(_lastpos select 2)],[0,0,0,1]];
		sleep 0.01;
	};
};

vts_helicopterlifthookdowned=
{
	disableserialization;
	private ['_display','_green','_loop','_veh','_v1','_v2','_speed','_pos','_var'];
	19458 cutrsc ['vts_lifthud','plain'];
	_display=(uiNamespace getVariable 'vts_lifthud_id');
	_green=_display displayCtrl 1207;
	_green ctrlshow false;
	_loop=true;
	_veh=vehicle player;
	[{[_this select 0] spawn vts_helicopterliftdrawnhookdowned;},[_veh]] call vts_broadcastcommand;
	while {_loop} do
	{
		[_display,_green] spawn vts_helicopterlifthud_update;
		
		if ((speed _veh)>=50) then
		{
			_pos=_veh modeltoworld [0,0,-25];
			if !(surfaceiswater _pos) then {_pos=atltoasl _pos;};
			if (lineIntersects [getposasl _veh,_pos,_veh]) then
			{
				_v1=(velocity _veh select 0);
				if (_v1<0) then {_v1=_v1*-1};
				_v2=(velocity _veh select 1);
				if (_v2<0) then {_v2=_v2*-1};
				_speed=(((_v1+_v2)/2)/2);
				_veh setvelocity [velocity _veh select 0,velocity _veh select 1,(velocity _veh select 2)-_speed];
				_veh setvariable ['vts_helicopterlifthookready',nil,true];
			};
		};
		sleep 0.1;
		_var=_veh getvariable ['vts_helicopterlifthookready',nil];
		if ((isnil '_var') or (!alive player) or (_veh!=vehicle player)) then {_loop=false};
	};
	_veh setvariable ['vts_helicopterlifthookready',nil,true];
	19458 cutFadeOut 0.0;
};

vts_helicopterliftrelease=
{
	(vehicle player) setvariable ['vts_liftattached',nil,true];
};

vts_helicopterlift=
{
	[player,"<t color=""#e1c7ff"">Cargo hook down</t>",{_this call vts_helicopterhookdown;},[],100,false,false,"","[] call vts_helicopterhookdowncheck"] call vts_AddAction;
	[player,"<t color=""#fbb7b7"">Cargo hook up</t>",{_this call vts_helicopterhookup;},[],100,false,false,"","[] call vts_helicopterhookupcheck"] call vts_AddAction;
	[player,"<t color=""#7700ff"">Hook cargo</t>",{_this call vts_helicopterliftgo;},[],100,false,false,"","[] call vts_helicopterliftcheck"] call vts_AddAction;
	[player,"<t color=""#d28f35"">Release cargo</t>",{_this call vts_helicopterliftrelease;},[],100,false,false,"","[] call vts_helicopterliftreleasecheck"] call vts_AddAction;
};



vts_spawn_vehicle_postprocess=
{
	private ["_veh","_grp","_crew"];
	_veh=_this select 0;
	_grp=_this select 1;
	_crew=crew _veh;
	//Make the crew stay in vehicle if can't move
	_veh allowCrewInImmobile true;
	//But only the gunner and commander stay in when the vehicle is immobilized
	_veh addeventhandler ["Dammaged",
	{
		if !(canmove (_this select 0)) then 
		{ 
			{
				if ((_x!=(gunner vehicle _x)) && (_x!=(commander vehicle _x))) then {unassignVehicle _x;};
			} foreach (crew (_this select 0));
		}; 
	}];
	//Spawn UAV controler if needed
	if (getnumber (configfile >> "CfgVehicles" >> (typeof _veh) >> "isuav")==1) then 
	{
		call compile "createVehicleCrew _veh;_crew=crew _veh;";	
	};	
	
	//Wait till everyone is inside the vehicle before ending the call
	//Need a delay, somehow a frame is doing jerk a NCP can be counted in the vehicle when it is technically out (BAD for post process like init or group init)
	if ((count _crew)>0) then
	{
		waituntil {sleep 0.001;({vehicle _x==_veh} count _crew)==(count _crew)};	
	};
};


//Thanks Soak for the model : Can source see target ?
vts_CanSee=
{
	private ["_target","_source","_dirTo","_eyeD","_eyePb","_eyePa","_eyeDV","_cansee","_eyeangle","_eyemin","_eyemax"];
	_cansee=false;
	_source = _this select 0;
	/*
	if (vehicle _source!=_source) then
	{
		if !(isnull (gunner (vehicle _source))) then
		{
			_source=(gunner (vehicle _source));
		};
	};
	*/
	_target = _this select 1;
	_eyeangle=40;
	if (count _this>2) then {_eyeangle=_this select 2;};
	_eyemin=360-_eyeangle;
	_eyemax=_eyeangle;
	_eyeDV = eyeDirection _source;
	_eyeD = ((_eyeDV select 0) atan2 (_eyeDV select 1));
	if (_eyeD < 0) then {_eyeD = 360 + _eyeD};
	_eyePb = eyePos _target;
	_eyePa = eyePos _source;
	_dirTo = ((_eyePb select 0) - (_eyePa select 0)) atan2 ((_eyePb select 1) - (_eyePa select 1));
	_dirTo = _dirTo % 360; 
	if ((abs(_dirTo - _eyeD) >= _eyemax && (abs(_dirTo - _eyeD) <= _eyemin)) || (lineIntersects [_eyePb, _eyePa]) ||(terrainIntersectASL [_eyePb, _eyePa])) then 
	{
		_cansee=false;
	}
	else
	{
		_cansee=true;
	};
	_cansee;
};

vts_isFacing=
{	
	private ["_post","_poss","_target","_source","_eyeangle","_anglemax","_anglemin","_facing","_Dir","_D"];
	_target=_this select 1;
	_source=_this select 0;
	_post=getposasl _target;
	_poss=getposasl _source;
	_eyeangle=40;
	if (count _this>2) then {_eyeangle=_this select 2;};
	_anglemin=360-_eyeangle;
	_anglemax=_eyeangle;	
	_D=direction _source;
	_Dir=((_post select 0) - (_poss select 0)) atan2 ((_post select 1) - (_poss select 1));
	if (_Dir < 0) then {_Dir = 360 + _Dir};

	if ((abs(_Dir - _D) >= _anglemax && (abs(_Dir - _D) <= _anglemin)) ) then 
	{	
		_facing=false;
	}
	else
	{
		_facing=true;
	};
	_facing;	
};

vts_SpyInLosWithInfiltredSide=
{
	private ["_source","_target","_sourceside","_distance","_checkangle","_obj","_sideobj","_i","_nearunits","_listwatching","_listnotwatching","_closestwatching","_dist"];
	_source=_this select 0;
	_distance=_this select 1;
	//_checkdistance=_this select 2;
	_checkangle=_this select 2;
	_sourceside=missionNamespace getvariable ["vts_spyside",nil];
	if (isnil "_sourceside") then {_sourceside=side group _source;};
	
	_closestwatching=objnull;
	_ClosestDistanceWatching=10000;
	_listwatching=[];
	_listnotwatching=[];
	_nearunits= (position _source) nearEntities [["CAManBase", "LandVehicle"], _distance];	
	for "_i" from 0 to (count _nearunits)-1 do
	{
		_obj=_nearunits select _i;
		if (!(isplayer _obj) && (alive _obj)) then
		{
			if !(isnull group _obj) then
			{
				_sideobj=(side group _obj);
				if (((side group _source)==_sideobj) && ((_sourceside getFriend _sideobj)<0.6)) then
				{
					if ([_obj,_source,_checkangle] call vts_CanSee) then
					{
						_listwatching set [count _listwatching,_obj];
						_dist=_source distance _obj;
						if ((_dist min _ClosestDistanceWatching)==_dist) then
						{
							_ClosestDistanceWatching=_dist;
							_closestwatching=_obj;
						};
					}
					else
					{
						_listnotwatching set [count _listnotwatching,_obj];
					};
				};
			};
		};
		sleep 0.001;
	};	
	[_closestwatching,_ClosestDistanceWatching,_listwatching,_listnotwatching];
};


vts_spyFireEvent=
{
	private ["_delay","_delayboardcast","_weaponitems","_silencer","_checkdistance","_angleeye","_shooter","_watcher","_revealvalue","_shotdist","_list"];
	_delay=1;
	_delayboardcast=5;
	_shooter=(_this select 1);
	_shotdist=(_this select 2);
	_revealvalue=75;
	if (isplayer _shooter) then
	{
		if (isnil "vts_infiltratelastfire") then {vts_infiltratelastfire=(time-_delay);};
		if ((vts_infiltratelastfire+_delay)<=time) then
		{
			
			//systemchat "test";
			vts_infiltratelastfire=time;
			_silencer=false;
			if (vtsarmaversion>2) then
			{
				_weaponitems=["","",""];	
				call compile "_weaponitems=_shooter weaponAccessories (_this select 3);";
				if !(isnil "_weaponitems") then {if ((_weaponitems select 0)!="") then {_silencer=true;};};
			};		
			_revealvalue=75;
			if (_silencer) then {_revealvalue=50;};
			vts_spyreveal=vts_spyreveal+_revealvalue;
			if (vts_spyreveal>500) then {vts_spyreveal=500;};
		};
		
		if (isnil "vts_infiltratelastfirebroadcast") then {vts_infiltratelastfirebroadcast=(time-_delayboardcast);};
		if ((vts_infiltratelastfirebroadcast+_delayboardcast)<=time) then
		{
			vts_infiltratelastfirebroadcast=time;
			_list=nearestObjects [(position _shooter),["CAManBase", "LandVehicle"],_revealvalue]; 
			{if !(alive _x) then {_list=_list-[_x];};} foreach _list;
			if (count _list>5) then {_list resize 5;};
			if (count _list>0) then
			{
				[{_this spawn vts_spylookat;},[_shooter,_list]] call vts_broadcastcommand;
			};
		};
		
	};
};

vts_spylookat=
{
	private ["_unit","_list","_target","_i"];
	_target=_this select 0;
	_list=_this select 1;
	for "_i" from 0 to (count _list)-1 do
	{
		_unit=_list select _i;
		if (local _unit) then
		{
			[_unit,_target] spawn {(_this select 0) dowatch (_this select 1);sleep 5;(_this select 0) dowatch objnull;};
			if (speed _unit>3) then {_unit domove position _target;sleep 2;_unit dofollow leader _unit;};
		};
	};
};

vts_spymodeon=
{
	disableserialization;
	private ["_speedmod","_lastveh","_firedevent","_vehfiredevent","_distancecheck","_watchers","_check","_distance","_infiltred","_obj","_i","_revealdistance","_eyeanglereveal","_originalside","_infside","_newgrp","_oldgrp","_fireevent","_dist","_ctrlui","_maskcolor","_revealvalue"];
	_spy=_this select 0;
	_infside=_this select 1;
	_originalside=missionNamespace getvariable ["vts_spyside",nil];
	if !(isnil "_originalside") exitwith {hint "You're already in infiltration mode";};
	
	if (vts_debug) then {systemchat "Spy On";};
	19459 cutrsc ["vts_spymask","plain"];
	_ctrlui=(uiNamespace getVariable "vts_spyhud_id") displayctrl 1200;
	//enableRadio false;
	_originalside=side group _spy;
	missionNamespace setvariable ["vts_spyside",_originalside];
	_oldgrp=group _spy;
	_newgrp=creategroup _infside;
	[_spy] joinsilent _newgrp;
	deletegroup _oldgrp;
	_spy addrating 100000;
	_lastveh=objnull;
	_distancecheck=100;
	_revealdistance=3;
	_eyeanglereveal=50;
	_firedevent=_spy addEventHandler ["FiredNear",{_this spawn vts_spyFireEvent;}];
	vts_spyreveal=20;
	vts_spyinfiltred=true;
	while {vts_spyinfiltred} do
	{
		//Handle class change, respawn or new unit
		if (_spy!=player) then 
		{
			_spy removeeventhandler ["FiredNear",_firedevent];
			_spy=player;
			_firedevent=_spy addEventHandler ["FiredNear",{_this spawn vts_spyFireEvent;}];
		};
		//Handle vehicles events
		if (vehicle _spy!=_spy) then
		{
			if (isnil "_vehfiredevent") then {_vehfiredevent=(vehicle _spy) addEventHandler ["FiredNear",{_this spawn vts_spyFireEvent;}];_lastveh==(vehicle _spy);};
		}
		else
		{
			if !(isnull _lastveh) then {_lastveh removeeventhandler ["FiredNear",_vehfiredevent];_vehfiredevent=nil;_lastveh=objnull;};
		};
		sleep 0.5;
		//_start = diag_tickTime;
		_check=[_spy,_distancecheck,_eyeanglereveal] call vts_SpyInLosWithInfiltredSide;
		//_stop = diag_tickTime;
		//systemchat format ["%1",_stop - _start];
		_dist=_check select 1;
		_watchers=_check select 2;
		_revealvalue=-5;
		_speedmod=1;
		if (vehicle _spy==_spy) then 
		{
			if ((speed _spy)>10) then {_speedmod=3;};
		};
		//if (_dist<=(_revealdistance*4)) then {_revealvalue=1;};
		if (_dist<=(_revealdistance*3*_speedmod)) then {_revealvalue=2.5;};
		if (_dist<=(_revealdistance*2*_speedmod)) then {_revealvalue=7.5;};
		if (_dist<=(_revealdistance)) then {_revealvalue=15;};
		
		vts_spyreveal=vts_spyreveal+_revealvalue;
		if (vts_spyreveal<0) then {vts_spyreveal=0;};
		if (vts_debug) then {systemchat str vts_spyreveal;};
		_maskcolor=[1,1,1,0];
		if (vts_spyreveal>=10) then {_maskcolor=[1,1,1,0.75];};
		if (vts_spyreveal>=25) then {_maskcolor=[1,(100-vts_spyreveal)/100,0,0.75];};
		_ctrlui ctrlSetTextColor _maskcolor;
		if ((vts_spyreveal>=100) && (count _watchers>0)) then 
		{	
			vts_spyinfiltred=false;
		};
	};
	//enableRadio true;
	_spy removeeventhandler ["FiredNear",_firedevent];
	_oldgrp=group _spy;
	_newgrp=creategroup _originalside;
	[_spy] joinsilent _newgrp;
	deletegroup _oldgrp;	
	_spy addrating 100000;
	if (vts_debug) then {systemchat "Spy Off";};
	for "_i" from 0 to 25 do
	{
		_ctrlui ctrlSetTextColor [0,0.0,0.0,0.75];
		sleep 0.1;
		_ctrlui ctrlSetTextColor [1.0,0,0,0.75];
		sleep 0.1;
	};
	19459 cutFadeOut 0.0;
	if (isnil "vts_spymode_active") then {missionNamespace setvariable ["vts_spyside",nil];};
};

vts_spystealuniform=
{
	private ["_gen","_caller","_id","_side","_items","_originalside","_uniform"];
	_gen = _this select 0;
	_caller = _this select 1;
	_id = _this select 2 ;
	
	if !(isnil "vts_spymode_active") exitwith {hint "You are already wearing a stolen uniform";playsound "computer";};
	
	_gen removeAction _id;
	_side=_gen getvariable ["vts_unitside",nil];
	if (isnil "_side") exitwith {hint "You are already wearing a stolen uniform"};
	_gen setVariable ["vts_unitside",nil,true];	
	[_caller,_side] spawn vts_spymodeon;
	vts_spymode_active=_caller addEventHandler ["Respawn", {if !(isnil "vts_spymode_active") then {[(_this select 0),"Remove disguise",{_this call vts_spyremoveuniform},[],0,true,true,"",""] call vts_addaction;};}];
	
	"Disguise" hintc "You are now disguised, be careful to not behave strangely and avoid getting close to the guards or your cover will be blown";
	playsound "computer";
	
	waituntil {sleep 0.1;(side group _caller)==_side};
	if (vtsarmaversion>2) then
	{
		missionNamespace setvariable ['vts_spyoriginaluniform',uniform _caller];
		_items=uniformItems _caller;
		_uniform=uniform _gen;
		//systemchat _uniform;
		[{if !(local (_this select 0)) then {removeuniform (_this select 0);sleep 1;(_this select 0) adduniform (_this select 1);};},[_caller,_uniform]] call vts_broadcastcommand;
		removeuniform _gen;
		sleep 2;
		_caller adduniform _uniform;
		{_caller additemtouniform _x} foreach _items;
	}
	else
	{
	};
	 _caller action ["RepairVehicle",_caller];
	[_caller,"Torn disguise",{_this call vts_spyremoveuniform},[],0,true,true,"",""] call vts_addaction;
};

vts_spyremoveuniform=
{
	private ["_gen","_caller","_id","_side","_items","_uniform","_originalside"];
	_gen = _this select 0;
	_caller = _this select 1;
	_id = _this select 2 ;
	_gen removeAction _id;
	_originalside=missionNamespace getvariable ['vts_spyside',nil];
	_caller removeeventhandler ["Respawn",vts_spymode_active];
	_uniform=missionNamespace getvariable 'vts_spyoriginaluniform';
	missionNamespace setvariable ["vts_spyside",nil];
	hint "Disguise thrown away";
	playsound "computer";
	if (vts_spyinfiltred) then {vts_spyinfiltred=false};
	waituntil {sleep 0.1;(side group _caller)==_originalside};
	if (vtsarmaversion>2) then
	{
		_items=uniformItems _caller;
		[{if !(local (_this select 0)) then {removeuniform (_this select 0);sleep 1;(_this select 0) adduniform (_this select 1);};},[_caller,_uniform]] call vts_broadcastcommand;
		//removeuniform _caller;
		sleep 2;
		_caller adduniform _uniform;
		{_caller additemtouniform _x} foreach _items;
	}
	else
	{
	};
	_caller action ["RepairVehicle",_caller];
	//Small sleep to make sure the spymode routine is disabled before allowing to grab a new uniform
	sleep 5;
	vts_spymode_active=nil;
};


vts_IsNavigableCargoHaloCheckRTB=
{
	private ["_gen","_maxdist"];
	_gen=_this select 0;
	if !(local _gen) exitwith {};
	if (_gen getVariable ["vts_IsNavigableCargoHaloWaitRTB",false]) exitwith {};
	//Disable damage while flying because BIS... 0 speed in flight = die plane
	_gen allowDamage false;
	_gen setVariable ["vts_IsNavigableCargoHaloWaitRTB",true,true];
	_maxdist=(_flyheight/10);
	if (_maxdist<50) then {_maxdist=50;};
	waituntil {sleep 10;((({(_x distance _gen)<_maxdist} count playableUnits)<1) or (isnull (attachedTo _gen)) or !(_gen getVariable "vts_IsNavigableCargoHaloWaitRTB"))};
	if (_gen getVariable "vts_IsNavigableCargoHaloWaitRTB") then
	{
		[_gen,_gen,0] call vts_IsNavigableCargoHaloOrderRTB;
		_gen setVariable ["vts_IsNavigableCargoHaloWaitRTB",false,true];		
		//systemchat "Transport back to base";
	};
	_gen allowDamage true;
};

vts_IsNavigableCargoHaloMove=
{
	private ["_gen","_postogo","_flyheight","_posasl","_dummypos","_genpos","_dummy","_initialpos","_txt"];
	_gen=_this select 0;
	if !(local _gen) exitwith {};
	_postogo=_this select 1;
	_flyheight=_this select 2;
	_txt="";
	if (count _this>3) then {_txt=_this select 3;};
	
	_dummy=attachedTo _gen;
	if (isnull _dummy) then
	{
		_dummy=vts_smallworkdummy createvehicle (getpos _gen);
		_dummy disableCollisionWith _gen;
		_gen disableCollisionWith _dummy;
		_dummy setdir (direction _gen);
		_dummy setposatl (getposatl _gen);	
	};
	_gen attachto [_dummy];
	_genpos=getposatl _gen;
	_dummypos=[_postogo select 0,_postogo select 1,_flyheight];
	{
		if !(isnull _x) then
		{
			if ((_x distance _gen)<100) then
			{
				_posasl=getposasl _x;
				_listobj=lineIntersectsWith [[_posasl select 0,_posasl select 1,(_posasl select 2)+25],[_posasl select 0,_posasl select 1,(_posasl select 2)-1],_x];
				//systemchat str _listobj;
				if (count _listobj>0) then
				{
					if ((_gen in _listobj) && ((getposatl _x select 2)>0.5)) then
					{
						_dir=direction _x;
						_x attachto [_gen];
						_x setdir (_dir-(direction _gen));
					};
				};

			};
		};
	} forEach (playableUnits);	
	_dummy setposasl _dummypos;
	//Hand detach locally on all player to have better sync
	[
	{	 
		_genpos=_this select 0;
		_finalpos=_this select 1;
		_plane=_this select 2;		
		_flyheight=_this select 3;
		_txt=_this select 4;		
		if (local player) then
		{
			_dummyatt=attachedTo _plane;
			if !(isnull _dummyatt) then
			{
				_dummyatt hideobject true;
			};
			
			if ((attachedTo player)==_plane) then
			{
				waituntil {(_finalpos distance (getposasl _plane))< 0.5}; 
				//sleep 0.1;
				detach player;	
				[player] execVM "functions\swimbug.sqf";
				//player switchmove "";
				if (_txt!="") then {[side group player,"HQ"] sidechat  _txt;};
			};
			
		};
		if ((local _plane) && (_flyheight>0)) then {[_plane] call vts_IsNavigableCargoHaloCheckRTB;};
		
	}
	,[_genpos,_dummypos,_gen,_flyheight,_txt]] call vts_broadcastcommand;
};

vts_IsNavigableCargoHaloOrderMove=
{
	private ["_gen","_caller","_id","_side","_items","_originalside","_offset","_initialpos","_var"];
	_gen = _this select 0;
	_caller = _this select 1;
	_id = _this select 2;
	

		if !(visibleMap) then {openMap [true, false];};
		vtshalomapclick=true;
		[side group _caller,"HQ"] sidechat "Give me the Fly coordinates on the map";
		onMapSingleClick "
		vtstransportpos=_pos;
		onMapSingleClick """";
		vtshalomapclick=false;
		openMap [false, false];
		";
		waituntil {!visibleMap};
		
		_flyheight=_gen getvariable ["vts_IsNavigableCargoHaloHeight",10000];
		_initialpos=_gen getvariable ["vts_IsNavigableCargoHaloPos",nil];
		if (isnil "_initialpos") then {_gen setvariable ["vts_IsNavigableCargoHaloPos",getposasl _gen,true];};
			
		_var=_gen getvariable ["vts_IsNavigableCargoHaloMoving",false];
		if (_var) exitwith {[side group _caller,"HQ"] sidechat  "Can't do, we are already on the move !";};
		
		
		if (vtshalomapclick) then
		{
			vtshalomapclick=false;
			onMapSingleClick "";
			[side group _caller,"HQ"] sidechat  "Understood, ready when you are !";
		}
		else
		{
			_gen setvariable ["vts_IsNavigableCargoHaloMoving",true,true];
			if (((getposatl _gen) select 2)>10) then 
			{
				[side group _caller,"HQ"] sidechat  "Moving on, Stand by";
			}
			else
			{
				[side group _caller,"HQ"] sidechat  "Taking-Off, Stand By";
			};
		
			//Wait till door are close to move the plane
			[
			{
				if (local (_this select 0)) then
				{
					(_this select 0) engineon true;
					(_this select 0) domove [0,0,0];
				};
			}
			,[_gen]] call vts_broadcastcommand;	
			[_gen,0,true] call vts_animatedoor;
			sleep 3;
			[
			{
				if (local (_this select 0)) then
				{
					_this call vts_IsNavigableCargoHaloMove;
				};
			}
			,[_gen,vtstransportpos,_flyheight,"On position, you have the green light !"]] call vts_broadcastcommand;				
			
			_gen setvariable ["vts_IsNavigableCargoHaloMoving",false,true];
		};		
};

vts_IsNavigableCargoHaloOrderRTB=
{
	private ["_gen","_caller","_id","_side","_items","_originalside","_offset","_initialpos","_var"];
	_gen = _this select 0;
	_caller = _this select 1;
	_id = _this select 2;
	//Wait till door are close to move the plane
	_initialpos=_gen getvariable ["vts_IsNavigableCargoHaloPos",nil];
	if (isnil "_initialpos") exitwith {};
	
	[side group _caller,"HQ"] sidechat  "Returning to base, Stand By";
	
	_gen setvariable ["vts_IsNavigableCargoHaloMoving",true,true];
	
	[_gen,0,true] call vts_animatedoor;
	sleep 3;		
	
	[
	{
		if (local (_this select 0)) then
		{
			_this call vts_IsNavigableCargoHaloMove;
			sleep 3;
			(_this select 0) domove (getpos (_this select 0));
			(_this select 0) engineon false;
			dostop (_this select 0);
		};
	}
	,[_gen,_initialpos,(_initialpos select 2),"Welcome back to base !"]] call vts_broadcastcommand;	
	
	_gen setvariable ["vts_IsNavigableCargoHaloPos",nil,true];
	_gen setvariable ["vts_IsNavigableCargoHaloMoving",false,true];
	_gen setVariable ["vts_IsNavigableCargoHaloWaitRTB",false,true];
};

vts_IsNavigableCargoHaloCheck=
{
	private ["_b","_listobj","_plane","_posasl","_var"];
	_b=false;
	_plane=_this select 0;
	_var=_plane getvariable ["vts_IsNavigableCargoHaloMoving",false];
	if (_var) exitwith {false;};
	if !(alive _plane) exitwith {false;};
	_posasl=getposasl player;
	//_listobj=lineIntersectsWith [[_posasl select 0,_posasl select 1,(_posasl select 2)+25],[_posasl select 0,_posasl select 1,(_posasl select 2)-1],player];
	_listobj=[_plane];
	if ((count _listobj)>0) then
	{
		if ((_plane in _listobj) && ((getposatl player select 2)>((getposatl _plane select 2)+0.5))) then
		{
			if ((leader group player)==player) then {_b=true;};
		};
	};
	_b;
};
vts_IsNavigableCargoHaloRTBCheck=
{
	private ["_b","_plane","_posasl"];
	_plane=_this select 0;
	_b=false;
	_var=_plane getvariable ["vts_IsNavigableCargoHaloMoving",false];
	if !(alive _plane) exitwith {false;};
	if (_var) exitwith {false;};
	_initialpos=_plane getvariable ["vts_IsNavigableCargoHaloPos",nil];
	if (isnil "_initialpos") exitwith {false;};
	if ((getposatl player select 2)>((getposatl _plane select 2)+0.5)) then
	{
		if ((leader group player)==player) then {_b=true;};
	};
	_b;
};

vts_IsNavigableCargoHalo=
{
	private ["_plane","_height","_pos"];
	_plane=_this select 0;
	_height=10000;
	if (count _this>1) then {_height=_this select 1;};
	if (local _plane) then
	{
		_pos=getposasl _plane;
		sleep 2;	
		_plane setvelocity [0,0,0];
		_pos=([_pos,true,20000,0.25,_plane] call vts_SetPosAtop);
		_plane setvectorUp [0,0,1];
		_plane setposasl [_pos select 0,_pos select 1,(_pos select 2)+1];
		_plane setvelocity [0,0,1];
		_plane setDamage 0;	
		
		if ((count crew _plane)<1) then
		{
			[_plane, creategroup ([getnumber (configfile >> "CfgVehicles" >> (typeof _plane) >> "side")] call vts_GetSideFromNumber)] call vts_fnc_spawn_crew;
		};

		_plane setvariable ["vts_IsNavigableCargoHaloHeight",_height,true];
		_plane domove (getpos _plane);
		_plane engineon false;
		_plane setbehaviour "CARELESS";
		dostop _plane;
		
	};
	if ([player] call vts_getisGM) then {"Navigable cargo Halo vehicle created" call vts_gmmessage;};
	_plane lock true;

	[_plane,"<t color=""#3333ff"">[Leader] Fly To</t>",{_this call vts_IsNavigableCargoHaloOrderMove;},[],100,false,false,"","[_target,_this] call vts_IsNavigableCargoHaloCheck"] call vts_AddAction;
	[_plane,"<t color=""#33ff99"">[Leader] Return to Base</t>",{_this call vts_IsNavigableCargoHaloOrderRTB;},[],100,false,false,"","[_target,_this] call vts_IsNavigableCargoHaloRTBCheck"] call vts_AddAction;
};
if (isserver) then {publicVariable "vts_IsNavigableCargoHalo";};


vts_EnableZeus=
{
	if (isnil "bis_fnc_iscurator") exitwith {};
	private ["_p","_center","_group","_logic","_key","_script","_gid","_Patches","_addons","_patchnum","_addaddons"];
	_p=_this select 0;
	if (local _p) then 
	{
		_key="Please bind the Zeus UI key";
		if (count (actionKeys "CuratorInterface")>0) then {_key=keyname ((actionKeys "CuratorInterface") select 0);};
		systemchat (("Zeus Activated on key : ")+_key);	
	};
	if !(isserver) exitwith {};

	_gid=(getPlayerUID _p);	
	
	_center = createCenter sideLogic;
	_group = createGroup _center;
	_logic = _group createUnit ["ModuleCurator_F",[0,0,0], [], 0, ""];
	_logic setvariable ["VTSOwner",_gid,true];
	
	sleep 0.1;
	_addaddons=[];
	_Patches=(configfile >> "CfgPatches");
	_patchnum=count _Patches;
	for "_i" from 0 to (_patchnum-1) do
	{
		_addaddons set [count _addaddons,configname (_Patches select _i)];
	};
	_logic addcuratoraddons _addaddons;

	sleep 0.1;
	_addons = curatoraddons _logic;
	removeAllCuratorAddons _logic;
	_logic addcuratoraddons _addons;
	
	
	_p assigncurator _logic;
	
	_logic addCuratorEditableObjects [(allunits+vehicles)];
	
	[_p,true] spawn vts_ZeusAddRespawnEvent;
};

vts_DisableZeus=
{
	private ["_p"];
	_p=_this select 0;
	if (isserver) then
	{
		(getAssignedCuratorLogic _p) setvariable ["VTSOwner",nil,true];
		unassignCurator (getAssignedCuratorLogic _p);	
	};
};

vts_ZeusProcessInit=
{
	if (isnil "bis_fnc_iscurator") exitwith {};
	private ["_o","_checkgm","_var","_gid","_x","_forceRespawnHandler"];

	if (isserver) then
	{
		_o=_this select 0;	
		_forceRespawnHandler=false;
		if ((count _this)>1) then {_forceRespawnHandler=_this select 1;};

		//Seriously ? Network latency you don't know ?
		sleep 3;
		if (isnull _o) exitwith {systemchat "null";};	
		_var="";
		_gid=(getPlayerUID _o);	

		if (isplayer _o) then 
		{				
			[_o,_forceRespawnHandler] spawn vts_ZeusAddRespawnEvent;
		};

		{
			_x addCuratorEditableObjects [[_o]];
			if (isplayer _o) then 
			{

				_var=_x getvariable ["VTSOwner","  "];					
				if (_var==_gid) then 
				{
					if (isnull (getAssignedCuratorLogic _o)) then
					{
						unassignCurator _x;
						_o assignCurator _x;
					};
				};
			};
			
		} foreach allcurators;	

	};
};
if (isserver) then {publicVariable "vts_ZeusProcessInit";};

vts_ZeusAddRespawnEvent=
{
	private ["_p","_gid","_forceRespawnHandler"];
	if !(isserver) exitwith {};
	_p=_this select 0;
	_forceRespawnHandler=false;
	if ((count _this)>1) then {_forceRespawnHandler=_this select 1;};	
	_gid=getPlayerUID _p;
	if (!(missionNamespace getvariable [("vtsZeusRespawnevent"+_gid),false]) or _forceRespawnHandler) then
	{
		//systemchat "add event";
		_p addMPEventHandler  ["mprespawn",{[{[_this] spawn vts_ZeusProcessInit;},(_this select 0)] call vts_broadcastcommand;}];
		missionNamespace setvariable [("vtsZeusRespawnevent"+_gid),true];
	};	
};

vts_cleanspacefromstring=
{
	private ["_txt","_array"];
	_txt=_this select 0;
	_array=toarray _txt;
	_array=_array-[32];
	_txt=tostring _array;
	_txt;
};