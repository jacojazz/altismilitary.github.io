private ["_leader","_upsmode","_pos","_radius","_behaviour","_group","_genericmarker","_patrolscript"];

_leader=_this select 0;
_upsmode=_this select 1;
_pos=_this select 2;
_radius=_this select 3;
_behaviour=_this select 4;

_group=group _leader;
//UPSMon need at least one waypoint to work
_group addwaypoint [_pos,0];

_genericmarker=createMarkerlocal [("vtsgenericmarker"+(str vts_genericmarker)),_pos];
_genericmarker setMarkerSizelocal [_radius,_radius];
_genericmarker setMarkerShapelocal "ELLIPSE";
if !(vts_debug) then {_genericmarker setMarkeralphalocal 0;};

/*
genericmarker=createMarkerlocal ["testmarker",(getpos player)];
genericmarker setMarkerSizelocal [1000,1000];
genericmarker setMarkerShapelocal "ELLIPSE";
*/

switch (true) do
{
	case (_upsmode=="upsauto"):
	{
		if (vts_debug) then {player sidechat _upsmode;};
		call compile format["_patrolscript = [leader _group,""vtsgenericmarker%1"",_behaviour] execVM ""scripts\UPSMON.sqf"";",vts_genericmarker];
	};	
	case (_upsmode=="upsdefend"):
	{
		if (vts_debug) then {player sidechat _upsmode;};
		call compile format["_patrolscript = [leader _group,""vtsgenericmarker%1"",""nomove"",_behaviour] execVM ""scripts\UPSMON.sqf"";",vts_genericmarker];
	};		
	case (_upsmode=="upsfortify"):
	{
		if (vts_debug) then {player sidechat _upsmode;};
		call compile format["_patrolscript = [leader _group,""vtsgenericmarker%1"",""fortify"",_behaviour] execVM ""scripts\UPSMON.sqf"";",vts_genericmarker];
	};	
	case (_upsmode=="upsnofollow"):
	{
		if (vts_debug) then {player sidechat _upsmode;};
		call compile format["_patrolscript = [leader _group,""vtsgenericmarker%1"",""nofollow"",_behaviour] execVM ""scripts\UPSMON.sqf"";",vts_genericmarker];
	};	
	case (_upsmode=="upsreinforcement"):
	{
		if (vts_debug) then {player sidechat _upsmode;};
		call compile format["_patrolscript = [leader _group,""vtsgenericmarker%1"",""reinforcement"",_behaviour] execVM ""scripts\UPSMON.sqf"";",vts_genericmarker];
	};		
	case (_upsmode=="upsambush"):
	{
		if (vts_debug) then {player sidechat _upsmode;};
		call compile format["_patrolscript = [leader _group,""vtsgenericmarker%1"",""ambush"",_behaviour] execVM ""scripts\UPSMON.sqf"";",vts_genericmarker];
	};		
};

vts_genericmarker=vts_genericmarker+1;
publicvariable "vts_genericmarker";

_group setvariable ["vtscurrentpatrolscript",_patrolscript,true];



