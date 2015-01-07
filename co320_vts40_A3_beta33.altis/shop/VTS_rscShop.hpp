//by Grimm - Inspired by Igor Drukov
#define CT_COMBO                 4
#define FontM 					"TahomaB"

class VTS_Rscshop
{
	IDD = 8004;
	MovingEnable = 1;
	class Controls
	{
		class VTS_ShopBackground:VTS_RscBackground
		{
			idc = 133000; 
			moving=true;
			x=0.05;
			y=0.04;
			w=0.9;
			h=0.9;
			text="";
			ColorBackground[]={0.1,0.1,0.2,0.7};
			ColorText[]={0.1,0.1,0.1,1};

		};

		class VTS_shopquit:VTS_boutons
		{ 
				idc = 133001;
				x = 0.45;
				y = 0.865;
				w = 0.12;
				h = 0.05;
			text = "EXIT"; 
			action = "[] call vts_shopclosed;closeDialog 8004;";
			style = ST_CENTER; 

		};    	

		class VTS_shoplist:VTS_RscListBox
		{ 
			type = CT_LISTBOX;
			style = ST_LEFT;
			idc = 133002;
			x = 0.06;
			y = 0.175;
			w = 0.235;
			h = 0.7;
			text = ""; 
			colorDisabled[] =  {0.9,0.9,0.9, 1};
		    colorSelection[] = {0.5, 0.5, 0.5, 1};		
			period=0.0;
			onLBSelChanged = "[0] call vts_shopitemselect";
			onLBDblClick = "[] call vts_shopbuy;";
			tooltip = "2xClick to buy the item";
			rowHeight = 0.04;
			colorBackground[] = { 1, 1, 1, 0.1 };
		};
		class VTS_playershoplist:VTS_RscListBox
		{ 
			type = CT_LISTBOX;
			style = ST_LEFT;
				idc = 133003;
				x = 0.72;
				y = 0.175;
				w = 0.22;
				h = 0.435;
			text = ""; 
			colorDisabled[] =  {0.9,0.9,0.9, 1};
		    colorSelection[] = {0.5, 0.5, 0.5, 1};
			period=0.0;
			onLBSelChanged = "[1] call vts_shopitemselect";
			onLBDblClick = "[] call vts_shopsell;";
			tooltip = "2xClick to sell the item";
			rowHeight = 0.04;
			colorBackground[] = { 1, 1, 1, 0.1 };
		};
	class VTS_shop_itempic:VTS_RscPicture 
    {
    idc = 133004;
    type = CT_STATIC;    // defined constant 
    style = ST_TILE_PICTURE; // defined constant 
    colorText[] = { 1, 1, 1, 1 }; 
    colorBackground[] = { 1, 1, 1, 0.75 }; 
    font = FontM; // defined constant 
    sizeEx = 0.023; 
    x = 0.300; 
    y = 0.190; 
    w = 0.200; 
    h = 0.130; 
    text = "#(argb,8,8,3)color(0,0,0,1)";
    };

    class VTS_shop_itemname:VTS_RscText 
    {
    idc = 133005;
    type = CT_STATIC; // defined constant 
    style = ST_CENTER; // defined constant   
    colorText[] = { 1, 1, 1, 1 }; 
    //colorBackground[] = { 1, 1, 1, 0.75 }; 
    font = FontM; // defined constant 
    sizeEx = 0.022; 
    x = 0.300; 
    y = 0.120; 
    w = 0.200; 
    h = 0.05; 
    text = ""; 
	
	  };
    class VTS_shop_itemnumber:VTS_RscText 
    {
    idc = 133037;
    type = CT_STATIC; // defined constant 
    style = ST_LEFT; // defined constant   
    colorText[] = { 1, 1, 1, 1 }; 
    colorBackground[] = { 1, 1, 1, 0.0 }; 
    font = FontM; // defined constant 
    sizeEx = 0.020; 
    x = 0.300; 
    y = 0.155; 
    w = 0.200; 
    h = 0.05; 
	shadow = 1;
    text = "In store: 0"; 	
	};	  

