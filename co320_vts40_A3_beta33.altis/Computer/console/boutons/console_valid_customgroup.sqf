
disableSerialization;

_n = _this select 0;       
 
console_valid_customgroup = lbCurSel 10237;




if (_n == 0) then
{

  customgroupvalid=lbData [10237, console_valid_customgroup];
  
		_array=customgroupvalid;
		if (isnil customgroupvalid) then {_array="""[]""";};
  		call compile format["
		[""---- Custom Group ----"",""%1"","""",""Group"",%2] spawn vts_displaysselectedpawninfo;
		",customgroupvalid,_array];

}
else
{
  //Array
  _MydualList2=[];
  for "_i" from 0 to 9 do
  {
	_MydualList2 set [count _MydualList2,["@Group_"+str(_i),"Custom_Group_"+str(_i)]];
  };
 
   if (isnil "Customgroupsave") then {Customgroupsave=0;};
  [10237, _MydualList2,Customgroupsave] call Dlg_FillListBoxLists;
  
};

