waitUntil {!(isNull player)};
_dummy =_this select 0;
_check = _dummy getVariable "task";
["_check",objnull] call vts_checkvar;
if !(isnull _check) exitwith{};
_dummy enablesimulation false;
_pos=getpos _dummy;
_side=_this select 1;
_txt=_this select 2;
_tState=_this select 3;
_color="";
_CanSeeMarker=false;

call compile format["
if ((side group player==%1) || ([player] call vts_getisGM)) then {_CanSeeMarker=true;};
",_side];


if (_CanSeeMarker) then
{

  
  if isnil "objmarker" then {objmarker = 0;};
  objmarker=objmarker+1;
  _currentmarker=objmarker;
  
  _marker = createMarkerlocal [format["objmarker_%1",_currentmarker],_pos];
  _marker setMarkerTypelocal "mil_objective";
  _marker setMarkerTextlocal _txt;
  _marker setMarkerDirlocal 0;
  _dummy setVariable ["text",_txt];
  _dummy setVariable ["side",_side];
  call compile format["
  
  if (%1 == west) then {_color=""ColorBlue"";};
  if (%1 == east) then {_color=""ColorRed"";};
  if (%1 == resistance) then {_color=""ColorGreen"";};
  if (%1 == civilian) then {_color=""ColorOrange"";};
  ",_side];
  _marker setMarkerColorlocal _color;
  
  //Creating task now
	_task = player createsimpletask [_txt];
	_task setsimpletaskdescription [_txt+" @ Coordinates : " + mapgridposition _pos,_txt,_txt];
	_task setsimpletaskdestination _pos;
	_overideState=_dummy getvariable "state";
	if !(isnil "_overideState") then {_tState=_overideState;};
  _task settaskstate _tState;  
  [_task] execvm "functions\fTaskHint.sqf";
  _dummy setVariable ["task",_task];
  //player sidechat str _task;
  waituntil {sleep 1;if !(isnull _dummy) then {_task = _dummy getVariable "task";};isnull _dummy;};
  deletemarkerlocal _marker;
  _task settaskstate "Canceled";
  [_task] execvm "functions\fTaskHint.sqf";
  sleep 30.0;
  player removeSimpleTask _task;
};
