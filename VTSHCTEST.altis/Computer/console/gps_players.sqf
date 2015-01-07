

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
	"GM Players markers OFF" call vts_gmmessage;
}
else
{
	"GM Players markers ON" call vts_gmmessage;
};


while {gps_valid == 1} do
{
	
	
	_playables=playableUnits;
	_players=[];
	for "_i" from 0 to (count _playables)-1 do
	{
		_o=_playables select _i;
		if (isplayer _o) then 
		{
			_players set [count _players,_o];
		};
	};
	
	_markers=[];
	for "_i" from 0 to (count _players)-1 do
	{
		_unitobj=_players select _i;;
		if (!(isnull _unitobj) && (name _unitobj!="Error: No unit") && (isplayer _unitobj)) then
		{
			_mcolor=[_unitobj] call _getplayermarkercolor;
			_posunit=getPosATL _unitobj;
			_unitmarker = createMarkerlocal[format["mark_%1%2%3",str(_posunit select 0),str(_posunit select 1),str(_posunit select 2)],_posunit];
			_unitmarker setMarkerShapelocal "ICON" ;  
			_unitmarker setMarkerTypelocal "mil_Arrow" ;
			_unitmarker setMarkerSizeLocal [0.30, 0.30];	
			_unitmarker setMarkerPosLocal (getPosATL _unitobj);
			_unitmarker setMarkerDirLocal direction _unitobj;            
			_unitmarker setMarkerColorLocal _mcolor;
			_unitmarker setMarkerTextlocal format["%1 - %2",_unitobj,name _unitobj];
			_markers set [count _markers,_unitmarker];
		};
	};

	sleep vts_gpsrefreshplayer;
	
	for "_i" from 0 to (count _markers)-1 do
	{
		deleteMarkerLocal (_markers select _i);
	};
	
	
};

