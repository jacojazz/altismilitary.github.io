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



while {true} do
{
	_markers=[];
	_markersactive=false;
	if (alive player && (leader player==player)) then
	{
		_markernum=0;
		_markertype="n_inf";
		_isgm=[player] call vts_getisGM;
		{
			_markercolor=([player] call _getplayermarkercolor);
			_side=side _x;		
			if (((_side==side group player) or (_isgm)) && ((count units _x)>1)) then
			{
				if (_isgm) then {_markercolor=([_x] call _getplayermarkercolor);};
				_markerlead = createMarkerLocal ["leadmarker"+(str _markernum),getPosATL (leader _x)];
				_markerlead setMarkerTypelocal  _markertype;
				_markerlead setMarkerSizeLocal [0.75, 0.75];
				_markerlead setMarkerDirLocal direction (leader _x);
				_markerlead setMarkerColorLocal _markercolor;
				//_markerlead setMarkerAlphaLocal 0.5;
				_markers set [count _markers,_markerlead];
				_markernum=_markernum+1;
				
			};		
			_markersactive=true;
		} foreach allGroups;
		
	};	
	sleep 10.0;
	if (_markersactive)  then
	{
		{
			deletemarkerlocal _x; 	
		} foreach _markers;
	};
};
