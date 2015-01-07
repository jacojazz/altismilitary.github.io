disableSerialization;
// side

_n = _this select 0;

private ["_MydualList","_Newlist","_CurItem"];

console_valid_side = lbCurSel 10206;

_sidename=lbText [10206, console_valid_side];
_side=lbdata [10206, console_valid_side]; 
		
//private ["var_console_valid_camp"];

if (_n == 0) then
{

	
	nom_console_valid_side =  _sidename;
	var_console_valid_side =  _side;
	local_var_console_valid_side =  _side;
		
	call compile format["if !(isnil ""%1_factions"") then {_MydualList = %1_factions;};",var_console_valid_side];

	if (isnil "_MydualList") exitwith {};
	
	_Newlist=[];
	for "_i" from 0 to (count _MydualList)-1 do
	{
		_CurItem=_MydualList select _i;
		if (typename _CurItem=="STRING") then
		{
			_Newlist set [count _Newlist,[([ _CurItem,"Faction"] call vts_GetClassDisplayName),_CurItem,(gettext (configfile >> "CfgFactionClasses" >> _CurItem >> "icon"))]];
		};
	};
	_MydualList=_Newlist;
	
	if (isnil "Campsave") then {Campsave=0;};
	[10203, _MydualList,Campsave] call Dlg_FillListBoxLists;
	//player sidechat str _Newlist;
    
	ctrlShow [10600,true];
	ctrlShow [10559,true];
	ctrlShow [10556,true];
	ctrlShow [10554,true];	
	if (local_var_console_valid_side=="OBJECT") then
	{
		ctrlShow [10600,false];
		ctrlShow [10559,false];
		ctrlShow [10556,false];
		ctrlShow [10554,false];	
	};
};




if (true) exitWith {};

