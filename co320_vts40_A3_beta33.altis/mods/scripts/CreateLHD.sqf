_spawnLHD=
{
	//_LHDspawn = _this select 0;
	//_LHDdir = getdir _LHDspawn;
	_LHDdir=local_console_unit_orientation;
	//_LHDspawnpoint = getpos _LHDspawn;
	_LHDspawnpoint = _this select 0;

	_parts = 
	[
		"Land_LHD_house_1",
		"Land_LHD_house_2",
		"Land_LHD_elev_R",
		"Land_LHD_1",
		"Land_LHD_2",
		"Land_LHD_3",
		"Land_LHD_4",
		"Land_LHD_5",
		"Land_LHD_6"
	];
	{
		_dummy = _x createvehicle _LHDspawnpoint;
		_dummy setdir _LHDdir;
		_dummy setpos _LHDspawnpoint;
		_dummy setPosasl  [getPosasl _dummy select 0, getPosasl _dummy select 1, 0];
		//[_dummy,(str(getposatl _dummy)+_x)] call vts_createbbmarker;
		_dummy setvariable["vts_object",true,true];
	}foreach _parts;
};

disableSerialization;


_gmable=player getVariable "GMABLE";If !( [player] call vts_getisGM) then {if (isnil "_gmable") then {killscript=true;breakclic=0;};}; if (killscript) exitwith {killscript=false;};

//Début de script OnmapClick
if  (breakclic <= 1 ) then
{
	clic1 = false;

	_display = finddisplay 8000;
	_txt = _display displayctrl 200;

	_txt CtrlSetText "Left click on the map";
	_txt CtrlSetTextColor [0.9,0.9,0.9,1];

	Ctrlshow [200,true];sleep 0.2; CtrlShow [200,false];sleep 0.2;Ctrlshow [200,true];

  //Récuperation des coordonnées de la carte
	onMapSingleClick "spawn_x = _pos select 0;
		spawn_y = _pos select 1;
		spawn_z = _pos select 2;

		
		clic1 = true;
		
	onMapSingleClick """";";
		for "_j" from 10 to 0 step -1 do 
		{
		format["Click On Map %1, or wait for cancellation",_j] spawn vts_gmmessage;
		sleep 1;
		//hint "pause";
		
			//if (_clic1) exitWith {};
			if (clic1) then
			{
				"" spawn vts_gmmessage;
				_j=0;
				clic1 = false;
				_posclick = [spawn_x,spawn_y,spawn_z];
				_marker_Take = createMarkerLocal ["Nmarker",_posclick];
				_marker_Take setMarkerShapeLocal "ELLIPSE";
				//		_marker_Take setMarkerTypeLocal "mil_Dot";
				_marker_Take setMarkerSizeLocal [25, 25];
				_marker_Take setMarkerDirLocal 0;
				_marker_Take setMarkerColorLocal "Colorred";
				_marker_Take setMarkerAlphaLocal 0.5;
				
        //******************************
        //***** Code come here *********
				//******************************
				
	      [[spawn_x, spawn_y,spawn_z]] call _spawnLHD;
		 

				//******************************
			
				sleep 0.5;
				deletemarker "Nmarker";
								
			};
			clic1 = false;
	}; 
		sleep 0.25;
		hint "SPAWNED";
		breakclic = 0; 
		//	waitUntil {(clic1)};
};
If (true) ExitWith {};
