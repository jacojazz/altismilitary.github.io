class RscBackground
{
	ColorBackground[] = {0.48,0.5,0.35,1};
	colorShadow[] = {0,0,0,0.5};
	ColorText[] = {0.1,0.1,0.1,1};
	fixedWidth = 0;
	font = "PuristaMedium";
	h = 1;
	IDC = -1;
	linespacing = 1;
	shadow = 0;
	SizeEx = 1;
	style = 512;
	text = "";
	tooltipColorBox[] = {1,1,1,1};
	tooltipColorShade[] = {0,0,0,0.65};
	tooltipColorText[] = {1,1,1,1};
	type = 0;
	w = 1;
	x = 0;
	y = 0;
};

class RscButton
{
	borderSize = 0;
	colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.69])","(profilenamespace getvariable ['GUI_BCG_RGB_G',0.75])","(profilenamespace getvariable ['GUI_BCG_RGB_B',0.5])",0.7};
	colorBackgroundActive[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.69])","(profilenamespace getvariable ['GUI_BCG_RGB_G',0.75])","(profilenamespace getvariable ['GUI_BCG_RGB_B',0.5])",1};
	colorBackgroundDisabled[] = {0.95,0.95,0.95,1};
	colorBorder[] = {0,0,0,1};
	colorDisabled[] = {0.4,0.4,0.4,1};
	colorFocused[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.69])","(profilenamespace getvariable ['GUI_BCG_RGB_G',0.75])","(profilenamespace getvariable ['GUI_BCG_RGB_B',0.5])",1};
	colorShadow[] = {0,0,0,1};
	colorText[] = {1,1,1,1};
	font = "PuristaMedium";
	h = 0.039216;
	offsetPressedX = 0.002;
	offsetPressedY = 0.002;
	offsetX = 0.003;
	offsetY = 0.003;
	shadow = 2;
	sizeEx = "(			(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
	soundClick[] = {"\A3\ui_f\data\sound\RscButton\soundClick",0.09,1};
	soundEnter[] = {"\A3\ui_f\data\sound\RscButton\soundEnter",0.09,1};
	soundEscape[] = {"\A3\ui_f\data\sound\RscButton\soundEscape",0.09,1};
	soundPush[] = {"\A3\ui_f\data\sound\RscButton\soundPush",0.09,1};
	style = 2;
	text = "";
	type = 1;
	w = 0.095589;
	x = 0;
	y = 0;
};
	
class RscPicture
{
	colorBackground[] = {0,0,0,0};
	colorText[] = {1,1,1,1};
	fixedWidth = 0;
	font = "TahomaB";
	h = 0.15;
	idc = -1;
	lineSpacing = 0;
	shadow = 0;
	sizeEx = 0;
	style = 48;
	text = "";
	tooltipColorBox[] = {1,1,1,1};
	tooltipColorShade[] = {0,0,0,0.65};
	tooltipColorText[] = {1,1,1,1};
	type = 0;
	w = 0.2;
	x = 0;
	y = 0;
};

class VHS_Dialog
{
	IDD = 7331;
	MovingEnable = 1;
	enableSimulation = 1;
	enableDisplay = 1;
	

	
	class Controls
	{

		class picture: RscPicture
		{
			idc = 1200;
			text = "#(argb,8,8,3)color(1,1,1,0.25)";
			x = 0.339544 * safezoneW + safezoneX;
			y = 0.149953 * safezoneH + safezoneY;
			w = 0.320912 * safezoneW;
			h = 0.672091 * safezoneH;
		};
	
