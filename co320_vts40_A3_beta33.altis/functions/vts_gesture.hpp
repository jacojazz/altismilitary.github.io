//BG picture
class vts_gesture_pic
{
    access = 0;
    idc = -1;
    type = 0;
    style = 0x30;
    colorBackground[] = {0,0,0,0};
    colorText[] = {1,1,1,1};
    font = "TahomaB";
    sizeEx = 0;
    lineSpacing = 0;
    text = "";
    fixedWidth = 0;
    shadow = 0;
    x = 0;
    y = 0;
    w = 0.2;
    h = 0.15;
};
//Button
class vts_gesture_text
{
	access = 0;
    idc = -1;
	type = 1;
	style = 0x02;
	colorBackground[] = {0,0,0,0.15};
	colorText[] = {1.0,1.0,1.0,0.75};
    colorDisabled[] = {0.6,0.1,0.3,1};
    colorBackgroundDisabled[] = {0,0.0,0};
    colorBackgroundActive[] = {0.0,0.0,1.0,0.5};
    colorFocused[] = {0,0,0,0.15};
    colorShadow[] = {0,0,0,0.0};
    colorBorder[] = {0,0,0,0};	
	font="TahomaB";//
	SizeEx = 0.060000;
	LineSpacing = 1.000000;
	shadow = 2;
	fixedWidth = 0;
	x = 0;
    y = 0;
    h = 0;
    w = 0;
    text = "";
    offsetX = 0.000;
    offsetY = 0.000;
    offsetPressedX = 0.000;
    offsetPressedY = 0.000;
    borderSize = 0;	
    soundEnter[] = {};
    soundPush[] = {};
    soundClick[] = {};
    soundEscape[] = {};	
	action = "closeDialog 1337001;if (vts_selected_gesture!='') then {player playactionnow vts_selected_gesture;};vts_selected_gesture='';";
};

class vts_m_gesture_rose
{
	idd = 1337001;
	movingenable = 0;
	
	////////////////////////////////////////////////////////
	// GUI EDITOR OUTPUT START (by Letranger, v1.062, #Damusu)
	////////////////////////////////////////////////////////
	
	class Controls
	{
		
		class vts_gesture_bg_1 : vts_gesture_pic
		{
			idc = 1021;
			text = "functions\vtsgesturebg2.paa";
			x = 0.262311 * safezoneW + safezoneX;
			y = 0.16397 * safezoneH + safezoneY;
			w = 0.488502 * safezoneW;
			h = 0.714064 * safezoneH;
		};
		class vts_gesture_bg_2 : vts_gesture_pic
		{
			idc = 1022;
			text = "functions\vtsgesturebg2.paa";
			x = 0.448962 * safezoneW + safezoneX;
			y = 0.441195 * safezoneH + safezoneY;
			w = 0.116657 * safezoneW;
			h = 0.154014 * safezoneH;
		};			
		class vts_gesture_text_1: vts_gesture_text
		{
			idc = 1001;
			text = "Move"; //--- ToDo: Localize;
			x = 0.45625 * safezoneW + safezoneX;
			y = 0.22 * safezoneH + safezoneY;
			w = 0.102083 * safezoneW;
			h = 0.21 * safezoneH;
			onMouseEnter ="vts_selected_gesture=""gestureGo"";";
			onMouseExit ="vts_selected_gesture="""";";
		};
		class vts_gesture_text_3: vts_gesture_text
		{
			idc = 1003;
			text = "No"; //--- ToDo: Localize;
			x = 0.572917 * safezoneW + safezoneX;
			y = 0.4475 * safezoneH + safezoneY;
			w = 0.145833 * safezoneW;
			h = 0.14 * safezoneH;
			onMouseEnter ="vts_selected_gesture=""gestureNo"";";
			onMouseExit ="vts_selected_gesture="""";";
		};
		class vts_gesture_text_7: vts_gesture_text
		{
			idc = 1007;
			text = "Yes"; //--- ToDo: Localize;
			x = 0.29585 * safezoneW + safezoneX;
			y = 0.447495 * safezoneH + safezoneY;
			w = 0.145821 * safezoneW;
			h = 0.140013 * safezoneH;
			onMouseEnter ="vts_selected_gesture=""gestureYes"";";
			onMouseExit ="vts_selected_gesture="""";";
		};
		class vts_gesture_text_2: vts_gesture_text
		{
			idc = 1002;
			text = "Point"; //--- ToDo: Localize;
			x = 0.572917 * safezoneW + safezoneX;
			y = 0.2725 * safezoneH + safezoneY;
			w = 0.116667 * safezoneW;
			h = 0.1575 * safezoneH;
			onMouseEnter ="vts_selected_gesture=""gesturePoint"";";
			onMouseExit ="vts_selected_gesture="""";";
		};
		class vts_gesture_text_5: vts_gesture_text
		{
			idc = 1005;
			text = "Freeze"; //--- ToDo: Localize;
			x = 0.45625 * safezoneW + safezoneX;
			y = 0.605 * safezoneH + safezoneY;
			w = 0.102083 * safezoneW;
			h = 0.21 * safezoneH;
			onMouseEnter ="vts_selected_gesture=""gestureFreeze"";";
			onMouseExit ="vts_selected_gesture="""";";
		};
		class vts_gesture_text_8: vts_gesture_text
		{
			idc = 1008;
			text = "Cover"; //--- ToDo: Localize;
			x = 0.325 * safezoneW + safezoneX;
			y = 0.2725 * safezoneH + safezoneY;
			w = 0.116667 * safezoneW;
			h = 0.1575 * safezoneH;
			onMouseEnter ="vts_selected_gesture=""gestureCover"";";
			onMouseExit ="vts_selected_gesture="""";";
		};
		class vts_gesture_text_6: vts_gesture_text
		{
			idc = 1006;
			text = "Come"; //--- ToDo: Localize;
			x = 0.325 * safezoneW + safezoneX;
			y = 0.605 * safezoneH + safezoneY;
			w = 0.116667 * safezoneW;
			h = 0.1575 * safezoneH;
			onMouseEnter ="vts_selected_gesture=""gestureFollow"";";
			onMouseExit ="vts_selected_gesture="""";";
		};
		class vts_gesture_text_4: vts_gesture_text
		{
			idc = 1004;
			text = "Cease"; //--- ToDo: Localize;
			x = 0.572917 * safezoneW + safezoneX;
			y = 0.605 * safezoneH + safezoneY;
			w = 0.116667 * safezoneW;
			h = 0.1575 * safezoneH;
			onMouseEnter ="vts_selected_gesture=""gestureCeaseFire"";";
			onMouseExit ="vts_selected_gesture="""";";
		};
	
	};
	////////////////////////////////////////////////////////
	// GUI EDITOR OUTPUT END
	////////////////////////////////////////////////////////
};