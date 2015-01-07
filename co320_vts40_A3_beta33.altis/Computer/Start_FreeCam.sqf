// Initialise spectate cam
// norrin
// AUGUST 2009 - norrin
disableSerialization;
if  (breakclic <= 1 ) then
{

	clic1 = false;

	//object3D = console_unit_unite createVehicleLocal [getPos player select 0, (getPos player select 1)+20,getPos player select 2] ;
	_display = finddisplay 8000;
	_txt = _display displayctrl 200;

	_txt CtrlSetText "Left click on the map";
	_txt CtrlSetTextColor [0.9,0.9,0.9,1];

	Ctrlshow [200,true];sleep 0.2; CtrlShow [200,false];sleep 0.2;Ctrlshow [200,true] ;
	
	onMapSingleClick "spawn_x = _pos select 0;
	spawn_y = _pos select 1;
	spawn_z = _pos select 2 ;
	clic1 = true;
	[] call Dlg_StoreParams;
	onMapSingleClick """";" ;
	for "_j" from 10 to 0 step -1 do 
	{
		format["Click On Map %1, or wait for cancellation",_j] spawn vts_gmmessage;
		//hint "pause";
		
		//if (_clic1) exitWith {};
		if (clic1) then
		{
			"" spawn vts_gmmessage;
			_j=0;
			clic1 = false;

			//closeDialog 8000;

			//object3D = console_unit_unite createVehicleLocal [spawn_x, spawn_y ,spawn_z] ;
			check3d  = false;
			Step3d  = 0.5;

			//Obj = "Rabbit" createVehicleLocal getPos object3D;
			//Obj = "Rabbit" createVehicleLocal [spawn_x, spawn_y ,0.5];
			//object3D allowDamage false;
			//Obj allowDamage false;

			// VtsHight = 0.5;
			// VTScamtarget = Obj;

			//object3D attachTo [Obj,[0,0,VtsHight ]]; 
			//checkattach = true;

			//_pos = [spawn_x, spawn_y ,0];
			//hauteur _pos = getpos Obj;
			//_bee = "butterfly" createVehicle [_pos select 0, _pos select 1, (_pos select 2) + 4];
			["VTScamtarget",objnull] call vts_checkvar;
			//[VTScamtarget, [spawn_x, spawn_y ,([[spawn_x,spawn_y]] call vts_SetPosAtop) select 2]] execVM "Computer\VTS_FreeCam.sqf";
			[VTScamtarget, [spawn_x, spawn_y ,spawn_z]] execVM "Computer\VTS_FreeCam.sqf";


			//Camera Options - hoz and mandoble's free cam settings, OFPEC - see: http://www.ofpec.com/forum/index.php?topic=32970.0
			OFPEC_MouseCoord = [0.5,0.5];
			OFPEC_MouseScroll = 0;
			OFPEC_MouseButtons =[false,false];
			OFPEC_camzoomspeed = 5;
			OFPEC_maxzoomout = 400;
			OFPEC_range_to_unit = 40;  //starting dist from target
		};
		clic1 = false;
		sleep 1;
	}; 
		sleep 0.5;
		"" spawn vts_gmmessage;
		breakclic = 0; 
		//	waitUntil {(clic1)};
};
if (true) exitWith {};
