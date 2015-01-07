private ["_data","_filter"];
_data=_this select 0;
_filter=0;
if (count _this>1) then { _filter=_this select 1;};

if (typeName _data=="STRING") exitwith {_data};

if (typeName _data=="ARRAY") then
{
  _n = (count _data)-1;
  if (_n>=0) then
  {
    _pickup=_data select (round(random _n));
	//Filter to only take groud units
	if (_filter==1) then
	{
		//player sidechat _pickup;
		_selector=0;
        while
		{(!([_pickup] call vts_islandman) or ([_pickup,"target"] call KRON_StrInStr)) && (_selector<count _data)}
		do
		{
			_selector=_selector+1;
			//player sidechat _pickup;
			_pickup=_data select _selector;
		};
	
		
      	
	};
    _data=_pickup;
  }
  else {_data="";};
};

if (isnil "_data") then {_data="";};

_data
