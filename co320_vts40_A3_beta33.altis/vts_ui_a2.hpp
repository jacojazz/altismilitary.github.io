
class VTS_MapControl
{
	access = ReadAndWrite;
	type = 101;
	idc = -1;
	style = 48;
	colorBackground[] = {1, 1, 1, 1};
	colorText[] = {0, 0, 0, 1};
	font = "TahomaB";
	sizeEx = 0.04;
	colorSea[] = {0.56, 0.8, 0.98, 0.5};
	colorForest[] = {0.6, 0.8, 0.2, 0.5};
	colorRocks[] = {0.5, 0.5, 0.5, 0.5};
	colorCountlines[] = {0.65, 0.45, 0.27, 0.5};
	colorMainCountlines[] = {0.65, 0.45, 0.27, 1};
	colorCountlinesWater[] = {0, 0.53, 1, 0.5};
	colorMainCountlinesWater[] = {0, 0.53, 1, 1};
	colorForestBorder[] = {0.4, 0.8, 0, 1};
	colorRocksBorder[] = {0.5, 0.5, 0.5, 1};
	colorPowerLines[] = {0, 0, 0, 1};
	colorRailWay[] = {0.8, 0.2, 0.3, 1};
	colorNames[] = {0, 0, 0, 1};
	colorInactive[] = {1, 1, 1, 0.5};
	colorLevels[] = {0, 0, 0, 1};
	colorOutside[] = {0, 0, 0, 1};
	fontLabel = "TahomaB";
	sizeExLabel = 0.04;
	fontGrid = "TahomaB";
	sizeExGrid = 0.04;
	fontUnits = "TahomaB";
	sizeExUnits = 0.04;
	fontNames = "TahomaB";
	sizeExNames = 0.04;
	fontInfo = "TahomaB";
	sizeExInfo = 0.04;
	fontLevel = "TahomaB";
	sizeExLevel = 0.04;
	text = "#(argb,8,8,3)color(1,1,1,1)";
	stickX[] = {0.2, {"Gamma", 1, 1.5}};
	stickY[] = {0.2, {"Gamma", 1, 1.5}};
	ptsPerSquareSea = 6;
	ptsPerSquareTxt = 8;
	ptsPerSquareCLn = 8;
	ptsPerSquareExp = 8;
	ptsPerSquareCost = 8;
	ptsPerSquareFor = "4.0f";
	ptsPerSquareForEdge = "10.0f";
	ptsPerSquareRoad = 2;
	ptsPerSquareObj = 5;
	showCountourInterval = "true";
	maxSatelliteAlpha = 0.6;
	alphaFadeStartScale = 2.0;
	alphaFadeEndScale = 2.0;	

	

	class Task {
			icon = "\ca\ui\data\ui_taskstate_current_ca.paa";
			iconCreated = "\ca\ui\data\ui_taskstate_new_ca.paa";
			iconCanceled = "\ca\ui\data\ui_taskstate_done_ca.paa";
			iconDone = "\ca\ui\data\ui_taskstate_done_ca.paa";
			iconFailed = "\ca\ui\data\ui_taskstate_failed_ca.paa";
	 	  color[] = {0.863000,0.584000,0.000000,1 };
		  colorCreated[] = {0.950000,0.950000,0.950000,1 };
	 	  colorCanceled[] = {0.606000,0.606000,0.606000,1 };
		  colorDone[] = {0.424000,0.651000,0.247000,1 };
		  colorFailed[] = {0.706000,0.074500,0.019600,1 };
			size = 27;
			importance = 1;
		  coefMin = 1;
		  coefMax = 1;
		};	

		

		class CustomMark {
			icon = "\ca\ui\data\map_waypoint_ca.paa";
			color[] = {1, 1, 1, 1};
			size = 18;
			importance = 1;
			coefMin = 1;
			coefMax = 1;
		};
		
						
		class Legend {
			x = 0;
			y = 0;
			w = 0;
			h = 0;
			font = "Zeppelin32";
			sizeEx = 0.0151;
			colorBackground[] = {1, 1, 1, 0.3};
			color[] = {0, 0, 0, 1};
		};
		
		class ActiveMarker {
			color[] = {0.3, 0.1, 0.9, 1};
			size = 50;
		};
				
		class Bunker {
			icon = "\ca\ui\data\map_bunker_ca.paa";
			color[] = {1, 1, 1, 1};
			size = 14;
			importance = 1.5 * 14 * 0.05;
			coefMin = 0.25;
			coefMax = 4;
		};
		
		class Bush {
			icon = "\ca\ui\data\map_bush_ca.paa";
			color[] = {0, 0.3, 0, 1};
			size = 14;
			importance = 0.2 * 14 * 0.05;
			coefMin = 0.25;
			coefMax = 4;
		};
		
		class BusStop {
			icon = "\ca\ui\data\map_busstop_ca.paa";
			color[] = {1, 1, 1, 1};
			size = 10;
			importance = 1 * 10 * 0.05;
			coefMin = 0.25;
			coefMax = 4;
		};
		
		class Command {
			icon = "\ca\ui\data\map_waypoint_ca.paa";
			color[] = {1, 1, 1, 1};
			size = 18;
			importance = 1;
			coefMin = 1;
			coefMax = 1;
		};
		
