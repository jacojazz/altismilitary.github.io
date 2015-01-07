// Start Gear Box
_gearBox = _this select 0;

// Empty Gear Box
ClearWeaponCargo _gearBox;
ClearMagazineCargo _gearBox;

//No Damage
_gearBox allowdamage false;

// Provide Kit Selections
_gearBox addAction [ "US Officer Loadout","scripts\gear.sqf",("o")];
_gearBox addAction [ "US Recruit Loadout","scripts\gear.sqf",("pl")];
_gearBox addAction [ "US Forward Air Controller/Radio Op","scripts\gear.sqf",("fc")];
_gearBox addAction [ "US SquadLeader/Platoon Leader","scripts\gear.sqf",("sl")];
_gearBox addAction [ "US Squad > Rifleman","scripts\gear.sqf",("r")];
_gearBox addAction [ "US Squad > Grenadier","scripts\gear.sqf",("gr")];
_gearBox addAction [ "US Squad > Anti-Tank","scripts\gear.sqf",("ag")];
_gearBox addAction [ "US Squad > Automatic Rifleman","scripts\gear.sqf",("ar")];
_gearBox addAction [ "US Squad > Medic","scripts\gear.sqf",("mc")];
_gearBox addAction [ "US Squad > Marksman","scripts\gear.sqf",("marksman")];
_gearBox addAction [ "US Air > Pilot","scripts\gear.sqf",("pilot")];
_gearBox addAction [ "UK Officer Loadout","scripts\gear.sqf",("uko")];
_gearBox addAction [ "UK Recruit Loadout","scripts\gear.sqf",("ukt")];
_gearBox addAction [ "UK Forward Air Controller/Radio Op","scripts\gear.sqf",("ukfc")];
_gearBox addAction [ "UK SquadLeader/Platoon Leader","scripts\gear.sqf",("uksl")];
_gearBox addAction [ "UK Squad > Rifleman","scripts\gear.sqf",("ukr")];
_gearBox addAction [ "UK Squad > Grenadier","scripts\gear.sqf",("ukgr")];
_gearBox addAction [ "UK Squad > M32 Practice Kit","scripts\gear.sqf",("ukgrw")];
_gearBox addAction [ "UK Squad > Anti-Tank","scripts\gear.sqf",("ukag")];
_gearBox addAction [ "UK Squad > Automatic Rifleman","scripts\gear.sqf",("ukar")];
_gearBox addAction [ "UK Squad > Medic","scripts\gear.sqf",("ukmc")];
_gearBox addAction [ "UK Squad > Marksman","scripts\gear.sqf",("ukmarksman")];
_gearBox addAction [ "UK Air > Pilot","scripts\gear.sqf",("ukpilot")];

// Add Gear To Box
// Resources [ammo]
_gearBox addMagazineCargo ["hlc_100Rnd_762x51_M_M60E4",250];
_gearBox addMagazineCargo ["30Rnd_556x45_Stanag",250];
_gearBox addMagazineCargo ["30Rnd_556x45_Stanag_Tracer_Red",250];
_gearBox addMagazineCargo ["RH_15Rnd_9x19_M9",250];
_gearBox addMagazineCargo ["9Rnd_45ACP_Mag",250];
_gearBox addMagazineCargo ["30Rnd_45ACP_Mag_SMG_01",250];
_gearBox addMagazineCargo ["1Rnd_HE_Grenade_shell",250];
_gearBox addMagazineCargo ["1Rnd_SmokeRed_Grenade_shell",250];
_gearBox addMagazineCargo ["1Rnd_Smoke_Grenade_shell",250];
_gearBox addMagazineCargo ["SmokeShell",250];
_gearBox addMagazineCargo ["SmokeShellRed",250];
_gearBox addMagazineCargo ["SmokeShellGreen",250];
_gearBox addMagazineCargo ["SmokeShellYellow",250];
_gearBox addMagazineCargo ["HandGrenade",250];

// Resources [items]
_gearBox additemcargo ["AGM_Bandage", 80];
_gearBox additemcargo ["AGM_Epipen", 80];
_gearBox additemcargo ["AGM_Morphine", 80];
_gearBox additemcargo ["ToolKit", 20];
_gearBox additemcargo ["acc_flashlight", 19];

