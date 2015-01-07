
_n=_this select 0;
// 10 * _atlm;
_altm=25;

if (typename _n=="ARRAY") then
{
  _n =_n select 1;
  _n=round(_n*_altm);
   
  //hint format["%1",_n];
  brume=[brume select 0,_n];

  ctrlSetText [200,"Fog Atlitude set to : "+str(_n)+" M"];

  //ctrlSetText [10220,("Skill----- "+nom_console_valid_moral)];

}
else
{
  sliderSetPosition [10234,((brume select 1)/_altm)];
  if (vtsarmaversion<3) then
  {
	ctrlShow [10234,false];
  };
  
  //ctrlSetText [10220,("Skill----- "+str(console_unit_moral))];
};

//Update fog text
_txt="D:"+str((brume select 0)*10);
if ((brume select 1)!=0) then {_txt=_txt+" A:"+str(brume select 1);};
ctrlSetText [10033,_txt];

if (true) exitWith {};
