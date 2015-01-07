private "_Offeset";
stopcam = false;
_Offset = [0,10,0];
private ["_source"];
vts3ddisplacement=false;
Zpos = 0;
Zposmod = 0.9;
Zrotmod=22.5;
VtsHight = 0.0;
VTS_Freecam_nvg = false;
VTS_Freecam_on = true;
VTS_Freecam_help = false;
VTS_Freecam_players = [];
_playableUnits = playableUnits;
VTS_Freecam_target = player;


VTS_3dmovehelp={
_time=1;
if (count _this>0) then {_time=_this select 0;};
hint  "Mousewheel: Change height\n
Left mouse button: Rotate left\n
Right mouse button: Rotate right\n
C: Pick/Drop object\n
B: Bind to nearby object\n
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
Press the H button to show/exit the help screen.";
};

//rabbit ! because we can attach stuff to it !
Obj = vts_dummyvehicle createVehicle [spawn_x , spawn_y ,spawn_z] ;
//Obj = vts_dummy3darrow createVehiclelocal [spawn_x , spawn_y ,spawn_z] ;
[Obj,"_spawn hideObject true;"] call vts_setobjectinit;
[] call vts_processobjectsinit;

[Obj] spawn  vts_NoVelocity;

	

ObjArrow = vts_dummy3darrow createVehicleLocal [spawn_x, spawn_y ,spawn_z] ;
ObjArrow attachTo [Obj,[0,0,0]]; 
// Obj disableCollisionWith ObjArrow;
Zpos=getTerrainHeightASL position Obj;
			
OBJdir = 0;

Obj allowDamage false;

sleep 0.1;

//Function
vts_3ddisplacement={
    switch (vts3ddisplacement) do
    {
    case false:
    {
      sleep 0.25;
	  _posasl=getPosasl Obj;
      _list = [_posasl,["Man","Car","Truck","Tank","Helicopter","Plane","Ship","ReammoBox","StaticWeapon","Building"],10] call vts_nearestobjects3d;
	    
		if ((count _list)<1) exitwith {breakclic = 0;hint "!!! No object found !!!"};
	    _cn=0;
		
	    _source = _list select _cn;
		_isok=false;
	    while {_cn<=((count _list)-1)} do
	    {
			_source = _list select _cn;
			if (_source iskindof "Building") then
			{
				_svar=_source getVariable "vts_object";
				if (isnil "_svar") then {_isok=false;} else {_isok=true;};
			}
			else
			{
				_isok=true;				
			};
			if (_source==Obj) then {_isok=false;};
			_cn=_cn+1;
			if (_isok) then {_cn=(count _list);};
		};
		
		if !(_isok) exitwith {breakclic = 0;hint "!!! No object found !!!"};
      
		if ((count _list)==0) exitwith {breakclic = 0;hint "!!! No object found !!!"};
      
		object3D = _source;
		
		if (object3D iskindof "Building") then {VtsHight=(((boundingBox object3D) select 0) select 2)-1.5;} else {VtsHight=0.0;};
		_distX=(((boundingBox object3D) select 1) select 0)-(((boundingBox object3D) select 0) select 0)+5;
		_distY=(((boundingBox object3D) select 1) select 1)-(((boundingBox object3D) select 0) select 1)+5;
		_distZ=(((boundingBox object3D) select 1) select 2)-(((boundingBox object3D) select 0) select 2)+5;
		_dist=_distZ;
		if (_distY>_dist) then {_dist=_distY};
		if (_distX>_dist) then {_distX=_distY};
		_Offset = [0,_dist,0];
		
		Obj setDir (direction object3D);
	    object3D attachTo [Obj,[0,0,VtsHight]];
		
	    hint "Pickup";
		vts3ddisplacement=true;
    };
    case true:
    {
	  _pos=getposasl object3D;
      sleep 0.25;
	  _Offset = [0,10,0];
      hint "Drop";
      detach object3D;
	  object3D setvariable ["vts_attachinherit",nil,true];
	  object3D setposasl _pos;
	  object3D setvelocity [0,0,-0.1];
      vts3ddisplacement=false;
    };
    };
};



//create camera
VTS_Freecam = "camconstruct" camcreate [spawn_x, spawn_y, vts_cameraheight];
VTS_Freecam camConstuctionSetParams [[spawn_x,spawn_y,spawn_z], 20000, 10000];
VTS_Freecam camSetTarget player;
VTS_Freecam cameraeffect ["internal","back"];
VTS_FreeCam setdir rot_y;
VTS_FreeCam setvectordirandup vts_cameravectorup;
cameraEffectEnableHUD true;

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

[0.5] call VTS_3dmovehelp;

//Spacekey to exit
_keydown_space = (finddisplay 46) displayaddeventhandler ["keydown", "
	if ((_this select 1) == 57 ) then {
		stopcam = true;
	};
	false;
"];

_keydown_Backspace = (finddisplay 46) displayaddeventhandler ["keydown", "
	if ((_this select 1) == 14 ) then {
		stopcam = true;
	};
	false;
"];

//Displace the unit 

_keydown_c_key = (finddisplay 46) displayaddeventhandler ["keydown", "
  if ((_this select 1) == 46 )then  {
    _tmp = [] spawn vts_3ddisplacement;
  };
  false;
  "];

_keydown_b_key = (finddisplay 46) displayaddeventhandler ["keydown", "
  if ((_this select 1) == 48 )then  {
	if !(vts3ddisplacement) then
	{
		playsound ""computer"";
		hint ""You must select an object first !"";
	}
	else
	{
		_tmp=[] spawn
		{
		_wait=[] spawn vts_3ddisplacement;
		waitUntil {scriptdone _wait};
		sleep 0.001;
		_wait=[(getposasl object3D),object3D] spawn vts_3DAttach;
		};
	};
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
			
			[] call VTS_3dmovehelp;
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


//If working on water, put the cursor on sea level by default, and not in the depth
if (surfaceIsWater (getpos Obj)) then {Zpos=((getposasl Obj) select 2)+2;};

//setpos loop 20 M before the camera
while {!stopcam && !dialog} do {
sleep 0.01;
_Objpos = VTS_Freecam modelToWorld _Offset;
if (Zpos< getTerrainHeightASL position Obj) then {Zpos=getTerrainHeightASL position Obj};
if ((Zpos-5)>((getposasl VTS_Freecam) select 2)) then {Zpos=((getposasl VTS_Freecam) select 2)+4;};
Obj setPosASL [_Objpos select 0,_Objpos select 1,Zpos];
};


if (vts_fromfreecam) then 
{
	spawn_x=position VTS_Freecam select 0;
	spawn_y=position VTS_Freecam select 1;
	spawn_z=position VTS_Freecam select 2;
	rot_y=direction VTS_Freecam;
	vts_cameravectorup=[VectorDir VTS_FreeCam,VectorUp VTS_FreeCam];;
};

//exit
//waitUntil {stopcam};
deleteVehicle Obj;
deleteVehicle ObjArrow;
VTS_Freecam_target switchCamera "INTERNAL";
VTS_Freecam CameraEffect ["Terminate","Back"];
camUseNVG false;
CamDestroy VTS_Freecam;
//selectplayer player;
vehicle player switchCamera "internal";
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

