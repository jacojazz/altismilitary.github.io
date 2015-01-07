
disableSerialization;

_gmable=player getVariable "GMABLE";If !([player] call vts_getisGM) then {if (isnil "_gmable") then {killscript=true;breakclic=0;};}; if (killscript) exitwith {killscript=false;};

_spawnammuntion=
{
	    private ["_num","_classname","_alt","_sim"];
        _num=round(radius/10);
        if (_num<1) then {_num=1;};
        hint format["Spawning : %1 ammunition",_num];
        
		_classname=ammunitionvalid;
		_alt=getnumber (configfile >> "Cfgammo" >> _classname >> "typicalspeed");
		_sim=gettext (configfile >> "Cfgammo" >> _classname >> "simulation");
		
        for "_n" from 0 to (_num-1) do
        {
          _pos=[spawn_x-(radius/2)+random(radius),spawn_y-(radius/2)+random(radius),spawn_z];
          
          _ammo=_classname createvehicle _pos;
		  
		  //Everything except mines
		  if (_sim=="shotIlluminating" or _sim=="shotMissile" or _sim=="shotDeploy" or _sim=="shotRocket") then 
		  {
			_ammo setpos [(getpos _ammo select 0),(getpos _ammo select 1),(getpos _ammo select 2)+(_alt/2)];
			_ammo setVectorup [0,10000,1];
			//_ammo setVectorup [0,0,-1];
			//_ammo setdir (random 360);
			
		  };
		  //_ammo setVectorup [1,-1,0];
          _ammo setVelocity [0,0,-10];

		  //player sidechat str _ammo;
		  
          _random=random (1);
          _random=_random+0.05;
          sleep _random;		  

        };	
};

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
				_marker_Take setMarkerColorLocal "Coloryellow";
				
        //******************************
        //***** Code come here *********
		//******************************
				
		//hint "Spawning ammunition";

		[] spawn _spawnammuntion;
		
    	sleep 0.25;		
				

        			
				//******************************
			
      	sleep 0.5;
  			deletemarker "Nmarker";
  			//clean marker

								
			};
			clic1 = false;

	}; 
		sleep 0.5;
		//"" spawn vts_gmmessage;
		breakclic = 0; 
		//	waitUntil {(clic1)};
};
If (true) ExitWith {};
