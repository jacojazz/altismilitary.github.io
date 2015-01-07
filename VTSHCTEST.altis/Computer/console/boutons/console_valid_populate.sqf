
disableSerialization;

_n = _this select 0;       
 
console_valid_populateciv = lbCurSel 10901;




if (_n == 0) then
{

  populatecivvalid=lbData [10901, console_valid_populateciv];

}
else
{
	if (isnil "civilian_factions") then {civilian_factions=[];};
	
  //Array
  _MydualList2=[];
  for "_i" from 0 to (count civilian_factions)-1 do
  {
	_faction=civilian_factions select _i;
	if (typename _faction=="STRING") then
	{
		if (_faction!="DEFAULT") then
		{
			_MydualList2 set [count _MydualList2,[_faction,_faction]];
		};
	};
  };
 
  [10901, _MydualList2] call Dlg_FillListBoxLists;
  
};

