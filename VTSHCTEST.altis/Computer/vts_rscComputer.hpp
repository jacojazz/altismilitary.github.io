
#define CT_COMBO                 4

class VTS_RscComputer
{
	IDD = 8000;
	MovingEnable = 1;
	
	class Controls
	{
		class CPUBackground:VTS_RscBackground
		{
		  moving=true;
				idc = -1;
				x = 0.05;
				y = 0.025;
				w = 1.1;
				h = 0.935;
			text="";
			ColorBackground[]={0.1,0.1,0.2,0.7};
			ColorText[]={0.1,0.1,0.1,1};

		};

		
		class acc_time : VTS_boutons
		{ 
			idc = 11557; 
			x = 0.500; 
			y = 0.040; 
			w = 0.13; 
			h = 0.015; 
			text = "Acc Time (1D=12Mn)"; 
			action = "if(go_acctime) then {hint ""Time x1"";go_acctime = false ; publicvariable ""go_acctime"";Sync_time = date;publicvariable ""Sync_time""} else {hint ""Time x120"";go_acctime = true ; publicvariable ""go_acctime"";};";
			tooltip = "Speeds up the time, in 12 minutes will elapse 1 day";
		};
		class openwestshop:VTS_boutons
		{ 
			idc = 10682; 
				x = 0.5;
				y = 0.065;
				w = 0.085;
				h = 0.015;
			colorText[] = {0.3,0.3,1.0, 1};
			text = "West Shop";
			action = "[WEST] execvm ""shop\shop_dialog.sqf"";";
			tooltip = "Open West players Shop";
		};
		class openeastshop:VTS_boutons
		{ 
			idc = 10683; 
				x = 0.59;
				y = 0.065;
				w = 0.08;
				h = 0.015;
			colorText[] = {0.9,0.3,0.3, 1};
			text = "East Shop";
			action = "[EAST] execvm ""shop\shop_dialog.sqf"";";
			tooltip = "Open East players Shop";
		};
		class openresshop:VTS_boutons
		{ 
			idc = 10684; 
				x = 0.675;
				y = 0.065;
				w = 0.075;
				h = 0.015;
			text = "Res Shop";
			colorText[] = {0.3,0.8,0.3, 1};
			action = "[RESISTANCE] execvm ""shop\shop_dialog.sqf"";";
			tooltip = "Open Resistance players Shop";
		};
		class opencivshop:VTS_boutons
		{ 
			idc = 10685; 
				x = 0.755;
				y = 0.065;
				w = 0.065;
				h = 0.015;
			colorText[] = {0.85,0.55,0.2, 1};
			text = "Civ Shop";
			action = "[CIVILIAN] execvm ""shop\shop_dialog.sqf"";";
			tooltip = "Open Civilian players Shop";
		};		
		class pointmap:VTS_boutons
		{ 
			idc = 10997; 
				x = 0.497624;
				y = 0.1;
				w = 0.105;
				h = 0.015;
			text = "Point the map";
			action = "[] execvm ""computer\console\pointmaptoplayer.sqf"";";
			tooltip = "Open the map on all players and show them a point on the map";
		};			
		class spectat:VTS_boutons
		{ 
			idc = 10601; 
			x = 0.640; 
			y = 0.040; 
			w = 0.055; 
			h = 0.015; 
			text = "Camera";
			action = "if (true) then {breakclic = 1;  [] execVM ""Computer\Start_freecam.sqf""} else {hint ""3D Cam desactivated in vehicles"";};";
			tooltip = "Watch anything, anywhere, at any time (Shortcut: Shift + 2xClick on the Minimap)";
		};
		class showlogs:VTS_boutons
		{ 
				idc = 11555;
				x = 0.05;
				y = -0.02;
				w = 0.08;
				h = 0.02;
			text = "Open logs";
			action = "[] call vts_showlogs;";
			tooltip = "Open the player's evenements log";
		};	
		class scalegmui:VTS_boutons
		{ 
			idc = 11556; 
			x = 0.050; 
			y = 0.94; 
			w = 0.120; 
			h = 0.020; 
			text = "UI scaling : OFF";
			action = "[] call vts_scalecpuui;";
			tooltip = "Enable or Disable scaling of the CPU interface";
		};			
		class move_respawn:VTS_RscText
		{
				idc = 11550;
				x = 0.095;
				y = 0.025;
				w = 0.1;
				h = 0.02;
		style = ST_LEFT;
		colorText[] = {0.9,0.9,0.9, 1};
		text = "Move base:";
		font = LucidaConsoleB;
		colorBackground[] = {0, 0, 0, 0};
		sizeEx = 0.018;

		tooltip = "Players can not see other side base positions, only the GM does";
		};		
		class W_respawn:VTS_boutons
		{ 
				idc = 11551;
				x = 0.205;
				y = 0.025;
				w = 0.04;
				h = 0.015;
			colorText[] = {0.3,0.3,1.0, 1};
			text = "West";
			action = "breakclic = 1;[""WEST""] execVM ""Computer\console\console_moverespawn.sqf"";";
			tooltip = "Move the West side base somewhere else";
		};

		class E_respawn:VTS_boutons
		{ 
				idc = 11552;
				x = 0.25;
				y = 0.025;
				w = 0.04;
				h = 0.015;
			colorText[] = {0.9,0.3,0.3, 1};
			text = "East";
			action = "breakclic = 1;[""EAST""] execVM ""Computer\console\console_moverespawn.sqf"";";
			tooltip = "Move the East side base somewhere else";
		};
		class G_respawn:VTS_boutons
		{ 
				idc = 11553;
				x = 0.295;
				y = 0.025;
				w = 0.04;
				h = 0.015;
			colorText[] = {0.3,0.8,0.3, 1};
			text = "Res";
			action = "breakclic = 1;[""GUER""] execVM ""Computer\console\console_moverespawn.sqf"";";
			tooltip = "Move the Resistance side base somewhere else";
		};
		class C_respawn:VTS_boutons
		{ 
				idc = 11554;
				x = 0.34;
				y = 0.025;
				w = 0.04;
				h = 0.015;
			colorText[] = {0.85,0.55,0.2, 1};
			text = "Civ";
			action = "breakclic = 1;[""CIV""] execVM ""Computer\console\console_moverespawn.sqf"";";
			tooltip = "Move the Civilian side base somewhere else";
		};		
		class God_mod:VTS_boutons
		{ 
			idc = 10603; 
			x = 0.705; 
			y = 0.040; 
			w = 0.070; 
			h = 0.015; 
			text = "Invisible";
			action = "[] execVM ""functions\cli_setcaptive.sqf"";";
			tooltip = "Be invisible and invincible for the AI";
		};

		class LoadSave_VTSMission:VTS_boutons
		{ 
			idc = 15603; 
			x = 0.850; 
			y = 0.040; 
			w = 0.095; 
			h = 0.030; 
			text = "Load / Save";
			action = "[] call Dlg_StoreParams;createDialog ""rsccommandloadsave"";[] execvm ""Computer\loadsavemission.sqf"";";
			tooltip = "Load or Save mission preset";
		};

   		
		class sec_obj : VTS_RscEdit
		{
		  	idc = 10600;
		  	x = 0.500;
		  	y = 0.759;
		  	w = 0.15;
		  	h = 0.02;
			colorText[] = {0.9,0.9,0.9, 1};
			colorDisabled[] =  {0.9,0.9,0.9, 1};
		    colorSelection[] = {0.5, 0.5, 0.5, 1};
		    tooltip = "Enter the task description here";
		};
		
		class add_sec_objective:VTS_boutons
		{ 
			idc = 10559; 
			x = 0.500; 
			y = 0.781; 
			w = 0.15; 
			h = 0.020; 
			text = "Create a new task";
			action = "breakclic = 1; [] execVM ""Computer\console\console_add_sec_obj.sqf"";";
			tooltip = "Create a task for the current selected side. It will only be seen by players from this side";
		};
		
		class task_done:VTS_boutons
		{ 
			idc = 10556; 
			x = 0.500; 
			y = 0.804; 
			w = 0.15; 
			h = 0.015; 
			colorText[] = { 0.2,1,0.2, 1 };
			text = "Set task succeeded";
			action = "breakclic = 1; [] execVM ""Computer\console\console_task_success.sqf"";";
			tooltip = "Validate any task";
		};

		class task_fail:VTS_boutons
		{ 
			idc = 10554; 
			x = 0.500; 
			y = 0.823; 
			w = 0.15; 
			h = 0.015; 
			colorText[] = { 1,0.2,0.2, 1 };
			text = "Set task failed";
			action = "breakclic = 1; [] execVM ""Computer\console\console_task_fail.sqf"";";
			tooltip = "Fail any task";
		};
		class tpplayer_onspawnconfirm:VTS_boutons
		{ 
				idc = 10756;
				x = 0.205001;
				y = 0.0450006;
				w = 0.175;
				h = 0.015;
				colorText[] = { 1.0,1.0,1.0, 1.0 };
			text = "Move Players -> Bases";

			action = "[] spawn vts_PlayerstoBaseConfirm;";
			tooltip = "Teleport every player to their respective bases";
		};		
		class tpplayer_onspawn:VTS_boutons
		{ 
				idc = 10755;
				x = 0.205001;
				y = 0.0450006;
				w = 0.175;
				h = 0.015;
				colorText[] = { 1.0,1.0,1.0, 0.8 };
			text = "Confirm Players -> Bases";

			action = "[] execvm ""Computer\console\console_sendplayerstorespawns.sqf"";";
			tooltip = "Teleport every player to their respective bases";
		};
			
		
		class fin_missionS:VTS_boutons
		{ 
				idc = 10557;
				x = 0.785;
				y = 0.915;
				w = 0.16;
				h = 0.02;
			colorText[] = { 0.2,1,0.2, 1 };
			text = "END MISSION (success)"; 
			action = "[] spawn vts_MissionsSuccessConfirm;";
			tooltip = "Terminate the VTS mission on a success";
		};
	class fin_missionSvalid:VTS_boutons
		{ 
				idc = 10560;
				x = 0.785;
				y = 0.915;
				w = 0.16;
				h = 0.02;
			colorText[] = { 0.5,1,0.5, 1 };
			text = "Confirm Success"; 
			action = "[] spawn vts_MissionsSuccess;";
			tooltip = "Confirm the success of the mission";		
		};		
		class fin_missionF:VTS_boutons
		{ 
				idc = 10558;
				x = 0.785;
				y = 0.935;
				w = 0.16;
				h = 0.02;
			colorText[] = { 1,0.2,0.2, 1 };
			text = "END MISSION (Failed)"; 
			action = "[] spawn vts_MissionFailConfirm;";
			tooltip = "Terminate the VTS mission on a fail";
		};
	class fin_missionFvalid:VTS_boutons
		{ 	
				idc = 10561;
				x = 0.785;
				y = 0.935;
				w = 0.16;
				h = 0.02;
			colorText[] = { 1,0.5,0.5, 1 };
			text = "Confirm Fail"; 
			action = "[] spawn vts_MissionFail;";
			tooltip = "Confirm the fail of the mission";				
		};			
		
