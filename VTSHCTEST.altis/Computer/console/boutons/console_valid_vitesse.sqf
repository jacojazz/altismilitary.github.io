
disableSerialization;

_n = _this select 0;       
 
console_valid_vitesse = lbCurSel 10214;




if (_n == 0) then
{

  _vtsspeedselected=lbText [10214, console_valid_vitesse];
  nom_console_valid_vitesse = _vtsspeedselected ;
  var_console_valid_vitesse = _vtsspeedselected ;
  local_var_console_valid_vitesse = _vtsspeedselected ;

}
else
{
  //Array
  _MydualList2=[
	"Limited",
	"Normal",
	"Full"
	];
 
  if (isnil "vtsspeedselected") then {vtsspeedselected=0;};	 
  [10214, _MydualList2,vtsspeedselected] call Dlg_FillListBoxLists;
};
