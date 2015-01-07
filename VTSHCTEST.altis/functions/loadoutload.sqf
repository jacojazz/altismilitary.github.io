// player spawn script

if (not (local player)) exitwith {};
_unit = _this select 0;
Sleep 0.2;
player sidechat "load";
removeAllWeapons _unit;
removeAllAssignedItems _unit;

if (!(EGG_EVO_headgear=="")) then 
{ 
	removeheadgear _unit;
	_unit addheadgear EGG_EVO_headgear;
	_unit assignItem (EGG_EVO_pitems select 0);
};
if (!(EGG_EVO_goggles=="")) then 
{ 
	removeGoggles _unit;
	_unit addGoggles EGG_EVO_goggles;
	_unit assignItem (EGG_EVO_goggles);
};
if (!(EGG_EVO_vest=="")) then 
{ 
	removeVest _unit;
	_unit AddVest EGG_EVO_vest;
};
if (!(EGG_EVO_uniform=="")) then 
{ 
	removeUniform _unit;
	_unit addUniform EGG_EVO_uniform;
};
if (!(EGG_EVO_backpack=="")) then 
{ 
	removebackpack _unit;
	_unit addbackpack EGG_EVO_backpack;
	clearAllItemsFromBackpack _unit;
	clearMagazineCargoGlobal (unitBackpack _unit);
	clearWeaponCargoGlobal (unitBackpack _unit);
};

{_unit addmagazine _x} forEach EGG_EVO_pallammo;
{_unit additem _x} forEach EGG_EVO_pitems;
{_unit additem _x; _unit assignItem _x} forEach EGG_EVO_aitems;
{_unit addweapon _x} forEach EGG_EVO_pweapons;

if ((count EGG_EVO_sgunitems)>0) then 
{ 
//	{_unit removeItemFromSecondaryWeapon _x} forEach (secondaryWeaponItems _unit);
	{_unit addSecondaryWeaponItem _x} forEach EGG_EVO_sgunitems;
};
if ((count EGG_EVO_handgunitems)>0) then 
{ 
//	{_unit removeItemFromHandgun _x} forEach (handgunItems _unit);
	{_unit addHandgunItem _x} forEach EGG_EVO_handgunitems;
};
if ((count EGG_EVO_pgunitems)>0) then 
{ 
	{_unit removePrimaryWeaponItem _x} forEach (primaryWeaponItems _unit);
	{_unit addPrimaryWeaponItem _x} forEach EGG_EVO_pgunitems;
};

// Grenade launcher Fix
_primary = primaryWeapon _unit;
if (_primary != "") then 
{
	_unit selectWeapon _primary;
	_muzzles = getArray(configFile>>"cfgWeapons" >> _primary >> "muzzles");
	_unit selectWeapon (_muzzles select 0);
};

/*
//A3 grenade fix - doesnt work yet
	_i=0;
	_c = count (EGG_gmagazines select 0) - 1; 
while {_i <= _c} do 
	{
		if ((EGG_gmagazines select 1) select _i in EGG_EVO_pallammo) then 
		{
			_unit selectWeapon "Throw";
			_muzzles = getArray(configFile>>"cfgWeapons" >> "Throw" >> "muzzles");
			_unit selectWeapon (_muzzles select 1);
			_i=_c;
		};
		_i=_i+1;
	};

	if ("MiniGrenade" in EGG_EVO_pallammo) then {_unit addWeapon "Throw";_unit selectWeapon "MiniGrenadeMuzzle"};
	if ("HandGrenade" in EGG_EVO_pallammo) then {_unit addWeapon "Throw";_unit selectWeapon "HandGrenadeMuzzle"};


//init array has EGG_gmagazines = [["MiniGrenadeMuzzle","MiniGrenade"],["HandGrenadeMuzzle","HandGrenade"],["SmokeShellMuzzle","SmokeShell"],["SmokeShellYellowMuzzle","SmokeShellYellow"],["SmokeShellRedMuzzle","SmokeShellRed"],["SmokeShellGreenMuzzle","SmokeShellGreen"],["SmokeShellPurpleMuzzle","SmokeShellPurple"],["SmokeShellBlueMuzzle","SmokeShellBlue"],["SmokeShellOrangeMuzzle","SmokeShellOrange"],["ChemlightGreenMuzzle","Chemlight_green"],["ChemlightRedMuzzle","Chemlight_red"],["ChemlightYellowMuzzle","Chemlight_yellow"],["ChemlightBlueMuzzle","Chemlight_blue"],["HandGrenade_Stone","HandGrenade_Stone"]];

//doesnt work - need to understand how muzzle grenade is selected
If ({_x iskindof "ThrowMuzzle"} in EGG_EVO_pweapons) then
{
	_i=0;
	_c = count (EGG_gmagazines select 0) - 1; 
while {_i <= _c} do 
	{
		if ((EGG_gmagazines select 1) select _i in EGG_EVO_pallammo) then 
		{
			_unit addWeapon "Throw";
			_unit selectWeapon "Throw";
			_muzzles = getArray(configFile>>"cfgWeapons" >> (EGG_gmagazines select 0) select _i >> "muzzles");
			_unit selectWeapon (_muzzles select 1);
			_i=_c;
		};
		_i=_i+1;
	};
};

//["HandGrenade_Stone","MiniGrenade","HandGrenade","SmokeShell","SmokeShellYellow","SmokeShellRed","SmokeShellGreen","SmokeShellPurple","SmokeShellBlue","SmokeShellOrange","Chemlight_green","Chemlight_red","Chemlight_yellow","Chemlight_blue"];
*/

