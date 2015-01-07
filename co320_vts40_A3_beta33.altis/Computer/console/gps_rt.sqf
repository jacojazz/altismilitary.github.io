// gps_rt.sqf

_getplayermarkercolor=
{
  _unit=_this select 0;
  _mcolor="ColorBlack";
  if (side _unit==west) then {_mcolor="ColorBlue";}; 
	if (side _unit==east) then {_mcolor="ColorRed";};
	if (side _unit==resistance) then {_mcolor="ColorGreen";};
	if (side _unit==civilian) then {_mcolor="ColorOrange";};
	_mcolor
};

gps_valid = gps_valid+1;

if (gps_valid > 1) then 
{
	gps_valid = 0;
	"GM All units markers OFF" call vts_gmmessage;
}
else
{
	"GM All units markers ON" call vts_gmmessage;
};

	gps_playerlist=[];

	while {gps_valid == 1} do
	{
		markergpslist=[];
		_players=playableUnits;
		
		
		if (isnil "gpsplayerlist") then {gpsplayerlist=[];};
		
		_gpsnewplayerlist=gpsplayerlist;
     
      
		if (count gpsplayerlist>0) then
		{
			//Moving already existing markers
			_ngpsplayerlist=(count gpsplayerlist)-1;
			for "_i" from 0 to _ngpsplayerlist do
			{
			  _unit=gpsplayerlist select _i;
			  _unitobj=_unit select 0;
			  _unitmarker=_unit select 1;
			  
			  if ((isnull _unitobj) or (name _unitobj=="Error: No unit") or !(isplayer _unitobj) ) then
			  {
				//Deleting the marker and update the array
				deleteMarkerLocal _unitmarker;
				_gpsnewplayerlist set [_i,objnull];
				_gpsnewplayerlist=_gpsnewplayerlist-[objnull];
			  }
			  else
			  {
				//Updating marker removing cached units from the _units var
				_mcolor=[_unitobj] call _getplayermarkercolor;
				_unitmarker setMarkerPosLocal (getPosATL _unitobj);
				_unitmarker setMarkerDirLocal direction _unitobj;            
				_unitmarker setMarkerColorLocal _mcolor;
				_unitmarker setMarkerTextlocal format["%1 - %2",_unitobj,name _unitobj];
				_players=_players-[_unitobj];
			  };
			};
		  gpsplayerlist=_gpsnewplayerlist;
		};
		
		{
			if (!(isnull _x) && (name _x!="Error: No unit") && (isplayer _x)) then
			{
			  _m = createMarkerlocal[format["mark_%1",_x],getPosATL _x];
			  _m setMarkerShapelocal "ICON" ;  
			  _m setMarkerTypelocal "mil_Arrow" ;
			  _m setMarkerSizeLocal [0.30, 0.30];
			  _m setMarkerDirLocal direction _x; 
			  _m setMarkerTextlocal format["%1 - %2",_x,name _x];
			  _mcolor=[_x] call _getplayermarkercolor;
			  _m setMarkerColorlocal  _mcolor;
			  gpsplayerlist set [count gpsplayerlist,[_x,_m]];
			};

		} foreach _players;
  
		
		sleep vts_gpsrefreshplayer;
		
	
	};

  
  //Cleaning up marker on exit
  _ngpsplayerlist=(count gpsplayerlist)-1;
  for "_i" from 0 to _ngpsplayerlist do
  {
    _unit=gpsplayerlist select _i;
    _unitmarker=_unit select 1;
    deleteMarkerLocal _unitmarker;
  };
  gpsplayerlist=[];
	
	
		
if (true) exitWith {};
