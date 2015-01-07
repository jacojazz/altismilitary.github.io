
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
	onMapSingleClick "local_spawn_x = _pos select 0;
		local_spawn_y = _pos select 1;
		local_spawn_z = _pos select 2;
		
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
				_posclick = [local_spawn_x,local_spawn_y,local_spawn_z];
				_marker_Take = createMarkerLocal ["Nmarker",_posclick];
				_marker_Take setMarkerShapeLocal "ELLIPSE";
				//		_marker_Take setMarkerTypeLocal "mil_Dot";
				_marker_Take setMarkerSizeLocal [local_radius, local_radius];
				_marker_Take setMarkerDirLocal 0;
				_marker_Take setMarkerColorLocal "Colororange";
				
        //******************************
        //***** Code come here *********
				//******************************
				
				hint "Spawning wreck on specifed area roads";

				
				//Spawning wreck on roads
				_pos=[local_spawn_x,local_spawn_y,local_spawn_z];
				_wreckstospawn=[
				"datsun01Wreck",
				"datsun02Wreck",
				"hiluxWreck",
				"UAZWreck",
				"SKODAWreck",
				"UralWreck",
				"LADAWreck",
				"LADAWreck",
				"Land_Wreck_Car2_F",
				"Land_Wreck_Car3_F",
				"Land_Wreck_Car_F",
				"Land_Wreck_Offroad_F",
				"Land_Wreck_Offroad2_F",
				"Land_Wreck_Truck_dropside_F",
				"Land_Wreck_Truck_F"
				];
				
				_checkwrecks=[];
				{if (isclass (configfile >> "cfgvehicles" >>_x)) then {_checkwrecks set [count _checkwrecks,_x];}; } foreach _wreckstospawn;
				
				_wreckstospawn=_checkwrecks;
				_wrecksnum=count _wreckstospawn;
				_wreckspercent=10;
				_roadlist = _pos nearRoads local_radius;
				_roadnum = count _roadlist;
				_numofwreckstospawn=round(_roadnum*(_wreckspercent/100));
        
        
        
        if (_roadnum>0) then
        {   
          for "_x" from 1 to _numofwreckstospawn do
          {  
             _roadnum = count _roadlist;
             _i=round(random (_roadnum-1));
             //hint format["%1 , %2",_i,_roadlist];
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
             _vehicle setvelocity [0,0,-1];
			 if !(isnil "vts_createbbmarker") then 
			 {
				//[_vehicle,(str (position _vehicle))+(str(direction _vehicle))] call vts_createbbmarker;
			 };
			 _vehicle setvariable ["vts_object",true,true];
            
          };
          hint format["%1 wrecks has been spawned in an area of %2 meters",_numofwreckstospawn,local_radius];        
        }
        else 
        {
          hint "!!! No roads in the area !!!";
        };
        
        			
				//******************************
			
      	sleep 0.5;
  			deletemarker "Nmarker";
  			//clean marker

								
			};
			clic1 = false;

	}; 
		sleep 0.5;
		"" spawn vts_gmmessage;
		breakclic = 0; 
		//	waitUntil {(clic1)};
};
If (true) ExitWith {};
