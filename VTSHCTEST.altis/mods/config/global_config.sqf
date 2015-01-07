//Those represent the available side (available in the cpu)
globalcamp_side=["WEST","EAST","RESISTANCE","CIVILIAN","OBJECT"];

//Those represent the avalaible unit types per camps.
globalcamp_types=["Man","Land","Air","Ship","Static","Group","Base","Object","Logistic","Empty","Composition","Building","Module","Animal"];

//************************************************************
//Vehicle spawn script on those categories for parsing purpose
//************************************************************
type_vehicles=["Land","Air","Ship","Static"];
//Object spawn script on those categories
type_objects=["Logistic","Base","Object","Empty","Composition","Building","Module"];
///!! Dont Touch the caterogys /////

//Custom group array
vts_custom_group_list=[	"Custom_Group_0",
						"Custom_Group_1",
						"Custom_Group_2",
						"Custom_Group_3",
						"Custom_Group_4",
						"Custom_Group_5",
						"Custom_Group_6",
						"Custom_Group_7",
						"Custom_Group_8",
						"Custom_Group_9"
						];

// Additional Script array for RT command 
// Edit _script_list in the scripts folder for easy import of script
_customscript=call compile preprocessfilelinenumbers "mods\scripts\custom_script_list.sqf";
vts_rtscript_array=[];
if (count _customscript>0) then
{
	{
		vts_rtscript_array set [count vts_rtscript_array,"mods\scripts\"+_x];
	} foreach _customscript;
};

//Addons config
[] execvm "mods\config\addons_config.sqf";


// Script 1
script1 = "Patrol (star*radius)";
script1Sqf = "Patrolstar.sqf";

// Script 2
script2 = "Patrol (circle*radius)";
script2Sqf = "Patrolcircle.sqf";

// Script 3
script3 = "Patrol (random*radius)";
script3Sqf = "Patrolrandom.sqf";

// Script 2
script4 = "Go to a point on map";
script4Sqf = "Gotopoint.sqf";

// Script 3
script5 = "Patrol between 2 points";
script5Sqf = "Partol2points.sqf";

// Script 3
script6 = "Land at point";
script6Sqf = "land.sqf";

//script7 = "Follow Mark1";
//script7Sqf = "Gotomarker.sqf";

script8 = "Get In";
script8Sqf = "Gogetin.sqf";

script9 = "Get Out";
script9Sqf = "Gogetout.sqf";

script10 = "Guard";
script10Sqf = "Guardpoint.sqf";

script11 = "Seek & Destroy";
script11Sqf = "SeekDestroy.sqf";

script12 = "Patrol (buildings*radius)";
script12Sqf = "patrolbuildings.sqf";

script13 = "Urban patrol (random*radius)";
script13Sqf = "UPS.sqf";

script14 = "Transport unload";
script14Sqf = "landunload.sqf";

script15 = "UPSMON: Autonomous (radius)";
script15Sqf = "upsauto";

script16 = "UPSMON: Wait Hidden (radius)";
script16Sqf = "upsdefend";

script17 = "UPSMON: Fortify (radius)";
script17Sqf = "upsfortify";

script18 = "UPSMON: Hold Area (radius)";
script18Sqf = "upsnofollow";

script19 = "UPSMON: Reinforcement";
script19Sqf = "upsreinforcement";

script20 = "UPSMON: Ambush (radius)";
script20Sqf = "upsambush";

vts_UPSMONscript=[script15Sqf,script16Sqf,script17Sqf,script18Sqf,script19Sqf,script20Sqf];

if (true) exitWith {};
