
disableSerialization;

_gmable=player getVariable "GMABLE";If !( [player] call vts_getisGM) then {if (isnil "_gmable") then {killscript=true;breakclic=0;};}; if (killscript) exitwith {killscript=false;};

private ["_source"];

//Début de script OnmapClick
if  (breakclic <= 1 ) then
{
	clic1 = false;

	_display = finddisplay 8000;
	_txt = _display displayctrl 200;

	_txt CtrlSetText "Left click on the map to select the group";
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
		_gcount=0;
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

				
        //******************************
        //***** Code come here *********
				//******************************
				
	      _list = [[spawn_x,spawn_y],["CAManBase","Car","Truck","Tank","Helicopter","Plane","Ship"],500] call vts_nearestobjects2d;
	      _source = _list select 0;
	      
	      if ((count _list)==0) exitwith {breakclic = 0;hint "!!! No units found !!!"};
	     

	
	      
	    _group = group _source;
	    {
			_gcount=_gcount+1;
			call compile format["_marker=createMarkerLocal [""Gmarker%1"",getpos _x]; _marker setMarkerTypeLocal ""mil_Dot"";_marker setMarkerSizeLocal [1, 1]; _marker setMarkerAlphaLocal 0.5; _marker setMarkerColorLocal ""ColorGreen"";",_gcount];
		} foreach units _group;
	      
	    [_group] execVM "Computer\console\updateorders.sqf";
	      
				//******************************
			
      	sleep 0.5;
			

								
			};
			clic1 = false;
	
	 }; 
		sleep 0.25;
		//"" spawn vts_gmmessage;
		breakclic = 0; 
		//	waitUntil {(clic1)};
		sleep 1.0;
		//clean marker
		while {_gcount>0} do
		{
		  call compile format["deletemarker ""Gmarker%1"";",_gcount];
		  _gcount=_gcount-1;
		};
};
If (true) ExitWith {};
