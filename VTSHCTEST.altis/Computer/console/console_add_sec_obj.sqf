disableSerialization;
if (var_console_valid_side=="OBJECT") exitwith {hint "!!! Task can be associated to the OBJECT side !!!";playsound "computer";};
if  (breakclic <= 1 ) then
{
	
	clic1 = false;

	_display = finddisplay 8000;
	_txt = _display displayctrl 200;
	_txt2 = _display displayctrl 10600;

	_txt CtrlSetText "Left click on the map";
	_txt CtrlSetTextColor [0.9,0.9,0.9,1];

	Ctrlshow [200,true];sleep 0.2; CtrlShow [200,false];sleep 0.2;Ctrlshow [200,true];
	onMapSingleClick "spawn_x = _pos select 0;
		spawn_y = _pos select 1;
		spawn_z = _pos select 2;
	
		console_sec_obj = format [""%1"",ctrlText 10600];
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
		"" spawn vts_gmmessage;
//		inc = inc + 1;
//		console_add_sec_obj = true;
//		console_add_sec_obj = false;
//		publicvariable "console_add_sec_obj";
//		hint format ["%1",inc];
    //_marker = vts_dummyvehicle createvehicle [spawn_x,spawn_y,0];
	_marker = vts_smallworkdummy createvehicle [spawn_x,spawn_y,0];
	_marker setvariable ["vts_object",true,true];
    _marker setPosATL [getPosATL _marker select 0,getPosATL _marker select 1,(getPosATL _marker select  2)-1];
    [_marker,format["_spawn hideobject true; _spawn allowdamage false;[_spawn,""%1"",""%2"",""Created""] execvm ""functions\taskmaker.sqf"";",var_console_valid_side,console_sec_obj]] call vts_setobjectinit;
    [] call vts_processobjectsinit;
    sleep 0.1;
    console_sec_obj == "";		
//		ctrlSetText [10600, ""]
		};
		clic1 = false;
		
	}; 
	sleep 0.1;
	hint format["Task created for %1 side.",var_console_valid_side];
	breakclic = 0; 
		//	waitUntil {(clic1)};
};

If (true) ExitWith {};

//_markerNo = random 10
//{marker = createMarker [format ["marker_%1",_markerNo], _x]}foreach VSP_radarArray
