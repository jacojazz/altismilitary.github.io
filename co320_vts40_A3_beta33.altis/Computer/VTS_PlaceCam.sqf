vts_stopcamplace = false;
_Offset = [0,15,0];
Zpos = 0;
Zposmod = 0.9;
Zrotmod = 22.5;
VtsHight = 0.0;
VTS_Freecam_nvg = false;
VTS_Freecam_on = true;
VTS_Freecam_help = false;
VTS_Freecam_players = [];
_playableUnits = playableUnits;
VTS_Freecam_target = player;

//rabbit ! because we can attach stuff to it !
Obj = vts_dummyvehicle createVehiclelocal [spawn_x , spawn_y ,spawn_z] ;
//Obj = vts_dummy3darrow createVehiclelocal [spawn_x , spawn_y ,spawn_z] ;
Zpos=getTerrainHeightASL position Obj;
Obj hideObject true;
[] call vts_processobjectsinit;

Obj enablesimulation true;
Obj allowDamage false;
//[Obj] spawn vts_NoVelocity;

	
vts_placecam_cursor=
{
	object3D = local_console_unit_unite createVehicleLocal [spawn_x, spawn_y ,spawn_z] ;
	object3D allowDamage false;
	object3D enablesimulation false;
	object3D setdir direction Obj;
	object3D attachto [Obj,[0,0,0]];

	//Obj disableCollisionWith object3D;
	/*
	if (nom_console_valid_type == "Man")  then {VtsHight = 0;_Offset = [0,5.0,0];};
	if (nom_console_valid_type in type_objects) then {VtsHight = -0.5;_Offset = [0,5.0,0]; };
	if (nom_console_valid_type == "Empty")  then {VtsHight = 0;_Offset = [0,15.0,0];};	 
	*/
	_distX=(((boundingBox object3D) select 1) select 0)-(((boundingBox object3D) select 0) select 0)+5;
	_distY=(((boundingBox object3D) select 1) select 1)-(((boundingBox object3D) select 0) select 1)+5;
	_distZ=(((boundingBox object3D) select 1) select 2)-(((boundingBox object3D) select 0) select 2)+5;
	_dist=_distZ;
	if (_distY>_dist) then {_dist=_distY};
	if (_distX>_dist) then {_distX=_distY};
	_Offset = [0,_dist,0];
	if (object3D iskindof "Building") then {VtsHight=((((boundingBox object3D) select 0) select 2)-(boundingCenter object3D select 2)-0);} else {VtsHight=0.0;};
	//object3D attachTo [Obj,[0,0,vtsHight]]; 
};

[] call vts_placecam_cursor;

ObjArrow = vts_dummy3darrow createVehicleLocal [spawn_x, spawn_y ,spawn_z] ;
//ObjArrow attachTo [Obj,[0,0,0]]; 
ObjArrow enablesimulation false;		
OBJdir = 0;


sleep 0.1;
//create camera
VTS_Freecam = "camconstruct" camcreate [spawn_x, spawn_y, vts_cameraheight];
VTS_Freecam camConstuctionSetParams [[spawn_x,spawn_y,spawn_z], 20000, 20000];
VTS_Freecam camSetTarget player;
VTS_Freecam cameraeffect ["internal","back"];
VTS_FreeCam setdir rot_y;
VTS_FreeCam setVectorDirAndUp vts_cameravectorup;
cameraEffectEnableHUD true;