		/*
		class Details : VTS_RscStructuredText
		{
			idc = 102;
			font = LucidaConsoleB;
			x = 0.1;
			y = 0.14;
			w = 0.6; 
			h = 1;
			default = true;
			colorText[] = {0.9,0.9,0.9, 1};
			text = "";
		};
		*/
		// bouton cloud
		
		class cloud_centre:VTS_boutons
		{ 
				idc = 10055;
				x = 0.87;
				y = 0.815;
				w = 0.025;
				h = 0.015;
			text = "Cloud"; 
			tooltip = "Modify overcast from 0 - none to 10 - storm";
		};
		
		class cloud_gauche:VTS_boutons
		{ 
				idc = 10056;
				x = 0.82;
				y = 0.815;
				w = 0.049;
				h = 0.015;
			text = "Cloud<"; 
			action = "valid_cloud = valid_cloud-1 ; [0] execVM ""computer\boutons\cloud_action.sqf"";";
			tooltip = "Modify overcast from 0 - none to 10 - storm";
		};
		
		class cloud_droite:VTS_boutons
		{ 
				idc = 10057;
				x = 0.895;
				y = 0.815;
				w = 0.02;
				h = 0.015;
			text = ">"; 
			action = "valid_cloud = valid_cloud+1 ; [0] execVM ""computer\boutons\cloud_action.sqf"";";
			tooltip = "Modify overcast from 0 - none to 10 - storm";
		};
		
		class cloud_valider:VTS_boutons
		{ 
				idc = 10058;
				x = 0.915;
				y = 0.815;
				w = 0.03;
				h = 0.015;
			text = "ok"; 
			action = "[1] execVM ""computer\boutons\cloud_action.sqf"";";
			tooltip = "Apply selected rain settings";
		};
		// bouton pluie
		
		class pluie_centre:VTS_boutons
		{ 
				idc = 10028;
				x = 0.87;
				y = 0.835;
				w = 0.025;
				h = 0.015;
			text = "pluie"; 
			tooltip = "Modify rain from 0 - none to 10 - storm (Rain need an overcast of 5 minimum to fall)";
		};
		
		class pluie_gauche:VTS_boutons
		{ 
				idc = 10029;
				x = 0.82;
				y = 0.835;
				w = 0.049;
				h = 0.015;
			text = "Rain <"; 
			action = "valid_pluie = valid_pluie-1 ; [0] execVM ""computer\boutons\pluie_action.sqf"";";
			tooltip = "Modify rain from 0 - none to 10 - storm (Rain need an overcast of 5 minimum to fall)";
		};
		
		class pluie_droite:VTS_boutons
		{ 
				idc = 10030;
				x = 0.895;
				y = 0.835;
				w = 0.02;
				h = 0.015;
			text = ">"; 
			action = "valid_pluie = valid_pluie+1 ; [0] execVM ""computer\boutons\pluie_action.sqf"";";
			tooltip = "Modify rain from 0 - none to 10 - storm (Rain need an overcast of 5 minimum to fall)";
		};
		
		class pluie_valider:VTS_boutons
		{ 
				idc = 10031;
				x = 0.915;
				y = 0.835;
				w = 0.03;
				h = 0.015;
			text = "ok"; 
			action = "[1] execVM ""computer\boutons\pluie_action.sqf"";";
			tooltip = "Apply selected rain settings";
		};
		// Fog altitude
		class brume_altitude:VTS_RscSlider
		{ 	

		  type = 3;
		  style = 1024;
				idc = 10234;
				x = 0.825;
				y = 0.755;
				w = 0.12;
				h = 0.015;
		  color[] = { 1, 1, 1, 1 };
		  coloractive[] = { 1, 1, 1, 1.0 };
		  sizeEx = 0.025;
		  // This is an ctrlEventHandler to show you some response if you move the sliderpointer. 
		  onSliderPosChanged = "[_this] execVM ""computer\console\boutons\console_valid_brume_altitude.sqf"";";
		  tooltip = "Select the altitude of the fog (0 = no altitude)";			
		};
		// Fog altitude
		class brume_density:VTS_RscSlider
		{ 	

		  type = 3;
		  style = 1024;
				idc = 10235;
				x = 0.825;
				y = 0.775;
				w = 0.12;
				h = 0.015;
		  color[] = { 1, 1, 1, 1 };
		  coloractive[] = { 1, 1, 1, 1.0 };
		  sizeEx = 0.025;
		  // This is an ctrlEventHandler to show you some response if you move the sliderpointer. 
		  onSliderPosChanged = "[_this] execVM ""computer\console\boutons\console_valid_brume_density.sqf"";";
		  tooltip = "Select the density of the fog from 0 - none to 10 - london";			
		};		
		// bouton brume
		
		
		class brume_text:VTS_RscText
		{ 
				idc = 10033;
				x = 0.815;
				y = 0.795;
				w = 0.098;
				h = 0.015;
			text = "Fog"; 
			tooltip = "Currently selected fog parameters (D=Density A=Altitude)";
			style = ST_LEFT;
			colorText[] = {0.9,0.9,0.9, 1};
			colorBackground[] = {0, 0, 0, 0};
			font = LucidaConsoleB;
			sizeEx = 0.018;			
		};
		

		
		class brume_valider:VTS_boutons
		{ 
				idc = 10035;
				x = 0.915;
				y = 0.795;
				w = 0.03;
				h = 0.015;
			text = "ok"; 
			action = "[1] execVM ""computer\boutons\brume_action.sqf"";";
			tooltip = "Apply selected fog parameters";
		};
		
		// bouton heure
		
		class heure_centre:VTS_boutons
		{ 
				idc = 10036;
				x = 0.87;
				y = 0.875;
				w = 0.025;
				h = 0.015;
			text = "heure"; 
			tooltip = "Set hour of the day from 00 to 24";
		};
		
		class heure_gauche:VTS_boutons
		{ 
				idc = 10037;
				x = 0.82;
				y = 0.875;
				w = 0.049;
				h = 0.015;
			text = "Time <"; 
			action = "valid_heure = valid_heure-1 ; [0] execVM ""computer\boutons\heure_action.sqf"";";
			tooltip = "Set hour of the day from 00 to 24";
		};
		
		class heure_droite:VTS_boutons
		{ 
				idc = 10038;
				x = 0.895;
				y = 0.875;
				w = 0.02;
				h = 0.015;
			text = ">"; 
			action = "valid_heure = valid_heure+1 ; [0] execVM ""computer\boutons\heure_action.sqf"";";
			tooltip = "Set hour of the day from 00 to 24";
		};
		
		class heure_valider:VTS_boutons
		{ 
				idc = 10039;
				x = 0.915;
				y = 0.875;
				w = 0.03;
				h = 0.015;
			text = "ok"; 
			action = "[1] execVM ""computer\boutons\heure_action.sqf"";";
			tooltip = "Apply selected hour of the day";
		};

		// bouton Wind
		
		class wind_centre:VTS_boutons
		{ 
				idc = 10136;
				x = 0.87;
				y = 0.855;
				w = 0.025;
				h = 0.015;
			text = "wind"; 
			tooltip = "Set the wind strength from 0 to 10";
		};
		
		class wind_gauche:VTS_boutons
		{ 
				idc = 10137;
				x = 0.82;
				y = 0.855;
				w = 0.049;
				h = 0.015;
			text = "Wind <"; 
			action = "valid_wind = valid_wind-1 ; [0] execVM ""computer\boutons\wind_action.sqf"";";
			tooltip = "Set the wind strength from 0 to 10";
		};
		
		class wind_droite:VTS_boutons
		{ 
				idc = 10138;
				x = 0.895;
				y = 0.855;
				w = 0.02;
				h = 0.015;
			text = ">"; 
			action = "valid_wind = valid_wind+1 ; [0] execVM ""computer\boutons\wind_action.sqf"";";
			tooltip = "Set the wind strength from 0 to 10";
		};
		
		class wind_valider:VTS_boutons
		{ 
				idc = 10139;
				x = 0.915;
				y = 0.855;
				w = 0.03;
				h = 0.015;
			text = "ok"; 
			action = "[1] execVM ""computer\boutons\wind_action.sqf"";";
			tooltip = "Apply selected wind strength";
		};
		
    class arty_select_combo:VTS_combo
    {
    idc = 10041;
    x = 0.500;
    y = 0.865; 
    w = 0.15;
    h = 0.020;
    text = "Artilley";
	colorDisabled[] =  {0.9,0.9,0.9, 1};
    onLBSelChanged = "[0] execVM ""computer\console\boutons\console_valid_arty.sqf"";";
    tooltip = "Select the artillery you wich to use";          
    };


		class artyr_valider:VTS_boutons
		{ 
			idc = 10043; 
			x = 0.650; 
			y = 0.865; 
			w = 0.03; 
			h = 0.020; 
			text = "ok"; 
			action = "[1] execVM ""computer\console\console_artillery.sqf"";";
			tooltip = "Launch Artillery with the specified radius, on the map";
		};
		
		
		class arty_text:VTS_RscText
		{
		idc=10049; x=0.49; y=0.845; w=0.20; h=0.02;	
		style = ST_LEFT;
		colorText[] = {0.9,0.9,0.9, 1};
		text = "Artillery";
		font = LucidaConsoleB;
		colorBackground[] = {0, 0, 0, 0};
		sizeEx = 0.018;

		};

    class ammunition_select_combo:VTS_combo
    {
    idc = 10918;
    x = 0.500;
    y = 0.910; 
    w = 0.15;
    h = 0.020;
    text = "Ammunition";
	colorDisabled[] =  {0.9,0.9,0.9, 1};
    onLBSelChanged = "[0] execVM ""computer\console\boutons\console_valid_ammunition.sqf"";";
    tooltip = "Select the ammunition to spawn";          
    };


	class ammunition_valider:VTS_boutons
	{ 
		idc = 10919; 
		x = 0.650; 
		y = 0.910; 
		w = 0.03; 
		h = 0.020; 
		text = "ok"; 
		action = "[1] execVM ""computer\console\console_ammunition.sqf"";";
		tooltip = "Spawn ammunitions with the specified radius on the map";
	};
		
		
	class ammunition_text:VTS_RscText
	{
	idc=10920; x=0.49; y=0.89; w=0.20; h=0.02;
	style = ST_LEFT;
	colorText[] = {0.9,0.9,0.9, 1};
	text = "Ammunition spawn";
	font = LucidaConsoleB;
	colorBackground[] = {0, 0, 0, 0};
	sizeEx = 0.018;

	};
     		
