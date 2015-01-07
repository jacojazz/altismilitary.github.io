////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT START (by Letranger, v1.061, #Goqify)
////////////////////////////////////////////////////////
class VTS_rscgroupteleport
{
	IDD = 8006;
	MovingEnable = 1;
	
	class Controls
	{

		class IGUIBack_2200: VTS_RscBackground
		{
			moving=true;
			idc = 2200;
			x = 0.15;
			y = 0.04;
			w = 0.7;
			h = 0.84;
			ColorBackground[]={0.1,0.1,0.2,0.7};
			ColorText[]={0.1,0.1,0.1,1};				
		};
		class RscListbox_1500: VTS_RscListBox
		{
			idc = 1500;
			x = 0.225;
			y = 0.12;
			w = 0.225;
			h = 0.68;
			colorText[] = { 1, 1, 1, 1 };
			colorDisabled[] =  {0.9,0.9,0.9, 1};
		    colorSelection[] = {0.5, 0.5, 0.5, 1};
			onLBSelChanged = "[] call vtsspawnonsquad_select;";
			onLBDblClick = "[] call vtsspawnonsquad_tpselect;";				
		};
		class RscButton_1600: VTS_boutons
		{
			idc = 1600;
			text = "Spawn"; //--- ToDo: Localize;
			x = 0.53;
			y = 0.72;
			w = 0.2175;
			h = 0.04;
			action = "[] call vtsspawnonsquad_tpselect;";
			style = ST_CENTER; 			
		};
		class RscButton_1601: VTS_boutons
		{
			idc = 1601;
			text = "Close"; //--- ToDo: Localize;
			x = 0.725;
			y = 0.82;
			w = 0.1;
			h = 0.04;
			action = "closeDialog 8004;";
			style = ST_CENTER; 			
		};
		class RscPicture_1200: VTS_MapControl
		{
			idc = 1200;

			x = 0.475;
			y = 0.12;
			w = 0.3375;
			h = 0.55;
			scaleMin=0.0025000;
			scaleMax=1.560000;		
			scaleDefault=0.096000;			
			
		};
		class RscText_1000: VTS_RscText
		{
			idc = 1000;
			text = "Select a squad member to spawn on"; //--- ToDo: Localize;
			x = 0.275;
			y = 0.06;
			w = 0.5;
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
