_pos=_this select 0;

_spawn_x=_pos select 0;
_spawn_y=_pos select 1;

_currentcamp=_this select 1;
_radius=_this select 2;
_side=_this select 3;
_skill=_this select 4;


//Get all vehicles in the area

_list = [[_spawn_x,_spawn_y,0],["Car","Truck","Tank","Helicopter","Plane","Ship"],_radius] call vts_nearestobjects2d;

_newlist=[];
for "_i" from 0 to (count _list)-1 do
{
	_vehicle=_list select _i;
	if ((side _vehicle==_side) or (side _vehicle==civilian)) then
	{
		_add=false;
		_cargook=false;
		//Check cargo available
		if ((_vehicle emptyPositions "cargo">0) && (canmove _vehicle)) then
		{
			_cargook=true;
		};
		//Fill empty vehicles only (empty are tagged as civilian but... what if we want to cargo civilian or other side in emtpy vehicle?)
		if ((side _vehicle==civilian) && (_side!=civilian)) then
		{
			if (count (crew _vehicle)<1) then 
			{
				_add=true;
			};
		}
		else
		{
			_add=true;
		};
		if (_add && _cargook) then {_newlist set [count _newlist,_vehicle];};
	};
};
_list=_newlist;

_go=true;
//No vehicle = end
_feedback="";
if ((count _list)==0) then {breakclic = 0;_go=false;_feedback="!!! No valid vehicles of the same side with available cargo space has been found !!!";};

_units=[];
call compile format["_units=%1_Man;",_currentcamp];

//Filter no ground units (diver etc)
_newunits=[];
for "_i" from 0 to (count _units)-1 do 
{
	_soldier=_units select _i;
	if ([_soldier] call vts_islandman) then 
	{
		_newunits set [count _newunits,_soldier];
	};
};
_units=_newunits;

if (count _units<1) then {breakclic = 0;_go=false;_feedback="!!! No Men in this faction !!!";};

_vehiclenum=0;
_grpnum=0;
private ["_tmpdrivergroup"];
if (_go) then
{
	//Create group with random unti for each cargo
	for "_i" from 0 to (count _list)-1 do 
	{
		_vehicle=_list select _i;
		_cargospace=_vehicle emptyPositions "cargo";
		_adddriver=false;
		_addcommander=false;
		_addgunner=false;
		if ((_vehicle emptypositions "driver")>0) then
		{
			_adddriver=true;
		};
		if ((_vehicle emptypositions "commander")>0) then
		{
			_addcommander=true;
		};	
		if ((_vehicle emptypositions "gunner")>0) then
		{
			_addgunner=true;
		};		
		
		if (_cargospace>0) then
		{
			_tmpgroup=creategroup _side;
			_vehiclenum=_vehiclenum+1;
			_grpnum=_grpnum+1;
			for "_b" from 1 to _cargospace do
			{
				_soldiertospawn=_units select (floor(random (count _units)));
				_newUnit=_tmpgroup createunit [_soldiertospawn,[1,10,1],[],0,"NONE"];

			};
			{
				[_x,_skill] call vts_setskill;
				_x assignAsCargo _vehicle;
				_x moveincargo _vehicle;
			} foreach units _tmpgroup;
			
			if (_adddriver or _addcommander or _addgunner) then
			{
				_grpnum=_grpnum+1;
				_soldiertospawn=_units select (floor(random (count _units)));
				_tmpdrivergroup=creategroup _side;				
				if (_adddriver) then
				{
					_newUnit=_tmpdrivergroup createunit [_soldiertospawn,[1,10,1],[],0,"NONE"];
					[_newUnit,_skill] call vts_setskill;
					_newUnit assignAsdriver _vehicle;
					_newUnit moveindriver _vehicle;
				};
				if (_addcommander) then
				{
					_newUnit=_tmpdrivergroup createunit [_soldiertospawn,[1,10,1],[],0,"NONE"];
					[_newUnit,_skill] call vts_setskill;
					_newUnit assignAscommander _vehicle;
					_newUnit moveincommander _vehicle;
				};
				if (_addgunner) then
				{
					_newUnit=_tmpdrivergroup createunit [_soldiertospawn,[1,10,1],[],0,"NONE"];
					[_newUnit,_skill] call vts_setskill;
					_newUnit assignAsgunner _vehicle;
					_newUnit moveingunner _vehicle;
				};					
				_wp = _tmpdrivergroup addwaypoint [position _vehicle,0];
				_wp setwaypointtype "MOVE";
				_wp setwaypointbehaviour "SAFE";

			};
		};
	};
};

_code=nil;
if (_feedback=="") then
{
	call compile format["
	_code={
	if ([player] call vts_getisGM) then {""Fill cargo result : %1 vehicle(s) filled with %2 group(s)"" spawn vts_gmmessage;};
	};
	",_vehiclenum,_grpnum];
}
else
{
	call compile format["
	_code={
	if ([player] call vts_getisGM) then {""%1"" spawn vts_gmmessage;};
	};
	",_feedback];
};
[_code] call vts_broadcastcommand;