		class destroyterrain:VTS_boutons
		{ 
				idc = 10044;
				x = 0.305;
				y = 0.57;
				w = 0.18;
				h = 0.015;
			text = "Destroy buildings"; 
			action = "[] execVM ""computer\console\console_destroyterrain.sqf"";";
			tooltip = "It destroy all buildings and natural objects inside the radius";
		};
		class killunits:VTS_boutons
		{ 
				idc = 10045;
				x = 0.305;
				y = 0.54;
				w = 0.18;
				h = 0.015;
			text = "Kill everything"; 
			action = "[] execVM ""computer\console\console_killunits.sqf"";";
			tooltip = "It kill all units and vehicles inside the radius, except players";
		};		
		class cleanworldtxt:VTS_RscText
		{
				idc = 10950;
				x = 0.1;
				y = 0.685;
				w = 0.3;
				h = 0.02;
		style = ST_LEFT;
		colorText[] = {0.9,0.9,0.9, 1};
		text = "Clean world from ---";
		font = LucidaConsoleB;
		colorBackground[] = {0, 0, 0, 0};
		sizeEx = 0.018;

		};
		class cleanworldcorpse:VTS_boutons
		{ 
				idc = 10951;
				x = 0.355;
				y = 0.685;
				w = 0.065;
				h = 0.015;
		text = "Corpses"; 
		action = "[""bodies""] spawn vts_cleanworld;";
		tooltip="Clean the world from all corpses";
		};
		class cleanworlditems:VTS_boutons
		{ 
				idc = 10952;
				x = 0.3;
				y = 0.685;
				w = 0.05;
				h = 0.015;
		text = "Items"; 
		action = "[""items""] spawn vts_cleanworld;";
		tooltip="Clean the world from all Items";
		};		
		class cleanworldwrecks:VTS_boutons
		{ 
				idc = 10953;
				x = 0.425;
				y = 0.685;
				w = 0.06;
				h = 0.015;
		text = "Wrecks"; 
		action = "[""wrecks""] spawn vts_cleanworld;";
		tooltip="Clean the world from all wrecks";
		};		
		class randomizeweaponbutton:VTS_boutons
		{ 
				idc = 10917;
				x = 0.395;
				y = 0.51;
				w = 0.09;
				h = 0.015;
		text = "Weap."; 
		action = "[] execVM ""computer\console\console_randomizeweapon.sqf"";";
		tooltip="Randomize the primary weapon of the currently selected side";
		};		


		class vtsweaponselection:VTS_combo
		{ 
				idc = 10921;
				x = 0.28;
				y = 0.51;
				w = 0.11;
				h = 0.015;
		text = ""; 
		onLBSelChanged = "[0] execVM ""computer\console\boutons\console_valid_weaponchange.sqf"";";
		tooltip="Select the primary weapon to equip the currently selected side in the radius";
		};		

		class vtsdeletedeadsbutton:VTS_boutons
		{ 
				idc = 10923;
				x = 0.335;
				y = 0.6;
				w = 0.15;
				h = 0.015;
		text = "Remove deads"; 
		action = "[true] execVM ""computer\console\console_delete.sqf"";";
		tooltip="Remove the deads units & vehicles";
		};		

		
		class vtsfilter:VTS_RscEdit
		{ 
				idc = 10046;
				x = 0.3;
				y = 0.07;
				w = 0.14;
				h = 0.02;
			style = ST_RIGHT; 

			text = ""; 
		  colorText[] = {0.9,0.9,0.9, 1};
		  colorSelection[] = {0.5, 0.5, 0.5, 1};
			colorDisabled[] =  {0.9,0.9,0.9, 1};		  
			tooltip = "Current filter for object listing (Shortcut: Enter to apply the filter)";
			onKeyDown="if ((_this select 1)==28  or (_this select 1)==156 ) then {sideobjectfilter=ctrlText 10046;[] call vts_updatenamefilter;};";
			
		};				

		class vtsfilter_button:VTS_boutons
		{ 
				idc = 10047;
				x = 0.445;
				y = 0.07;
				w = 0.045;
				h = 0.02;
			text = "Set"; 
			action = "sideobjectfilter=[(ctrlText 10046)] call vts_cleanspacefromstring;[] call vts_updatenamefilter;";
			tooltip = "Apply the filter for object listing";
		};

		class vtsfilter_txt:VTS_RscText
		{
				idc = 10048;
				x = 0.220;
				y = 0.068;
				w = 0.095;
				h = 0.02;
		style = ST_LEFT;
		colorText[] = {0.9,0.9,0.9, 1};
		text = "Filter :";
		font = LucidaConsoleB;
		colorBackground[] = {0, 0, 0, 0};
		sizeEx = 0.018;		
		tooltip = "Current filter applied on object listing";
		};	

		class menubas1:VTS_boutons
		{ 
			idc = 10053; 
			x = 0.100; 
			y = 0.880; 
			w = 0.12; 
			h = 0.030; 
			text = "Exit"; 
			action = "[] call Dlg_StoreParams;closeDialog 0;";
			tooltip = "Close the GM interface";
		};
		class menubas2backgm:VTS_boutons
		{ 
				idc = 19000;
				x = 0.23;
				y = 0.925;
				w = 0.12;
				h = 0.03;
			text = "Back to GM"; 
			action = "[player,""null"",""null""] execVM ""computer\console\takecontrolback.sqf"";";
			tooltip = "Get back in your GM avatar shoes";
		};		
		class menubasaar:VTS_boutons
		{ 
				idc = 10054;
				x = 0.35;
				y = 0.88;
				w = 0.12;
				h = 0.03;
			text = "Open AAR"; 
			action = "[] call vts_aar_open;";
			tooltip = "Open the After Action Report tool";
		};


    class unit_object_music_combo:VTS_combo
    {
				idc = 10605;
				x = 0.658824;
				y = 0.816546;
				w = 0.11;
				h = 0.02;
    text = "Music";
	colorDisabled[] =  {0.9,0.9,0.9, 1};
    onLBSelChanged = "[0] execVM ""computer\console\boutons\console_valid_music.sqf"";";
    tooltip = "Launch the selected music in the mission only for the master, use ""Play"" to not interupt the current play";          
    };
    
	class unit_object_music_all:VTS_boutons
	{ 
				idc = 10607;
				x = 0.768824;
				y = 0.816546;
				w = 0.04;
				h = 0.02;
		text = "All"; 
		action = "[] call vts_playmusicall";
		tooltip = "Broadcast the selected music to ALL players";    
    };

    class unit_vts_painter_colors_combo:VTS_combo
    {
				idc = 10710;
				x = 0.658824;
				y = 0.759;
				w = 0.105;
				h = 0.02;
    text = "Colors";
	colorDisabled[] =  {0.9,0.9,0.9, 1};
    onLBSelChanged = "[0] execVM ""computer\console\boutons\console_valid_painter_color.sqf"";";        
    tooltip = "Change the brush used to paint the map";  
    };	
	
		class unit_vts_painter_ok:VTS_boutons
	{ 
				idc = 10711;
				x = 0.763824;
				y = 0.759;
				w = 0.045;
				h = 0.02;
		text = "Paint"; 
		action = "[] execvm ""computer\console\console_paintarea.sqf"";";
		tooltip = "Paint the map with the selected brush for all players";    
    };
    
    class unit_object_colors_combo:VTS_combo
    {
				idc = 10705;
				x = 0.658824;
				y = 0.791546;
				w = 0.11;
				h = 0.02;
    text = "Colors";
	colorDisabled[] =  {0.9,0.9,0.9, 1};
    onLBSelChanged = "[0] execVM ""computer\console\boutons\console_valid_colors.sqf"";";        
    tooltip = "Change the ambient colors";  
    };
    class unit_object_colors_all:VTS_boutons
    {
				idc = 10706;
				x = 0.768824;
				y = 0.791546;
				w = 0.04;
				h = 0.02;
    text = "All";
	colorDisabled[] =  {0.9,0.9,0.9, 1};
    action = "[2] execVM ""computer\console\boutons\console_valid_colors.sqf"";";        
    tooltip = "Broadcast the selected colors to ALL players";  
    };	

		class camp_combo:VTS_combo
		{ 
				idc = 10203;
				x = 0.1;
				y = 0.1;
				w = 0.115;
				h = 0.03;
			text = "unit camp"; 
			colorDisabled[] =  {0.9,0.9,0.9, 1};
			onLBSelChanged = "boutoncamp=[0] execVM ""computer\console\boutons\console_valid_camp.sqf"";";
			tooltip = "Select the faction";
		};
		
		class side_combo:VTS_combo
		{ 
				idc = 10206;
				x = 0.1;
				y = 0.065;
				w = 0.115;
				h = 0.03;
			text = "unit side"; 
			colorDisabled[] =  {0.9,0.9,0.9, 1};
			onLBSelChanged = "boutonside=[0] execVM ""computer\console\boutons\console_valid_side.sqf"";";
			tooltip = "Select the side";
		};
	
	
		
		// ----------------------- Unités et objets =  ligne 1 type
		class type_combo:VTS_combo
		{ 
				idc = 10305;
				x = 0.22;
				y = 0.1;
				w = 0.075;
				h = 0.03;
			text = "unit Type"; 
			colorDisabled[] =  {0.9,0.9,0.9, 1};
			onLBSelChanged = "boutontype=[0] execVM ""computer\console\boutons\console_valid_type.sqf"";";
			tooltip = "Select the type of your spawn";
		};
		// ----------------------- Unités et objets =  ligne 1 unite
		
		class formation_combo:VTS_combo
		{ 
				idc = 10307;
				x = 0.365;
				y = 0.185;
				w = 0.125;
				h = 0.015;
			text = "formation"; 
			colorDisabled[] =  {0.9,0.9,0.9, 1};
			onLBSelChanged = "[0] execVM ""computer\console\boutons\console_valid_formation.sqf"";";
			tooltip = "Select the formation for the next order";
		};
		
		
		class unit_combo:VTS_combo
		{ 
				idc = 10306;
				x = 0.3;
				y = 0.1;
				w = 0.19;
				h = 0.03;
			text = "unit"; 
			colorDisabled[] =  {0.9,0.9,0.9, 1};
			onLBSelChanged = "boutonunit=[0] execVM ""computer\console\boutons\console_valid_unite.sqf"";";
			tooltip = "Object to spawn";
		};		
		


		// ----------------------- Unités et objets =  ligne 2 attitude
		
		class unit_object_attitude1:VTS_combo
		{ 
				idc = 10211;
				x = 0.11;
				y = 0.16;
				w = 0.09;
				h = 0.015;
			text = "Safe"; 
			onLBSelChanged = "[0] execVM ""computer\console\boutons\console_valid_attitude.sqf"";";
			tooltip = "Select spawning object behaviour";
		};
		

		
		// ----------------------- Unités et objets =  ligne 2 vitesse
		
		class unit_object_vitesse1:VTS_combo
		{ 
				idc = 10214;
				x = 0.21;
				y = 0.16;
				w = 0.09;
				h = 0.015;
			text = "Limited"; 
			onLBSelChanged = "[0] execVM ""computer\console\boutons\console_valid_vitesse.sqf"";";
			tooltip = "Select motion speed of your spawning object";
		};
		

		
		// ----------------------- Unités et objets =  ligne 2 mouvement
		class unit_object_mouvement_combo:VTS_combo
		{ 
				idc = 10218;
				x = 0.31;
				y = 0.16;
				w = 0.18;
				h = 0.015;
			text = "mouvement"; 
			colorDisabled[] =  {0.9,0.9,0.9, 1};
			onLBSelChanged = "[0] execVM ""computer\console\boutons\console_valid_mouvement.sqf"";";
			tooltip = "Select movement order of your spawning object";
		};

		// ----------------------- Unités et objets =  ligne 1 type
		class Env_Sfx_combo:VTS_combo
		{ 
			idc = 10609;
				x = 0.725;
				y = 0.1;
				w = 0.095;
				h = 0.016;
			text = "Audio Env."; 
			colorDisabled[] =  {0.9,0.9,0.9, 1};
			onLBSelChanged = "[0] execVM ""computer\console\boutons\console_valid_audio_env.sqf"";";
			tooltip = "Select the audio environment to place";
		};

