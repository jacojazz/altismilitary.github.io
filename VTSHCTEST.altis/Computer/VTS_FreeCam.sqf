

private["_keydown_Help", "_keydown_NightVision", "_keydown_camconstruct", "_keydown_switchCamera" , "_keydown_space", "_mousez", "_playableUnits", "_z","_captiveon"];



_pos = _this select 1;

_camx = _pos select 0;
_camy = _pos select 1;
_camz = _pos select 2;

//player sidechat str _camz;
//if !(surfaceiswater [_camx,_camy]) then  {_camz=(ASLToATL [_camx,_camy,_camz]) select 2;};

VTS_Freecam_nvg = false;
VTS_Freecam_on = true;
VTS_Freecam_help = false;
_playableUnits = playableUnits;
VTS_Freecam_target = player;
VTS_Freecam_targetOrigin = player;
VTS_Freecam_players = [];
{if (alive _x) then {VTS_Freecam_players = VTS_Freecam_players + [_x]}} foreach _playableUnits;
VTS_Freecam_players_count = count VTS_Freecam_players - 1;
VTS_Freecam_players_select = 0; //waitUntil {not alive player}; sleep 5; //cutText ["GDT SPECTATOR\n----------------------------------------------------------------------------------------------\nWill start shortly\n\nDuring spectating press your help button (Standard: H) for instructions","PLAIN"]; //waitUntil {typeof cameraOn == "SeaGull"}; //cutText ["GDT SPECTATOR\n----------------------------------------------------------------------------------------------\nWill start shortly\n\nDuring spectating press your help button (Standard: H) for instructions","PLAIN"]; 
vts_fromfreecam = false;
//setAperture -1;
//hint "1";
["VTS_Freecam",objnull] call vts_checkvar;
if (!isnull VTS_Freecam) then
{
	vts_cameravectorup=[VectorDir VTS_FreeCam,VectorUp VTS_FreeCam];
	vts_stopcam=true;
	CamDestroy VTS_Freecam;
	//selectplayer player;
	vehicle player switchCamera "internal";
	_time=time+10;
	waituntil {sleep 0.01;isnull VTS_Freecam or _time<time};
};
vts_stopcam = false;

VTS_Freecam = "camconstruct" camcreate [_camx,_camy-5,vts_cameraheight];
VTS_Freecam camConstuctionSetParams [[_camx,_camy,_camz], 20000, 20000];
VTS_Freecam camSetTarget objnull; VTS_Freecam cameraeffect ["internal","back"];
VTS_FreeCam setVectorDirAndUp vts_cameravectorup;
cameraEffectEnableHUD true;
[] execvm "computer\vts_cameramarker.sqf";

VTS_gmcamerahelp=
{
_time=1;
if (count _this>0) then {_time=_this select 0;};
hint "Mousewheel: Camera jumps to player positions
\nMovement keys and mouse: Move camera
\n\n
Q: Move camera up\n
Z: Move camera down\n
SHIFT Left: Slow movement\n
ALT Left : Fast movement\n
ALT + SHIFT : Faster movement\n\n
Nightvision key: Nightvision On/Off\n\n
Teamswitch key: Computer On/Off\n\n
Press Space to exit.";				
};

VTS_gmcamerafast = 
{
	_dX = _this select 0;
	_dY = _this select 1;
	_dZ = _this select 2;
	_coef=_this select 3;
	_cam=VTS_Freecam;
	_pos = getposasl _cam;
	_dir = (direction _cam) + _dX * 90;
	_camPos = 
	[
		(_pos select 0) + ((sin _dir) * _coef * _dY),
		(_pos select 1) + ((cos _dir) * _coef * _dY),
		(_pos select 2) + _dZ * _coef
	];
	_camPos set [2,(_camPos select 2) max (getterrainheightasl _camPos)];
	//systemchat str _camPos;
	_cam setposasl _camPos;
};	
	
