
disableSerialization;

_n = _this select 0;       
 
console_valid_attitude = lbCurSel 10211;




if (_n == 0) then
{

	_attitude=lbText [10211, console_valid_attitude];
  	nom_console_valid_attitude = _attitude ;
	var_console_valid_attitude = _attitude ;
	local_var_console_valid_attitude = _attitude ;

}
else
{
  //Array
  _MydualList2=[
		"Safe",
		"Aware",
		"Combat",
		"Stealth",
		"Careless"
		];
		
 
  if (isnil "vtsbehaviorselected") then {vtsbehaviorselected=0;};	 
  [10211, _MydualList2,vtsbehaviorselected] call Dlg_FillListBoxLists;

};