		class Place_Env_Sfx:VTS_boutons
		{ 
			idc = 10604; 
				x = 0.82;
				y = 0.1;
				w = 0.05;
				h = 0.015;
			text = "Place"; 
			action = "breakclic = 1;[] execVM ""computer\console\console_audio_env.sqf"";";
			tooltip = "Place the selected environment effect on the map";
		};		
		
		class DiceRoll:VTS_combo
		{ 
			idc = 10611; 
				x = 0.612625;
				y = 0.1;
				w = 0.1;
				h = 0.015;
			text = "";
			onLBSelChanged = "[0] execVM ""computer\console\boutons\console_valid_dice.sqf"";";
			tooltip = "Roll a dice, only you can see it";
		};
	
	
		class Minimaphelp:VTS_boutons
		{ 
			idc = 10630; 
			x = 0.875; 
			y = 0.1; 
			w = 0.075; 
			h = 0.015; 
			text = "Help"; 
			action = "[] spawn vts_minimaphelp;";
			tooltip = "Display minimap help";
			style = ST_CENTER; 	
		};
		class vts_serverfps_info:VTS_RscText
		{ 
			idc = 10624; 
			style = ST_LEFT; 			
				x = 0.96;
				y = 0.045;
				w = 0.1;
				h = 0.015;
			sizeEx = 0.018;
			text = "Server FPS: ";
			colorText[] = {0.9,0.9,0.9, 1};
			tooltip = "Information about the server performance, below 15 fps is critical";
		};

		class vts_HeadlessClientfps_info:VTS_RscText
		{ 
			idc = 10636; 
			style = ST_LEFT; 			
				x = 1.06;
				y = 0.045;
				w = 0.08;
				h = 0.015;
			sizeEx = 0.018;
			text = "HC FPS: ";
			colorText[] = {0.9,0.9,0.9, 1};
			tooltip = "Information about the HC performance, below 15 fps is critical";
		};		
		
		class vts_maxteam_info:VTS_RscText
		{ 
			idc = 10625; 
			style = ST_CENTER; 			
			x = 0.96; 
			y = 0.915;
			w = 0.05;
			h = 0.015;
			sizeEx = 0.020;
			text = "Groups:";
			colorText[] = {0.9,0.9,0.9, 1};
			tooltip = "Engine limitation : 144 groups maximum per side";
		
		};
		class vts_maxteam_infoB:VTS_RscText
		{ 
			idc = 10626; 
			style = ST_CENTER; 			
			x = 1.01; 
			y = 0.915;
			w = 0.0325;
			h = 0.015;
			sizeEx = 0.020;
			text = "0";
			colorText[] = {0.9,0.9,0.9, 1};
			tooltip = "Bluefor groups : 144 maximum (engine limit)";
		
		};	
		class vts_maxteam_infoR:VTS_RscText
		{ 
			idc = 10627; 
			style = ST_CENTER; 			
			x = 1.0425; 
			y = 0.915;
			w = 0.0325;
			h = 0.015;
			sizeEx = 0.020;
			text = "0";
			colorText[] = {0.9,0.9,0.9, 1};
			tooltip = "Opfor groups : 144 maximum (engine limit)";
		
		};	
		class vts_maxteam_infoG:VTS_RscText
		{ 
			idc = 10628; 
			style = ST_CENTER; 			
			x = 1.075; 
			y = 0.915;
			w = 0.0325;
			h = 0.015;
			sizeEx = 0.020;
			text = "0";
			colorText[] = {0.9,0.9,0.9, 1};
			tooltip = "Resistance groups : 144 maximum (engine limit)";
		
		};		
		class vts_maxteam_infoC:VTS_RscText
		{ 
			idc = 10629; 
			style = ST_CENTER; 			
			x = 1.1075; 
			y = 0.915;
			w = 0.0325;
			h = 0.015;
			sizeEx = 0.020;
			text = "0";
			colorText[] = {0.9,0.9,0.9, 1};
			tooltip = "Civilian groups : 144 maximum (engine limit)";
		
		};			
		

		class vts_maxunit_info:VTS_RscText
		{ 
			idc = 10631; 
			style = ST_CENTER; 			
			x = 0.96; 
			y = 0.935;
			w = 0.05;
			h = 0.015;
			sizeEx = 0.020;
			text = "Units:";
			colorText[] = {0.9,0.9,0.9, 1};
			tooltip = "Number of units per side";
		
		};
		class vts_maxunit_infoB:VTS_RscText
		{ 
			idc = 10632; 
			style = ST_CENTER; 			
			x = 1.01; 
			y = 0.935;
			w = 0.0325;
			h = 0.015;
			sizeEx = 0.020;
			text = "0";
			colorText[] = {0.9,0.9,0.9, 1};
			tooltip = "Bluefor units";
		
		};	
		class vts_maxunit_infoR:VTS_RscText
		{ 
			idc = 10633; 
			style = ST_CENTER; 			
			x = 1.0425; 
			y = 0.935;
			w = 0.0325;
			h = 0.015;
			sizeEx = 0.020;
			text = "0";
			colorText[] = {0.9,0.9,0.9, 1};
			tooltip = "Opfor units";
		
		};	
		class vts_maxunit_infoG:VTS_RscText
		{ 
			idc = 10634; 
			style = ST_CENTER; 			
			x = 1.075; 
			y = 0.935;
			w = 0.0325;
			h = 0.015;
			sizeEx = 0.020;
			text = "0";
			colorText[] = {0.9,0.9,0.9, 1};
			tooltip = "Resistance units";
		
		};		
		class vts_maxunit_infoC:VTS_RscText
		{ 
			idc = 10635; 
			style = ST_CENTER; 			
			x = 1.1075; 
			y = 0.935;
			w = 0.0325;
			h = 0.015;
			sizeEx = 0.020;
			text = "0";
			colorText[] = {0.9,0.9,0.9, 1};
			tooltip = "Civilian units";
		
		};				
		//class vts_object_info:VTS_RscText
		class vts_object_info:VTS_RscStructuredText
		{ 

			idc = 10623; 
			style = ST_LEFT + ST_MULTI; 			
			x = 0.96; 
			//y = 0.12;
			y = 0.07;
			w = 0.18;
			//h = 0.63;
			h = 0.835;
			sizeEx = 0.020;
			size = 0.020;
			htmlControl = true;
			colorText[] = {0.9,0.9,0.9, 1};
			colorDisabled[] =  {0.9,0.9,0.9, 1};
			colorSelection[] = {0.5, 0.5, 0.5, 1};		
			ColorBackground[] = {1,1,1,0.2};		
			text = "------ No data ------"; 
			tooltip = "Information about the object under the cursor";
		};			
		// ----------------------- Unités et objets = moral texte
		
		class unit_object_moraltexte:VTS_RscText
		{
			idc=10220; x=0.1; y=0.185; w=0.3; h=0.02;		
			style = ST_LEFT;
			colorText[] = {0.9,0.9,0.9, 1};
			text = "Skill----- 0.3";
			font = LucidaConsoleB;
			colorBackground[] = {0, 0, 0, 0};
			sizeEx = 0.018;
		};
		
		// ----------------------- Unités et objets = orientation texte
		
		class unit_object_orientationtexte:VTS_RscText
		{
			idc=10221; x=0.1; y=0.205; w=0.3; h=0.02;
			style = ST_LEFT;
			colorText[] = {0.9,0.9,0.9, 1};
			text = "Direction----";
			font = LucidaConsoleB;
			colorBackground[] = {0, 0, 0, 0};
			sizeEx = 0.018;

		};
		
		// ----------------------- Unités et objets = Nom texte
		
		class unit_object_nomtexte:VTS_RscText
		{
				idc = 10222;
				x = 0.1;
				y = 0.225;
				w = 0.14;
				h = 0.02;
			style = ST_LEFT;
			colorText[] = {0.9,0.9,0.9, 1};
			text = "Variable Name--------";
			font = LucidaConsoleB;
			colorBackground[] = {0, 0, 0, 0};
			sizeEx = 0.018;

		};
		
		// ----------------------- Unités et objets = Init texte
		/*
		class unit_object_inittexte:VTS_RscText
		{
				idc = 10223;
				x = 0.1;
				y = 0.245;
				w = 0.11;
				h = 0.02;
			style = ST_LEFT;
			colorText[] = {0.9,0.9,0.9, 1};
			text = "Init---------";
			font = LucidaConsoleB;
			colorBackground[] = {0, 0, 0, 0};
			sizeEx = 0.018;

		};
		*/

		class unit_object_customgrouptext:VTS_RscText
		{
				idc = 10236;
				x = 0.1;
				y = 0.135;
				w = 0.15;
				h = 0.02;
			style = ST_LEFT;
			colorText[] = {0.9,0.9,0.9, 1};
			text = "Custom group --";
			font = LucidaConsoleB;
			colorBackground[] = {0, 0, 0, 0};
			sizeEx = 0.018;
			tooltip = "You can add any unit to one of these custom group";

		};

		class unit_object_customgroupcombo:VTS_combo
		{ 
				idc = 10237;
				x = 0.255;
				y = 0.135;
				w = 0.09;
				h = 0.015;
		text = ""; 
		colorDisabled[] =  {0.9,0.9,0.9, 1};
		onLBSelChanged = "[0] execVM ""computer\console\boutons\console_valid_customgroup.sqf"";"; 
		tooltip = "Select the custom group to modify";
		};		

			
		class unit_addobject_togroup:VTS_boutons
		{ 
				idc = 10308;
				x = 0.45;
				y = 0.135;
				w = 0.04;
				h = 0.015;
		text = "+";
		style = ST_CENTER;
		action = "[] call vts_gmaddobjecttocustomgroup;";
		tooltip = "Add the currently selected object to spawn to this custom group";
		};	
		
		class unit_removeobject_togroup:VTS_boutons
		{ 
				idc = 10309;
				x = 0.405;
				y = 0.135;
				w = 0.04;
				h = 0.015;
		text = "-";
		style = ST_CENTER;
		action = "[] call vts_gmremoveobjecttocustomgroup;";
		tooltip = "Remove the last item of this custom group";
		};	
		class unit_clearobject_togroup:VTS_boutons
		{ 
				idc = 10310;
				x = 0.35;
				y = 0.135;
				w = 0.045;
				h = 0.015;
		text = "Reset";
		action = "[] call vts_gmclearcustomgroup;";
		tooltip = "Reset this custom group";
		};			
		// ----------------------- Unités et objets = valid texte
		
		class unit_object_validtexte:VTS_RscText
		{
			idc=10224; x=0.1; y=0.270; w=0.1; h=0.02;
			style = ST_LEFT;
			colorText[] = {0.9,0.9,0.9, 1};
			text = "Spawn-";
			font = LucidaConsoleB;
			colorBackground[] = {0, 0, 0, 0};
			sizeEx = 0.018;

		};
		
		// ----------------------- Unités et objets =  ligne 3 moral
			class unit_object_moral_slider:VTS_RscSlider
		{ 
				idc = 10225;
				x = 0.245;
				y = 0.185;
				w = 0.1;
				h = 0.015;
			type = 3;
		  style = 1024;

