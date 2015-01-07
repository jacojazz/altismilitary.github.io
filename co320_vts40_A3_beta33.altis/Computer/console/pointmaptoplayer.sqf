
disableSerialization;


//Début de script
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
			  _size = _this select 0;
				"" spawn vts_gmmessage;
				_j=0;
				clic1 = false;
				_marker_Del = createMarkerLocal ["Delmarker",[spawn_x,spawn_y,spawn_z]];
				_marker_Del setMarkerShapeLocal "ELLIPSE";
				//		_marker_Del setMarkerTypeLocal "mil_Dot";
				_marker_Del setMarkerSizeLocal [5, 5];
				_marker_Del setMarkerDirLocal 0;
				_marker_Del setMarkerColorLocal "Colorgreen";
				_marker_Del setMarkerAlphaLocal 0.5;
				
				_code={};
				call compile format["
				_code={
				if !(visibleMap) then {openmap true} else {};mapAnimAdd [1.5, 0.075 + (random 0.05), [%1,%2]];mapAnimCommit;
				};
				",spawn_x,spawn_y];
				[_code] call vts_broadcastcommand;
				
				sleep 0.5;
				deletemarker _marker_Del;
				hint "Map pointed";
			};
			clic1 = false;
			
		
	}; 
		breakclic = 0; 
		//	waitUntil {(clic1)};
};
If (true) ExitWith {};
