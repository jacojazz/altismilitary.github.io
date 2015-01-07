
disableSerialization;

// Attention! il faut faire passer en global toutes les variables sur l'unité!
// **********  mettre des ennemis dans les batiments **************



//Début de script
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
			
				
				_list = [[spawn_x,spawn_y,0],["CAManBase","Car","Truck","Tank","StaticWeapon","Ship","Air"],50] call vts_nearestobjects2d;
							
				if ((count _list)==0) exitwith {breakclic = 0;hint "!!! No alive unit found !!!";};
				
				_nearest2dobj=_list select 0;

				vts_property_group=nil;
				vts_property_group_selected=group _nearest2dobj;
				vts_object_property_selected=_nearest2dobj;
				vts_object_property=[_nearest2dobj];
				[] call vts_property_showpanel;

			};
			clic1 = false;
			

	}; 
		breakclic = 0; 
		//	waitUntil {(clic1)};
};
If (true) ExitWith {};
