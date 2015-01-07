
disableSerialization;

_gmable=player getVariable "GMABLE";If !([player] call vts_getisGM) then {if (isnil "_gmable") then {killscript=true;breakclic=0;};}; if (killscript) exitwith {killscript=false;};

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
  
        currenttpgroup=_group;
        //Fade for proper teleport
        _code={
                  if (group player==_this) then 
                  {
                  cutText ["","BLACK OUT",1];
                  sleep 1;
                  cutText ["","BLACK IN",2];
                  };
               };
        [_code,currenttpgroup] call vts_broadcastcommand;
        sleep 1.0;
                
        _posx=spawn_x;
        _posy=spawn_y;
        _posz=spawn_z;
        _posxn=0;
        
        {
        if (vehicle _x!=_x) then {(vehicle _x) setpos [_posx+_posxn+random 10,_posy+_posxn+random 10];_posxn=_posxn+5} else {_x setpos [_posx+random 25,_posy+random 25]};
  			if ((vehicle _x) iskindof "Helicopter") then {(vehicle _x) setpos [getpos (vehicle _x) select 0, getpos (vehicle _x) select 1,100]};
			   if ((vehicle _x) iskindof "Plane") then {(vehicle _x) setpos [getpos (vehicle _x)select 0, getpos (vehicle _x) select 1,200]};
              
        } foreach units _group;


   
				//******************************
				
				sleep 0.5;
				deletemarker "N2marker";

								
			};
			clic1 = false;
		}; 
		sleep 0.25;
		if ([player] call vts_getisGM) then {hint format["%1 : Teleported",_group];};


If (true) ExitWith {};
