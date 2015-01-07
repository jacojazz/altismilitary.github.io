
#define CT_COMBO                 4

class rsccommandloadsave
{
	IDD = 8002;
	MovingEnable = 1;
	
	class Controls
	{
		class VTS_SkinBackground : VTS_RscBackground
		{
		  moving=true;
			x=0.05;
			y=0.04;
			w=0.9;
			h=0.9;
			text=;
			ColorBackground[]={0.1,0.1,0.2,0.7};
			ColorText[]={0.1,0.1,0.1,1};
		};
		
		class vtscommandloadsavepexit : VTS_boutons
		{ 
			idc = 10053; 
			x = 0.100; 
			y = 0.870; 
			w = 0.10; 
			h = 0.030; 
			text = "Exit"; 
			action = "closeDialog 0;";
		};

    
    class vtscommandloadsaverefresh : VTS_boutons
		{ 
			idc = 20503; 
			x = 0.230; 
			y = 0.870; 
			w = 0.14; 
			h = 0.030; 
			sizeEx = 0.023; 
			style = ST_CENTER;
			text = "Filter : None"; 
			action = "[1] execvm ""Computer\loadsavemission.sqf"";";
		};
   class vtscommandloadsavepastetxt : VTS_RscText
		{ 
			idc = 2051; 
			x = 0.590; 
			y = 0.870; 
			w = 0.17; 
			h = 0.030; 
			sizeEx = 0.023; 
			style = ST_CENTER;
			colorText[] = {0.9,0.9,0.9, 1};
			text = "Use CTRL+V to paste"; 
		};
		
    class vtscommandloadsavepaste : VTS_boutons
		{ 
			idc = 20504; 
			x = 0.590; 
			y = 0.870; 
			w = 0.17; 
			h = 0.030; 
			sizeEx = 0.023; 
			style = ST_CENTER;
			text = "Paste from Clipboard"; 
			action = "[] execvm ""Computer\loadsavepaste.sqf"";";
		};
    class vtscommandloadsavecopytxt : VTS_RscText
		{ 
			idc = 2052; 
			x = 0.395; 
			y = 0.870; 
			w = 0.17; 
			h = 0.030; 
			sizeEx = 0.023; 
			style = ST_CENTER;
			colorText[] = {0.9,0.9,0.9, 1};
			text = "Use CTRL+C to copy"; 
		};		
    class vtscommandloadsavecopy : VTS_boutons
		{ 
			idc = 20505; 
			x = 0.395; 
			y = 0.870; 
			w = 0.17; 
			h = 0.030; 
			sizeEx = 0.023; 
			style = ST_CENTER;
			text = "Copy to Clipboard"; 
			action = "[] execvm ""Computer\loadsavecopy.sqf"";";
		};

    class vtscommandloadsavebuild : VTS_boutons
		{ 
			idc = 20506; 
			x = 0.780; 
			y = 0.870; 
			w = 0.12; 
			h = 0.030; 
			sizeEx = 0.023; 
			style = ST_CENTER;
			text = "Build this"; 
			action = "[] execvm ""Computer\loadsavebuild.sqf"";";
			tooltip="Generate the mission from the current displayed data (wait until the Build process is completed before trying to spawn new unit to avoid issue)";
		};
    class vtscommandloadsaveheader:VTS_RscText
		{
			idc=20302;
			style = ST_LEFT + ST_MULTI;
			colorText[] = {0.9,0.9,0.9, 1};
			text = "Generating mission data, please wait. . .";
			font = LucidaConsoleB;
			colorBackground[] = {0, 0, 0, 0};
			sizeEx = 0.018;
			x = 0.1;
			y = 0.045;
			w = 0.8;
			h = 0.1;		  
    };		
		class vtscommandloadsavetext : VTS_RscEdit
		{
		idc = 20301;
		type = CT_EDIT;
		style = ST_LEFT + ST_MULTI; 	
		htmlControl = true;
		x=0.10;
		y=0.145;
		w=0.8;
		h=0.70;
		text = ""; 
		colorText[] = {0.9,0.9,0.9, 1};
		colorDisabled[] =  {0.9,0.9,0.9, 1};
		colorSelection[] = {0.5, 0.5, 0.5, 1};
		autocomplete=true;
		tooltip="You can use CTRL+C to copy the selection to your clipboard and CTRL+V to pase your clipboard data into this windows";
		};
		
    	  
  };
};
