
disableSerialization;

_n = _this select 0;       
 
console_valid_color = lbCurSel 10705;

//hint format["%1",console_valid_music];

if (_n == 0 || _n == 2) then
{
  switch (console_valid_color) do 
  {
	  case 0: {effectoldcolor=console_valid_color};
	  case 1: {colorsarray=[1, 1, 0, [0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 1], [0.0, 0.0, 0.0, 0.0]]};
	  case 2: {colorsarray=[1, 0.8, -0.001, [0.0, 0.0, 0.0, 0.0], [0.8*2, 0.5*2, 0.0, 0.7], [0.9, 0.9, 0.9, 0.0]]};
	  case 3: {colorsarray=[1, 1, -0.008, [0.0, 0.8, 0.9, 0.002], [1.0, 0.8, 0.7, 0.5], [1, 1, 0, 0.0]]};
	  case 4: {colorsarray=[1, 0.75, 0, [0.4,0.45,0.5,-0.1], [1,1,1,4], [-0.5,0,-1,5]]};
	  case 5: {colorsarray=[1, 1, 0, [0.0, 0.0, 0.0, 0.0], [0.6, 1.4, 0.6, 0.7],  [0.199, 0.587, 0.114, 0.0]]};
	  case 6: {colorsarray=[1, 1, 0, [0.0, 0.0, 0.0, 0.0], [1.8, 1.8, 0.3, 0.7],  [0.199, 0.587, 0.114, 0.0]]};
	  case 7: {colorsarray=[1, 1.04, -0.004, [0.0, 0.0, 0.0, 0.0], [1, 0.8, 0.6, 0.5], [0.199, 0.587, 0.114, 0.0]]};
	  case 8: {colorsarray=[1, 1, 0, [0.0, 0.0, 0.0, 0.0], [0.40, 0.30, 0.3, 0.3], [1, 1, 1, 0.0]]};
	  case 9: {colorsarray=[1, 1, 0, [0.4,0.45,0.5,-0.1], [1,1,1,6], [-0.5,0,-1,5]]};
	  default {effectoldcolor=console_valid_color};
  };
 
  if (effectoldcolor!=console_valid_color) then 
  {
	  effectoldcolor=console_valid_color;
	  if (_n==0) then
	  {
		"Light effects: Changed on GM only" call vts_gmmessage;
		"colorCorrections" ppEffectAdjust colorsarray;"colorCorrections" ppEffectCommit 1;
	  };
  };
  if (_n==2) then
  {
	  "Light effects: Changed on All players" call vts_gmmessage;
	  publicvariable "colorsarray";
	  _code=compile format[" ""colorCorrections"" ppEffectAdjust %1;""colorCorrections"" ppEffectCommit 1;",colorsarray];
	  _sync=[_code] call vts_broadcastcommand;
  };  
  
}
else
{
  //Colors
  _MydualList2=
      [
        ["Light effects","0"],
        ["Standard","1"],
        ["Nuclear","2"],
        ["Stalker","3"],
        ["Bright burning","4"],
        ["Flashpoint","5"],
        ["Gold Autumn","6"],
        ["Metal summer","7"],
        ["Red spring","8"],
		["Clear Night","9"]
       ];
 
    [10705, _MydualList2] spawn Dlg_FillListBoxLists;
};