		class head: RscButton
		{
			idc = 1600;
			text = "head"; //--- ToDo: Localize;
			x = 0.470826 * safezoneW + safezoneX;
			y = 0.191958 * safezoneH + safezoneY;
			w = 0.0583476 * safezoneW;
			h = 0.0700095 * safezoneH;
		};
		class spine3: RscButton
		{
			idc = 1601;
			text = "spine3"; //--- ToDo: Localize;
			x = 0.470826 * safezoneW + safezoneX;
			y = 0.289972 * safezoneH + safezoneY;
			w = 0.0583476 * safezoneW;
			h = 0.0700095 * safezoneH;
		};
		class spine1: RscButton
		{
			idc = 1602;
			text = "spine1"; //--- ToDo: Localize;
			x = 0.470826 * safezoneW + safezoneX;
			y = 0.401987 * safezoneH + safezoneY;
			w = 0.0583476 * safezoneW;
			h = 0.0700095 * safezoneH;
		};
		class leftarm: RscButton
		{
			idc = 1603;
			text = "leftarm"; //--- ToDo: Localize;
			x = 0.558348 * safezoneW + safezoneX;
			y = 0.289972 * safezoneH + safezoneY;
			w = 0.0583476 * safezoneW;
			h = 0.0700095 * safezoneH;
		};
		class rightarm: RscButton
		{
			idc = 1604;
			text = "rightarm"; //--- ToDo: Localize;
			x = 0.383305 * safezoneW + safezoneX;
			y = 0.289972 * safezoneH + safezoneY;
			w = 0.0583476 * safezoneW;
			h = 0.0700095 * safezoneH;
		};
		class leftforearm: RscButton
		{
			idc = 1605;
			text = "leftforearm"; //--- ToDo: Localize;
			x = 0.587521 * safezoneW + safezoneX;
			y = 0.401987 * safezoneH + safezoneY;
			w = 0.0583476 * safezoneW;
			h = 0.0700095 * safezoneH;
		};
		class rightforearm: RscButton
		{
			idc = 1606;
			text = "rightforearm"; //--- ToDo: Localize;
			x = 0.354131 * safezoneW + safezoneX;
			y = 0.401987 * safezoneH + safezoneY;
			w = 0.0583476 * safezoneW;
			h = 0.0700095 * safezoneH;
		};
		class rightupleg: RscButton
		{
			idc = 1607;
			text = "rightupleg"; //--- ToDo: Localize;
			x = 0.514587 * safezoneW + safezoneX;
			y = 0.514002 * safezoneH + safezoneY;
			w = 0.0583476 * safezoneW;
			h = 0.0700095 * safezoneH;
		};
		class leftupleg: RscButton
		{
			idc = 1608;
			text = "leftupleg"; //--- ToDo: Localize;
			x = 0.427065 * safezoneW + safezoneX;
			y = 0.514002 * safezoneH + safezoneY;
			w = 0.0583476 * safezoneW;
			h = 0.0700095 * safezoneH;
		};
		class leftleg: RscButton
		{
			idc = 1609;
			text = "leftleg"; //--- ToDo: Localize;
			x = 0.427065 * safezoneW + safezoneX;
			y = 0.612015 * safezoneH + safezoneY;
			w = 0.0583476 * safezoneW;
			h = 0.0700095 * safezoneH;
		};
		class leftfoot: RscButton
		{
			idc = 1610;
			text = "leftfoot"; //--- ToDo: Localize;
			x = 0.427065 * safezoneW + safezoneX;
			y = 0.710028 * safezoneH + safezoneY;
			w = 0.0583476 * safezoneW;
			h = 0.0700095 * safezoneH;
		};
		class rightleg: RscButton
		{
			idc = 1611;
			text = "rightleg"; //--- ToDo: Localize;
			x = 0.514587 * safezoneW + safezoneX;
			y = 0.612015 * safezoneH + safezoneY;
			w = 0.0583476 * safezoneW;
			h = 0.0700095 * safezoneH;
		};
		class rightfoot: RscButton
		{
			idc = 1612;
			text = "rightfoot"; //--- ToDo: Localize;
			x = 0.514587 * safezoneW + safezoneX;
			y = 0.710028 * safezoneH + safezoneY;
			w = 0.0583476 * safezoneW;
			h = 0.0700095 * safezoneH;
		};

	};
	
};
	