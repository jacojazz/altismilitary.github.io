disableSerialization;
// camp

_n = _this select 0;

private "_MydualList";

skin_valid_camp = lbCurSel 10203;

_camp=lbdata [10203, skin_valid_camp]; 
_nomcamp=lbText [10203, skin_valid_camp]; 

//private ["var_console_valid_camp"];

if (_n == 0) then
{

		nom_skin_valid_camp =  _nomcamp;
		var_skin_valid_camp =  _camp;
		
		//player sidechat var_skin_valid_camp;
		
		_MydualList = globalcamp_types;

		[10305, _MydualList] spawn Dlg_FillListBoxLists;
		
		_n = [0] execVM "computer\console\boutons\skin_valid_type.sqf"; _time=time+10;waitUntil {scriptDone _n or _time<time};
    _n = [0] execVM "computer\console\boutons\skin_valid_unite.sqf"; _time=time+10;waitUntil {scriptDone _n or _time<time};
};
if (true) exitWith {};