    class VTS_shop_itemdescription:VTS_RscText 
    {
    idc = 133006;
    type = 13 ; // Construct text 
    style = ST_MULTI + ST_LEFT ; // defined constant   
    colorText[] = { 1, 1, 1, 1 }; 
    //colorBackground[] = { 1, 1, 1, 0.75 }; 
    font = FontM; // defined constant 
    size = 0.019; 
    x = 0.300; 
    y = 0.320; 
    w = 0.200; 
    h = 0.13; 
    text = "";
    class Attributes 
    {
      font = "TahomaB"; 
      color = "#ffffff"; 
      align = "left"; 
      valign = "top"; 
      shadow = false; 
      shadowColor = "#ff0000"; 
      size = "1"; 
     };
	
	  };  
	  
    class VTS_shop_itemprice:VTS_RscText 
    {
    idc = 133007;
    type = CT_STATIC; // defined constant 
    style = ST_RIGHT; // defined constant   
    colorText[] = { 1, 1, 1, 1 }; 
    //colorBackground[] = { 1, 1, 1, 0.75 }; 
    font = FontM; // defined constant 
    sizeEx = 0.023; 
    x = 0.300; 
    y = 0.470; 
    w = 0.200; 
    h = 0.05; 
    text = ""; 
	tooltip = "Buying price";
	  };
		class VTS_shopbuy:VTS_boutons
		{ 
			idc = 133008; 
			x = 0.340; 
			y = 0.535; 
			w = 0.12; 
			h = 0.035; 
			text = "BUY"; 
			action = "[] call vts_shopbuy;";
			style = ST_CENTER; 

		};
		class VTS_shopinfo:VTS_RscText
		{ 

			type = 13 ; // defined constant 
			style = ST_MULTI; // defined constant   
				idc = 133009;
				x = 0.3;
				y = 0.69;
				w = 0.42;
				h = 0.15;
			font = FontM; // defined constant 
			colorText[] = { 1, 1, 1, 1 }; 
			size = 0.023;
			text = "Welcome to the Shop, have a look !";  
      
		};

		class VTS_shop_playeritempic:VTS_RscPicture 
    {
    idc = 133010;
    type = CT_STATIC;    // defined constant 
    style = ST_TILE_PICTURE; // defined constant 
    colorText[] = { 1, 1, 1, 1 }; 
    colorBackground[] = { 1, 1, 1, 0.75 }; 
    font = FontM; // defined constant 
    sizeEx = 0.023; 
    x = 0.515; 
    y = 0.190; 
    w = 0.200; 
    h = 0.130; 
    text = "#(argb,8,8,3)color(0,0,0,1)";
    };

    class VTS_shop_playeritemname:VTS_RscText 
    {
    idc = 133011;
    type = CT_STATIC; // defined constant 
    style = ST_CENTER; // defined constant   
    colorText[] = { 1, 1, 1, 1 }; 
    //colorBackground[] = { 1, 1, 1, 0.75 }; 
    font = FontM; // defined constant 
    sizeEx = 0.022; 
    x = 0.515; 
    y = 0.120; 
    w = 0.200; 
    h = 0.05; 
    text = ""; 
	
	};

    class VTS_shop_playeritemdescription:VTS_RscText 
    {
    idc = 133012;
    type = 13 ; // Construct text 
    style = ST_MULTI + ST_LEFT ; // defined constant   
    colorText[] = { 1, 1, 1, 1 }; 
    //colorBackground[] = { 1, 1, 1, 0.75 }; 
    font = FontM; // defined constant 
    size = 0.019; 
    x = 0.515; 
    y = 0.320; 
    w = 0.200; 
    h = 0.13; 
    text = "";
    class Attributes 
    {
      font = "TahomaB"; 
      color = "#ffffff"; 
      align = "left"; 
      valign = "top"; 
      shadow = false; 
      shadowColor = "#ff0000"; 
      size = "1"; 
     };
	
	  };  
	  
