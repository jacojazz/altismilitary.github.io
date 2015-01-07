

/*  Controls       */


// Control types
#define CT_STATIC           0
#define CT_BUTTON           1
#define CT_EDIT             2
#define CT_ACTIVETEXT       11
#define CT_STRUCTURED_TEXT  13
#define CT_LISTBOX          5
#define CT_COMBO            4
#define CT_MAP_MAIN         101
#define CT_SLIDER           3


#define CT_TOOLBOX          6
#define CT_CHECKBOXES       7
#define CT_PROGRESS         8
#define CT_HTML             9
#define CT_STATIC_SKEW      10
#define CT_TREE             12

#define CT_CONTEXT_MENU     14
#define CT_CONTROLS_GROUP   15
#define CT_XKEYDESC         40
#define CT_XBUTTON          41
#define CT_XLISTBOX         42
#define CT_XSLIDER          43
#define CT_XCOMBO           44
#define CT_ANIMATED_TEXTURE 45
#define CT_OBJECT           80
#define CT_OBJECT_ZOOM      81
#define CT_OBJECT_CONTAINER 82
#define CT_OBJECT_CONT_ANIM 83
#define CT_LINEBREAK        98
#define CT_USER             99
#define CT_MAP              100


// Static styles
#define ST_POS            0x0F
#define ST_HPOS           0x03
#define ST_VPOS           0x0C
#define ST_LEFT           0x00
#define ST_RIGHT          0x01
#define ST_CENTER         0x02
#define ST_DOWN           0x04
#define ST_UP             0x08
#define ST_VCENTER        0x0c

#define ST_TYPE           0xF0
#define ST_SINGLE         0
#define ST_MULTI          16
#define ST_TITLE_BAR      32
#define ST_PICTURE        48
#define ST_FRAME          64
#define ST_BACKGROUND     80
#define ST_GROUP_BOX      96
#define ST_GROUP_BOX2     112
#define ST_HUD_BACKGROUND 128
#define ST_TILE_PICTURE   144
#define ST_WITH_RECT      160
#define ST_LINE           176

#define ST_SHADOW         0x100
#define ST_NO_RECT        0x200
#define ST_KEEP_ASPECT_RATIO  0x800

#define ST_TITLE          ST_TITLE_BAR + ST_CENTER

// Slider styles

#define SL_DIR            0x400
#define SL_VERT           0
#define SL_HORZ           0x400

#define SL_TEXTURES       0x10

// Listbox styles
#define LB_TEXTURES       0x10
#define LB_MULTI          0x20

/*
/*******************/
//  Basic classes  */

class VTS_RscBackground
{
	type = CT_STATIC;
	IDC = -1;
	style = 512;
	x=0.0;
	y=0.0;
	w=1.0;
	h=1.0;
	text="";
	ColorBackground[]={0.6,0.6,0.6,1};
	ColorText[]={0.1,0.1,0.1,1};
	font="TahomaB";//
	SizeEx = 1;
};

class VTS_RscPicture
{
	type=0;
    idc=-1;
    style=2;
    colorBackground[]={0,0,0,0};
    colorText[]={1,1,1,1};
    font="TahomaB";//
    size=3;
};

class VTS_RscText
{
	type = CT_STATIC;
	IDC = -1;
	style = ST_LEFT + ST_MULTI + ST_NO_RECT;
	LineSpacing = 1.000000;
	h = 0.040000;
	ColorBackground[] = {1,1,1,0.2};
	ColorText[] = {0.1,0.1,0.1,1};
	// ColorBackground[] = CA_UI_grey;
	// ColorText[] = Color_Black;
	font="TahomaB";//
	SizeEx = 0.030000;
	Size = 0.030000;
	
};

class VTS_RscEdit
{
       type = CT_EDIT;
       idc = -1;
       style = ST_LEFT;
       font = LucidaConsoleB;
       sizeEx = 0.018;
	   colorDisabled[] = { 1, 0, 0, 1 }; // text color for disabled state 	   
       colorText[] = {0, 0, 0, 1};
       colorSelection[] = {0.5, 0.5, 0.5, 1};
       autocomplete = true;
       text = ;
};


