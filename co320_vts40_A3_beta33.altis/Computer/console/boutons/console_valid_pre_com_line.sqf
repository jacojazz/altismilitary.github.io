disableSerialization;

_n = _this select 0;      
 
console_valid_pre_com_line = lbCurSel 10606;

if (_n == 0) then
{
          _txt=lbText [10606,(lbCurSel 10606)];
          if (_txt=="command line example") then {_txt="";};
          ctrlSetText [10243,_txt]
         
}
else
{
  _MydualList2=
      [
                ["command line example","0"],
                ["vehicle leader user1 setfuel 0","1"],
                ["vehicle leader user1 setdamage 1","2"],
                ["{_x setCaptive true; removeAllWeapons _x; doStop _x;} forEach group user1","3"],
                ["[user1,user2,user3] join user4","4"],
                ["veh1 lock true","5"],
                ["removeAllWeapons (leader user1)","6"],
                ["user1 doMove (getpos user2)","7"],
                ["user1 moveInCargo truck1","8"],
                ["doGetOut user1","9"],
                ["vts_x setObjectTextureglobal [0,""#(rgb,8,8,3)color(1,0,0,0.25)""];","10"],
                ["hostage1 playMove ""ActsPercMstpSnonWpstDnon_sceneBardak01""","11"],
                ["user1 addRating -100","12"],
				["[user1] call vts_enablevehiclenitro","13"],
				["[vts_x,user1] spawn vts_Isfollowing",""],
				["[user1,2000] call vts_setheight",""],
                ["hint format[""%1"", debug ];","14"],
				["[user1,""WEST""] call vts_SetBasePos;",""],
				["[user1,""EAST""] call vts_SetBasePos;",""],
				["[user1,""GUER""] call vts_SetBasePos;",""],
				["[user1,""CIV""] call vts_SetBasePos;",""],
				["[user4,true] call vts_EnableGM;",""],
				["if (player==user1) then {[user1,user1,""""] execvm ""spectator\specta.sqf"";};","15"],
				["if (player==user1) then {[user1,getpos user1] execVM ""Computer\VTS_FreeCam.sqf"";};","16"],
                ["[] execvm ""mods\config\generatingconfig.sqf"";","17"],
                ["[] call bis_fnc_help;","18"],
				["[] call bis_fnc_configviewer;","19"],
				["[] call bis_fnc_camera;","20"],
				["[] call vts_ShowObjectsOwner","21",""]
       ];
	_MydualList2=_MydualList2+vts_customprecommands;
  [10606, _MydualList2] spawn Dlg_FillListBoxLists;
};