    class VTS_shop_playeritemprice:VTS_RscText 
    {
    idc = 133013;
    type = CT_STATIC; // defined constant 
    style = ST_RIGHT; // defined constant   
    colorText[] = { 1, 1, 1, 1 }; 
    //colorBackground[] = { 1, 1, 1, 0.75 }; 
    font = FontM; // defined constant 
    sizeEx = 0.023; 
    x = 0.515; 
    y = 0.470; 
    w = 0.200; 
    h = 0.05; 
    text = ""; 
	tooltip = "Selling price";
	
	  };
		class VTS_shopsell:VTS_boutons
		{ 
			idc = 133014; 
			//x = 0.340;
      x = 0.560;
			y = 0.535; 
			w = 0.12; 
			h = 0.035; 
			text = "SELL"; 
			action = "[] call vts_shopsell;";
			style = ST_CENTER; 

		};                   		

    class VTS_shop_name:VTS_RscText 
    {

    type = CT_STATIC; // defined constant 
    style = ST_CENTER; // defined constant   
    colorText[] = { 1, 1, 1, 1 }; 
    //colorBackground[] = { 1, 1, 1, 0.75 }; 
    font = FontM; // defined constant 
    sizeEx = 0.023; 
				idc = 133015;
				x = 0.06;
				y = 0.045;
				w = 0.235;
				h = 0.03;
    text = "The shop"; 
	tooltip = "Side of the current Shop";
	 };

    class VTS_shop_playername:VTS_RscText 
    {
 
    type = CT_STATIC; // defined constant 
    style = ST_CENTER; // defined constant   
    colorText[] = { 1, 1, 1, 1 }; 
    //colorBackground[] = { 1, 1, 1, 0.75 }; 
    font = FontM; // defined constant 
    sizeEx = 0.023; 
				idc = 133016;
				x = 0.72;
				y = 0.045;
				w = 0.22;
				h = 0.07;
    text = "You"; 
	
	};	 

    class VTS_shop_playerclass:VTS_RscText 
    {

    type = CT_STATIC; // defined constant 
    style = ST_RIGHT; // defined constant   
    colorText[] = { 1, 1, 1, 1 }; 
    //colorBackground[] = { 1, 1, 1, 0.75 }; 
    font = FontM; // defined constant 
    sizeEx = 0.02; 
				idc = 133048;
				x = 0.72;
				y = 0.12;
				w = 0.22;
				h = 0.05;
    text = "Soldier"; 
	
	};	 	  

		class VTS_shopbalance:VTS_RscText
		{ 
			idc = 133017;
			  type = CT_STATIC ; // defined constant 
			  style = ST_CENTER + ST_MULTI;  // defined constant   
			x = 0.400; 
			y = 0.590; 
			w = 0.200; 
			h = 0.075; 
			font = FontM; // defined constant 
			colorText[] = { 1, 1, 1, 1 }; 
			  sizeEx = 0.023;
			  text = "Balance : \n\n0 $";  
      
		};

		class VTS_shopprimaryweapon:VTS_boutons
		{ 
				idc = 133018;
				x = 0.06;
				y = 0.1;
				w = 0.0625;
				h = 0.02;
			text = "Primary"; 
			action = "[ShopWeaponList,""null"",[1,5]] call vts_shopgeneratelist;";
			style = ST_CENTER; 
			tooltip = "Main Weapons";
		};

		class VTS_shopsecondaryweapon:VTS_boutons
		{ 
				idc = 133024;
				x = 0.1275;
				y = 0.1;
				w = 0.0725;
				h = 0.02;
			text = "Secondary"; 
			action = "[ShopWeaponList,""null"",[4]] call vts_shopgeneratelist;";
			style = ST_CENTER; 
			tooltip = "Launchers & Heavy items";
		};

		class VTS_shopammo:VTS_boutons
		{ 
				idc = 133019;
				x = 0.0600001;
				y = 0.125;
				w = 0.05;
				h = 0.02;
			text = "Ammo"; 
			action = "[ShopMagazineList,""null"",[16,16*2,16*3,16*4,16*5,16*6,16*7,16*8,256,256*2,256*3,256*4,256*5,256*6,256*7,256*8]] call vts_shopgeneratelist;";
			style = ST_CENTER; 
			tooltip = "Ammunition & Explosives";
		};

