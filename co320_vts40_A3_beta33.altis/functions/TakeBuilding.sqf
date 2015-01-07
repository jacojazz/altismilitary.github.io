//*******************************************************************************
//**************** Populate building base on selectionned camp ******************
//*******************************************************************************

_position = _this select 0;

//Vars
_areasize = _this select 2; //Size of the brush where to fill buildings
_spawnpercent = _this select 1;//% of the chance to spawn an unit at a building position

//Lets pick our arrays of units first
_units=[];

//Select camp
if (count _this>3) then {var_console_valid_camp=_this select 3;};
call compile format["_units=%1_Man;",var_console_valid_camp];

if (isnil "_units" or count _units<1) exitwith {hint "!!! no men for this camp !!!"};

_unitsnum=count _units;

if (count _this>4) then {var_console_valid_side=_this select 4;};
if (var_console_valid_side=="object") exitwith {hint "!!! Invalid side / army selectionned !!!";};

_inbuildingskill=0.3;
if (count _this>5) then {_inbuildingskill=_this select 5;};

//Let's count how much houses can be filled with freash meat and create a fillable array
_validhouses=[];
_houses = nearestObjects [[_position select 0, _position select 1], ["Building"], _areasize];
_housenum = count _houses;
_housepos=[];
_numvalidhouse=0;
for "_x" from 0 to (_housenum-1) do
{
	_currenthouse=_houses select _x;
	_n=_currenthouse call buildingPosCount; 
	if (_n>0) then
	{
		for "_i" from 0 to (_n-1) do
		{
			_housepos set [count _housepos,_currenthouse buildingPos _i];
		};
	_numvalidhouse=_numvalidhouse+1;
	};
};
//player sidechat format["%1",_housepos];


_numvalidpos=count _housepos;
//_group = createGroup east;
//      hint format["%1",_numvalidhouse];

if (_numvalidpos<1) exitwith {hint "!!! No building with interior detected in the area !!!";};

//Now i know my fillable houses, let's the fun begin

//First, we create a group faction from the selected side

_SpawnSide=""; 
call compile format["_SpawnSide=%1;",var_console_valid_side];
_group=createGroup _SpawnSide;
_tempgroup=createGroup _SpawnSide;

//player sidechat format["%1 %2 %3",_logic,_group,_tmpgroup];

_spawned=0;

//How much spawn are we gonna get ?
_numtospawn=round(_numvalidpos*(_spawnpercent/100));
//Let's fill house one by one
for "_i" from 0 to _numtospawn do
{

	//Check if there is still pos available for unit to fill
	if (count _housepos>0) then
	{
		if ((_i!=0) && (_i mod 64==0)) then 
		{
			//player sidechat str _i;
			_group = createGroup _SpawnSide;
		};
		//player sidechat format["%1 %2 %3",_logic,_group,_tempgroup];
		_unittospawn=_units select (round(random(_unitsnum-1)));
		if !([_unittospawn] call vts_islandman) then
		{
		_unittospawn=_units select 0;
		};
		
		_buildingpos=_housepos select (floor(random _numvalidpos));
		_housepos=_housepos-_buildingpos;
		if (isnull _tempgroup) then {_tempgroup=createGroup _SpawnSide;};
		_unit = _tempgroup createUnit [_unittospawn,_buildingpos,[],0,"NONE"];
		//_unit disableAI "MOVE";
		//_unit disableAI "TARGET";
		[_unit] joinsilent _group;
		
		_unit setpos _buildingpos;
		_unit setUnitPosWeak "UP";
		_unit setUnitPos "UP";

		
		[_unit,_inbuildingskill] call vts_setskill;
		_unit switchmove "";
		_unit setDir (random 360);
		
		_unit setBehaviour "AWARE";
		_unit setCombatMode "YELLOW";
		 
		 dostop _unit;
		 _unit disableai "TARGET";
		[_unit,25,true,vts_buildingpatroldelay,(getposatl _unit),false] execVM "functions\crB_HousePos.sqf";
		
		_marker_test = createMarkerLocal ["bmarker",_buildingpos];
		_marker_test setMarkerShapeLocal "ELLIPSE";
		_marker_test setMarkerSizeLocal [2, 2];
		_marker_test setMarkerDirLocal 0;
		_marker_test setMarkerColorLocal "Colorred";
		_marker_test setMarkerAlphaLocal 0.5;
		deletemarker "bmarker";
		
		_spawned=_spawned+1;
	};
};
		
deletegroup _tempgroup;



/*
if (pa_aiautomanage>0) then
{
	[_group] execvm "functions\ai_engaged.sqf";
};
*/

_code=nil;
call compile format["
_code={
if ([player] call vts_getisGM) then {""Spawn result : %1 unit(s) in %2 building(s)"" spawn vts_gmmessage;};
};
",_spawned,_numvalidhouse];
[_code] call vts_broadcastcommand;


