
disableSerialization;

// Attention! il faut faire passer en global toutes les variables sur l'unit�!
// **********  mettre des ennemis dans les batiments **************



//D�but de script
if  (breakclic <= 1 ) then
{
	clic1 = false;

	_display = finddisplay 8000;
	_txt = _display displayctrl 200;

	_txt CtrlSetText "Left click on the map";
	_txt CtrlSetTextColor [0.9,0.9,0.9,1];

	Ctrlshow [200,true];sleep 0.2; CtrlShow [200,false];sleep 0.2;Ctrlshow [200,true];

  //R�cuperation des coordonn�es de la carte
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

			
				// D�tecte la premi�re unit� depuis le centre du click
				//_list = nearestObjects  [[spawn_x,spawn_y,0],["CAManBase","Car","Truck","Tank","Helicopter","Plane","StaticWeapon"],10];
				//On ne prends le control que d'un seul homme
				_list = nearestObjects  [[spawn_x,spawn_y,0],["CAManBase","Car","Truck","Tank","Helicopter","Plane","StaticWeapon"],1000];
				_nearest = _list select 0;
				hint format ["Groupe : %1, typeOf : %2, unit : %3",group _nearest,typeOf  _nearest,_nearest];
				copyToClipboard format ["G:%1,T:%2,U:%3",group _nearest,typeOf  _nearest,_nearest];

			};
			clic1 = false;
			

	}; 
		breakclic = 0; 
		//	waitUntil {(clic1)};
};
If (true) ExitWith {};
