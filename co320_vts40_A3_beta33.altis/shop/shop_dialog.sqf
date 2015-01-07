_canshop=!(isnil "vtsdataloaded");
if (!(isnil "vts_respawn_abletointeract") && _canshop) then {_canshop=[player] call vts_respawn_abletointeract;};
if !(_canshop) exitwith {if (isnil "vtsdataloaded") then {hint "Error : Game data not yet loaded, please wait";};};
//closedialog 0;

_param=nil;
if (count _this>0) then {_param=_this select 0;};

if (typename _param=="OBJECT") then 
{
	vts_shopside=_param getvariable ["vts_shopside",side group player];
};
if (typename _param=="SIDE") then
{
	vts_shopside=_param;
};

_shopfunc=[] execvm "shop\shop_functions.sqf";
waitUntil {scriptDone _shopfunc};

//player action ["WeaponOnBack",player];
shopdialog=createDialog "VTS_Rscshop";

vts_shopinitialpanel=[1,5];


_sidearray=[] call vts_shopsidenameandcolor;
ctrlsettext [133015,(_sidearray select 0)+" shop"];
((finddisplay 8004) displayctrl 133015) ctrlsettextcolor (_sidearray select 1);

vts_shopfirstdisplay=[ShopWeaponList,"CfgWeapons",vts_shopinitialpanel,true] spawn vts_shopgeneratelist;

[] spawn vts_shoprefreshplayeritems;
[] spawn vts_shopdisplaybalance;

if !(isnil "vts_shop_filter") then {ctrlsettext [133033,vts_shop_filter];};



//Loadout only accessible for Arma 3
if (vtsarmaversion>2) then
{
	private "_index";
	//[] spawn vts_shopdisplayloadouts;
	//Persistent Loadout or Ally loadout

	_index=lbAdd [133038,"Personal Loadouts"];
	lbSetData [133038,_index,"0"];


	_index=lbAdd [133038,"Allies Loadouts"];
	lbSetData [133038,_index,"1"];


	_index=lbAdd [133038,"Server Loadouts"];
	lbSetData [133038,_index,"2"];
	
	if (isnil "vts_shoploadouttype") then {vts_shoploadouttype=0;};
	lbSetCurSel [133038, vts_shoploadouttype];
}
else
{
	ctrlShow [133038,false];
	ctrlShow [133030,false];
	ctrlShow [133031,false];
	ctrlShow [133032,false];
	ctrlShow [133035,false];
	ctrlShow [133036,false];
	ctrlShow [133042,false];
	ctrlShow [133043,false];	
	
};

if (!([player] call vts_getisGM)) then 
{
ctrlShow [133023,false];
ctrlShow [133039,false];
ctrlShow [133040,false];
ctrlShow [133041,false];
ctrlShow [133044,false];
ctrlShow [133045,false];
ctrlShow [133046,false];
ctrlShow [133047,false];
ctrlShow [133049,false];
ctrlShow [133050,false];
};

//["VTS_Rscshop"] spawn vts_uieditor;
//((finddisplay 8004) displayctrl 133002) ctrlSetFontHeight 0.02;
//((finddisplay 8004) displayctrl 133002) ctrlSetBackgroundColor [1,1,1,1];

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
	waituntil{sleep 0.1;!(isnull (finddisplay 8004))};
	["VTS_Rscshop",0.4,0] spawn _movedialog;
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
		(isnull (finddisplay 8004));
	};

	_cam cameraeffect ["terminate", "back"] ;
	camdestroy _cam;
	

};

