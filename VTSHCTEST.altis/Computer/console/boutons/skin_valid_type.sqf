disableSerialization;
_n = _this select 0;

private "_myDualList2";

_camp=var_skin_valid_camp;

skin_valid_type = lbCurSel 10305;

_type="man";

if (_n == 0) then 
{

		nom_skin_valid_type = "man" ;
		var_skin_valid_type = "man" ;


		//call compile format ["_MydualList2 = %1_%2 call Dlg_GenerateList",_camp,_type];
		call compile format ["_MydualList2 = %1_%2",_camp,_type];
		_newduallist=[];
		for "_i" from 0 to (count _MydualList2)-1 do
		{
			_class=_MydualList2 select _i;
			_newduallist set [count _newduallist,[([_class] call vts_getvehicleclassdisplayname)+(gettext (configfile >> "CfgVehicles" >> _class >> "displayName")),_class]];
		};
		[10306, _newduallist] call Dlg_FillListBoxLists;
		lbsort ((findDisplay 8003)  displayCtrl 10306);

};


if (true) exitWith {};
