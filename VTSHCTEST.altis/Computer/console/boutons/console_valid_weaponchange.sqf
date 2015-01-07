
disableSerialization;

_n = _this select 0;       
 
console_valid_weapon = lbCurSel 10921;

//hint format["%1",console_valid_music];


if (_n == 0) then
{

  weaponvalid=lbData [10921, console_valid_weapon];
  //publicvariable "ammunitionvalid";
}
else
{
	//Array
	//Generating available weapon list
	if (isnil "ShopWeaponList") then {ShopWeaponList=[];};
	
	_weapons=[];
	{
		_class=nil;
		call compile format ["_class=(ConfigFile >> %1);",_x];
		
		if (((getnumber (_class >> "scope"))>1) &&  ((getnumber (_class >> "type"))==1)) then
		{
			
			//_weapons set [count _weapons,[gettext (_class >> "displayname"),(configname _class)]];
			_weapons set [count _weapons,[(configname _class),(configname _class)]];
		};

		
	}
	foreach ShopWeaponList;  
  
  _MydualList2=[["Random","Random"]];
  
  _MydualList2=_MydualList2+_weapons;
 
  if (isnil "vtsWeaponsave") then {vtsWeaponsave=0;};	  
  [10921, _MydualList2,vtsWeaponsave] call Dlg_FillListBoxLists;

  
};


