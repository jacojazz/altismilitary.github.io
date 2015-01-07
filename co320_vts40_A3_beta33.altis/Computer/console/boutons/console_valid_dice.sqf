disableSerialization;

_n = _this select 0;      
 
if (_n == 0) then
{
	
        _txt=lbdata [10611,(lbCurSel 10611)];
		if (_txt!="") then
		{
			[] call compile _txt;
		};
	
}
else
{
	_MydualList2=
	[
		
		["Roll a dice",""],
		["Roll a D2","hint format[""You roll a D2 for : %1"",round(random 1)+1];"],
		["Roll a D3","hint format[""You roll a D3 for : %1"",round(random 2)+1];"],
		["Roll a D6","hint format[""You roll a D6 for : %1"",round(random 5)+1];"],
		["Roll a D20","hint format[""You roll a D20 for : %1"",round(random 19)+1];"]
		
	];
 
	[10611, _MydualList2] spawn Dlg_FillListBoxLists;
};
