_unitrole = toLower (_this select 3);
_unit = _this select 1;

removeallweapons _unit;
removegoggles _unit;
removeheadgear _unit;
removevest _unit;
removeuniform _unit;
removeallassigneditems _unit;
removebackpack _unit;
_unit addweapon "ItemMap";

// Resources [items]
_nvg = "NVGoggles";
_gps = "ItemGPS";
_bino = "Binocular";
_map = "ItemMap";
_medkit = "Medikit";
_bandage = "FirstAidKit";
_toolkit = "ToolKit";
_compass = "ItemCompass";
_minedectector = "MineDetector";
_laser = "Laserdesignator";
_laserbatteries = "Laserbatteries";
_rangefinder = "Rangefinder";
_uavterminal = "B_UAVTERMINAL";
_democharge = "DemoCharge_Remote_Mag";
_bandage = "AGM_Bandage";
_morphine = "AGM_Morphine";
_epi = "AGM_Epipen";
_bloodbag= "AGM_BloodBag";

// Resources [weapons]
_ar = "hlc_lmg_m60";
_rGL = "RH_M16a2gl";
_r = "RH_M16a2";
_pilot = "RH_m9";
_pistol = "RH_m9";
_at = "STI_m136";
_mk = "RH_Mk12mod1";
_ukr = "kio_l85a2_p";
_grw = "STI_M32";
_ukat = "STI_MAAWS";

// Resources [ammo]
_armag = "hlc_100Rnd_762x51_M_M60E4";
_rmag = "30Rnd_556x45_Stanag";
_rmagtracer = "30Rnd_556x45_Stanag_Tracer_Red";
_atmag = "STI_84MM_SMOKE";
_athe = "STI_84MM_HEAT";
_pistolmag = "RH_15Rnd_9x19_M9";
_smgmag = "30Rnd_45ACP_Mag_SMG_01";
_ukrmag = "L85_30Rnd_556x45_Stanag";
_ukrtracer= "L85_30Rnd_556x45_Stanag_Tracer";

// Resources [grenade]
_HEShell = "1Rnd_HE_Grenade_shell";
_smokeshellR = "1Rnd_SmokeRed_Grenade_shell";
_smokeshellW = "1Rnd_Smoke_Grenade_shell";
_hsmokegrenadeW = "SmokeShell";
_hsmokegrenadeR = "SmokeShellRed";
_hsmokegrenadeG = "SmokeShellGreen";
_hsmokegrenadeY = "SmokeShellYellow";
_hgrenade = "HandGrenade";
_minihgrenade = "MiniGrenade";
_m32he = "STI_6Rnd_HE_Grenade_shell";
_m32w = "STI_6Rnd_Smoke_Grenade_shell";

// Resources [attachments]
_ir = "acc_pointer_IR";
_fl = "acc_flashlight";
_reddot = "optic_Aco";
_greendot = "optic_ACO_grn";
_rco = "optic_Hamr";
_aco = "optic_Arco";
_halo = "optic_Holosight";
_mrco = "optic_MRCO";
_silencer762 = "muzzle_snds_B";
_silencer65 = "muzzle_snds_H";
_silencer56 = "muzzle_snds_M";
_silencerLMG = "muzzle_snds_H_MG";
_silencer9 = "muzzle_snds_L";
_dms =  "optic_DMS";


// Resources [backpacks]
_uavbackpack = "B_UAV_01_backpack_F";
_squadlbackpack = "B_Kitbag_mcamo";
_riflebackpack = "B_AssaultPack_mcamo";
_grenadierpack = "B_AssaultPack_mcamo";
_assistantbackpack = "B_Kitbag_mcamo";
_pilotbackpack = "B_FieldPack_Base";
_parachute = "B_Parachute";
_radiobag = "tf_rt1523g";

// Resources [radios]
//_343radio = "ACRE_PRC343";
//_148radio = "ACRE_PRC148";
//_119radio = "ACRE_PRC119";
_152radio = "tf_anprc152_2";

// Resources [clothing]

