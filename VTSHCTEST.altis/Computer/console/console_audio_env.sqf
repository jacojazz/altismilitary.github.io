disableSerialization;
// Attention! il faut faire passer en global toutes les variables sur l'unité!
if  (breakclic <= 1 ) then
{
	clic1 = false;
	_display = finddisplay 8000;
	_txt = _display displayctrl 200;

	_txt CtrlSetText "Left click on the map";
	_txt CtrlSetTextColor [0.9,0.9,0.9,1];
	Ctrlshow [200,true];sleep 0.2; CtrlShow [200,false];sleep 0.2;Ctrlshow [200,true];
	onMapSingleClick "markpos_x = _pos select 0;
		markpos_y = _pos select 1;

		clic1 = true;
	onMapSingleClick """";";
	for "_j" from 10 to 0 step -1 do 
	{
		format["Click On Map %1, or wait for cancellation",_j] spawn vts_gmmessage;
    sleep 1;
		if (clic1) then
		{
			"" spawn vts_gmmessage;
			_j=0;
			clic1 = false;							
			
			_soundobject = vts_dummyvehicle createvehicle [markpos_x,markpos_y];
			_sound=Envsoundvalid;
			_init=format ["
			_soundtrg=createTrigger[""EmptyDetector"",getPos _spawn];
			_soundtrg triggerAttachVehicle [_spawn];
			  _soundtrg setTriggerActivation [""VEHICLE"",""PRESENT"",true];
			  _soundtrg setTriggerStatements [""this"","""",""""];
			  _soundtrg setSoundEffect [""Info"","""","""",""%1""];
			  _spawn hideobject true;
			  ",_sound];
			  [_soundobject,_init] call vts_setobjectinit;
			  [] call vts_processobjectsinit;
      
			hint "Environment sound placed";
			
			_genericmarker=createMarkerLocal ["vtsgenericmarker"+(str vts_genericmarker),[markpos_x,markpos_y]];
			_genericmarker setMarkerSizeLocal [15,15];
			_genericmarker setmarkershapeLocal "ELLIPSE";
			_genericmarker setmarkerColorLocal "ColorBlue";
			[_soundobject,_genericmarker] call vts_setchild;
			vts_genericmarker=vts_genericmarker+1;
			publicvariable "vts_genericmarker";
		
   

		};
	clic1 = false;
	}; 
	sleep 0.5;
	"" spawn vts_gmmessage;
	breakclic = 0; 
		//	waitUntil {(clic1)};
};

If (true) ExitWith {};