		  color[] = { 1, 1, 1, 1 };
		  coloractive[] = { 1, 1, 1, 1.0 };
		  sizeEx = 0.025;
		  // This is an ctrlEventHandler to show you some response if you move the sliderpointer. 
		  onSliderPosChanged = "[_this] execVM ""computer\console\boutons\console_valid_moral.sqf"";";
		  tooltip = "Select the skill of your spawning object";
		};

		class Radius_Less:VTS_boutons
		{ 
				idc = 10227;
				x = 0.37;
				y = 0.205;
				w = 0.02;
				h = 0.015;
		text = "<"; 
		action = "radius=[0] call vts_radiuschange;hint format [""Patrols, delete, Fill interiors -> %1 Radius"",radius];[] call updateradiusbuttons;";
		tooltip = "Change the work radius value";
		};		
		class Radius_multiplied :VTS_boutons
		{ 
				idc = 10904;
				x = 0.39;
				y = 0.205;
				w = 0.095;
				h = 0.015;
		text = "change radius >"; 
		action = "radius=[1] call vts_radiuschange;hint format [""Patrols, delete, Fill interiors -> %1 Radius"",radius];[] call updateradiusbuttons;";
		tooltip = "Change the work brush radius value";
		};
		
		// ----------------------- Unités et objets =  ligne 4 orientation
		
		class unit_object_orientation1:VTS_boutons
		{ 
				idc = 10228;
				x = 0.25;
				y = 0.205;
				w = 0.02;
				h = 0.015;
		text = "<"; 
		action = "console_valid_orientation = console_valid_orientation-1 ; [0] execVM ""computer\console\boutons\console_valid_orientation.sqf"";";
		tooltip = "Select direction of the spawning object";
		};
		
		class unit_object_orientation2:VTS_boutons
		{ 
				idc = 10229;
				x = 0.265;
				y = 0.205;
				w = 0.05;
				h = 0.015;
		text = "orient"; 
		tooltip = "Select direction of the spawning object";
		};
		
		class unit_object_orientation3:VTS_boutons
		{ 
				idc = 10230;
				x = 0.315;
				y = 0.205;
				w = 0.02;
				h = 0.015;
		text = ">"; 
		action = "console_valid_orientation = console_valid_orientation+1 ; [0] execVM ""computer\console\boutons\console_valid_orientation.sqf"";";
		tooltip = "Select direction of the spawning object";
		};

    //------------------------- Mise à jour des ordres d'une unité déja existante
    
    class unit_neworders:VTS_boutons
		{ 
		idc = 10903; 
		x = 0.330; 
		y = 0.273; 
		w = 0.160; 
		h = 0.015; 
		text = "Reassign orders"; 
		action = "breakclic = 1; [] execVM ""Computer\console\console_applyordersonmap.sqf"";";
		tooltip = "Reassign the selected movement order, formation, speed and behaviour to a spawned group";
		};
		
		// ----------------------- Unités et objets =  ligne 5 nom
		
		class unit_object_nom : VTS_RscEdit
		{
				idc = 10231;
				x = 0.245;
				y = 0.223;
				w = 0.245;
				h = 0.02;
		colorText[] = {0.9,0.9,0.9, 1};
		colorDisabled[] =  {0.9,0.9,0.9, 1};
		colorSelection[] = {0.5, 0.5, 0.5, 1};
		tooltip = "Object varname that can be then used after spawn to manipulate it through the command line";
		};
		
		// ----------------------- Unités et objets =  ligne 6 init
		
		class unit_object_init : VTS_RscEdit
		{
				idc = 10232;
				x = 0.245;
				y = 0.245;
				w = 0.245;
				h = 0.02;
		colorText[] = {0.9,0.9,0.9, 1};
		colorDisabled[] =  {0.9,0.9,0.9, 1};
		colorSelection[] = {0.5, 0.5, 0.5, 1};
		autocomplete="scripting";
		tooltip = "Script commands executed on the object at spawn";
		};

	   class unit_object_init_pre_line_combo:VTS_combo
		{
				idc = 10608;
				x = 0.105;
				y = 0.245;
				w = 0.135;
				h = 0.02;
		text = "";
		colorDisabled[] =  {0.9,0.9,0.9, 1};
		onLBSelChanged = "[0] execVM ""computer\console\boutons\console_valid_pre_init_line.sqf"";"; 
		tooltip = "Special scripts to apply on the spawns";      
		onLBListSelChanged = "player sidechat ""test"";";
		};
		
		// ----------------------- Unités et objets =  ligne 5 valid
		
