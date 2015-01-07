
disableSerialization;

_n = _this select 0;       
 
console_valid_arty = lbCurSel 10041;

//hint format["%1",console_valid_music];


if (_n == 0) then
{

  Artyvalid=lbData [10041, console_valid_arty];
  //publicvariable "Artyvalid";


  

}
else
{
  //Array
  _MydualList2=[];
  
  if (isnil "ShopArtyAmmoList") then {ShopArtyAmmoList=[];};
  
  _MydualList2=_MydualList2+ShopArtyAmmoList;
 
  if (isnil "Artysave") then {Artysave=0;};	
  [10041, _MydualList2,Artysave] call Dlg_FillListBoxLists;

  
};


