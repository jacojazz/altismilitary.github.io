_canchange=!(isnil "vtsdataloaded");
if (!(isnil "vts_respawn_abletointeract") && _canchange) then {_canchange=[player] call vts_respawn_abletointeract;};
if !(_canchange) exitwith {if (isnil "vtsdataloaded") then {hint "Error : Game data not yet loaded, please wait";};};

closedialog 0;

//pside="west";
_side=side group player;
//hint format["%1",_side];
private "_pside";

if (_side==WEST) then {_pside="west"};
if (_side==EAST) then {_pside="east"};
if (_side==RESISTANCE) then {_pside="resistance"};
if (_side==CIVILIAN) then {_pside="civilian"};

//hint _pside;

vts_shopside=_this select 3;

nom_skin_valid_side = _pside ;
var_skin_valid_side = _pside ;

_ok=createDialog "VTS_rscskin";



_n = [0] execVM "computer\console\boutons\skin_valid_side.sqf"; waitUntil {scriptDone _n};
_n = [0] execVM "computer\console\boutons\skin_valid_camp.sqf"; waitUntil {scriptDone _n};
_n = [0] execVM "computer\console\boutons\skin_valid_type.sqf"; waitUntil {scriptDone _n};
_n = [0] execVM "computer\console\boutons\skin_valid_unite.sqf"; waitUntil {scriptDone _n};

_text="Each soldier class has its own ability";
//ctrlSetText [10504,_text];


//Move dialog on the right
_movedialog=
{
	disableserialization;
	_dialog=_this select 0;
	_xoffset=_this select 1;
	if (_xoffset!=0) then {_xoffset=(_xoffset* safezoneW + safezoneX);};
	_yoffest=_this select 2;
	if (_yoffest!=0) then {_yoffest=(_yoffest* safezoneH + safezoneY);};
	_cfgdisplayid=getnumber (missionconfigfile >> _dialog >> "IDD");
	_cfgui=(missionconfigfile >> _dialog >> "Controls");
	for "_i" from 0 to ((count _cfgui)-1) do
	{
		_idc=getnumber ((_cfgui select _i) >> "idc");
		_ctrl=(finddisplay _cfgdisplayid) displayctrl _idc;
		_idcpos=ctrlPosition _ctrl;
		_ctrl ctrlsetposition [(_idcpos select 0)+_xoffset,(_idcpos select 1)+_yoffest,(_idcpos select 2),(_idcpos select 3)];
		_ctrl ctrlCommit 0;
	};
};


//Display camera 
if (((positionCameraToWorld [0,0,0]) distance player)<5) then
{
	waituntil{sleep 0.1;!(isnull (finddisplay 8003))};
	["VTS_rscskin",0.4,0] spawn _movedialog;
	_cam = "camera" camcreate [0,0,0];
	_cam cameraeffect ["internal", "back"] ;
	_cam camsettarget player;
	_cam camsetrelpos [1.25,1.25,1.25];
	//_cam camsettarget [(getpos player select 0),(getpos player select 1),(getpos player select 2)+1];
	_cam camsettarget (player modeltoworld [-3,0,0.75]);
	
	_cam camcommit 0 ; 
	showCinemaBorder  false;
		
	if ((currentVisionMode player)==1) then { camUseNVG true;}
	else {camUseNVG false;};
	
	cameraEffectEnableHUD true;
	
	_rot=1;
	waituntil
	{
		sleep 0.015;
		if (_rot>0) then {player setdir ((direction player)-0.20);};
		if (_rot<0) then {player setdir ((direction player)+0.20);};
		_rot=_rot+1;
		if (_rot>125) then {_rot=-125;};
		(isnull (finddisplay 8003));
	};

	_cam cameraeffect ["terminate", "back"] ;
	camdestroy _cam;
};

