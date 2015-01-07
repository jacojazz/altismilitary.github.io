disableSerialization;

_n = _this select 0;

/*
if (isnil "countvalidunite") then {countvalidunite=1;};
countvalidunite=countvalidunite+1;
hint format["%1",countvalidunite];
*/

console_valid_unite = lbCurSel 10306;
local_console_valid_unite = console_valid_unite;

_unitname=lbtext [10306, console_valid_unite]; 
_unitclass=lbdata [10306, console_valid_unite]; 

//hint _unitclass;

if (_n == 0) then 
{

			nom_console_valid_unite = _unitclass;
			
			//Check if we selected a special spawn  (like a custom group or else)
			if (_unitclass in vts_custom_group_list) then
			{
				call compile format["_unitclass=%1;",_unitclass];
			};
			
			console_unit_unite = _unitclass;
			local_console_unit_unite = _unitclass;
	
			[] spawn vts_displaysselectedpawninfo;
			
			[true] spawn Dlg_StoreParams;
};



If (true) ExitWith {};
