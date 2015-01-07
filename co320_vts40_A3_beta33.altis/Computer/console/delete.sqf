_size = _this select 1;
_size = local_radius;
_pos = _this select 0;
"" spawn vts_gmmessage;
_deadonly=false;
if (count _this >2) then {_deadonly=_this select 2;};

_marker_Del = createMarkerLocal ["Delmarker",_pos];
_marker_Del setMarkerShapeLocal "ELLIPSE";
//		_marker_Del setMarkerTypeLocal "mil_Dot";
_marker_Del setMarkerSizeLocal [_size, _size];
_marker_Del setMarkerDirLocal 0;
_marker_Del setMarkerColorLocal "Colorred";
_marker_Del setMarkerAlphaLocal 0.5;

// Détecte la première unité depuis le centre du click
//_list = nearestObjects  [[spawn_x,spawn_y,0],["CAManBase","Car","Truck","Tank","Helicopter","Plane","StaticWeapon"],10];
_deletecrew=
{
	private ["_crew","_deldeadonly","_ncrew","_deldeadonly"];
	
  _crew=crew (_this select 0);
  _deldeadonly=_this select 1;
  _ncrew=(count  _crew)-1;
  for "_i" from 0 to _ncrew do
  {
  [(_crew select _i),_deldeadonly] call vts_deletevehicle;
  };
  
};



//Take a list with 1000 M more because I cant to check 2D for aeril vehicle
//_list = nearestObjects  [_pos,[vts_smallworkdummy,"Motorcycle","Man","Car","Truck","Tank","Helicopter","Plane","StaticWeapon","Ship","Building","ReammoBox","Thing","WeaponHolder","GroundWeaponHolder","TargetBase"],_size+1000];
_List=allMissionObjects "ALL";

/*
//Near entities for faster search (and flying & deep should be alive unit)
_listairdepth= _pos nearEntities   [["Air","Ship"],_size+5000];
//Add missing flying air & depth units to the del 
for "_i" from 0 to (count _listairdepth)-1 do
{
	_obj=_listairdepth select _i;
	if !(_obj in _list) then 
	{	
		_list set [count _list,_obj];
	};
	
};
*/


//Lets rebuild a list with 2D position (so we can delete flying aircraft with a 6M brush)
_pos2d=[_pos select 0,_pos select 1];
_maxdist=_size;
_objects=[];
for "_i" from 0 to (count _list)-1 do
{
	_curobject=_list select _i;
	_curdist=[(getposatl _curobject) select 0,(getposatl _curobject) select 1] distance _pos2d;
	if ( _curdist<=_maxdist ) then {_objects set [count _objects,_curobject];};				
};
_list=_objects;
//hintc str _list;

{
	
	if ( (_x iskindof "Building") && !(_x iskindof "WeaponHolder") && !(_x iskindof "GroundWeaponHolder") && !(_deadonly)) then 
	{
		_var=_x getVariable "vts_object";
		
		if !(isnil "_var") then {[_x] call vts_deletevehicle;};						
	} 
	else 
	{
		
		if !(isPlayer _x ) then 
		{					
			_grp=group _x;[_x,_deadonly] call _deletecrew;[_x,_deadonly] call vts_deletevehicle;deletegroup _grp;
		} 
		else 
		{
			if ("TRUE" == driver _x getVariable "GMABLE" and !(isplayer (vehicle driver _x))) then 
			{
			_grp=group _x;[_x,_deadonly] call _deletecrew;[_x,_deadonly] call vts_deletevehicle;deletegroup _grp;
			};
		};
		
	};
} forEach _list;

_msg="Zone deleted";
if (_deadonly) then {_msg="Deads deleted"};
_msg spawn vts_gmmessage;
sleep 0.5;
deletemarker _marker_Del;
