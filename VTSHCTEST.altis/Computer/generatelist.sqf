//Generate an array with units list entered units in side config.
//test : [""vts2_Mani""] execVM ""Computer\generatelist.sqf""

private ["_array","_b","_test","_n","_varstring","_unitvarname","_index","_ok"];

ExistingVar=
{
  _b=false;
  call compile format["if (!isNil ""%1%2"") then {_b=true;};",_unitvarname,_n];
  //hint format["if (!isNil ""%1%2"") then {_b=true;};",_unitvarname,_n];
  _b
};

_array=[];
_unitvarname=_this select 0;
_n=1;
_index=0;

_ok=[_unitvarname,_n] call ExistingVar;

while {_ok} do
{
  call compile format["_array set [count _array,[%1%2,""%3""]];",_unitvarname,_n,_index];
  _n=_n+1;
  _index=_index+1;
   _ok=[_unitvarname,_n] call ExistingVar;
};


//hint format["%1",_array];
_array
