////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT START (by Letranger, v1.061, #Goqify)
////////////////////////////////////////////////////////
class VTS_rscgroup
{
	IDD = 8005;
	MovingEnable = 1;
	
	class Controls
	{
		class IGUIBack_2200: VTS_RscBackground
		{
			moving=true;
			idc = 2200;
			x = 0.075;
			y = 0;
			w = 0.875;
			h = 0.92;
			ColorBackground[]={0.1,0.1,0.2,0.7};
			ColorText[]={0.1,0.1,0.1,1};			
		};
		class vtsgroup_list: VTS_RscListBox
		{
			idc = 1500;
			x = 0.125;
			y = 0.16;
			w = 0.25;
			h = 0.72;
			colorText[] = { 1, 1, 1, 1 };
			colorDisabled[] =  {0.9,0.9,0.9, 1};
		    colorSelection[] = {0.5, 0.5, 0.5, 1};
			onLBSelChanged = "[] call vtsgroup_selectgroup;";
			onLBDblClick = "";			
		};
		class vtsgroup_detailstest: VTS_RscListBox
		{
			idc = 1100;
			x = 0.425;
			y = 0.16;
			w = 0.3;
			h = 0.72;
			sizeEx = 0.02;
			colorText[] = { 1, 1, 1, 1 };
			text = "";
			ColorBackground[] = {1,1,1,0.2};
			colorDisabled[] =  {0.9,0.9,0.9, 0};
		    colorSelection[] = {0.5, 0.5, 0.5, 0};			
			style = ST_LEFT; 	
			onLBSelChanged = "";
			onLBDblClick = "";			
			
		};
		class vtsgroup_join: VTS_boutons
		{
			idc = 1600;
			text = "Join the squad"; //--- ToDo: Localize;
			x = 0.75;
			y = 0.16;
			w = 0.15;
			h = 0.04;
			action = "[] call vtsgroup_joingroup;";
			style = ST_CENTER; 
		};
		class vtsgroup_takelead: VTS_boutons
		{
			idc = 1601;
			text = "Take the lead"; //--- ToDo: Localize;
			x = 0.75;
			y = 0.32;
			w = 0.15;
			h = 0.04;
			action = "[] call vtsgroup_leadgroup;";
			style = ST_CENTER; 
		};
		class vtsgroup_leave: VTS_boutons
		{
			idc = 1602;
			text = "Leave the squad"; //--- ToDo: Localize;
			x = 0.75;
			y = 0.24;
			w = 0.15;
			h = 0.04;
			action = "[] call vtsgroup_leavegroup;";
			style = ST_CENTER; 
		};
		class vtsgroup_exit: VTS_boutons
		{
			idc = 1603;
			text = "Exit"; //--- ToDo: Localize;
			x = 0.75;
			y = 0.84;
			w = 0.15;
			h = 0.04;
			action = "closeDialog 8005;";
			style = ST_CENTER; 
		};		
		class vtsgroup_joinred: VTS_boutons
		{
			idc = 1604;
			text = "Join Red Team"; //--- ToDo: Localize;
			x = 0.75;
			y = 0.40;
			w = 0.15;
			h = 0.04;
			action = "[""RED""] call vtsgroup_jointeam;";
			colorText[] = { 1,0.6,0.6,1};
			style = ST_CENTER; 
		};	
		class vtsgroup_joinblue: VTS_boutons
		{
			idc = 1605;
			text = "Join Blue Team"; //--- ToDo: Localize;
			x = 0.75;
			y = 0.48;
			w = 0.15;
			h = 0.04;
			action = "[""BLUE""] call vtsgroup_jointeam;";
			colorText[] = { 0.6,0.6,1,1 };
			style = ST_CENTER; 
		};	
		class vtsgroup_joingreen: VTS_boutons
		{
			idc = 1606;
			text = "Join Green Team"; //--- ToDo: Localize;
			x = 0.75;
			y = 0.56;
			w = 0.15;
			h = 0.04;
			action = "[""GREEN""] call vtsgroup_jointeam;";
			colorText[] = { 0.6,1,0.6,1 };
			style = ST_CENTER; 
		};	
		class vtsgroup_joinyellow: VTS_boutons
		{
			idc = 1607;
			text = "Join Yellow Team"; //--- ToDo: Localize;
			x = 0.75;
			y = 0.64;
			w = 0.15;
			h = 0.04;
			action = "[""YELLOW""] call vtsgroup_jointeam;";
			colorText[] = { 1,1,0.6,1 };
			style = ST_CENTER; 
		};	
		class vtsgroup_joinwhite: VTS_boutons
		{
			idc = 1608;
			text = "Leave Team"; //--- ToDo: Localize;
			x = 0.75;
			y = 0.72;
			w = 0.15;
			h = 0.04;
			action = "[""MAIN""] call vtsgroup_jointeam;";
			colorText[] = { 1, 1, 1, 1 };
			style = ST_CENTER; 
		};			
		class vtsgroup_groups: VTS_RscText
		{
			idc = 1000;
			text = "Available squad(s)"; //--- ToDo: Localize;
			x = 0.125;
			y = 0.1;
			w = 0.25;
			h = 0.04;
			sizeEx = 0.02;
			colorText[] = { 1, 1, 1, 1 };
			style = ST_CENTER; 
		};
		class vtsgroup_details: VTS_RscText
		{
			idc = 1001;
			text = "Squad information"; //--- ToDo: Localize;
			x = 0.425;
			y = 0.1;
			w = 0.3;
			h = 0.04;
			sizeEx = 0.02;
			colorText[] = { 1, 1, 1, 1 };
			style = ST_CENTER; 
		};
		class vtsgroup_title: VTS_RscText
		{
			idc = 1002;
			text = "Squad manager"; //--- ToDo: Localize;
			x = 0.125;
			y = 0.03;
			w = 0.775;
			h = 0.04;
			sizeEx = 0.02;
			colorText[] = { 1, 1, 1, 1 };
			style = ST_CENTER; 
		};		
	};
};
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT END
////////////////////////////////////////////////////////