		class Cross {
			icon = "\ca\ui\data\map_cross_ca.paa";
			color[] = {1, 1, 1, 1};
			size = 16;
			importance = 0.7 * 16 * 0.05;
			coefMin = 0.25;
			coefMax = 4;
		};
		
		class Fortress {
			icon = "\ca\ui\data\map_bunker_ca.paa";
			color[] = {0, 0, 0, 1};
			size = 16;
			importance = 2 * 16 * 0.05;
			coefMin = 0.25;
			coefMax = 4;
		};
		
		class Fuelstation {
			icon = "\ca\ui\data\map_fuelstation_ca.paa";
			color[] = {0, 0, 0, 1};
			size = 16;
			importance = 2 * 16 * 0.05;
			coefMin = 0.75;
			coefMax = 4;
		};
		
		class Fountain {
			icon = "\ca\ui\data\map_fountain_ca.paa";
			color[] = {0, 0, 0, 1};
			size = 12;
			importance = 1 * 12 * 0.05;
			coefMin = 0.25;
			coefMax = 4;
		};
		
		class Hospital {
			icon = "\ca\ui\data\map_hospital_ca.paa";
			color[] = {0, 0, 0, 1};
			size = 16;
			importance = 2 * 16 * 0.05;
			coefMin = 0.5;
			coefMax = 4;
		};
		
		class Chapel {
			icon = "\ca\ui\data\map_chapel_ca.paa";
			color[] = {0, 0, 0, 1};
			size = 16;
			importance = 1 * 16 * 0.05;
			coefMin = 0.9;
			coefMax = 4;
		};
		
		class Church {
			icon = "\ca\ui\data\map_church_ca.paa";
			color[] = {0, 0, 0, 1};
			size = 16;
			importance = 2 * 16 * 0.05;
			coefMin = 0.9;
			coefMax = 4;
		};
		
		class Lighthouse {
			icon = "\ca\ui\data\map_lighthouse_ca.paa";
			color[] = {0, 0, 0, 1};
			size = 20;
			importance = 3 * 16 * 0.05;
			coefMin = 0.9;
			coefMax = 4;
		};
		
		class Quay {
			icon = "\ca\ui\data\map_quay_ca.paa";
			color[] = {0, 0, 0, 1};
			size = 16;
			importance = 2 * 16 * 0.05;
			coefMin = 0.5;
			coefMax = 4;
		};
		
		class Rock {
			icon = "\ca\ui\data\map_rock_ca.paa";
			color[] = {0.78, 0, 0.05, 1};
			size = 12;
			importance = 0.5 * 12 * 0.05;
			coefMin = 0.25;
			coefMax = 4;
		};
		
		class Ruin {
			icon = "\ca\ui\data\map_ruin_ca.paa";
			color[] = {0.78, 0, 0.05, 1};
			size = 16;
			importance = 1.2 * 16 * 0.05;
			coefMin = 1;
			coefMax = 4;
		};
		
		class SmallTree {
			icon = "\ca\ui\data\map_smalltree_ca.paa";
			color[] = {0.55, 0.64, 0.43, 1};
			size = 12;
			importance = 0.6 * 12 * 0.05;
			coefMin = 0.25;
			coefMax = 4;
		};
		
		class Stack {
			icon = "\ca\ui\data\map_stack_ca.paa";
			color[] = {0, 0, 0, 1};
			size = 20;
			importance = 2 * 16 * 0.05;
			coefMin = 0.9;
			coefMax = 4;
		};
		
		class Tree {
			icon = "\ca\ui\data\map_tree_ca.paa";
			color[] = {0.55, 0.64, 0.43, 1};
			size = 12;
			importance = 0.9 * 16 * 0.05;
			coefMin = 0.25;
			coefMax = 4;
		};
		
		class Tourism {
			icon = "\ca\ui\data\map_tourism_ca.paa";
			color[] = {0.78, 0, 0.05, 1};
			size = 16;
			importance = 1 * 16 * 0.05;
			coefMin = 0.7;
			coefMax = 4;
		};
		
		class Transmitter {
			icon = "\ca\ui\data\map_transmitter_ca.paa";
			color[] = {0.78, 0, 0.05, 1};
			size = 20;
			importance = 2 * 16 * 0.05;
			coefMin = 0.9;
			coefMax = 4;
		};
		
		class ViewTower {
			icon = "\ca\ui\data\map_viewtower_ca.paa";
			color[] = {0.78, 0, 0.05, 1};
			size = 16;
			importance = 2.5 * 16 * 0.05;
			coefMin = 0.5;
			coefMax = 4;
		};
		
		class Watertower {
			icon = "\ca\ui\data\map_watertower_ca.paa";
			color[] = {0, 0.35, 0.7, 1};
			size = 32;
			importance = 1.2 * 16 * 0.05;
			coefMin = 0.9;
			coefMax = 4;
		};
		
		class Waypoint {
			icon = "\ca\ui\data\map_waypoint_ca.paa";
			color[] = {0, 0, 0, 1};
			size = 32;
			importance = 1.2 * 16 * 0.05;
			coefMin = 0.9;
			coefMax = 4;			
		};
		
		class WaypointCompleted {
			icon = "\ca\ui\data\map_waypoint_completed_ca.paa";
			color[] = {0, 0, 0, 1};
			size = 32;
			importance = 1.2 * 16 * 0.05;
			coefMin = 0.9;
			coefMax = 4;			
		};
};
