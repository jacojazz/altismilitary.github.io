_unit = _this select 0;
EGG_EVO_pallammo = (magazines _unit);
EGG_EVO_pweapons = (weapons _unit);
EGG_EVO_pweapons = EGG_EVO_pweapons +["Throw","Put"];

EGG_EVO_pitems = (items _unit);
EGG_EVO_aitems = (assignedItems _unit);
player sidechat "save";
//Arma3 items

if !((headgear _unit)=="") then 
{ 
	EGG_EVO_headgear = (headgear _unit);
};
if !((Goggles _unit)=="") then 
{ 
	EGG_EVO_goggles = (Goggles _unit);
};
if !((vest _unit)=="") then 
{ 
	EGG_EVO_vest = (vest _unit);
	EGG_EVO_vestitems = (vestItems _unit);
//	EGG_EVO_Vmags = getMagazineCargo (unitvest _unit);
//	EGG_EVO_Vweps = getWeaponCargo (unitvest _unit);
};
if !((uniform _unit)=="") then 
{ 
	EGG_EVO_uniform = (uniform _unit);
	EGG_EVO_uniformitems = (uniformItems _unit);
//	EGG_EVO_Umags = getMagazineCargo (unitUniform _unit);
//	EGG_EVO_Uweps = getWeaponCargo (unitUniform _unit);
};
if !((backpack _unit)=="") then 
{ 
	EGG_EVO_backpack = (backpack _unit);
	EGG_EVO_packitems = (backpackItems _unit);
//	EGG_EVO_packmags = getMagazineCargo (unitBackpack _unit);
//	EGG_EVO_packweps = getWeaponCargo (unitBackpack _unit);
};
//if !((handgun _unit)=="") then 
//{ 
	EGG_EVO_handgunitems = (handgunItems _unit);
//};
if !((primaryweapon _unit)=="") then 
{ 
	EGG_EVO_pgunitems = (primaryWeaponItems _unit);
};
if !((secondaryweapon _unit)=="") then 
{ 
	EGG_EVO_sgunitems = (secondaryWeaponItems _unit);
};



