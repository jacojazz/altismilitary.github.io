disableSerialization;
// Attention! il faut faire passer en global toutes les variables sur l'unité!
if  (breakclic <= 1 ) then
{
	clic1 = false;
_display = finddisplay 8000;
_txt = _display displayctrl 200;
		
_txt CtrlSetText "Left click on the map";
_txt CtrlSetTextColor [0.9,0.9,0.9,1];

_side=_this select 0;

Ctrlshow [200,true];sleep 0.2; CtrlShow [200,false];sleep 0.2;Ctrlshow [200,true];

	onMapSingleClick "spawn_x = _pos select 0;
		spawn_y = _pos select 1;
		spawn_z = _pos select 2;
		clic1 = true;
		
		onMapSingleClick """";";
		for "_j" from 10 to 0 step -1 do
		{
		format["Click On Map %1, or wait for cancellation",_j] spawn vts_gmmessage;
		sleep 1;
		
		if (clic1) then
		{
			hint format["Moving %1 respawn",_side];
			_j=0;
			clic1 = false;
			_marker1 = createMarkerLocal ["marker1",[spawn_x,spawn_y]];
			_marker1 setMarkerTypeLocal "mil_Dot";
			_marker1 setMarkerSizeLocal [0.5, 0.5];

			_marker1 setMarkerColorLocal "Colorred";
			_marker1 setMarkerAlphaLocal 0.5;
			[[spawn_x, spawn_y],_side,false] call vts_SetBasePos;

			deletemarker "marker1";

		};
		clic1 = false;

	}; 
	sleep 0.5;
	breakclic = 0; 
		//	waitUntil {(clic1)};
};

If (true) ExitWith {};