		class VTS_shophandgun:VTS_boutons
		{ 
				idc = 133025;
				x = 0.205;
				y = 0.1;
				w = 0.0475;
				h = 0.02;
			text = "Belt"; 
			action = "[ShopWeaponList,""null"",[2]] call vts_shopgeneratelist;";
			style = ST_CENTER; 
			tooltip = "Handguns and Holster weapons";
		};

		class VTS_shopgear:VTS_boutons
		{ 
				idc = 133026;
				x = 0.2385;
				y = 0.125;
				w = 0.0515;
				h = 0.02;
			text = "Gear"; 
			action = "[ShopgearList,""null""] call vts_shopgeneratelist;";
			style = ST_CENTER; 
			tooltip = "Cloths & Protections";
		};

		class VTS_shopattachments:VTS_boutons
		{ 
				idc = 133029;
				x = 0.1735;
				y = 0.125;
				w = 0.0615;
				h = 0.02;
			text = "W. Item"; 
			action = "[ShopWeaponItemList,""null"",[131072]] call vts_shopgeneratelist;";
			style = ST_CENTER; 
			tooltip = "Weapon items";
		};		
		
		class VTS_shopmiscitem:VTS_boutons
		{ 
				idc = 133027;
				x = 0.1175;
				y = 0.125;
				w = 0.05;
				h = 0.02;
			text = "Item"; 
			action = "[ShopWeaponList,""null"",[131072,131072*2,131072*3,131072*4,131072*5,131072*6,131072*7,131072*8,4096,4096*2,4096*3,4096*4,4096*5,4096*6,4096*7,4096*8,4096*9,4096*10,4096*11,4096*12,4096*13,4096*14,4096*15,4096*16]] call vts_shopgeneratelist;";
			style = ST_CENTER; 
			tooltip = "Tactical items";
		};

		class VTS_shopbackpack:VTS_boutons
		{ 
				idc = 133028;
				x = 0.255;
				y = 0.1;
				w = 0.035;
				h = 0.02;
			text = "Bag"; 
			action = "[ShopBackPackList,""null""] call vts_shopgeneratelist;";
			style = ST_CENTER; 
			tooltip = "Backpacks & Parachutes";
		};
		
		class VTS_shopland:VTS_boutons
		{ 
				idc = 133020;
				x = 0.06;
				y = 0.075;
				w = 0.07;
				h = 0.02;
			text = "Vehicle"; 
			action = "[ShopLandList,""null""] call vts_shopgeneratelist;";
			style = ST_CENTER; 
			tooltip = "Land & Sea vehicles";
		}; 
		class VTS_shopstatic:VTS_boutons
		{ 
				idc = 133021;
				x = 0.14;
				y = 0.075;
				w = 0.07;
				h = 0.02;
			text = "Turret"; 
			action = "[ShopStaticList,""null""] call vts_shopgeneratelist;";
			style = ST_CENTER; 
			tooltip = "Static support";
		}; 
		class VTS_shopair:VTS_boutons
		{ 
				idc = 133022;
				x = 0.22;
				y = 0.075;
				w = 0.07;
				h = 0.02;
			text = "Aircraft"; 
			action = "[ShopAirList,""null""] call vts_shopgeneratelist;";
			style = ST_CENTER; 
			tooltip = "Air vehicles";
		}; 
		class VTS_itemlockedit:VTS_RscEdit
		{
			idc = 133039; 
			x = 0.380; 
			y = 0.29; 
			w = 0.075; 
			h = 0.022; 
			text = ""; 
			shadow = 1;
			style = ST_RIGHT; 
			colorText[] = { 1, 1, 1, 1 }; 
			Tooltip="(GM only) Enter the number of this type of item available for the no-GM players";
			onKeyDown="if ((_this select 1)==28  or (_this select 1)==156 ) then {[] call vts_shopitemsetcountgui;};";
		};  		
		class VTS_itemlock:VTS_boutons
		{
			idc = 133023; 
			x = 0.460; 
			y = 0.29; 
			w = 0.035; 
			h = 0.022; 
			text = "Set"; 
			action = "[] call vts_shopitemsetcountgui;";
			style = ST_CENTER; 
			Tooltip="(GM only) Set the number of this items available to no-GM players";
		};  
		class VTS_itemlockmax:VTS_boutons
		{
			idc = 133040; 
			x = 0.340; 
			y = 0.29; 
			w = 0.03; 
			h = 0.022; 
			text = "Max"; 
			action = "[9999] call vts_shopitemsetcountgui;";
			style = ST_CENTER; 
			Tooltip="(GM only) Set number of this items available to 9999";
		};  		
		class VTS_itemlockmin:VTS_boutons
		{
			idc = 133041; 
			x = 0.305; 
			y = 0.29; 
			w = 0.03; 
			h = 0.022; 
			text = "Min"; 
			action = "[0] call vts_shopitemsetcountgui;";
			style = ST_CENTER; 
			Tooltip="(GM only) Set number of this items available to 0";
		};  		