		class unit_object_valid1:VTS_boutons
		{ 
		idc = 10233; 
		x = 0.160; 
		y = 0.273; 
		w = 0.030; 
		h = 0.015; 
		colorText[] = { 0.2,1,0.2, 1 };
		text = "2D"; 
		action = "breakclic = 1;[false] execVM ""computer\console\console_map.sqf"";";
		tooltip = "Spawn an object at a position by clicking on the map";
		};
		
		
		class unit_object_3D:VTS_boutons
		{ 
		idc = 10210; 
		x = 0.195; 
		y = 0.273; 
		w = 0.030; 
		h = 0.015; 
		text = "3D";
		colorText[] = { 1.0,0.5,0.5, 1 };
		action = "if (true) then {breakclic = 1;[] call Dlg_StoreParams;console_valid_mouvement = 0;nom_console_valid_mouvement = ""None"";var_console_valid_mouvement = """";[] execVM ""Computer\Start_PlaceCam.sqf"";} else {hint ""3D Cam desactivated in vehicles"";}";
		tooltip = "Spawn an object via a 3D view after a click on the map";
		};

				
		class unit_object_valid1random:VTS_boutons
		{ 
		idc = 10250; 
		x = 0.230; 
		y = 0.273; 
		w = 0.035; 
		h = 0.015; 
		colorText[] = { 0.5,0.5,1.0, 1 };
		text = "R2D"; 
		action = "breakclic = 1;[true] execVM ""computer\console\console_map.sqf"";";
		tooltip = "Spawn an object on a random position (inside the brush) by clicking on the map";
		};
		
		class unit_object_3Dmove:VTS_boutons
		{ 
		
		idc = 19001;
		x = 0.36;
		y = 0.32;
		w = 0.12;
		h = 0.015;
		text = "3D Displacement";
		//action = "if ((var_console_valid_type == ""Statique"") or (var_console_valid_type == ""Groupe"")) then {} else {Typesave=lbCurSel 10305;Unitsave=lbCurSel 10306;console_valid_mouvement = 0;nom_console_valid_mouvement = ""None"";var_console_valid_mouvement = """";[] execVM ""NORRN_spectate\start3d.sqf""};";
		action = "if (true) then {breakclic = 1;[] call Dlg_StoreParams;console_valid_mouvement = 0;nom_console_valid_mouvement = ""None"";var_console_valid_mouvement = """";[] execVM ""Computer\Start_3Dmove.sqf"";} else {hint ""3D Cam desactivated in vehicles"";}";
		tooltip = "Displace an object after a click on the map";
		};
			
		class unit_object_preview:VTS_boutons
		{ 
		idc = 10399; 
		x = 0.270; 
		y = 0.273; 
		w = 0.055; 
		h = 0.015; 
		text = "Preview";
		//action = "if ((var_console_valid_type == ""Statique"") or (var_console_valid_type == ""Groupe"")) then {} else {Typesave=lbCurSel 10305;Unitsave=lbCurSel 10306;Mouvsave=lbCurSel 10218;closeDialog 0;[] execVM ""computer\console\preview.sqf""};";
		action = "if (true) then {[] call Dlg_StoreParams;closeDialog 0;[] execVM ""computer\console\preview.sqf""} else {hint ""3D Cam desactivated in vehicles"";};";
		tooltip = "Preview the selected object to spawn";
		};
		//action = "Typesave=lbCurSel 10305;Unitsave=lbCurSel 10306;Mouvsave=lbCurSel 10218;closeDialog 0;[] execVM ""computer\console\preview.sqf"";";
		
		// delete_valid




		

		
		class deletebig_valid:VTS_boutons
		{ 
				idc = 10400;
				x = 0.17;
				y = 0.298;
				w = 0.075;
				h = 0.015;
		text = "Del(500m)";
		action = "breakclic = 1; [false] execVM ""Computer\console\console_delete.sqf"";";
		tooltip = "Delete units, vehicles and tasks in the specified radius";
		};
		
		class clone_valid:VTS_boutons
		{ 
				idc = 10391;
				x = 0.252;
				y = 0.298;
				w = 0.045;
				h = 0.015;
		text = "Clone";
		action = "breakclic = 1; [50] execVM ""Computer\console\console_clone.sqf"";";
		tooltip = "Make a copy of a group";
		};
		
		class Join_valid:VTS_boutons
		{ 
				idc = 10392;
				x = 0.3;
				y = 0.298;
				w = 0.035;
				h = 0.015;
		text = "Join";
		action = "breakclic = 1; [] execVM ""Computer\console\console_join.sqf"";";
		tooltip = "Merge a group with another group";
		};

		class Property_valid:VTS_boutons
		{ 
				idc = 10396;
				x = 0.34;
				y = 0.298;
				w = 0.05;
				h = 0.015;
		text = "Params.";
		action = "breakclic = 1; [] execVM ""Computer\console\console_properties.sqf"";";
		tooltip = "Change the properties of a selected unit (Shortcut : Ctrl + 2xClick on a unit of the Minimap)";
		};
		
		class Take_valid:VTS_boutons
		{ 
				idc = 10395;
				x = 0.395;
				y = 0.298;
				w = 0.095;
				h = 0.015;
		text = "Take Control";
		action = "if (hcShownBar) then {hcShowBar false};breakclic = 1; [] execVM ""Computer\console\takecontrol.sqf"";";
		tooltip = "As GM take control of an AI";
		};
		

		
		
		
		// téléportation d'un joueur solo
		
		class joueursolo_telep_titre:VTS_RscText
		{
		idc = 10294;
		x = 0.1;
		y = 0.345;
		w = 0.3;
		h = 0.02;
		style = ST_LEFT;
		colorText[] = {0.9,0.9,0.9, 1};
		text = "Teleport ---------";
		font = LucidaConsoleB;
		colorBackground[] = {0, 0, 0, 0};
		sizeEx = 0.018;

		};
	

		class joueursolo_telep_nom:VTS_combo
		{ 
				idc = 10297;
				x = 0.28;
				y = 0.345;
				w = 0.17;
				h = 0.015;
		text = "User"; 
		colorDisabled[] =  {0.9,0.9,0.9, 1};
		onLBSelChanged = "[0] execVM ""computer\console\boutons\joueur_tp.sqf"";"; 
		tooltip = "Select player to teleport";  
		};
	
		
		class joueursolo_telep_valid:VTS_boutons
		{ 
				idc = 10299;
				x = 0.455;
				y = 0.345;
				w = 0.025;
				h = 0.015;
		text = "TP"; 
		action = "[] execVM ""computer\console\teleport_user.sqf"";";
		tooltip = "Teleport selected player";
		};
		
		class joueur_gps_titre:VTS_RscText
		{
				idc = 10239;
				x = 0.1;
				y = 0.71;
				w = 0.3;
				h = 0.02;
		style = ST_LEFT;
		colorText[] = {0.9,0.9,0.9, 1};
		text = "Disable / Enable markers for GM --";
		font = LucidaConsoleB;
		colorBackground[] = {0, 0, 0, 0};
		sizeEx = 0.018;

		
		};

		class moveobjectin3d:VTS_RscText
		{
		idc = 19002;
		x = 0.1;
		y = 0.320;
		w = 0.25;
		h = 0.02;
		style = ST_LEFT;
		colorText[] = {0.9,0.9,0.9, 1};
		text = "Move an object around  ----";
		font = LucidaConsoleB;
		colorBackground[] = {0, 0, 0, 0};
		sizeEx = 0.018;

		};
		
		
		class camera_titre:VTS_RscText
		{
				idc = 10390;
				x = 0.1;
				y = 0.295;
				w = 0.075;
				h = 0.02;
		style = ST_LEFT;
		colorText[] = {0.9,0.9,0.9, 1};
		text = "Interact --";
		font = LucidaConsoleB;
		colorBackground[] = {0, 0, 0, 0};
		sizeEx = 0.018;

		};
		
		
    
		
		class addbat:VTS_RscText
		{
				idc = 10398;
				x = 0.1;
				y = 0.424;
				w = 0.21;
				h = 0.02;
		style = ST_LEFT;
		colorText[] = {0.9,0.9,0.9, 1};
		//text = "Put enemy in buildings (50M radius) ---";
		//text = "Fill interiors with current side (100M)";
		text = "Fill with cur. side";
		font = LucidaConsoleB;
		colorBackground[] = {0, 0, 0, 0};
		sizeEx = 0.018;

		};
		
		class convoi:VTS_RscText
		{
				idc = 10302;
				x = 0.1;
				y = 0.37;
				w = 0.3;
				h = 0.02;
		style = ST_LEFT;
		colorText[] = {0.9,0.9,0.9, 1};
		text = "Teleport a group and its vehicles ----";
		font = LucidaConsoleB;
		colorBackground[] = {0, 0, 0, 0};
		sizeEx = 0.018;

		};
    
		class changesideofagroup:VTS_RscText
		{
				idc = 10910;
				x = 0.1;
				y = 0.48;
				w = 0.3;
				h = 0.02;
		style = ST_LEFT;
		colorText[] = {0.9,0.9,0.9, 1};
		text = "Apply current side to a group ----";
		font = LucidaConsoleB;
		colorBackground[] = {0, 0, 0, 0};
		sizeEx = 0.018;

		};
		

		// changeside
		class applyside:VTS_boutons
		{ 
				idc = 10911;
				x = 0.395;
				y = 0.482;
				w = 0.09;
				h = 0.015;
		text = "Change side"; 
		action = "[] execVM ""computer\console\console_changeside.sqf"";";
		tooltip="Change the side of a group by the current selected side";
		};
		

		class populate:VTS_RscText
		{
				idc = 10900;
				x = 0.1;
				y = 0.45;
				w = 0.3;
				h = 0.02;
		style = ST_LEFT;
		colorText[] = {0.9,0.9,0.9, 1};
		text = "Populate with civilians";
		font = LucidaConsoleB;
		colorBackground[] = {0, 0, 0, 0};
		sizeEx = 0.018;

		};

		class destroybuildings:VTS_RscText
		{
				idc = 10912;
				x = 0.1;
				y = 0.57;
				w = 0.2;
				h = 0.02;
		style = ST_LEFT;
		colorText[] = {0.9,0.9,0.9, 1};
		text = "Destroy buildings ----";
		font = LucidaConsoleB;
		colorBackground[] = {0, 0, 0, 0};
		sizeEx = 0.018;

		};		

		class killeverythings:VTS_RscText
		{
				idc = 10913;
				x = 0.1;
				y = 0.54;
				w = 0.2;
				h = 0.02;
		style = ST_LEFT;
		colorText[] = {0.9,0.9,0.9, 1};
		text = "Kill units & vehicles -";
		font = LucidaConsoleB;
		colorBackground[] = {0, 0, 0, 0};
		sizeEx = 0.018;
	
		};	


		
		class randomizeprimaryweapon:VTS_RscText
		{
				idc = 10916;
				x = 0.1;
				y = 0.51;
				w = 0.18;
				h = 0.02;	
		style = ST_LEFT;
		colorText[] = {0.9,0.9,0.9, 1};
		text = "Equip cur. side with ";
		font = LucidaConsoleB;
		colorBackground[] = {0, 0, 0, 0};
		sizeEx = 0.018;

		};	

		class deletedeadvehicles:VTS_RscText
		{
				idc = 10922;
				x = 0.1;
				y = 0.595;
				w = 0.25;
				h = 0.02;
		style = ST_LEFT;
		colorText[] = {0.9,0.9,0.9, 1};
		text = "Delete dead entities ----";
		font = LucidaConsoleB;
		colorBackground[] = {0, 0, 0, 0};
		sizeEx = 0.018;
		};	
		
		class vtstimertext:VTS_RscText
		{
				idc = 10924;
				x = 0.1;
				y = 0.625;
				w = 0.225;
				h = 0.02;
		style = ST_LEFT;
		colorText[] = {0.9,0.9,0.9, 1};
		text = "Display timer ---";
		font = LucidaConsoleB;
		colorBackground[] = {0, 0, 0, 0};
		sizeEx = 0.018;
		};	
		
		class vtstimeredit : VTS_RscEdit
		{
				idc = 10925;
				x = 0.255;
				y = 0.625;
				w = 0.065;
				h = 0.02;
		text = "60";
		colorText[] = {0.9,0.9,0.9, 1};
		colorDisabled[] =  {0.9,0.9,0.9, 1};
		colorSelection[] = {0.5, 0.5, 0.5, 1};
		tooltip = "Enter the timer duration in seconds (Can use math operators, ex: 60*10) (Shortcut: Enter to run/update the timer)";
		onKeyDown="if ((_this select 1)==28  or (_this select 1)==156 ) then {[] spawn vts_timer_start;};";
		};		

		
		
		class vtstimerstart:VTS_boutons
		{ 
				idc = 10926;
				x = 0.325;
				y = 0.63;
				w = 0.05;
				h = 0.015;
		text = "Start"; 
		action = "[] spawn vts_timer_start;";
		tooltip="Start the timer on all players with the set seconds";
		};	

		class vtstimerpause:VTS_boutons
		{ 
				idc = 10927;
				x = 0.38;
				y = 0.63;
				w = 0.05;
				h = 0.015;
		text = "Freeze"; 
		action = "[] spawn vts_timer_pause;";
		tooltip="Pause/Resume the timer on all players in the current state";
		};
		class vtstimerstop:VTS_boutons
		{ 
				idc = 10928;
				x = 0.435;
				y = 0.63;
				w = 0.05;
				h = 0.015;
		text = "Stop"; 
		action = "[] spawn vts_timer_stop;";
		tooltip="Stop and close the timer on all players";
		};		

		class vtsshowtext:VTS_RscText
		{
				idc = 10930;
				x = 0.1;
				y = 0.655;
				w = 0.1;
				h = 0.02;
		style = ST_LEFT;
		colorText[] = {0.9,0.9,0.9, 1};
		text = "Show text-";
		font = LucidaConsoleB;
		colorBackground[] = {0, 0, 0, 0};
		sizeEx = 0.018;
		};	
		
		class vtsshowtextedit : VTS_RscEdit
		{
				idc = 10931;
				x = 0.205;
				y = 0.655;
				w = 0.175;
				h = 0.02;
		text = "";
		colorText[] = {0.9,0.9,0.9, 1};
		colorDisabled[] =  {0.9,0.9,0.9, 1};
		colorSelection[] = {0.5, 0.5, 0.5, 1};
		tooltip = "Enter the text to show up (Shortcut: Enter to run the display)";
		onKeyDown="if ((_this select 1)==28  or (_this select 1)==156 ) then {[] spawn vts_showtext_display;};";
		};		

		class vtshowtextselection:VTS_combo
		{ 
				idc = 10932;
				x = 0.384703;
				y = 0.653454;
				w = 0.06;
				h = 0.015;
		text = ""; 
		onLBSelChanged = "[0] execVM ""computer\console\boutons\console_valid_showtexttype.sqf"";";
		tooltip="Select the method to display the text";
		};			

		class vtshowtextbutton:VTS_boutons
		{ 
				idc = 10933;
				x = 0.444703;
				y = 0.653454;
				w = 0.04;
				h = 0.015;
		text = "Show"; 
		action = "[] spawn vts_showtext_display;";
		tooltip="Display the typed text";
		};		
		// Populate city list
		class populatecivvillagecombo:VTS_combo
		{ 
				idc = 10901;
				x = 0.305;
				y = 0.455;
				w = 0.105;
				h = 0.015;
		text = "Civilians"; 
		colorDisabled[] =  {0.9,0.9,0.9, 1};
		onLBSelChanged = "[0] execVM ""computer\console\boutons\console_valid_populate.sqf"";"; 
		tooltip = "Select Civilian faction";
		};

		// Populate city
		class populatecivvillage:VTS_boutons
		{ 
				idc = 10905;
				x = 0.415;
				y = 0.455;
				w = 0.07;
				h = 0.015;
		text = "Civ"; 
		action = "[""NULL""] execVM ""computer\console\console_populate.sqf"";";
		tooltip = "Populate a town with civilians";
		};
    
    //Parachute
		class parachute:VTS_RscText
		{
				idc = 19900;
				x = 0.1;
				y = 0.394;
				w = 0.3;
				h = 0.02;
		style = ST_LEFT;
		colorText[] = {0.9,0.9,0.9, 1};
		text = "Parachute a group : altitude";
		font = LucidaConsoleB;
		colorBackground[] = {0, 0, 0, 0};
		sizeEx = 0.018;
	
		};			
		
		class parachutebouton1500:VTS_boutons
		{ 
				idc = 19901;
				x = 0.315;
				y = 0.395;
				w = 0.05;
				h = 0.015;
		text = "1500M"; 
		action = "[1500] execVM ""computer\console\console_groupparachute.sqf"";";
		tooltip = "Parachute a group at 1500 M";
		};
		class parachutebouton3000:VTS_boutons
		{ 
				idc = 19902;
				x = 0.37;
				y = 0.395;
				w = 0.05;
				h = 0.015;
		text = "3000M"; 
		action = "[3000] execVM ""computer\console\console_groupparachute.sqf"";";
		tooltip = "Parachute a group at 3000 M";
		};
		class parachutebouton10000:VTS_boutons
		{ 
				idc = 19903;
				x = 0.425;
				y = 0.395;
				w = 0.06;
				h = 0.015;
		text = "10000M"; 
		action = "[10000] execVM ""computer\console\console_groupparachute.sqf"";";
		tooltip = "Parachute a group at 10000 M";
		};
		
		
		// gps_valid
		
		class gps_valid:VTS_boutons
		{ 
				idc = 10241;
				x = 0.385;
				y = 0.712;
				w = 0.055;
				h = 0.015;
		text = "Players"; 
		action = "[] spawn gmgps_players;";
		tooltip = "Enable Disable players marker. Only the GM can see players markers";
		};
		
		class gps_eni_valid:VTS_boutons
		{ 
				idc = 10209;
				x = 0.45;
				y = 0.712;
				w = 0.03;
				h = 0.015;
		text = "All"; 
		action = "[] spawn gmgps_all;";
		tooltip = "Enable Disable all units marker. Only the GM can see units markers";
		};
		// camera_valid
		
		
	
		class fillvehicles:VTS_boutons
		{ 
				idc = 10393;
				x = 0.375;
				y = 0.423;
				w = 0.055;
				h = 0.015;
		text = "Cargos"; 
		action = "breakclic = 1;  [] execVM ""Computer\console\console_fillvehicles.sqf"";";
		tooltip = "Fill vehicles cargo of the selected side with this selected faction";
		};	
		
		class fillroads:VTS_boutons
		{ 
				idc = 10394;
				x = 0.435;
				y = 0.423;
				w = 0.05;
				h = 0.015;
		text = "Roads"; 
		action = "breakclic = 1;  [] execVM ""Computer\console\console_fillroads.sqf"";";
		tooltip = "Populate a road with land vehicles of the currently selected faction";
		};	
		
		// gps_valid
		class addbat_valid:VTS_boutons
		{ 
				idc = 10301;
				x = 0.315;
				y = 0.423;
				w = 0.055;
				h = 0.015;
		text = "Building"; 
		action = "breakclic = 1;[] execVM ""Computer\console\console_IAinBat.sqf"";";
		tooltip = "Fill buildings interiors with units from the selected faction";
		};
		
		class tpgroup_valid:VTS_boutons
		{ 
				idc = 10303;
				x = 0.41;
				y = 0.37;
				w = 0.075;
				h = 0.015;
		text = "Group TP"; 
		action = "[] execVM ""Computer\console\console_grouptp.sqf"";";
		tooltip = "Teleport a group to a new position";
		};
		
		// --------------------------------------------------------------
		// ----------------------- Ligne de commande = présentation
		// --------------------------------------------------------------
		
		class ligne_commande_pres:VTS_RscText
		{
				idc = 10242;
				x = 0.095;
				y = 0.735;
				w = 0.3;
				h = 0.02;
		style = ST_LEFT;
		colorText[] = {0.9,0.9,0.9, 1};
		text = "====== Command Line ==================";
		font = LucidaConsoleB;
		colorBackground[] = {0, 0, 0, 0};
		sizeEx = 0.018;

		};
		
		// ligne de commande
		
		class ligne_commande_cadre : VTS_RscEdit
		{
				idc = 10243;
				x = 0.1;
				y = 0.76;
				w = 0.35;
				h = 0.02;
		colorText[] = {0.9,0.9,0.9, 1};
		colorDisabled[] =  {0.9,0.9,0.9, 1};
		colorSelection[] = {0.5, 0.5, 0.5, 1};
		autocomplete="scripting";
		tooltip = "Enter script to be executed (Shortcut: Enter to execute, Arrow up & Arrow down to use history)";
		onKeyDown="if ((_this select 1)==28  or (_this select 1)==156 ) then {if (scriptrun < 1) then {scriptrun = 1 ; [1] execVM ""computer\console\boutons\script_commande.sqf"";};};if ((_this select 1)==200) then {[2] execVM ""computer\console\boutons\script_commande.sqf"";};if ((_this select 1)==208) then {[3] execVM ""computer\console\boutons\script_commande.sqf"";};";
		
		};

		
		class ligne_commande_help:VTS_boutons
		{ 
				idc = 10300;
				x = 0.45;
				y = 0.76;
				w = 0.04;
				h = 0.015;
		text = "HELP"; 
		action = "[] call Dlg_StoreParams;[] call vts_commandlinehelp";
		tooltip = "Display help box about the command line";
		};
		
	    class unit_object_pre_com_line_combo:VTS_combo
		{
				idc = 10606;
				x = 0.1;
				y = 0.79;
				w = 0.39;
				h = 0.025;
		text = "precommandline";
		colorDisabled[] =  {0.9,0.9,0.9, 1};
		onLBSelChanged = "[0] execVM ""computer\console\boutons\console_valid_pre_com_line.sqf"";"; 
		tooltip = "Precommand can be used as examples";         
		};
		
		// Script : titre
		
		class script_titre:VTS_RscText
		{
				idc = 10244;
				x = 0.1;
				y = 0.825;
				w = 0.3;
				h = 0.02;	
		style = ST_LEFT;
		colorText[] = {0.9,0.9,0.9, 1};
		text = "Script :";
		font = LucidaConsoleB;
		colorBackground[] = {0, 0, 0, 0};
		sizeEx = 0.018;

		};
		
		// ----------------------- Script
		
		class scriptbouton1:VTS_boutons
		{ 
				idc = 10245;
				x = 0.18;
				y = 0.825;
				w = 0.02;
				h = 0.015;
		text = "<"; 
		action = "script_commande = script_commande-1 ; [0] execVM ""computer\console\boutons\script_commande.sqf"";";
		tooltip = "Select a custom script to run instead of typed command";
		};
		
		class scriptbouton2:VTS_boutons
		{ 
				idc = 10246;
				x = 0.2;
				y = 0.825;
				w = 0.265;
				h = 0.015;
		text = "Script"; 
		action = "script_commande = script_commande+1 ; [0] execVM ""computer\console\boutons\script_commande.sqf"";";
		tooltip = "Select a custom script to run instead of typed command";
		};
		
		class scriptbouton3:VTS_boutons
		{ 
				idc = 10247;
				x = 0.465;
				y = 0.825;
				w = 0.02;
				h = 0.015;
		text = ">"; 
		action = "script_commande = script_commande+1 ; [0] execVM ""computer\console\boutons\script_commande.sqf"";";
		tooltip = "Select a custom script to run instead of typed command";
		};
		
		//------------------------- valider
		
		class command_validtexte:VTS_RscText
		{
				idc = 10248;
				x = 0.1;
				y = 0.85;
				w = 0.3;
				h = 0.02;
		style = ST_LEFT;
		colorText[] = {0.9,0.9,0.9, 1};
		text = "Execute -----";
		font = LucidaConsoleB;
		colorBackground[] = {0, 0, 0, 0};
		sizeEx = 0.018;

		};
		
		class command_valid1:VTS_boutons
		{ 
				idc = 10249;
				x = 0.23;
				y = 0.85;
				w = 0.025;
				h = 0.02;
		text = "ok"; 
		action = "if (scriptrun < 1) then {scriptrun = 1 ; [1] execVM ""computer\console\boutons\script_commande.sqf"";};";
		tooltip = "Execute command or script";
		//action = "[1] execVM ""computer\console\boutons\script_commande.sqf""";
		};
			
			
		//class vts_object_info:VTS_RscText
		class vts_object_property:VTS_RscText
		{ 

