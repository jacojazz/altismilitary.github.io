
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
				_marker_Take setMarkerSizeLocal [radius, radius];
				_marker_Take setMarkerDirLocal 0;
				_marker_Take setMarkerColorLocal "Colororange";
				
        //******************************
        //***** Code come here *********
				//******************************
				
				hint "Destroying all objects in the specified area";
				/*
	      _objs = nearestObjects [[_posclick select 0, _posclick select 1],[],radius];
	      _count=0;
	      {
          if (!(_x isKindOf "AllVehicles") && !(_x isKindof "ReammoBox")) then {_count=_count+1;call compile format["_marker=createMarkerLocal [""Gmarker%1"",getpos _x]; _marker setMarkerTypeLocal ""mil_Dot"";_marker setMarkerSizeLocal [0.5, 0.5]; _marker setMarkerAlphaLocal 0.5; _marker setMarkerColorLocal ""Colorred"";",_count];};
        } foreach _objs;
	     */
				_code={};
		call compile format["		
				_code=
        {
          [[%1,%2,%3],%4,true] call vts_destroyterrain;
        };
		",spawn_x,spawn_y,spawn_z,radius]	;

        [_code] call vts_broadcastcommand;
    	sleep 0.5;		
		hint "All terrain objects has been destroyed...";
				
				/*
				//Then we are spawning wreck on roads
				_pos=[spawn_x,spawn_y,spawn_z];
				_wreckstospawn=["datsun01Wreck","datsun02Wreck","hiluxWreck","UAZWreck","SKODAWreck","UralWreck"];
				_wrecksnum=count _wreckstospawn;
				_wreckspercent=75;
							

        _roadlist = _pos nearRoads radius;
        _roadnum = count _roadlist;
        _numofwreckstospawn=round(_roadnum*(_wreckspercent/100));
        
        
        
        if (_roadnum>0) then
        {   
          for "_x" from 1 to _numofwreckstospawn do
          {  
             _roadnum = count _roadlist;
             _i=round(random (_roadnum-1));
             hint format["%1 , %2",_i,_roadlist];
             _road = _roadlist select _i; 
             _roadlist = _roadlist - [_road];
             _validpos=getpos _road;
             _vehicle= _wreckstospawn select (round(random(_wrecksnum-1))) createVehicle _validpos;
             //Random direction on the road
             _dir=round(random 360);
             _vehicle setDir (direction _road)+_dir;
             //Put the vehicle on the right of the road
             _Offset = [random(3.5),0,0];
             _validpos = _vehicle modelToWorld _Offset;
             //Make sure the vehicle is not in a wall on the road side
             _validpos = _validpos findEmptyPosition [0.1,10];
             _vehicle setpos _validpos;
             //Velocity to make sur the vehicle follow the slope
             _vehicle setvelocity [0,0,1];
            
          };        
        };	
        */
        			
				//******************************
			
      	sleep 1;
  			deletemarker "Nmarker";
  			//clean marker
 
								
			};
			clic1 = false;

	}; 
		sleep 0.5;
		//"" spawn vts_gmmessage;
		breakclic = 0; 
		//	waitUntil {(clic1)};
};
If (true) ExitWith {};