//US Standard Recruit
_plhelm = "H_HelmetB_desert";
_pluniform = "U_mas_usr_B_IndUniform2_d";
_plvest = "V_mas_usr_PlateCarrier2_rgr_d";

//US Forward Air Controller
_fchelm = "H_HelmetB_desert";
_fcuniform = "U_mas_usr_B_IndUniform2_d";
_fcvest = "V_mas_usr_PlateCarrier2_rgr_d";

//US Squad Leader
_slhelm = "H_HelmetB_desert";
_sluniform = "U_mas_usr_B_IndUniform2_d";
_slvest = "V_mas_usr_PlateCarrier2_rgr_d";

//US Rifleman
_rmhelm = "H_HelmetB_desert";
_rmuniform = "U_mas_usr_B_IndUniform2_d";
_rmvest = "V_mas_usr_PlateCarrier2_rgr_d";

//US Grenadier
_grhelm = "H_HelmetB_desert";
_gruniform = "U_mas_usr_B_IndUniform2_d";
_grvest = "V_mas_usr_PlateCarrier2_rgr_d";

//US Assistant Gunner
_aghelm = "H_HelmetB_desert";
_aguniform = "U_mas_usr_B_IndUniform2_d";
_agvest = "V_mas_usr_PlateCarrier2_rgr_d";

//US Automatic Rifleman
_arhelm = "H_HelmetB_desert";
_aruniform = "U_mas_usr_B_IndUniform2_d";
_arvest = "V_mas_usr_PlateCarrier2_rgr_d";

//US Officer
_ohelm = "H_Beret_Colonel";
_ouniform = "U_mas_usr_B_IndUniform2_d";
_ovest = "V_mas_usr_PlateCarrier2_rgr_d";

//US Pilot
_pilothelm = "H_PilotHelmetHeli_B";
_pilotuniform = "U_B_PilotCoveralls";
_pilotvest = "V_TacVest_oli";

//UK Officer
_ukohelm = "Beret_SAS_Maroon";
_ukouniform = "STKR_UBACS_GLV";
_ukovest = "STKR_Osprey_SL";

//UK Soldier
_ukhelm = "STKR_MK7";
_ukuniform = "STKR_UBACS_GLV";
_ukvest = "STKR_Osprey_SL";

// Other
_blackshades = "G_Shades_Black";

sleep 1;

