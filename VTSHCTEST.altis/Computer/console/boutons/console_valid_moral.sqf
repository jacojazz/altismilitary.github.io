// moral
_n=_this select 0;

if (typename _n=="ARRAY") then
{
  _n =_n select 1;
  _n=round(_n);
 

  
  console_unit_moral=_n/10;
  if (console_unit_moral==0) then {console_unit_moral=0.01};
  if (console_unit_moral>1) then {console_unit_moral=1.0};
  nom_console_valid_moral=str console_unit_moral;
  
  local_console_unit_moral=console_unit_moral;
  
  //hint format["%1",console_unit_moral];
  

  ctrlSetText [10220,("Skill----- "+nom_console_valid_moral)];
  //hint "send";
}
else
{
  sliderSetPosition [10225,(console_unit_moral*10)];
  ctrlSetText [10220,("Skill----- "+str(console_unit_moral))];
};

if (true) exitWith {};
