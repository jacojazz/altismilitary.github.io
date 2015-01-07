
#define CT_COMBO                 4

class VTS_rsccommandhelp
{
	IDD = 8001;
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
		
		class VTS_vtscommandhelpexit : VTS_boutons
		{ 
			idc = 10053; 
			x = 0.100; 
			y = 0.870; 
			w = 0.12; 
			h = 0.030; 
			text = "Exit"; 
			action = "closeDialog 0;";
		};

    
    class VTS_vtscommandhelprefresh : VTS_boutons
		{ 
			idc = 10503; 
			x = 0.250; 
			y = 0.870; 
			w = 0.12; 
			h = 0.030; 
			sizeEx = 0.023; 
			style = ST_CENTER;
			text = "Refresh"; 
			action = "[] call vts_commandlinehelprefresh;";
		};

		
		class VTS_vtscommandhelptext : VTS_RscEdit
		{
		idc = 10301;
		type = CT_EDIT;
		style = ST_LEFT + ST_MULTI; 	
		x=0.10;
		y=0.06;
		w=0.8;
		h=0.8;
		text = ""; 
		colorText[] = {0.9,0.9,0.9, 1};
		colorSelection[] = {0.5, 0.5, 0.5, 1};
		autocomplete=true;
		htmlControl=true;
	
		};
		
    	  
  };
};