switch (_unitrole) do{

case "pl": //US Standard Rifleman
{
_unit adduniform _pluniform;
_unit addheadgear _plhelm;

_unit addvest _plvest;
{_unit additem _bandage} foreach [1];
_unit addmagazines [_Rmag ,12];
_unit addmagazines [_Rmagtracer ,4];
_unit addmagazines [_pistolmag ,4];

_unit addweapon _r;
_unit addweapon _pistol;

_unit addweapon "ItemCompass";
_unit addweapon "ItemWatch";
_unit additem _152radio;
_unit assignitem _152radio;
_unit additem _nvg;
_unit assignitem _nvg;
_unit additem _gps;
_unit assignitem _gps;
_unit addweapon _bino;
_unit assignitem _bino;
_unit additem _epi;
_unit additem _epi;
_unit additem _morphine;
_unit additem _morphine;
_unit additem _morphine;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;

};

case "fc": //US Forward Air Controller
{
_unit adduniform _fcuniform;
_unit addheadgear _fchelm;
_unit  addBackPack _radiobag;

_unit addvest _fcvest;
_unit addmagazines [_Rmag ,12];
_unit addmagazines [_Rmagtracer ,4];
_unit addmagazines [_pistolmag ,4];

_unit addweapon _r;
_unit addweapon _pistol;

_unit addweapon "ItemCompass";
_unit addweapon "ItemWatch";
_unit additem _152radio;
_unit assignitem _152radio;
_unit additem _nvg;
_unit assignitem _nvg;
_unit additem _gps;
_unit assignitem _gps;
_unit addweapon _rangefinder;
_unit assignitem _rangefinder;
_unit addmagazines [_hsmokegrenadeR ,2];
_unit addmagazines [_hsmokegrenadeG ,2];
_unit addmagazines [_hsmokegrenadeY ,2];
_unit addmagazines [_hsmokegrenadeW ,2];
_unit additem _epi;
_unit additem _epi;
_unit additem _morphine;
_unit additem _morphine;
_unit additem _morphine;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;


};

case "o": //US officer
{
_unit adduniform _fcuniform;
_unit addheadgear _ohelm;
_unit  addBackPack _radiobag;

_unit addvest _fcvest;
_unit addmagazines [_Rmag ,12];
_unit addmagazines [_Rmagtracer ,4];
_unit addmagazines [_pistolmag ,4];

_unit addweapon _r;
_unit addweapon _pistol;

_unit addweapon "ItemCompass";
_unit addweapon "ItemWatch";
_unit additem _152radio;
_unit assignitem _152radio;
_unit additem _nvg;
_unit assignitem _nvg;
_unit additem _gps;
_unit assignitem _gps;
_unit addweapon _rangefinder;
_unit assignitem _rangefinder;
_unit addmagazines [_hsmokegrenadeR ,2];
_unit addmagazines [_hsmokegrenadeG ,2];
_unit addmagazines [_hsmokegrenadeY ,2];
_unit addmagazines [_hsmokegrenadeW ,2];
_unit additem _epi;
_unit additem _epi;
_unit additem _morphine;
_unit additem _morphine;
_unit additem _morphine;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;


};

case "uko": //UK officer
{
_unit adduniform _ukouniform;
_unit addheadgear _ukohelm;
_unit  addBackPack _radiobag;

_unit addvest _ukovest;
_unit addmagazines [_ukrmag ,12];
_unit addmagazines [_ukrtracer ,4];
_unit addmagazines [_pistolmag ,4];

_unit addweapon _ukr;
_unit addweapon _pistol;

_unit addweapon "ItemCompass";
_unit addweapon "ItemWatch";
_unit additem _152radio;
_unit assignitem _152radio;
_unit additem _nvg;
_unit assignitem _nvg;
_unit additem _gps;
_unit assignitem _gps;
_unit addweapon _rangefinder;
_unit assignitem _rangefinder;
_unit addmagazines [_hsmokegrenadeR ,2];
_unit addmagazines [_hsmokegrenadeG ,2];
_unit addmagazines [_hsmokegrenadeY ,2];
_unit addmagazines [_hsmokegrenadeW ,2];
_unit additem _epi;
_unit additem _epi;
_unit additem _morphine;
_unit additem _morphine;
_unit additem _morphine;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;


};

case "ukt": //UK Trainee
{
_unit adduniform _ukouniform;
_unit addheadgear _ukrhelm;

_unit addvest _ukovest;
_unit addmagazines [_ukrmag ,12];
_unit addmagazines [_ukrtracer ,4];
_unit addmagazines [_pistolmag ,4];

_unit addweapon _ukr;
_unit addweapon _pistol;

_unit addweapon "ItemCompass";
_unit addweapon "ItemWatch";
_unit additem _152radio;
_unit assignitem _152radio;
_unit additem _nvg;
_unit assignitem _nvg;
_unit additem _gps;
_unit assignitem _gps;
_unit addweapon _bino;
_unit assignitem _bino;
_unit additem _epi;
_unit additem _epi;
_unit additem _morphine;
_unit additem _morphine;
_unit additem _morphine;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;


};

case "ukfc": //UK Forward Air Controller
{
_unit adduniform _ukuniform;
_unit addheadgear _ukhelm;
_unit  addBackPack _radiobag;

_unit addvest _ukvest;
_unit addmagazines [_ukrmag ,12];
_unit addmagazines [_ukrtracer ,4];
_unit addmagazines [_pistolmag ,4];

_unit addweapon _ukr;
_unit addweapon _pistol;

_unit addweapon "ItemCompass";
_unit addweapon "ItemWatch";
_unit additem _152radio;
_unit assignitem _152radio;
_unit additem _nvg;
_unit assignitem _nvg;
_unit additem _gps;
_unit assignitem _gps;
_unit addweapon _rangefinder;
_unit assignitem _rangefinder;
_unit addmagazines [_hsmokegrenadeR ,2];
_unit addmagazines [_hsmokegrenadeG ,2];
_unit addmagazines [_hsmokegrenadeY ,2];
_unit addmagazines [_hsmokegrenadeW ,2];
_unit additem _epi;
_unit additem _epi;
_unit additem _morphine;
_unit additem _morphine;
_unit additem _morphine;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;


};

case "uksl": //UK Squad Leader
{
_unit adduniform _ukuniform;
_unit addheadgear _ukhelm;

_unit addbackpack _radiobag;
{_unit additem _bandage} foreach [1];
_unit addmagazines [_hsmokegrenadeR ,2];
_unit addmagazines [_hsmokegrenadeG ,2];
_unit addmagazines [_hsmokegrenadeY ,2];

_unit addvest _ukvest;
_unit addmagazines [_ukrmag ,12];
_unit addmagazines [_ukrtracer ,5];
_unit addmagazines [_hgrenade ,2];
_unit addmagazines [_pistolmag ,4];

_unit addweapon _ukr;
_unit addweapon _pistol;

_unit addweapon "ItemCompass";
_unit addweapon "ItemWatch";
//_unit additem _343radio;
_unit additem _152radio;
_unit assignitem _152radio;
_unit additem _nvg;
_unit assignitem _nvg;
_unit additem _gps;
_unit assignitem _gps;
_unit addweapon _rangefinder;
_unit assignitem _rangefinder;
_unit additem _epi;
_unit additem _epi;
_unit additem _morphine;
_unit additem _morphine;
_unit additem _morphine;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;


};

case "ukr": //UK Rifleman
{
_unit adduniform _ukuniform;
_unit addheadgear _ukhelm;

_unit addvest _ukvest;
_unit addmagazines [_ukrmag ,12];
_unit addmagazines [_ukrtracer ,1];
_unit addmagazines [_hgrenade ,1];
_unit addmagazines [_pistolmag ,4];
_unit addmagazines [_hsmokegrenadeW ,1];

_unit addweapon _ukr;
_unit addweapon _pistol;

_unit addweapon "ItemCompass";
_unit addweapon "ItemWatch";
//_unit additem _343radio;
_unit additem _152radio;
_unit assignitem _152radio;
_unit additem _nvg;
_unit assignitem _nvg;
_unit additem _gps;
_unit assignitem _gps;
_unit addweapon _bino;
_unit assignitem _bino;
_unit additem _epi;
_unit additem _epi;
_unit additem _morphine;
_unit additem _morphine;
_unit additem _morphine;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;


};

case "ukgr": //UK Grenadier
{
_unit adduniform _ukuniform;
_unit addheadgear _ukhelm;
_unit addBackPack _grenadierpack;

_unit addvest _ukvest;
_unit addmagazines [_ukrmag ,9];
_unit addmagazines [_ukrtracer ,2];
_unit addmagazines [_hgrenade ,2];
_unit addmagazines [_pistolmag ,2];
_unit addmagazines [_hsmokegrenadeW ,2];

_unit addweapon _ukr;
_unit addweapon _pistol;

_unit addweapon "ItemCompass";
_unit addweapon "ItemWatch";
//_unit additem _343radio;
_unit additem _152radio;
_unit assignitem _152radio;
_unit additem _nvg;
_unit assignitem _nvg;
_unit additem _gps;
_unit assignitem _gps;
_unit addweapon _bino;
_unit assignitem _bino;
_unit additem _epi;
_unit additem _epi;
_unit additem _morphine;
_unit additem _morphine;
_unit additem _morphine;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;

};

case "ukgrw": //UK Grenadier Weapon Kit
{
_unit adduniform _ukuniform;
_unit addheadgear _ukhelm;
_unit addBackPack _grenadierpack;

_unit addvest _ukvest;
_unit addmagazines [_m32he ,8];
_unit addmagazines [_m32w ,3];
_unit addmagazines [_hgrenade ,2];
_unit addmagazines [_pistolmag ,2];
_unit addmagazines [_hsmokegrenadeW ,2];

_unit addweapon _pistol;
_unit addweapon _grw;

_unit addweapon "ItemCompass";
_unit addweapon "ItemWatch";
//_unit additem _343radio;
_unit additem _152radio;
_unit assignitem _152radio;
_unit additem _nvg;
_unit assignitem _nvg;
_unit additem _gps;
_unit assignitem _gps;
_unit addweapon _bino;
_unit assignitem _bino;
_unit additem _epi;
_unit additem _epi;
_unit additem _morphine;
_unit additem _morphine;
_unit additem _morphine;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;


};

case "ukag": //UK Anti-Tank
{
_unit adduniform _ukuniform;
_unit addheadgear _ukhelm;
_unit addBackPack _squadlbackpack;

_unit addvest _ukvest;
_unit addmagazines [_ukrmag ,10];
_unit addmagazines [_hgrenade ,1];
_unit addmagazines [_pistolmag ,2];
_unit addmagazines [_hsmokegrenadeW ,1];
_unit addmagazines [_atmag ,1];
_unit addmagazines [_athe ,3];

_unit addweapon _ukr;
_unit addweapon _pistol;
_unit addweapon _ukat;

_unit addweapon "ItemCompass";
_unit addweapon "ItemWatch";
//_unit additem _343radio;
_unit additem _152radio;
_unit assignitem _152radio;
_unit additem _nvg;
_unit assignitem _nvg;
_unit additem _gps;
_unit assignitem _gps;
_unit addweapon _bino;
_unit assignitem _bino;
_unit additem _epi;
_unit additem _epi;
_unit additem _morphine;
_unit additem _morphine;
_unit additem _morphine;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;


};

case "ukar": //UK Automatic Rifleman
{
_unit adduniform _ukuniform;
_unit addheadgear _ukhelm;
_unit addbackpack _assistantbackpack;

_unit addvest _ukvest;
_unit addmagazines [_armag ,7];
_unit addmagazines [_hgrenade ,2];
_unit addmagazines [_pistolmag ,4];
_unit addmagazines [_hsmokegrenadeW ,2];

_unit addweapon _ar;
_unit addweapon _pistol;

_unit addweapon "ItemCompass";
_unit addweapon "ItemWatch";
//_unit additem _343radio;
_unit additem _152radio;
_unit assignitem _152radio;
_unit additem _nvg;
_unit assignitem _nvg;
_unit additem _gps;
_unit assignitem _gps;
_unit addweapon _bino;
_unit assignitem _bino;
_unit additem _epi;
_unit additem _epi;
_unit additem _morphine;
_unit additem _morphine;
_unit additem _morphine;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;


};

case "ukmc": //UK Medic
{
_unit adduniform _ukuniform;
_unit addheadgear _ukhelm;
_unit addbackpack _assistantbackpack;

_unit addvest _ukvest;
_unit addmagazines [_ukrmag ,12];
_unit addmagazines [_ukrtracer ,5];
_unit addmagazines [_hgrenade ,2];
_unit addmagazines [_pistolmag ,4];
_unit addmagazines [_hsmokegrenadeW ,2];

_unit addweapon _ukr;
_unit addweapon _pistol;

_unit addweapon "ItemCompass";
_unit addweapon "ItemWatch";
_unit additem _152radio;
_unit assignitem _152radio;
_unit additem _nvg;
_unit assignitem _nvg;
_unit removeitem _gps;
_unit addweapon _bino;
_unit assignitem _bino;
_unit additem _epi;
_unit additem _epi;
_unit additem _epi;
_unit additem _epi;
_unit additem _epi;
_unit additem _epi;
_unit additem _epi;
_unit additem _epi;
_unit additem _morphine;
_unit additem _morphine;
_unit additem _morphine;
_unit additem _morphine;
_unit additem _morphine;
_unit additem _morphine;
_unit additem _morphine;
_unit additem _morphine;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bloodbag;
_unit additem _bloodbag;
_unit additem _bloodbag;


};

case "ukmarksman": //UK Marksman
{
_unit adduniform _ukuniform;
_unit addheadgear _ukhelm;

_unit addvest _ukvest;
_unit addmagazines [_Rmag ,12];
_unit addmagazines [_Rmagtracer ,5];
_unit addmagazines [_hgrenade ,2];
_unit addmagazines [_pistolmag ,4];
_unit addmagazines [_hsmokegrenadeW ,2];

_unit addweapon _mk;
_unit addprimaryweaponitem _dms;
_unit addweapon _pistol;

_unit addweapon "ItemCompass";
_unit addweapon "ItemWatch";
//_unit additem _343radio;
_unit additem _152radio;
_unit assignitem _152radio;
_unit additem _nvg;
_unit assignitem _nvg;
_unit additem _gps;
_unit assignitem _gps;
_unit addweapon _bino;
_unit assignitem _bino;
_unit additem _epi;
_unit additem _epi;
_unit additem _morphine;
_unit additem _morphine;
_unit additem _morphine;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;


};

case "ukpilot": //UK Pilot
{
_unit adduniform _pilotuniform;
_unit addheadgear _pilothelm;

_unit addmagazines [_pistolmag ,4];

_unit addweapon _pilot;
_unit addprimaryweaponitem _ir;
_unit addweapon _pistol;

_unit addbackpack _parachute;

_unit addweapon "ItemCompass";
_unit addweapon "ItemWatch";
_unit additem _152radio;
_unit assignitem _152radio;
_unit additem _nvg;
_unit assignitem _nvg;
_unit additem _gps;
_unit assignitem _gps;
_unit additem _epi;
_unit additem _epi;
_unit additem _morphine;
_unit additem _morphine;
_unit additem _morphine;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;


};

case "sl": //US Squad Leader
{
_unit adduniform _sluniform;
_unit addheadgear _slhelm;

_unit addbackpack _radiobag;
{_unit additem _bandage} foreach [1];
_unit addmagazines [_smokeshellR ,1];
_unit addmagazines [_smokeshellW ,1];
_unit addmagazines [_hsmokegrenadeR ,2];
_unit addmagazines [_hsmokegrenadeG ,2];
_unit addmagazines [_hsmokegrenadeY ,2];

_unit addvest _slvest;
_unit addmagazines [_Rmag ,12];
_unit addmagazines [_Rmagtracer ,5];
_unit addmagazines [_HEShell ,4];
_unit addmagazines [_hgrenade ,2];
_unit addmagazines [_pistolmag ,4];

_unit addweapon _rgl;
_unit addweapon _pistol;

_unit addweapon "ItemCompass";
_unit addweapon "ItemWatch";
//_unit additem _343radio;
_unit additem _152radio;
_unit assignitem _152radio;
_unit additem _nvg;
_unit assignitem _nvg;
_unit additem _gps;
_unit assignitem _gps;
_unit addweapon _rangefinder;
_unit assignitem _rangefinder;
_unit additem _epi;
_unit additem _epi;
_unit additem _morphine;
_unit additem _morphine;
_unit additem _morphine;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;

};

case "r": //US Rifleman
{
_unit adduniform _rmuniform;
_unit addheadgear _rmhelm;

{_unit additem _bandage} foreach [1];
_unit addvest _rmvest;
_unit addmagazines [_Rmag ,12];
_unit addmagazines [_Rmagtracer ,4];
_unit addmagazines [_hgrenade ,1];
_unit addmagazines [_hsmokegrenadeW ,1];
_unit addmagazines [_pistolmag ,4];

_unit addweapon _r;
_unit addweapon _pistol;

_unit addweapon "ItemCompass";
_unit addweapon "ItemWatch";
_unit additem _152radio;
_unit assignitem _152radio;
_unit additem _nvg;
_unit assignitem _nvg;
_unit removeitem _gps;
_unit addweapon _bino;
_unit assignitem _bino;
_unit additem _epi;
_unit additem _epi;
_unit additem _morphine;
_unit additem _morphine;
_unit additem _morphine;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;

};

case "gr": //US Grenadier
{
_unit adduniform _gruniform;
_unit addheadgear _grhelm;

{_unit additem _bandage} foreach [1];
_unit addmagazines [_smokeshellR ,3];
_unit addmagazines [_smokeshellW ,3];
_unit addmagazines [_hsmokegrenadeR ,2];
_unit addmagazines [_hsmokegrenadeG ,2];
_unit addmagazines [_hsmokegrenadeY ,2];

_unit addvest _slvest;
_unit addmagazines [_Rmag ,12];
_unit addmagazines [_Rmagtracer ,5];
_unit addmagazines [_HEShell ,8];
_unit addmagazines [_hgrenade ,2];
_unit addmagazines [_pistolmag ,4];

_unit addweapon _rgl;
_unit addweapon _pistol;

_unit addweapon "ItemCompass";
_unit addweapon "ItemWatch";
//_unit additem _343radio;
_unit additem _152radio;
_unit assignitem _152radio;
_unit additem _nvg;
_unit assignitem _nvg;
_unit additem _gps;
_unit assignitem _gps;
_unit addweapon _bino;
_unit assignitem _bino;
_unit additem _epi;
_unit additem _epi;
_unit additem _morphine;
_unit additem _morphine;
_unit additem _morphine;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;

};

case "ag": //US Anti-Tank
{
_unit adduniform _aguniform;
_unit addheadgear _aghelm;

_unit addvest _agvest;
_unit addmagazines [_Rmag ,11];
_unit addmagazines [_Rmagtracer ,4];
_unit addmagazines [_pistolmag ,4];
_unit addmagazines [_hgrenade ,1];
_unit addmagazines [_hsmokegrenadeW ,1];


_unit addweapon _r;
_unit addweapon _pistol;
_unit addweapon _at;


_unit addweapon "ItemCompass";
_unit addweapon "ItemWatch";
_unit additem _152radio;
_unit assignitem _152radio;
_unit additem _nvg;
_unit assignitem _nvg;
_unit additem _gps;
_unit assignitem _gps;
_unit addweapon _bino;
_unit assignitem _bino;
_unit additem _epi;
_unit additem _epi;
_unit additem _morphine;
_unit additem _morphine;
_unit additem _morphine;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;

};

case "ar": //US Automatic Rifleman
{
_unit adduniform _aruniform;
_unit addheadgear _arhelm;

_unit addvest _arvest;
_unit addmagazines [_armag ,7];
_unit addmagazines [_pistolmag ,4];
_unit addmagazines [_hgrenade ,1];
_unit addmagazines [_hsmokegrenadeW ,1];

_unit addweapon _ar;
_unit addweapon _pistol;

_unit addweapon "ItemCompass";
_unit addweapon "ItemWatch";
_unit additem _152radio;
_unit assignitem _152radio;
_unit additem _nvg;
_unit assignitem _nvg;
_unit additem _gps;
_unit assignitem _gps;
_unit addweapon _bino;
_unit assignitem _bino;
_unit additem _epi;
_unit additem _epi;
_unit additem _morphine;
_unit additem _morphine;
_unit additem _morphine;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;

_unit addmagazines [_armag ,1];
{_unit additem _bandage} foreach [1];

};

case "mc": //US medic
{
_unit adduniform _rmuniform;
_unit addheadgear _rmhelm;
_unit addbackpack _assistantbackpack;

{_unit additem _bandage} foreach [1];
_unit addvest _rmvest;
_unit addmagazines [_Rmag ,12];
_unit addmagazines [_Rmagtracer ,4];
_unit addmagazines [_hgrenade ,1];
_unit addmagazines [_hsmokegrenadeW ,4];
_unit addmagazines [_hsmokegrenadeG ,2];
_unit addmagazines [_hsmokegrenadeR ,1];
_unit addmagazines [_pistolmag ,4];

_unit addweapon _r;
_unit addweapon _pistol;

_unit addweapon "ItemCompass";
_unit addweapon "ItemWatch";
_unit additem _152radio;
_unit assignitem _152radio;
_unit additem _nvg;
_unit assignitem _nvg;
_unit removeitem _gps;
_unit addweapon _bino;
_unit assignitem _bino;
_unit additem _epi;
_unit additem _epi;
_unit additem _epi;
_unit additem _epi;
_unit additem _epi;
_unit additem _epi;
_unit additem _epi;
_unit additem _epi;
_unit additem _morphine;
_unit additem _morphine;
_unit additem _morphine;
_unit additem _morphine;
_unit additem _morphine;
_unit additem _morphine;
_unit additem _morphine;
_unit additem _morphine;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bloodbag;
_unit additem _bloodbag;
_unit additem _bloodbag;

};

case "marksman": //US Marksman
{
_unit adduniform _rmuniform;
_unit addheadgear _rmhelm;

{_unit additem _bandage} foreach [1];
_unit addvest _rmvest;
_unit addmagazines [_Rmag ,12];
_unit addmagazines [_Rmagtracer ,4];
_unit addmagazines [_hgrenade ,1];
_unit addmagazines [_hsmokegrenadeW ,2];
_unit addmagazines [_hsmokegrenadeG ,2];
_unit addmagazines [_hsmokegrenadeR ,1];
_unit addmagazines [_pistolmag ,4];

_unit addweapon _mk;
_unit addprimaryweaponitem _dms;
_unit addweapon _pistol;

_unit addweapon "ItemCompass";
_unit addweapon "ItemWatch";
_unit additem _152radio;
_unit assignitem _152radio;
_unit additem _nvg;
_unit assignitem _nvg;
_unit removeitem _gps;
_unit addweapon _rangefinder;
_unit assignitem _rangefinder;

};

case "pilot": //US Pilot
{
_unit adduniform _pilotuniform;
_unit addheadgear _pilothelm;

_unit addmagazines [_pistolmag ,4];

_unit addweapon _pilot;
_unit addprimaryweaponitem _ir;
_unit addweapon _pistol;

_unit addbackpack _parachute;

_unit addweapon "ItemCompass";
_unit addweapon "ItemWatch";
_unit additem _152radio;
_unit assignitem _152radio;
_unit additem _nvg;
_unit assignitem _nvg;
_unit additem _gps;
_unit assignitem _gps;
_unit additem _epi;
_unit additem _epi;
_unit additem _morphine;
_unit additem _morphine;
_unit additem _morphine;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;
_unit additem _bandage;

};

};  