			idc = 10650; 
			//type = ST_STATIC;
			style = ST_LEFT + ST_MULTI; 			
			x = 0.96; 
			//y = 0.12;
			y = 0.07;
			w = 0.18;
			//h = 0.63;
			h = 0.835;
			sizeEx = 0.020;
			colorText[] = {0.9,0.9,0.9, 1};
			//colorDisabled[] =  {0.9,0.9,0.9, 1};
			//colorSelection[] = {0.5, 0.5, 0.5, 1};		
			ColorBackground[] = {1,1,1,0.2};		
			text = "\n\nObject property :"; 
			tooltip = "Change the property of the object or the group objects";
		};				
		
		class vts_object_property_close:VTS_boutons
		{ 
				idc = 10651;
				x = 0.965;
				y = 0.075;
				w = 0.05;
				h = 0.02;
		text = "Close"; 
		action = "[] call vts_property_close";
		tooltip = "Close the properties menu";
		};		

		class vts_object_property_group:VTS_boutons
		{ 
				idc = 10661;
				x = 0.965;
				y = 0.11;
				w = 0.165;
				h = 0.02;
				text = "Object properties :"; 
				action = "[] call vts_property_unitorgroup";
				tooltip = "Change to whom the properties are applied, the selected unit, or the unit and its group";
		};	
		
		class vts_object_property_damage:VTS_boutons
		{ 
				idc = 10652;
				x = 0.965;
				y = 0.295;
				w = 0.11;
				h = 0.02;
		text = "Set damage"; 
		action = "[] call vts_property_setdamage";
		tooltip = "Change the damage value from 0.0 intact to 1.0 = fully damaged";
		};				
		class vts_object_property_damageedit : VTS_RscEdit
		{
				idc = 10653;
				x = 1.08;
				y = 0.295;
				w = 0.055;
				h = 0.02;
			colorText[] = {0.9,0.9,0.9, 1};
			colorDisabled[] =  {0.9,0.9,0.9, 1};
		    colorSelection[] = {0.5, 0.5, 0.5, 1};
		    tooltip = "Enter the damage value, from 0.0 intact to 1.0 = fully damaged";
			onKeyDown="if ((_this select 1)==28  or (_this select 1)==156 ) then {[] call vts_property_setdamage;};";
		};	

		class vts_object_property_ammo:VTS_boutons
		{ 
				idc = 10654;
				x = 0.965;
				y = 0.32;
				w = 0.11;
				h = 0.02;
		text = "Set ammunition"; 
		action = "[] call vts_property_setammo";
		tooltip = "Change the quantity of ammo from 1.0 to 0.0 = none";
		};				
		class vts_object_property_ammoedit : VTS_RscEdit
		{
				idc = 10655;
				x = 1.08;
				y = 0.32;
				w = 0.055;
				h = 0.02;
			colorText[] = {0.9,0.9,0.9, 1};
			colorDisabled[] =  {0.9,0.9,0.9, 1};
		    colorSelection[] = {0.5, 0.5, 0.5, 1};
		    tooltip = "Enter the quantity of ammunition, from 1.0 to 0.0 = empty";
			onKeyDown="if ((_this select 1)==28  or (_this select 1)==156 ) then {[] call vts_property_setammo;};";
		};	

		class vts_object_property_fuel:VTS_boutons
		{ 
				idc = 10656;
				x = 0.965;
				y = 0.345;
				w = 0.11;
				h = 0.02;
		text = "Set fuel"; 
		action = "[] call vts_property_setfuel";
		tooltip = "Change the quantity of fuel from 0.0 to 1.0 = full";
		};				
		class vts_object_property_fueledit : VTS_RscEdit
		{
				idc = 10657;
				x = 1.08;
				y = 0.345;
				w = 0.055;
				h = 0.02;
			colorText[] = {0.9,0.9,0.9, 1};
			colorDisabled[] =  {0.9,0.9,0.9, 1};
		    colorSelection[] = {0.5, 0.5, 0.5, 1};
		    tooltip = "Enter the quantity of fuel, from 0.0 to 1.0 = full";
			onKeyDown="if ((_this select 1)==28  or (_this select 1)==156 ) then {[] call vts_property_setfuel;};";
		};	
		class vts_object_property_fheight:VTS_boutons
		{ 
				idc = 10658;
				x = 0.965;
				y = 0.37;
				w = 0.11;
				h = 0.02;
		text = "Set flying height"; 
		action = "[] call vts_property_setfheight";
		tooltip = "Change the quantity of fuel";
		};				
		class vts_object_property_fheightedit : VTS_RscEdit
		{
				idc = 10659;
				x = 1.08;
				y = 0.37;
				w = 0.055;
				h = 0.02;
			colorText[] = {0.9,0.9,0.9, 1};
			colorDisabled[] =  {0.9,0.9,0.9, 1};
		    colorSelection[] = {0.5, 0.5, 0.5, 1};
		    tooltip = "Enter the altitude to fly";
			onKeyDown="if ((_this select 1)==28  or (_this select 1)==156 ) then {[] call vts_property_setfheight;};";
		};	
		
