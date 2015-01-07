
_n=_this select 0;
// 10 * _atlm;

if (typename _n=="ARRAY") then
{
  _n =_n select 1;
  _n=round _n;
   
  //hint format["%1",_n];
  brume=[(_n/10),brume select 1];

  ctrlSetText [200,"Fog density set to : "+str(_n)];

  //ctrlSetText [10220,("Skill----- "+nom_console_valid_moral)];
	
}
else
{
  sliderSetPosition [10235,(brume select 0)*10];
  //ctrlSetText [10220,("Skill----- "+str(console_unit_moral))];
};

//Update fog text
_txt="D:"+str((brume select 0)*10);
if ((brume select 1)!=0) then {_txt=_txt+" A:"+str(brume select 1);};
ctrlSetText [10033,_txt];

if (true) exitWith {};
