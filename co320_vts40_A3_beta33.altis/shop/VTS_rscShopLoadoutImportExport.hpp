
#define CT_COMBO                 4

class VTS_Rscshoploadoutimportexport
{
	IDD = 8007;
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
		
		class vtsexit : VTS_boutons
		{ 
			idc = 10053; 
			x = 0.100; 
			y = 0.870; 
			w = 0.10; 
			h = 0.030; 
			text = "Exit"; 
			action = "closeDialog 8007;";
		};


   class vtscommandloadsavepastetxt : VTS_RscText
		{ 
			idc = 2051; 
			x = 0.490; 
			y = 0.870; 
			w = 0.17; 
			h = 0.030; 
			sizeEx = 0.023; 
			style = ST_CENTER;
			colorText[] = {0.9,0.9,0.9, 1};
			text = "Use CTRL+V to paste"; 
		};
		

    class vtscommandloadsavecopytxt : VTS_RscText
		{ 
			idc = 2052; 
			x = 0.295; 
			y = 0.870; 
			w = 0.17; 
			h = 0.030; 
			sizeEx = 0.023; 
			style = ST_CENTER;
			colorText[] = {0.9,0.9,0.9, 1};
			text = "Use CTRL+C to copy"; 
		};		


    class vtscommandloadsavebuild : VTS_boutons
		{ 
			idc = 20506; 
			x = 0.680; 
			y = 0.870; 
			w = 0.22; 
			h = 0.030; 
			sizeEx = 0.023; 
			style = ST_CENTER;
			text = "Apply this Loadout DATA"; 
			action = "[] call vts_shoploadoutimportexportapply;";
			tooltip="Apply this loadout data on your soldier";
		};
    class vtscommandloadsaveheader:VTS_RscText
		{
			idc=20302;
			style = ST_LEFT + ST_MULTI;
			colorText[] = {0.9,0.9,0.9, 1};
			text = "Here is the current DATA of the Loadout currently carried by your soldier. You can Copy and Paste it in a text editor and share it Offline. To Import a new Loadout DATA, Paste it from your Clipboard into the input field and Hit 'Apply this Loadout DATA', this will apply the Loadout DATA to your soldier (if there is enough money and items in the shop stock of course).";
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