class VTS_boutons 
	{ 
	idc = -1; 
	type = CT_BUTTON ; 
	style = ST_LEFT; 
	font="TahomaB";//
	sizeEx = 0.02; 
	colorText[] = { 0.9,0.9,0.9, 1 }; 
	colorFocused[] = { 0, 0, 0, 1 }; // border color for focused state 
	colorDisabled[] = { 1, 0, 0, 1 }; // text color for disabled state 
	colorBackground[] = { 0, 0, 0, 0.7 }; 
	colorBackgroundDisabled[] = { 0, 0, 0, 1 }; // background color for disabled state 
	colorBackgroundActive[] = { 0, 0, 0, 0 }; // background color for active state 
	offsetX = 0.003; 
	offsetY = 0.003; 
	offsetPressedX = 0.002; 
	offsetPressedY = 0.002; 
	colorShadow[] = { 0, 0, 0, 0.5 };
	colorBorder[] = { 0, 0, 0, 1 }; 
	borderSize = 0; 
	soundEnter[] = { "", 0, 1 }; // no sound 
	soundPush[] = { "", 0.1, 1 }; 
	soundClick[] = { "", 0, 1 }; // no sound 
	soundEscape[] = { "", 0, 1 }; // no sound 
	};

	class VTS_RscStructuredText
{
	access = ReadAndWrite;
	type = CT_STRUCTURED_TEXT;
	idc = -1;
	style = ST_CENTER + ST_MULTI;
	lineSpacing = 1;
	w = 0.1;
	h = 0.05;
	size = 0.0170;
	colorBackground[] = {0,0,0,0};
	colorText[] = {0,0,0,0};
	text = "";
	font="TahomaB";//
	sizeEx = 0.02; 
	class Attributes {
		font="TahomaB";//
		color = "#ffffff";
		align = "left";
		shadow = true;
	};
};
		
class VTS_RscText2
{
	type = CT_STATIC;
	IDC = -1;
	style = ST_LEFT + ST_MULTI + ST_NO_RECT;
	LineSpacing = 1.000000;
	h = 0.040000;
	ColorBackground[] = {1,1,1,0.2};
	ColorText[] = {0.1,0.1,0.1,1};
	// ColorBackground[] = CA_UI_grey;
	// ColorText[] = Color_Black;
	font="TahomaB";//
	SizeEx = 0.030000;
	Size = 0.030000;
	
};

class VTS_RscActiveText
{
	type = CT_ACTIVETEXT;
	style = ST_LEFT;
	SizeEx = 0.05;
	font="TahomaB";//
	color[]= {1,1,1,0.8};
	colorActive[] = {1, 1, 1,1};
	soundEnter[] = {"", 0.1, 1};
	soundPush[] = {"", 0.1, 1};
	soundClick[] = {"", 0.1, 1};
	soundEscape[] = {"", 0.1, 1};
	text = "";
};


class VTS_RscListBox
{
		type = CT_LISTBOX;
        style = ST_LEFT;
        idc = -1;
		colorSelect[] = {0.9,0.9,0.9, 1 };
		colorSelectBackground[] = {1,1,1,0.2}; 
		colorSelectBackground2[] = {1,1,1,0.2};			
		colorText[] = { 0.9,0.9,0.9, 1 };
		colorScrollbar[] = {0, 0, 0, 1};
		colorBackground[] = { 0, 0, 0, 0.7 };
		colorBorder[] = {0, 0, 0, 1};
		colorShadow[] = {0, 0, 0, 1};
		colorDisabled[] =  {0.9,0.9,0.9, 1};
		colorSelection[] = {0.5, 0.5, 0.5, 1};		
		soundSelect[] = { "", 0, 1 };
		soundExpand[] = { "", 0, 1 };
		soundCollapse[] = { "", 0, 1 };		
        font = "TahomaB";
        sizeEx = 0.02; 
        rowHeight = 0.02;
		offsetX = 0.003;
	    offsetY = 0.003;
	    offsetPressedX = 0.002;
	    offsetPressedY = 0.002;
	    colorFocused[] = {1,0,0,0};
		borderSize = 0.0;	
		autoScrollSpeed = -1;
		autoScrollDelay = 5;
		autoScrollRewind = 0;		
		maxHistoryDelay = 1.0;
		class ScrollBar 
		{
			color[] = {1, 1, 1, 0.6};
			colorActive[] = {1, 1, 1, 1};
			colorDisabled[] = {1, 1, 1, 0.3};
			thumb = "#(argb,8,8,3)color(1,1,1,1)";
			arrowEmpty = "#(argb,8,8,3)color(1,1,1,1)";
			arrowFull = "#(argb,8,8,3)color(1,1,1,1)";
			border = "#(argb,8,8,3)color(1,1,1,1)";
			autoScrollEnabled = 1;
			autoScrollSpeed = -1;
			autoScrollRewind = 0;
			autoSCrollDelay = 0;
		};
		
