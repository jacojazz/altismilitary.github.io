disableSerialization;
_display = finddisplay 8000;
_txt = _display displayctrl 200;



_txt CtrlSetText "Rain activated";
_txt CtrlSetTextColor [0.9,0.9,0.9,1];
CtrlShow [200,true];sleep 0.75;Ctrlshow [200,false];sleep 0.75; CtrlShow [200,true] ;
if (true) exitWith {};