_keydown_Help = (finddisplay 46) displayaddeventhandler ["keydown", "
	if ((_this select 1) in (actionkeys ""Help"")) then {
		if (not VTS_Freecam_help) then {
			[] call VTS_gmcamerahelp;
			VTS_Freecam_help = true;
		}
		else {
			hint """";
			VTS_Freecam_help = false;
		};
	};
	false;
"];



_keydown_NightVision = (finddisplay 46) displayaddeventhandler ["keydown", "
	if ((_this select 1) in (actionkeys ""NightVision"")) then {
		if (VTS_Freecam_nvg) then {camUseNVG false;VTS_Freecam_nvg = false;}
		else {camUseNVG true;VTS_Freecam_nvg = true;};
	};
	false;
"];



_keydown_space = (finddisplay 46) displayaddeventhandler ["keydown", "
	if ((_this select 1) == 57 ) then {
		vts_stopcam = true;
	};
	false;
"];

_keydown_fastmove = (finddisplay 46) displayaddeventhandler ["keydown", "
	if (((_this select 1) in [17,31,30,32,16,44]) && ((_this select 4) or ((_this select 4) && (_this select 2)))) then 
	{
		_k=(_this select 1);
		_coef=10;
		if (_this select 2) then {_coef=_coef*10;};
		if (_k==17) then {[0,1,0,_coef] spawn VTS_gmcamerafast;};
		if (_k==31) then {[0,-1,0,_coef] spawn VTS_gmcamerafast;};
		if (_k==30) then {[-1,1,0,_coef] spawn VTS_gmcamerafast;};
		if (_k==32) then {[1,1,0,_coef] spawn VTS_gmcamerafast;};
		if (_k==16) then {[0,0,1,_coef] spawn VTS_gmcamerafast;};
		if (_k==44) then {[0,0,-1,_coef] spawn VTS_gmcamerafast;};

	};
	false;
"];

_mousez = (findDisplay 46) displayAddEventHandler ["mousezchanged", "


	
	if ({alive _x} count VTS_Freecam_players > 0) then {
		_z = _this select 1;
		if (_z  < 0) then {
			VTS_Freecam_players_select = VTS_Freecam_players_select - 1;
			if (VTS_Freecam_players_select < 0) then {VTS_Freecam_players_select = VTS_Freecam_players_count};
			while {not (alive (VTS_Freecam_players select VTS_Freecam_players_select))} do {
				VTS_Freecam_players_select = VTS_Freecam_players_select - 1;
				if (VTS_Freecam_players_select < 0) then {VTS_Freecam_players_select = VTS_Freecam_players_count};
			};
			VTS_Freecam_target = vehicle (VTS_Freecam_players select VTS_Freecam_players_select);		
		}
		else {
			VTS_Freecam_players_select = VTS_Freecam_players_select + 1;
			if (VTS_Freecam_players_select > VTS_Freecam_players_count) then {VTS_Freecam_players_select = 0};
			while {not (alive (VTS_Freecam_players select VTS_Freecam_players_select))} do {
				VTS_Freecam_players_select = VTS_Freecam_players_select + 1;
				if (VTS_Freecam_players_select > VTS_Freecam_players_count) then {VTS_Freecam_players_select = 0};
			};
			VTS_Freecam_target = vehicle (VTS_Freecam_players select VTS_Freecam_players_select);	
		};
		cutText [format[""%1"", name VTS_Freecam_target],""PLAIN down""];
		if (VTS_Freecam_on) then {
		VTS_Freecam setpos [((position VTS_Freecam_target) select 0) + ((sin (getdir VTS_Freecam_target)) * ( - 10)), ((position VTS_Freecam_target) select 1) + ((cos (getdir VTS_Freecam_target)) * (- 10)), ((position VTS_Freecam_target) select 2) + 3];
		
		VTS_Freecam setdir getdir VTS_Freecam_target;
		VTS_Freecam camSetTarget player;
		
		}
		else {VTS_Freecam_target switchCamera ""EXTERNAL"";};
		VTS_Freecam_help = false;
		

	};
	false;
"];

titleText ["\n\nPress H for Help and Space to quit", "PLAIN down"];
//sleep 5;
//titleFadeOut 1;



waitUntil {sleep 0.01;vts_stopcam or isnull VTS_Freecam};

/*
if(_captiveon) then
{
}else{
	user1 allowDamage true;
	user1 setCaptive false;
	_code={
		user1 allowDamage true;
		user1 setCaptive false;
		};
	[_code] call vts_broadcastcommand;
};*/

if !(isnull VTS_Freecam) then
{
	vts_cameravectorup=[VectorDir VTS_FreeCam,VectorUp VTS_FreeCam];
	VTS_Freecam_targetOrigin switchCamera "INTERNAL";
	VTS_Freecam CameraEffect ["Terminate","Back"];
	camUseNVG false;
	CamDestroy VTS_Freecam;

	vehicle player switchCamera "internal";
	//selectplayer player;
	
	(finddisplay 46) displayRemoveEventHandler ["keydown",_keydown_Help];
	(finddisplay 46) displayRemoveEventHandler ["keydown",_keydown_NightVision];
	(finddisplay 46) displayRemoveEventHandler ["keydown",_keydown_space];
	(finddisplay 46) displayRemoveEventHandler ["keydown",_keydown_fastmove];
	(finddisplay 46) displayRemoveEventHandler ["mousezchanged",_mousez];
	_time=time+10;
	waituntil {isnull VTS_Freecam or _time<time};
};

//if (isnull VTS_Freecam) then {[] execVM "Computer\cpu_dialog.sqf";};
