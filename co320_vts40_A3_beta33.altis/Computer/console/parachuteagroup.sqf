
disableSerialization;

_gmable=player getVariable "GMABLE";If !( [player] call vts_getisGM) then {if (isnil "_gmable") then {killscript=true;breakclic=0;};}; if (killscript) exitwith {killscript=false;};

private ["_source","_group"];

//Début de script OnmapClick

	_display = finddisplay 8000;
	_txt = _display displayctrl 200;

	_txt CtrlSetText "Left click on the destination position";
	_txt CtrlSetTextColor [0.9,0.9,0.9,1];

	Ctrlshow [200,true];sleep 0.2; CtrlShow [200,false];sleep 0.2;Ctrlshow [200,true];

  //Récuperation des coordonnées de la carte
	onMapSingleClick "
    spawn_x = _pos select 0;
		spawn_y = _pos select 1;
		spawn_z = _pos select 2;

		clic1 = true;
	   onMapSingleClick """";
     ";
	 
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
			
				_marker_Take = createMarkerLocal ["N2marker",_posclick];
				_marker_Take setMarkerShapeLocal "ELLIPSE";
				//		_marker_Take setMarkerTypeLocal "mil_Dot";
				_marker_Take setMarkerSizeLocal [5, 5];
				_marker_Take setMarkerDirLocal 0;
				_marker_Take setMarkerColorLocal "Colorred";
				_marker_Take setMarkerAlphaLocal 0.5;
			
				
        //******************************
        //***** Code come here *********
				//******************************
	
	      
	      _group = _this select 0;
			currentparapgroup=_group;
	
        //Fade for proper teleport
        _code={
                  if (player in _this) then 
                  {
                  cutText ["","BLACK OUT",1];
                  sleep 1;
                  cutText ["","BLACK IN",2];
                  };
               };
        [_code,currentparapgroup] call vts_broadcastcommand;
        sleep 1.0;    
        
        _posx=spawn_x;
        _posy=spawn_y;
        _posz=spawn_z;
        _posxn=0;
        
		//building group object to parachute vehicle also
		_groupobjects=[];
		_paragroup=_group;
		for "_i" from 0 to (count _paragroup)-1 do
		{
			_o=_paragroup select _i;
			if (alive vehicle _o) then
			{
				if !((vehicle _o) in _groupobjects) then 
				{
					_groupobjects set [count _groupobjects,(vehicle _o)];
				};
			};
			
		};

        currentparapgroup=_groupobjects;	
		
        {
          //moveout _x;
          sleep 0.2;
          _posx=(spawn_x-100)+random 200;
          _posy=(spawn_y-100)+random 200;
          _x setpos [_posx, _posy, parachutealtitude];      
        } foreach _groupobjects;
        
        //Arma 2
        //Script need to be run on everyone to be sure local function doesnt get screwed in mp.
        _code={          
          
          {
			  if (local _x) then
			  {
				[_x] call vts_freefall;	
			  };
		  }
          foreach _this;                   
        
        };
        
       [_code,currentparapgroup] call vts_broadcastcommand;
   
				//******************************
			
      	sleep 0.5;
		deletemarker "N2marker";

								
			};
			clic1 = false;
	 }; 
		sleep 0.25;
		if ([player] call vts_getisGM) then {hint format["%1 : Parachuted",_group];};


If (true) ExitWith {};