		class VTS_shop_persitentloadout:VTS_combo 
		{

		//type = CT_STATIC; // defined constant 
		//style = ST_CENTER; // defined constant   
		colorText[] = { 1, 1, 1, 1 }; 
		//colorBackground[] = { 1, 1, 1, 0.75 }; 
		font = FontM; // defined constant 
		sizeEx = 0.023; 
				idc = 133038;
				x = 0.725;
				y = 0.62;
				w = 0.215;
				h = 0.03;
		text = "Persistent loadouts"; 
		onLBSelChanged = "[0] execVM ""shop\shop_valid_loadouttype.sqf"";";
		tooltip = "Select if you want to use your personal persistent loadouts or use one of your ally loadout"; 
		};		
		class VTS_shoploadout01info:VTS_boutons
		{ 
				idc = 133030;
				x = 0.725;
				y = 0.655;
				w = 0.1;
				h = 0.02;
			text = "Import/Export"; 
			action = "[] call vts_shoploadoutimportexport;";
			style = ST_CENTER; 
			Tooltip="Import a new loadout or export your current loadout";
		};	
		class VTS_shoploadout01price:VTS_RscText 
		{

			type = CT_STATIC; // defined constant 
			style = ST_CENTER; // defined constant   
			colorText[] = { 1, 1, 1, 1 }; 
			//colorBackground[] = { 1, 1, 1, 0.75 }; 
			font = FontM; // defined constant 
			sizeEx = 0.023; 
				idc = 133031;
				x = 0.725;
				y = 0.89;
				w = 0.215;
				h = 0.025;
			text = "Empty loadout"; 
			tooltip = "Loadout buying price";
		};		

		class VTS_shoploadout01Load:VTS_boutons
		{ 
				idc = 133032;
				x = 0.83;
				y = 0.655;
				w = 0.05;
				h = 0.02;
			text = "Load"; 
			action = "[] spawn vts_shoploadoutload;";
			style = ST_CENTER; 
			Tooltip="Buy the selected loadout to equip yourself";
		};	
		

		class VTS_shoploadout01Save:VTS_boutons
		{ 
				idc = 133035;
				x = 0.885;
				y = 0.655;
				w = 0.055;
				h = 0.02;
			text = "Save"; 
			action = "[] spawn vts_shoploadoutsave;";
			style = ST_CENTER; 
			Tooltip="Save your current loadout on the selected slot";
		};	
	
	
		class VTS_loadoutlist:VTS_RscListBox
		{ 
			type = CT_LISTBOX;
			style = ST_LEFT;
				idc = 133036;
				x = 0.725;
				y = 0.68;
				w = 0.215;
				h = 0.175;
			text = ""; 
			colorDisabled[] =  {0.9,0.9,0.9, 1};
		    colorSelection[] = {0.5, 0.5, 0.5, 1};
			onLBSelChanged = "[] call vts_shoploadoutselect";
			onLBDblClick = "[] spawn vts_shoploadoutload;";
			tooltip = "2xClick to buy the loadout";
		};

		class VTS_shoploadoutrenameedit:VTS_RscEdit
		{ 
				idc = 133043;
				x = 0.725;
				y = 0.86;
				w = 0.15;
				h = 0.025;
			text = ""; 
			colorText[] = {0.9,0.9,0.9, 1};
			colorSelection[] = {0.5, 0.5, 0.5, 1};
			colorDisabled[] =  {0.9,0.9,0.9, 1};	
			style = ST_LEFT; 
			tooltip = "Type a text to rename the loadout slot";
			onKeyDown="if ((_this select 1)==28  or (_this select 1)==156 ) then {[] call vts_shopsetloadoutname;};";
		};		
		
