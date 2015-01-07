
disableSerialization;

_gmable=player getVariable "GMABLE";If !([player] call vts_getisGM) then {if (isnil "_gmable") then {killscript=true;breakclic=0;};}; if (killscript) exitwith {killscript=false;};

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
				
			
			  haloc130 = createVehicle ["C130J", [spawn_x, spawn_y, spawn_z + 10000], [], 0, "FLY"];
			  _groupPilot = createGroup civilian;
		  _pilotc1301 = "RU_Pilot" createUnit [[spawn_x,spawn_y,0], _groupPilot,"this assignasdriver haloc130;this moveindriver haloc130",0.5,"corporal"];
		  _pilotc1302 = "RU_Pilot" createUnit [[spawn_x,spawn_y,0], _groupPilot,"this assignascargo haloc130;this moveincargo haloc130",0.5,"corporal"];
		  _pilotc1303 = "RU_Pilot" createUnit [[spawn_x,spawn_y,0], _groupPilot,"this assignascargo haloc130;this moveincargo haloc130",0.5,"corporal"];
				haloc130 setpos [spawn_x, spawn_y, spawn_z + 10000]; 
		haloc130 flyInHeight 10000;
		  haloc130 setCaptive true;
		  haloc130 lock true;
          _WP = _groupPilot addWaypoint [getpos haloc130, 100];
          _WP setWaypointType "HOLD";
          publicVariable "haloc130";
     
        
          sleep 1;
        
        _players=playableUnits;
        for "_i" from 0 to (count _players)-1 do
        {
			_user=_players select _i;
           if (alive _user) then { if (vehicle _user!=_user) then {moveout _user};};

        };        
  
        sleep 0.5;
        
        
      
        for "_i" from 0 to (count _players)-1 do
        {
		   _user=_players select _i;
           _code={if (player==_user) then {cutText ["","BLACK OUT",1];sleep 1;cutText ["","BLACK IN",2];player assignascargo haloc130; player moveInCargo haloc130;haloc130 addaction ["Jump Out","halojumpout.sqf"];clearWeaponCargo  haloc130;if (ACEMOD) then {haloc130 addWeaponCargo ["ACE_ParachutePack",50]};};
           [_code] call vts_broadcastcommand;
           //call compile format ["
           
           sleep 0.75;
           //",_i];
        };        
        
        
        /*
        _codetorun={
        player assignascargo haloc130; player moveinCargo haloc130;
        };
        [_codetorun] call vts_broadcastcommand;
        */
		// *******************
		// End of code there
		// *******************

        
        //******************************
				//******************************
			
      	sleep 0.5;
				deletemarker "Nmarker";
								
			};
			clic1 = false;
	}; 
		sleep 0.25;
		"" spawn vts_gmmessage;
		breakclic = 0; 
		//	waitUntil {(clic1)};
};
If (true) ExitWith {};