		class vts_object_property_lock:VTS_boutons
		{ 
				idc = 10660;
				x = 0.965;
				y = 0.395;
				w = 0.11;
				h = 0.02;
		text = "Unlock vehicle"; 
		action = "[] call vts_property_setlocked";
		tooltip = "Lock or Unlock the vehicle";
		};		

		class vts_object_property_removeweapons:VTS_boutons
		{ 
				idc = 10662;
				x = 0.965;
				y = 0.68;
				w = 0.165;
				h = 0.02;
		text = "Remove all weapons"; 
		action = "[] call vts_property_removeweapons";
		tooltip = "Remove all weapons & magazines of the unit";
		};	

		class vts_object_property_nvgoff:VTS_boutons
		{ 
				idc = 10663;
				x = 0.965;
				y = 0.755;
				w = 0.08;
				h = 0.02;
		text = "NVG OFF"; 
		action = "[""off""] call vts_property_nvgoggle";
		tooltip = "Remove NV Goggles of the unit";
		};	

		class vts_object_property_nvgon:VTS_boutons
		{ 
				idc = 10649;
				x = 1.050;
				y = 0.755;
				w = 0.08;
				h = 0.02;
		text = "NVG ON"; 
		action = "[""on""] call vts_property_nvgoggle";
		tooltip = "Add NV Goggles to the unit";
		};			
		
		class vts_object_property_stance:VTS_boutons
		{ 
				idc = 10664;
				x = 0.965;
				y = 0.49;
				w = 0.165;
				h = 0.02;
		text = "AI Stance : Auto"; 
		action = "[""AUTO""] call vts_property_changestance";
		tooltip = "Force the stance of the unit";
		};		
		class vts_object_property_stanceup:VTS_boutons
		{ 
				idc = 10665;
				x = 0.965;
				y = 0.515;
				w = 0.165;
				h = 0.02;
		text = "AI Stance : Up"; 
		action = "[""UP""] call vts_property_changestance";
		tooltip = "Force the stance of the unit";
		};
		class vts_object_property_stancemid:VTS_boutons
		{ 
				idc = 10666;
				x = 0.965;
				y = 0.54;
				w = 0.165;
				h = 0.02;
		text = "AI Stance : Middle"; 
		action = "[""Middle""] call vts_property_changestance";
		tooltip = "Force the stance of the unit";
		};	
		class vts_object_property_stancelow:VTS_boutons
		{ 
				idc = 10667;
				x = 0.965;
				y = 0.565;
				w = 0.165;
				h = 0.02;
		text = "AI Stance : Down"; 
		action = "[""DOWN""] call vts_property_changestance";
		tooltip = "Force the stance of the unit";
		};		
		class vts_object_property_skill:VTS_boutons
		{ 
				idc = 10668;
				x = 0.965;
				y = 0.605;
				w = 0.11;
				h = 0.02;
		text = "AI Set skill"; 
		action = "[] call vts_property_skill";
		tooltip = "Change the skill of an unit from 0.0 to 1.0 = Highest";
		};			
		class vts_object_property_skilledit : VTS_RscEdit
		{
				idc = 10669;
				x = 1.08;
				y = 0.605;
				w = 0.055;
				h = 0.02;
			colorText[] = {0.9,0.9,0.9, 1};
			colorDisabled[] =  {0.9,0.9,0.9, 1};
		    colorSelection[] = {0.5, 0.5, 0.5, 1};
		    tooltip = "Enter the skill of the unit from 0.0 to 1.0 = Highest";
			onKeyDown="if ((_this select 1)==28  or (_this select 1)==156 ) then {[] call vts_property_skill;};";
		};	
		class vts_object_property_flee:VTS_boutons
		{ 
				idc = 10670;
				x = 0.965;
				y = 0.63;
				w = 0.11;
				h = 0.02;
		text = "AI Cowardice"; 
		action = "[] call vts_property_fleeing";
		tooltip = "Change the cowardice of an unit from 0.0 to 1.0 = Highest";
		};			
		class vts_object_property_fleeedit : VTS_RscEdit
		{
				idc = 10671;
				x = 1.08;
				y = 0.635;
				w = 0.055;
				h = 0.02;
			colorText[] = {0.9,0.9,0.9, 1};
			colorDisabled[] =  {0.9,0.9,0.9, 1};
		    colorSelection[] = {0.5, 0.5, 0.5, 1};
		    tooltip = "Enter the cowardice of the unit from 0.0 to 1.0 = Highest";
			onKeyDown="if ((_this select 1)==28  or (_this select 1)==156 ) then {[] call vts_property_fleeing;};";
		};			
		class vts_object_property_surrender:VTS_boutons
		{ 
				idc = 10672;
				x = 0.965;
				y = 0.655;
				w = 0.165;
				h = 0.02;
		text = "AI Surrender & ungear"; 
		action = "[] call vts_property_surrender";
		tooltip = "Make an unit to surrender (irreversible)";
		};		

		class vts_object_property_init:VTS_boutons
		{ 
				idc = 10673;
				x = 0.965;
				y = 0.715;
				w = 0.04;
				h = 0.02;
		text = "Init"; 
		action = "[] call vts_property_init";
		tooltip = "Add an init function to the unit (irreversible)";
		};			
		class vts_object_property_initlist : VTS_combo
		{
				idc = 10674;
				x = 1.01;
				y = 0.715;
				w = 0.125;
				h = 0.02;
			colorText[] = {0.9,0.9,0.9, 1};
			colorDisabled[] =  {0.9,0.9,0.9, 1};
		    colorSelection[] = {0.5, 0.5, 0.5, 1};
		    tooltip = "Select the init function to add then press Init to apply";
			onLBSelChanged = "vts_property_initselected=lbText [10674,(lbCurSel 10674)];";
		};	
		class vts_object_property_lighton:VTS_boutons
		{
			idc = 10676;
			x = 1.050;
			y = 0.780;
			w = 0.08;
			h = 0.02;
			text = "Light On"; 
		    tooltip = "Add flashlight item to the primary weapon and turn it On";
			action = "[""forceon""] call vts_property_light";			
		};	
		class vts_object_property_lightoff:VTS_boutons
		{
			idc = 10677;
			x = 0.965;
			y = 0.780;
			w = 0.08;
			h = 0.02;
			text = "Light Off";
		    tooltip = "Turn flashlight Off and remove the item from the primary weapon";
			action = "[""forceoff""] call vts_property_light";
		};
		class vts_object_property_laseron:VTS_boutons
		{
			idc = 10678;
			x = 1.050;
			y = 0.805;
			w = 0.08;
			h = 0.02;
			text = "Laser On"; 
		    tooltip = "Add laser item to the primary weapon and turn it On";
			action = "[true] call vts_property_gunlaser";			
		};	
		class vts_object_property_laseroff:VTS_boutons
		{
			idc = 10679;
			x = 0.965;
			y = 0.805;
			w = 0.08;
			h = 0.02;
			text = "Laser Off";
		    tooltip = "Turn laser Off and remove the item from the primary weapon";
			action = "[false] call vts_property_gunlaser";
		};	
		class vts_object_property_suppressoron:VTS_boutons
		{
			idc = 10680;
			x = 1.050;		
			y = 0.830;
			w = 0.08;
			h = 0.02;
			text = "Suppr. On"; 
		    tooltip = "Add suppressor item to the primary weapon";
			action = "[""on""] call vts_property_suppressor";			
		};	
		class vts_object_property_suppressoroff:VTS_boutons
		{
			idc = 10681;
			x = 0.965;
			y = 0.830;
			w = 0.08;
			h = 0.02;
			text = "Suppr. Off";
		    tooltip = "Remove suppressor item from the primary weapon";
			action = "[""off""] call vts_property_suppressor";
		};			
				
		class vts_object_property_revive:VTS_boutons
		{ 
				idc = 10675;
				x = 0.965;
				y = 0.870;
				w = 0.165;
				h = 0.02;
		text = "VTS Revive : player"; 
		action = "[] call vts_property_revive";
		tooltip = "Turn a dead or unconcious player, healthy (work only with VTS revive system)";
		};			
		// ---------------------------------------------------------fin des VTS_boutons

			
		class Map: VTS_MapControl
		{
		idc = 105;
		//scaleMin=0.030000;
		//scaleMax=1.560000;
		scaleMin=0.0025000;
		scaleMax=1.560000;		
		scaleDefault=0.096000;
		x = 0.5; 
		y = 0.12;
		w = 0.45;
		h = 0.63;
		onKeyDown="_this spawn vts_gmmapkeydown;";
		onKeyUp="_this spawn vts_gmmapkeyup;";
		onMouseButtonUp="_this spawn vts_gmmapmousebuttonup;";
		onMouseZChanged="_this call vts_gmmapmousez;";
		onMouseButtonDblClick="_this spawn vts_gmmapdblclick;";
		onMouseMoving="_this spawn vts_gmmapmousemoving;";
		default = true;
		};
		
		
		/*
		class PIPtest: VTS_RscPicture
		{
		idc = 105;
		style = 48;
		fadein = 0;
		fadeout = 0;
		enableSimulation = 1;
		enableDisplay = 1;
		duration = 99999999;
		text = "#(argb,512,512,1)r2t(vtsfeed1,1.0)";
		x = 0.5; 
		y = 0.12;
		w = 0.45;
		h = 0.63;
		sizeEx=0.20;
		};
		*/
		
		class ClickMap:VTS_RscText
		{

		style = ST_LEFT;
		colorText[] = {0.9,0.9,0.9, 1};
		text = "";
		font = LucidaConsoleB;
		colorBackground[] = {0, 0, 0, 0.25};
		sizeEx = 0.018;
				idc = 200;
				x = 0.05;
				y = 0.005;
				w = 1.1;
				h = 0.02;
		};
		/*
		class TimeCPU:VTS_RscText
		{
		idc=110;
		style = ST_LEFT;
		colorText[] = {1, 1, 0, 1};
		text = "";
		font = LucidaConsoleB;
		colorBackground[] = {0, 0, 0, 0};
		sizeEx = 0.018;
		x = 0.1;
		y = 0.55;
		w = 0.80;
		h = 0.61;
		};

		class Chopper : VTS_RscStructuredText
		{
		idc = 108;
		font = LucidaConsoleB;
		x = 0.55;
		y = 0.67;
		w = 0.6; 
		h = 1;
		default = true;
		colorText[] = {0.9,0.9,0.9, 1};
		text = "";
		};
		
		
		class Harrier : VTS_RscStructuredText
		{
		idc = 109;
		font = LucidaConsoleB;
		x = 0.55;
		y = 0.73;
		w = 0.6; 
		h = 1;
		default = true;
		colorText[] = {0.9,0.9,0.9, 1};
		text = "";
		};
		*/
	};	
};
		
		
		