		class VTS_shoploadoutrename:VTS_boutons
		{ 
				idc = 133042;
				x = 0.88;
				y = 0.86;
				w = 0.06;
				h = 0.02;
			text = "Rename"; 
			action = "[] call vts_shopsetloadoutname;";
			style = ST_CENTER; 
			Tooltip="Rename the current selected loadout slot";
		};			
		class VTS_filter:VTS_boutons
		{ 
				idc = 133034;
				x = 0.2225;
				y = 0.15;
				w = 0.0675;
				h = 0.02;
			text = "Filter"; 
			style = ST_CENTER;
			action = "vts_shop_filter=ctrlText 133033;[] call vts_shopsetfilter;";  
			tooltip = "Apply the typed filter to the current list";			
		};

		class VTS_filteredit:VTS_RscEdit
		{ 
				idc = 133033;
				x = 0.06;
				y = 0.15;
				w = 0.157;
				h = 0.02;
			text = ""; 
			colorText[] = {0.9,0.9,0.9, 1};
			colorSelection[] = {0.5, 0.5, 0.5, 1};
			colorDisabled[] =  {0.9,0.9,0.9, 1};	
			style = ST_RIGHT; 
			tooltip = "Type a text to filter items by name or description (ex: 5.56, Leave empty to disable filtering)";
			onKeyDown="if ((_this select 1)==28  or (_this select 1)==156 ) then {vts_shop_filter=ctrlText 133033;[] call vts_shopsetfilter;};";
		};
		class VTS_shopbalancegm:VTS_RscEdit
		{
			idc = 133044; 
			x = 0.420; 
			y = 0.615; 
			w = 0.125; 
			h = 0.022; 
			text = ""; 
			style = ST_RIGHT; 
			colorText[] = { 1, 1, 1, 1 }; 
			Tooltip="(GM only) Change the balance of this side";
			onKeyDown="if ((_this select 1)==28  or (_this select 1)==156 ) then {[] call vts_shopsetbalancebygm;};";
		};  		
		class VTS_shopbalancegmSet:VTS_boutons
		{
			idc = 133045; 
			x = 0.550; 
			y = 0.615; 
			w = 0.035; 
			h = 0.022; 
			text = "Set"; 
			action = "[] call vts_shopsetbalancebygm;";
			style = ST_CENTER; 
			Tooltip="(GM only) Apply the balance to this side";
		};  		

		class VTS_lockall:VTS_boutons
		{ 
				idc = 133046;
				x = 0.06;
				y = 0.914999;
				w = 0.12;
				h = 0.02;
			text = "Empty all"; 
			style = ST_CENTER;
			action = "[] call vts_shoplockall;";  
			tooltip = "(GM only) Set every items of this side to 0";			
		};
		class VTS_unlockall:VTS_boutons
		{ 
				idc = 133047;
				x = 0.185;
				y = 0.914999;
				w = 0.11;
				h = 0.02;
			text = "Fill all"; 
			style = ST_CENTER;
			action = "[] call vts_shopunlockall;";  
			tooltip = "(GM only) Set every items of this side to 9999";			
		};		
		class VTS_locklist:VTS_boutons
		{ 
				idc = 133049;
				x = 0.06;
				y = 0.879999;
				w = 0.12;
				h = 0.025;
			text = "Empty current list"; 
			style = ST_CENTER;
			action = "[] call vts_shoplocklist;";  
			tooltip = "(GM only) Set every side's items of the current list to 0";			
		};
		class VTS_unlocklist:VTS_boutons
		{ 
				idc = 133050;
				x = 0.185;
				y = 0.879999;
				w = 0.11;
				h = 0.025;
			text = "Fill current list"; 
			style = ST_CENTER;
			action = "[] call vts_shopunlocklist;";  
			tooltip = "(GM only) Set every side's items of the current list to 9999";			
		};	
		
  };
};	
		
		
