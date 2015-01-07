
disableSerialization;

_n = _this select 0;       
 
console_valid_zonepaintcolor = lbCurSel 10710;




if (_n == 0) then
{

  vts_zonepaintercolor=lbdata [10710, console_valid_zonepaintcolor];

}
else
{
  //Array
  _MydualList2=[
  ["Blue Grid","[0,""ELLIPSE"",""Grid"",""ColorBlue"",0.5]"],
  ["Red Grid","[0,""ELLIPSE"",""Grid"",""ColorRed"",0.5]"],
  ["Green Grid","[0,""ELLIPSE"",""Grid"",""ColorGreen"",0.5]"],
  ["Orange Grid","[0,""ELLIPSE"",""Grid"",""ColorOrange"",0.5]"],
  ["Blue Cross","[0,""ELLIPSE"",""Cross"",""ColorBlue"",0.5]"],
  ["Red Cross","[0,""ELLIPSE"",""Cross"",""ColorRed"",0.5]"],
  ["Green Cross","[0,""ELLIPSE"",""Cross"",""ColorGreen"",0.5]"],
  ["Orange Cross","[0,""ELLIPSE"",""Cross"",""ColorOrange"",0.5]"],
  ["Blue Solid","[0,""ELLIPSE"",""Solid"",""ColorBlue"",0.5]"],
  ["Red Solid","[0,""ELLIPSE"",""Solid"",""ColorRed"",0.5]"],
  ["Green Solid","[0,""ELLIPSE"",""Solid"",""ColorGreen"",0.5]"],
  ["Orange Solid","[0,""ELLIPSE"",""Solid"",""ColorOrange"",0.5]"]  
  ];
	 

 
  if (isnil "zonepaintcolorSave") then {zonepaintcolorSave=0;};	 
  [10710, _MydualList2,zonepaintcolorSave] call Dlg_FillListBoxLists;
  /*
  _combocolor=((findDisplay 8000)  displayCtrl 10710);
  _combocolor lbSetColor [0,[0.3,0.3,1.0, 1]];
  _combocolor lbSetColor [1,[0.9,0.3,0.3, 1]];
  _combocolor lbSetColor [2,[0.3,0.8,0.3, 1]];
  _combocolor lbSetColor [3,[0.85,0.55,0.2, 1]];
  */
  
};

