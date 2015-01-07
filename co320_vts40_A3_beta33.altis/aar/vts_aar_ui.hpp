
class VTS_aar_ui
{
	IDD = 8008;
	MovingEnable = 1;

	class Controls
	{
		class BKG: VTS_RscBackground
		{
			moving=true;
			idc = 2200;
			x = 0.208298 * safezoneW + safezoneX;
			y = 0.0939826 * safezoneH + safezoneY;
			w = 0.583404 * safezoneW;
			h = 0.812036 * safezoneH;
			ColorBackground[]={0.1,0.1,0.2,0.7};
			ColorText[]={0.1,0.1,0.1,1};			
		};
		
		class TIME: VTS_RscSlider
		{

			idc = 1900;
			x = 0.310394 * safezoneW + safezoneX;
			y = 0.794013 * safezoneH + safezoneY;
			w = 0.393798 * safezoneW;
			h = 0.0420019 * safezoneH;
		  color[] = { 1, 1, 1, 1 };
		  coloractive[] = { 1, 1, 1, 1.0 };
		  sizeEx = 0.025;
		  type = 3;
		  style = 1024;
		  // This is an ctrlEventHandler to show you some response if you move the sliderpointer. 
		  onSliderPosChanged = "_this spawn vts_aar_setframe;";
		  tooltip = "Change the AAR timeline position";				
		};
		class RscText_1000: VTS_RscText
		{
			idc = 1937;
			text = "00:00:00"; //--- ToDo: Localize;
			x = 0.718777 * safezoneW + safezoneX;
			y = 0.785613 * safezoneH + safezoneY;
			w = 0.0583404 * safezoneW;
			h = 0.0280013 * safezoneH;
			colorText[] = {0.9,0.9,0.9, 1};
			tooltip="Timeline position";
		};

		class RscText_1013: VTS_RscText
		{
			idc = 1938;

			text = "00:00:00"; //--- ToDo: Localize;
			x = 0.718777 * safezoneW + safezoneX;
			y = 0.816414 * safezoneH + safezoneY;
			w = 0.0583404 * safezoneW;
			h = 0.0280013 * safezoneH;
			colorText[] = {0.9,0.9,0.9,1};
			tooltip = "AAR Duration"; //--- ToDo: Localize;
		};
		
		class STOP: VTS_boutons
		{
			idc = 1600;
			text = "Stop"; //--- ToDo: Localize;
			x = 0.21559 * safezoneW + safezoneX;
			y = 0.794013 * safezoneH + safezoneY;
			w = 0.0291702 * safezoneW;
			h = 0.0420019 * safezoneH;
			action = "[] call vts_aar_stop;";
			tooltip = "Stop & Clean the broadcasting of the AAR";				
		};
		class PLAY: VTS_boutons
		{
			idc = 1601;
			text = "Play"; //--- ToDo: Localize;
			x = 0.259346 * safezoneW + safezoneX;
			y = 0.794013 * safezoneH + safezoneY;
			w = 0.0291702 * safezoneW;
			h = 0.0420019 * safezoneH;
			action = "[] call vts_aar_play;";
			tooltip = "Play/Pause the broadcast of the AAR";				
		};

		class record: VTS_boutons
		{
			idc = 1603;
			text = "Start recording"; //--- ToDo: Localize;
			x = 0.21559 * safezoneW + safezoneX;
			y = 0.850016 * safezoneH + safezoneY;
			w = 0.0875107 * safezoneW;
			h = 0.0420019 * safezoneH;
			action = "[] call vts_aar_recordbutton;";
			tooltip = "Start/Stop/Resume the local recording of the session";				
		};
		class map: VTS_MapControl
		{
			idc = 1200;
			text = "#(argb,8,8,3)color(1,1,1,1)";
			x = 0.208298 * safezoneW + safezoneX;
			y = 0.149984 * safezoneH + safezoneY;
			w = 0.583404 * safezoneW;
			h = 0.630028 * safezoneH;
			scaleMin=0.0025000;
			scaleMax=1.560000;		
			scaleDefault=0.096000;			
		};
		class RscEdit_1400: VTS_RscEdit
		{
			idc = 1400;
			x = 0.478122 * safezoneW + safezoneX;
			y = 0.864016 * safezoneH + safezoneY;
			w = 0.189606 * safezoneW;
			h = 0.0280013 * safezoneH;
			colorText[] = {0.9,0.9,0.9, 1};
			colorDisabled[] =  {0.9,0.9,0.9, 1};
		    colorSelection[] = {0.5, 0.5, 0.5, 1};	
			tooltip = "Filename to save or load AAR data";				
		};
		class Export: VTS_boutons
		{
			idc = 1610;
			text = "Export"; //--- ToDo: Localize;
			x = 0.740654 * safezoneW + safezoneX;
			y = 0.864016 * safezoneH + safezoneY;
			w = 0.0437553 * safezoneW;
			h = 0.0280013 * safezoneH;
			action = "[] call vts_aar_export;";
			tooltip = "Export the current AAR data into the filename";				
		};
		class Import: VTS_boutons
		{
			idc = 1611;
			text = "Import"; //--- ToDo: Localize;
			x = 0.682314 * safezoneW + safezoneX;
			y = 0.864016 * safezoneH + safezoneY;
			w = 0.0437553 * safezoneW;
			h = 0.0280013 * safezoneH;
			action = "[] call vts_aar_import;";
			tooltip = "Import the AAR data from the filename";			
		};
		class log: VTS_RscText
		{
			idc = 1006;
			text = "Welcome to the AAR interface"; //--- ToDo: Localize;
			x = 0.208298 * safezoneW + safezoneX;
			y = 0.0939814 * safezoneH + safezoneY;
			w = 0.583404 * safezoneW;
			h = 0.0560025 * safezoneH;
			colorText[] = {0.9,0.9,0.9, 1};
		};
		class Filename: VTS_RscText
		{
			idc = 1007;
			text = "Filename:"; //--- ToDo: Localize;
			x = 0.405197 * safezoneW + safezoneX;
			y = 0.864016 * safezoneH + safezoneY;
			w = 0.065633 * safezoneW;
			h = 0.0280013 * safezoneH;
			colorText[] = {0.9,0.9,0.9, 1};
		};	
		class Exit: VTS_boutons
		{
			idc = 1609;

			text = "Exit"; //--- ToDo: Localize;
			x = 0.332271 * safezoneW + safezoneX;
			y = 0.850016 * safezoneH + safezoneY;
			w = 0.0437553 * safezoneW;
			h = 0.0420019 * safezoneH;
			action = "[] call vts_aar_closedialog;";
			tooltip = "Close the AAR tool";
		};		
	};
};