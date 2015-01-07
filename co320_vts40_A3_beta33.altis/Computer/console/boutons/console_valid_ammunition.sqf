
disableSerialization;

_n = _this select 0;       
 
console_valid_ammunition = lbCurSel 10918;

//hint format["%1",console_valid_music];


if (_n == 0) then
{

  ammunitionvalid=lbData [10918, console_valid_ammunition];
  //publicvariable "ammunitionvalid";


  

}
else
{
  //Array
  _MydualList2=[];
  
  if (isnil "SpawnableAmmoList") then {SpawnableAmmoList=[];};
  _MydualList2=_MydualList2+SpawnableAmmoList;
 
  if (isnil "Ammosave") then {Ammosave=0;};	
  [10918, _MydualList2,Ammosave] call Dlg_FillListBoxLists;

  
};