		class ListScrollBar 
		{
			color[] = {1, 1, 1, 0.6};
			colorActive[] = {1, 1, 1, 1};
			colorDisabled[] = {1, 1, 1, 0.3};
			thumb = "#(argb,8,8,3)color(1,1,1,1)";
			arrowEmpty = "#(argb,8,8,3)color(1,1,1,1)";
			arrowFull = "#(argb,8,8,3)color(1,1,1,1)";
			border = "#(argb,8,8,3)color(1,1,1,1)";
			autoScrollEnabled = 1;
			autoScrollSpeed = -1;
			autoScrollRewind = 0;
			autoSCrollDelay = 0;
		};			
		
};

class VTS_RscEdit2
{
       type = CT_EDIT;
       idc = -1;
       style = ST_LEFT;
       font="TahomaB";//
       sizeEx = 0.018;
       colorText[] = {0, 0, 0, 1};
       colorSelection[] = {0.5, 0.5, 0.5, 1};
       autocomplete = true;
       text = ;
};

class VTS_RscSlider;


class VTS_combo
{	
	idc = -1;
	type = CT_COMBO;
	style = ST_LEFT; 
	colorSelect[] = {0.9,0.9,0.9, 1 };
	colorSelectBackground[] = {0.9,0.9,0.9,0.1}; 
	colorText[] = { 0.9,0.9,0.9, 1 };
	colorScrollbar[] = {0, 0, 0, 1};
	colorBackground[] = { 0, 0, 0, 0.7 };
	colorBorder[] = {0, 0, 0, 1};
	colorShadow[] = {0, 0, 0, 1};
	soundSelect[] = { "", 0, 1 };
	soundExpand[] = { "", 0, 1 };
	soundCollapse[] = { "", 0, 1 };
	colorDisabled[] =  {0.9,0.9,0.9, 1};
	colorSelection[] = {0.5, 0.5, 0.5, 1};	
	borderSize = 0;
	font = "TahomaB";
	sizeEx = 0.02; 
	rowHeight = 0.025;
	wholeHeight = 10 * 0.025; // 3 lines to display + 1 line of the unelapsed control 
	text = "";
	maxHistoryDelay = 0;
	default = true;
	
	x = 0; y = 0;
	w = 0; h = 0;
	
		thumb = "#(argb,8,8,3)color(1,1,1,1)";
		arrowEmpty = "#(argb,8,8,3)color(1,1,1,1)";
		arrowFull = "#(argb,8,8,3)color(1,1,1,1)";
		border = "#(argb,8,8,3)color(1,1,1,1)";
	
	autoScrollSpeed = -1;
	autoScrollDelay = 5;
	autoScrollRewind = 0;

	class ScrollBar 
	{
		color[] = {1, 1, 1, 0.6};
		colorActive[] = {1, 1, 1, 1};
		colorDisabled[] = {1, 1, 1, 0.3};
		thumb = "#(argb,8,8,3)color(1,1,1,1)";
		arrowEmpty = "#(argb,8,8,3)color(1,1,1,1)";
		arrowFull = "#(argb,8,8,3)color(1,1,1,1)";
		border = "#(argb,8,8,3)color(1,1,1,1)";
			autoScrollEnabled = 1;
			autoScrollSpeed = -1;
			autoScrollRewind = 0;
			scrollSpeed = 0;
			autoSCrollDelay = 0;
	};
	class ComboScrollBar 
	{
		color[] = {1, 1, 1, 0.6};
		colorActive[] = {1, 1, 1, 1};
		colorDisabled[] = {1, 1, 1, 0.3};
		thumb = "#(argb,8,8,3)color(1,1,1,1)";
		arrowEmpty = "#(argb,8,8,3)color(1,1,1,1)";
		arrowFull = "#(argb,8,8,3)color(1,1,1,1)";
		border = "#(argb,8,8,3)color(1,1,1,1)";
			autoScrollEnabled = 1;
			autoScrollSpeed = -1;
			autoScrollRewind = 0;
			scrollSpeed = 0;
			autoSCrollDelay = 0;
	};
};

