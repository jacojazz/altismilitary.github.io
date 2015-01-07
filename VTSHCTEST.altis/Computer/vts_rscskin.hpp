//by Grimm - Inspired by Igor Drukov
#define CT_COMBO                 4
#define FontM 					"TahomaB"

class VTS_rscskin
{
	IDD = 8003;
	MovingEnable = 1;
	
	class Controls
	{
		class VTS_SkinBackground:VTS_RscBackground
		{
		  moving=true;
			x=0.25;
			y=0.08;
			w=0.4;
			h=0.9;
			text="";
			ColorBackground[]={0.1,0.1,0.2,0.7};
			ColorText[]={0.1,0.1,0.1,1};
		};
		
		class VTS_skinmenubas1:VTS_boutons
		{ 
			idc = 10053; 
			x = 0.300; 
			y = 0.870; 
			w = 0.12; 
			h = 0.030; 
			text = "Exit"; 
			action = "closeDialog 0;";
		};


		class VTS_skin_campcombo:VTS_combo
		{ 
			idc = 10203;
			x = 0.260; 
			y = 0.120; 
			w = 0.180;
			h = 0.04;
			text = "unit camp"; 
			rowHeight = 0.04;
			onLBSelChanged = "[0] execVM ""computer\console\boutons\skin_valid_camp.sqf"";";
		};
		
		class VTS_skin_unitcombo:VTS_combo
		{ 
			idc = 10306;
			x = 0.450;  
			y = 0.120; 
			w = 0.19;
			h = 0.04;
			text = "unit"; 
			rowHeight = 0.04;
			onLBSelChanged = "[0] execVM ""computer\console\boutons\skin_valid_unite.sqf"";";
		};
		class vtsskin_picture:VTS_RscPicture 
    {
    idc = 10500;
    type = CT_STATIC;    // defined constant 
    style = ST_TILE_PICTURE; // defined constant 
    colorText[] = { 1, 1, 1, 1 }; 
	colorBackground[] = { 1, 1, 1, 0.75 }; 
    font = FontM; // defined constant 
    sizeEx = 0.023; 
    x = 0.350; 
    y = 0.200; 
    w = 0.2; 
    h = 0.25; 
    text = "#(argb,8,8,3)color(1,1,1,1)";  
    };
    
    class vtsskin_icon:VTS_RscPicture 
    {
    idc = 10501;
    type = CT_STATIC;    // defined constant 
    style = ST_TILE_PICTURE; // defined constant 
    colorText[] = { 1, 1, 1, 1 }; 
	colorBackground[] = { 1, 1, 1, 0.75 }; 
    font = FontM; // defined constant 
    sizeEx = 0.023; 
    x = 0.500; 
    y = 0.200; 
    w = 0.05; 
    h = 0.055; 
    text = "#(argb,8,8,3)color(1,1,1,1)";
	
	  };
    
    class vtsskin_name:VTS_RscText 
    {
    idc = 10502;
    type = CT_STATIC; // defined constant 
    style = ST_CENTER; // defined constant   
    colorText[] = { 1, 1, 1, 1 }; 
    //colorBackground[] = { 1, 1, 1, 0.75 }; 
    font = FontM; // defined constant 
    sizeEx = 0.023; 
    x = 0.300; 
    y = 0.470; 
    w = 0.300; 
    h = 0.05; 
    text = "Soldier"; 
	
	  };
    
    class vtskin_valid : VTS_boutons
		{ 
			idc = 10503; 
			x = 0.350; 
			y = 0.540; 
			w = 0.200; 
			h = 0.035; 
			sizeEx = 0.023; 
			style = ST_CENTER;
			text = "Use this class"; 
			action = "if (vtskincooldown==0) then {vtskincooldown=1;[player] execvm ""Computer\console\changeclass.sqf"";};";
		};

    class vtsskin_info:VTS_RscText 
    {
    idc = 10504;
    type = 13; // defined constant 
    style = ST_MULTI; // defined constant   
    colorText[] = { 1, 1, 1, 1 }; 
    //colorBackground[] = { 1, 1, 1, 0.75 }; 
    font = FontM; // defined constant 
    sizeEx = 0.023; 
	size = 0.023;
    x = 0.300; 
    y = 0.605; 
    w = 0.300; 
    h = 0.220; 
    text = "Info"; 
	
	};		
    	  
  };
};
