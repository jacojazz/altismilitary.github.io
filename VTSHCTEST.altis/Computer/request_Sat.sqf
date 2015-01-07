disableSerialization;
_display = finddisplay 8000;
_txt = _display displayctrl 200;

	
_txt CtrlSetText "Left click on the map";
_txt CtrlSetTextColor [0.9,0.9,0.9,1];
while {dialog and count OnMapArrayS<1} do {
	CtrlShow [200,false];sleep 0.75;Ctrlshow [200,true];sleep 0.75;
	};
	
_txt CtrlSetText "Confirm location";
	
_txt CtrlSetTextColor [1,1,0,1];
while {dialog and (CASOn==3 or CAS==-1)} do {
	CtrlShow [200,false];sleep 1;Ctrlshow [200,true];sleep 1;
	};
if (true) exitWith {};