VTS_3dplacinghelp=
{
//_time=1;
//if (count _this>0) then {_time=_this select 0;};
_txt="";
if (count _this>0) then {_txt=_this select 0;};
hint (_txt+"Mousewheel: Change height\n
Left mouse button: Rotate left\n
Right mouse button: Rotate right\n
C: Place object\n
B: Bind object\n
E: Cycle object list backward\n
R: Cycle object list forward\n
Space: Exit\n
Movement keys and mouse: Move camera\n
\n
Q: Move camera up\n
 Z: Move camera down\n
CTRL Left : Slower movement\n
SHIFT Left: Slow movement\n
ALT Left : Fast movement\n
ALT + SHIFT : Faster movement\n\n
\n
Nightvision key: Nightvision On/Off\n
\n
 Press the H button to show/exit the help screen.");					
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

[] call VTS_3dplacinghelp;

//Left or Right arrow
//Spacekey to exit
_keydown_arrows = (finddisplay 46) displayaddeventhandler ["keydown", "
	   _n=0;
	  if ((_this select 1) == 18 )then  
	  {
		_n=-2;
	  };
	  if ((_this select 1) == 19 )then  
	  {
		_n=2;
	  };  
	  if (_n!=0) then
	 {
		_type=local_console_unit_unite;
		if (_type!="""") then 
		{
			_listcount=count vts_currentspawn_list;
			if (_listcount>0) then
			{			
				_index=vts_currentspawn_list find _type;

				if (_index>-1) then 
				{		
					_index=_index+_n;
					if (_index>_listcount) then {_index=1;};
					if (_index<0) then {_index=(_listcount-1);};
					_name=vts_currentspawn_list select (_index-1);
					_newtype=vts_currentspawn_list select _index;
					local_console_unit_unite=_newtype;
					console_unit_unite=_newtype;
					_oldcursor=object3D;
					[] call vts_placecam_cursor;
					deleteVehicle _oldcursor;
					[""Spawning : ""+_name+""\n\n\n""] call VTS_3dplacinghelp;
				};
			};
		};
	 };
	false;
"];

//Spacekey to exit
_keydown_space = (finddisplay 46) displayaddeventhandler ["keydown", "
	if ((_this select 1) == 57 ) then {
		vts_stopcamplace = true;
	};
	false;
"];

_keydown_Backspace = (finddisplay 46) displayaddeventhandler ["keydown", "
	if ((_this select 1) == 14 ) then {
		vts_stopcamplace = true;
	};
	false;
"];

//Spawn the unit 

_keydown_c_key = (finddisplay 46) displayaddeventhandler ["keydown", "
  if ((_this select 1) == 46 )then  {
    if (placingdone < 1) then { placingdone=1; _tmp= [] execVM""Computer\place.sqf"";};
  };
  false;
  "];

_keydown_b_key = (finddisplay 46) displayaddeventhandler ["keydown", "
  if ((_this select 1) == 48 )then  {
    if (placingdone < 1) then {   vts3DAttach= true; local_vts3DAttach=vts3DAttach; placingdone=1; _tmp= [] execVM""Computer\place.sqf"";};
  };
  false;
  "];


_keydown_ShiftL = (finddisplay 46) displayaddeventhandler ["keydown", "
	if ((_this select 1) == 42 ) then {
		Zposmod=0.3;
		Zrotmod=11.25;
	};
	false;
"];

_keyup_ShiftL = (finddisplay 46) displayaddeventhandler ["keyup", "
	if ((_this select 1) == 42 ) then {
		Zposmod=0.9;
		Zrotmod=22.5;
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

_keydown_ShiftR = (finddisplay 46) displayaddeventhandler ["keydown", "
	if ((_this select 1) == 54 ) then {
		Zposmod=0.3;
		Zrotmod=11.25;
	};
	false;
"];

_keyup_ShiftR = (finddisplay 46) displayaddeventhandler ["keyup", "
	if ((_this select 1) == 54 ) then {
		Zposmod=0.9;
		Zrotmod=22.5;
	};
	false;
"];

_keydown_CtrlL = (finddisplay 46) displayaddeventhandler ["keydown", "
	if ((_this select 1) in [29,157]) then {
		Zposmod=0.15;
		Zrotmod=5.625;
	};
	false;
"];

_keyup_CtrlL = (finddisplay 46) displayaddeventhandler ["keyup", "
	if ((_this select 1) in [29,157]) then {
		Zposmod=0.9;
		Zrotmod=22.5;
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


_keydown_Help = (finddisplay 46) displayaddeventhandler ["keydown", "
	if ((_this select 1) in (actionkeys ""Help"")) then {
		if (not VTS_Freecam_help) then {
			[] call VTS_3dplacinghelp;
			VTS_Freecam_help = true;
		}
		else {
			hint """";
			VTS_Freecam_help = false;
		};
	};
	false;
"];



_keydown_Rclick = (finddisplay 46) displayaddeventhandler ["MouseButtonDown", "
	if ((_this select 1) == 0) then {
	OBJdir = getdir Obj;
	Obj setDir (OBJdir - Zrotmod);
	};
	false;
"];


_keydown_Lclick = (finddisplay 46) displayaddeventhandler ["MouseButtonDown", "
	if ((_this select 1) == 1) then {
	OBJdir = getdir Obj;
	Obj setDir (OBJdir + Zrotmod);
	};
	false;
"];

_mousez = (findDisplay 46) displayAddEventHandler ["mousezchanged", "
		_z = _this select 1;
		if (_z  < 0) then {
			Zpos = Zpos - Zposmod;
		}
		else {
			Zpos = Zpos + Zposmod;
		};
		false;
"];


/*
_mousez = (findDisplay 46) displayAddEventHandler ["mousezchanged", "
	if ({alive _x} count VTS_Freecam_players > 0) then {
		_z = _this select 1;
		if (_z  < 0) then {
			hint "up";
			VTS_Freecam_players_select = VTS_Freecam_players_select - 1;
			if (VTS_Freecam_players_select < 0) then {VTS_Freecam_players_select = VTS_Freecam_players_count};
			while {not (alive (VTS_Freecam_players select VTS_Freecam_players_select))} do {
				VTS_Freecam_players_select = VTS_Freecam_players_select - 1;
				if (VTS_Freecam_players_select < 0) then {VTS_Freecam_players_select = VTS_Freecam_players_count};
			};
			VTS_Freecam_target = vehicle (VTS_Freecam_players select VTS_Freecam_players_select);		
		}
		else {
			hint "down";
			VTS_Freecam_players_select = VTS_Freecam_players_select + 1;
			if (VTS_Freecam_players_select > VTS_Freecam_players_count) then {VTS_Freecam_players_select = 0};
			while {not (alive (VTS_Freecam_players select VTS_Freecam_players_select))} do {
				VTS_Freecam_players_select = VTS_Freecam_players_select + 1;
				if (VTS_Freecam_players_select > VTS_Freecam_players_count) then {VTS_Freecam_players_select = 0};
			};
			VTS_Freecam_target = vehicle (VTS_Freecam_players select VTS_Freecam_players_select);	
		};
		cutText [format[""%1"", name VTS_Freecam_target],""PLAIN""];
		if (VTS_Freecam_camera_on) then {
		VTS_Freecam_camera setpos [((position VTS_Freecam_target) select 0) + ((sin (getdir VTS_Freecam_target)) * ( - 10)), ((position VTS_Freecam_target) select 1) + ((cos (getdir VTS_Freecam_target)) * (- 10)), ((position VTS_Freecam_target) select 2) + 10];
		VTS_Freecam_camera setdir getdir VTS_Freecam_target;
		VTS_Freecam_camera camSetTarget VTS_Freecam_target;
		}
		else {VTS_Freecam_target switchCamera ""EXTERNAL"";};
		VTS_Freecam_camera_help = false;
	};
"];
*/
/*
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
		cutText [format[""%1"", name VTS_Freecam_target],""PLAIN""];
		if (VTS_Freecam_camera_on) then {
		VTS_Freecam_camera setpos [((position VTS_Freecam_target) select 0) + ((sin (getdir VTS_Freecam_target)) * ( - 10)), ((position VTS_Freecam_target) select 1) + ((cos (getdir VTS_Freecam_target)) * (- 10)), ((position VTS_Freecam_target) select 2) + 10];
		VTS_Freecam_camera setdir getdir VTS_Freecam_target;
		VTS_Freecam_camera camSetTarget VTS_Freecam_target;
		}
		else {VTS_Freecam_target switchCamera ""EXTERNAL"";};
		VTS_Freecam_camera_help = false;
	};
"];
*/

//create the local uaz


//If working on water, put the cursor on sea level by default, and not in the depth
if (surfaceIsWater (getpos Obj)) then {Zpos=((getposasl Obj) select 2)+2;};

//setpos loop 20 M before the camera
while {!vts_stopcamplace && !dialog} do {
	sleep 0.01;
	_Objpos = VTS_Freecam modelToWorld _Offset;
	//Obj setPos [_Objpos select 0,_Objpos select 1,Zpos];
	if (Zpos< getTerrainHeightASL position Obj) then {Zpos=getTerrainHeightASL position Obj};
	//player sidechat format["o %1 cam %2",Zpos,(getposasl VTS_Freecam) select 2];
	if ((Zpos-5)>((getposasl VTS_Freecam) select 2)) then {Zpos=((getposasl VTS_Freecam) select 2)+4;};
	Obj setPosASL [_Objpos select 0,_Objpos select 1,Zpos];
	
	//object3D setdir (direction Obj);
	ObjArrow setdir (direction Obj);
	_cursorpos=getposasl Obj;
	object3D setposasl [_cursorpos select 0,_cursorpos select 1,(_cursorpos select 2)+VtsHight]; 	
	ObjArrow setposasl [_cursorpos select 0,_cursorpos select 1,(_cursorpos select 2)]; 	

};

if (vts_fromfreecam) then 
{
	spawn_x=position VTS_Freecam select 0;
	spawn_y=position VTS_Freecam select 1;
	spawn_z=position VTS_Freecam select 2;
	rot_y=direction VTS_Freecam;
	vts_cameravectorup=[VectorDir VTS_FreeCam,VectorUp VTS_FreeCam];	
};

//exit
//waitUntil {vts_stopcamplace};
deleteVehicle Obj;
deleteVehicle object3D;
deleteVehicle ObjArrow;
VTS_Freecam_target switchCamera "INTERNAL";
VTS_Freecam CameraEffect ["Terminate","Back"];
camUseNVG false;
CamDestroy VTS_Freecam;
vehicle player switchCamera "internal";
//selectplayer player;
(finddisplay 46) displayRemoveEventHandler ["keydown",_keydown_Help];
(finddisplay 46) displayRemoveEventHandler ["keydown",_keydown_NightVision];
(finddisplay 46) displayRemoveEventHandler ["keydown",_keydown_space];
(finddisplay 46) displayRemoveEventHandler ["keydown",_keydown_Backspace];
(finddisplay 46) displayRemoveEventHandler ["keydown",_keydown_fastmove];
(finddisplay 46) displayRemoveEventHandler ["keydown",_keydown_c_key];
(finddisplay 46) displayRemoveEventHandler ["keydown",_keydown_b_key];
(finddisplay 46) displayRemoveEventHandler ["keydown",_keydown_ShiftL];
(finddisplay 46) displayRemoveEventHandler ["keyup",_keyup_ShiftL];
(finddisplay 46) displayRemoveEventHandler ["keydown",_keydown_ShiftR];
(finddisplay 46) displayRemoveEventHandler ["keydown",_keydown_arrows];
(finddisplay 46) displayRemoveEventHandler ["keyup",_keyup_ShiftR];
(finddisplay 46) displayRemoveEventHandler ["keydown",_keydown_CtrlL];
(finddisplay 46) displayRemoveEventHandler ["keyup",_keyup_CtrlL];
(finddisplay 46) displayRemoveEventHandler ["mousezchanged",_mousez];
(finddisplay 46) displayRemoveEventHandler ["MouseButtonDown",_keydown_Rclick];
(finddisplay 46) displayRemoveEventHandler ["MouseButtonDown",_keydown_Lclick];

if (vts_fromfreecam) then 
{
	vts_fromfreecam=false;
	cutText ["","BLACK FADED",0.02]	;
	["VTScamtarget",objnull] call vts_checkvar;
	[VTScamtarget, [spawn_x, spawn_y ,0]] execVM "Computer\VTS_FreeCam.sqf";
};
