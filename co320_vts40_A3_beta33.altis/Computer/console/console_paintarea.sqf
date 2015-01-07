
disableSerialization;

_gmable=player getVariable "GMABLE";If !( [player] call vts_getisGM) then {if (isnil "_gmable") then {killscript=true;breakclic=0;};}; if (killscript) exitwith {killscript=false;};

//buildingPosCount = compile preprocessFile "buildingPosCount.sqf";

//For test purpose remember to remove it
//openmap true;

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
				_marker_Take setMarkerColorLocal "ColorGreen";
				_marker_Take setMarkerAlphaLocal 0.5;
				
				//******************************
				//***** Code come here *********
				//******************************
				_dummy=vts_smallworkdummy createvehicle _posclick;
				_dummy setposatl [_posclick select 0,_posclick select 1,-5];
				_dummy setvariable ["vts_object",true,true];
				_marker=[];
				call compile format["_marker=%1;",vts_zonepaintercolor];
				_marker set [0,[local_radius,local_radius]];
				[_dummy,_marker] call vts_createbbmarkeroverride;
				//[_dummy,('vtsma'+str(_posclick select 0)+str(_posclick select 1))] call vts_createbbmarker;
				
				[_dummy,format ["[_spawn,'vtsma%1%2'] call vts_createbbmarker;",(_posclick select 0),(_posclick select 1)]] call vts_setobjectinit;
				[] call vts_processobjectsinit;
				
				//******************************
				//******************************
				//******************************
			
				sleep 0.5;
				deletemarker "Nmarker";
	
			
								
			};
			clic1 = false;

	}; 
		sleep 0.25;
		breakclic = 0; 
		//	waitUntil {(clic1)};
};


If (true) ExitWith {};
