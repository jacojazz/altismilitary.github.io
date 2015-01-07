
disableSerialization;

_gmable=player getVariable "GMABLE";If !([player] call vts_getisGM) then {if (isnil "_gmable") then {killscript=true;breakclic=0;};}; if (killscript) exitwith {killscript=false;};

private ["_source"];

//Début de script OnmapClick
if  (breakclic <= 1 ) then
{
	clic1 = false;

	[] execvm "computer\cpu_dialog.sqf";
	
	_display = finddisplay 8000;
	_txt = _display displayctrl 200;

	_txt CtrlSetText "Left click on the map to specify the linkfeed source";
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
				//********** CODE HERE **********
			
				
				_objs=[_posclick,["Man"],50] call vts_nearestobjects2d;
				
				if (count _objs<1) then
				{
					hint "!!! No unit found !!!";
				}
				else
				{
					_obj=_objs select 0;
					
					_marker_Take = createMarkerLocal ["Nmarker",position _obj];
					_marker_Take setMarkerShapeLocal "ELLIPSE";
					//		_marker_Take setMarkerTypeLocal "mil_Dot";
					_marker_Take setMarkerSizeLocal [10, 10];
					_marker_Take setMarkerDirLocal 0;
					_marker_Take setMarkerColorLocal "Colorgreen";
					_marker_Take setMarkerAlphaLocal 0.5;	
					
					
					_dummy=(_this select 0) getvariable "dummy";
					_dummy setvariable ["currentfeed",_obj,true];
					hint "Reconfiguring link . . .";
				};
				

				//******************************
				
				breakclic = 0; 
				sleep 3;
				deletemarker "Nmarker";
				//clean marker

								
			};
			clic1 = false;

	 }; 
		sleep 0.25;
		//"" spawn vts_gmmessage;
		breakclic = 0; 
		//	waitUntil {(clic1)};
};
If (true) ExitWith {};

