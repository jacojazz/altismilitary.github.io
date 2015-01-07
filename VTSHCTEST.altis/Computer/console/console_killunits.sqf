
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
				_marker_Take setMarkerSizeLocal [radius, radius];
				_marker_Take setMarkerDirLocal 0;
				_marker_Take setMarkerColorLocal "Colororange";
				
        //******************************
        //***** Code come here *********
				//******************************
				
				hint "Killing all non player units in the specified area";
				
	      //_objs = nearestObjects [[_posclick select 0, _posclick select 1],[],radius+1000];
		  _objs=AllMissionObjects "All";
	      _count=count _objs;
	      for "_n" from 0 to (_count-1) do
	      {
	        _object=_objs select _n;
			if (([getposatl _object select 0,getposatl _object select 1] distance [_posclick select 0, _posclick select 1])<=radius) then
			{
			  if (!isplayer _object) then
			  {
				if (_object iskindof "AllVehicles") then 
				{
				  {_x setdamage 1} foreach (crew _object);
				  _object setdamage 1;
				};
			  };
			};
		  };
	     
				

    		sleep 0.25;		
				hint "All non players units has been killed...";

        			
				//******************************
			
      	sleep 0.5;
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