//Assistant Gunner
_aghelm = "H_HelmetB_paint";
_aguniform = "U_B_CombatUniform_mcam";
_agvest = "V_PlateCarrier1_rgr";

//Automatic Rifleman
_arhelm = "H_HelmetB";
_aruniform = "U_B_CombatUniform_mcam_tshirt";
_arvest = "V_PlateCarrier2_rgr";

//Pilot
_pilothelm = "H_PilotHelmetHeli_B";
_pilotuniform = "U_B_PilotCoveralls";
_pilotvest = "V_TacVest_oli";

// Other
_blackshades = "G_Shades_Black";

sleep 1;

switch (_unitrole) do{

case "pl": // Platoon Leader
{
_unit adduniform _pluniform;
removeallcontainers _unit;
_unit addheadgear _plhelm;
_unit addbackpack _uavbackpack;

_unit addvest _plvest;
{_unit additem _bandage} foreach [1];
_unit addmagazines [_Rmag ,7];
_unit addmagazines [_pistolmag ,1];
_unit addmagazines [_hgrenade ,2];
_unit additem _uavterminal;
_unit addmagazines [_hsmokegrenadeR ,2];
_unit addmagazines [_hsmokegrenadeG ,2];

_unit addweapon _r;
_unit addprimaryweaponitem _ir;
_unit addprimaryweaponitem _mrco;
_unit addweapon _pistol;

_unit addweapon "ItemCompass";
_unit addweapon "ItemWatch";
//_unit additem _119radio;
//_unit additem _148radio;
_unit additem _nvg;
_unit assignitem _nvg;
_unit additem _gps;
_unit assignitem _gps;
_unit addweapon _rangefinder;
_unit assignitem _rangefinder;

};