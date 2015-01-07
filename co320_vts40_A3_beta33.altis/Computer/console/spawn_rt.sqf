disableSerialization;

private ["_nom_groupe","_positX","_positY","_positZ","_pos1","_decallage","_grouparray","_composition","_currentsaveindex"];

	_positX = spawn_x ;
	_positY = spawn_y ;
	_positZ = spawn_z ;
	_positX2 = spawn_x2 ;
	_positY2 = spawn_y2 ;
	_positZ2 = spawn_z2 ;	
	_pos1=[_positX,_positY,_positZ];
	
	//Debug
	//player sidechat format["%1",from3D];
	
	if (console_unit_unite=="") exitwith 
	{
		hint "!!! Nothing to spawn !!!";
	};
	
	//Improve init of unit
	console_spawn_init="";
	console_spawn_init=console_init;
	
    //========== Generating the spawn script for save/load function	
	_currentsaveindex=vtsmissionpreset_index;
    if (isnil "vts_build_spawn") then {vts_build_spawn=false;};
	//Override to keep mission build in historic (since we can delete to remove stuff from historic)
	vts_build_spawn=false;
    if (!vts_build_spawn) then
    {
      _currentspawnscript=[false] call vts_storespawnsetup;
      call compile ("vtsmissionpreset_"+(str vtsmissionpreset_index)+"=_currentspawnscript;publicvariable 'vtsmissionpreset_"+(str vtsmissionpreset_index)+"';");	  
	  vtsmissionpreset_index=vtsmissionpreset_index+1;
	  publicvariable "vtsmissionpreset_index";
    };
	
     
		//====================================== MAN

		if (var_console_valid_type == "Man" or console_unit_unite isKindOf "Man" or var_console_valid_type=="Animal") then
		{
			if (vts_debug) then {player sidechat "Man";};
			
			var_hom_solo = var_hom_solo+1;
			if (console_nom =="") then {call compile format["console_nom = ""nom_h_s%1"";",(var_hom_solo)];};
			
			_tmpgroup=grpnull;
			_group=grpnull;
			
			
			if (var_console_valid_type=="Animal") then {var_console_valid_side="Civilian";};
			
			call compile format["
			_tmpgroup = creategroup %2;
			_group = creategroup %2;
			",var_hom_solo,var_console_valid_side];
			
			
			if From3D then 
			{
				call compile format["
				%1 = _tmpgroup createUnit [console_unit_unite,[0,0,10],[], 0, ""NONE""];
				%1 setdir console_unit_orientation ;
				%1 setPosatl [_positX2,_positY2,_positZ2 ];
				if (vts3DAttach) then {[getposasl %1,%1] call vts_3dattach;};
				",console_nom];
			} else 
			{
				call compile format["%2 = _tmpgroup createUnit [console_unit_unite,[_positX,_positY,_positZ ],[], 0, ""NONE""];",(var_hom_solo),(console_nom)];
			};

			//Workaround for badly configured addons (ie East soldier spawning as guerilla... or what ever), making sure they are the VTS side they show on	
			call compile format["
			[%1] joinsilent _group; deletegroup _tmpgroup;
			%1 call vts_setskill;
			if !(vts3DAttach) then {%1 setdir console_unit_orientation ;};
			%1 setBehaviour var_console_valid_attitude ;
			%1 setspeedmode var_console_valid_vitesse;
			%1 setFormDir console_unit_orientation;
			
			if (var_console_valid_formation!=""FORMATION"") then {%1 setFormation var_console_valid_formation;};
			
			[%1,(""%1 = _spawn;""+console_spawn_init+([%1] call vts_spawninit))] call vts_setobjectinit;
			",(console_nom)];
	

		};
		
		
		// ====================================== VEHICLES
		
		if ((var_console_valid_type == "Land" or var_console_valid_type == "Air" or var_console_valid_type == "Ship" or var_console_valid_type == "Static" or console_unit_unite isKindOf "LandVehicle" or console_unit_unite isKindOf "Helicopter" or console_unit_unite isKindOf "Plane" or console_unit_unite isKindOf "Ship") and (var_console_valid_type!="Empty") ) then
		{
			if (vts_debug) then {player sidechat "Vehicle";};
			var_v_solo = var_v_solo+1;
			if (console_nom =="") then {call compile format["console_nom = ""nom_v_s%1"";",(var_v_solo)];};
			
			_tmpgroup=grpnull;
			_group=grpnull;
			call compile format["
			_tmpgroup = creategroup %2;
			_group = creategroup %2;
			",(console_nom),var_console_valid_side];
			
			if From3D then 
			{
			 
			 	call compile format ["_tmpspawn= [[0,0,5000],console_unit_orientation,console_unit_unite,_tmpgroup,false] call vts_fnc_spawn_vehicle;  %1%2=_tmpspawn select 0; nomvehicule=%1%2;",(console_nom),(var_v_solo)];

				nomvehicule setvehicleVarName format["%1_V%2",(console_unit_unite),(var_v_solo)];
				
				//sleep 1;
				//sleep 0.1;
				nomvehicule setdir console_unit_orientation ;
				nomvehicule setPosatl [_positX2,_positY2,_positZ2 ];

				if (vts3DAttach) then {[getposasl nomvehicule,nomvehicule] call vts_3dattach;}
				 else
				 {nomvehicule enablesimulation false;};
			}
			else
			{
				call compile format ["_tmpspawn= [[_positX,_positY],console_unit_orientation,console_unit_unite,_tmpgroup] call vts_fnc_spawn_vehicle;  %1%2=_tmpspawn select 0; nomvehicule=%1%2;",(console_nom),(var_v_solo)];

				
				nomvehicule setvehicleVarName format["%1_V%2",(console_unit_unite),(var_v_solo)];
				nomvehicule setdir console_unit_orientation;

			};

			nomvehicule allowdamage false;
			call compile format ["_damaget%1 = [nomvehicule] spawn  vts_DamageSecurityTempo;",(var_v_solo)];
			
			//sleep 0.25;
			//Workaround for badly configured addons (ie East soldier spawning as guerilla... or what ever), making sure they are the VTS side they show on	
			call compile format["(units _tmpgroup) joinsilent _group;deletegroup _tmpgroup;%1 = _group;",(console_nom)];
			
			if !(vts3DAttach) then {nomvehicule setdir console_unit_orientation ;};
			{_x call vts_setskill;} foreach crew nomvehicule;
			nomvehicule call vts_setskill;
			call compile format["
			%1 setFormDir console_unit_orientation ;
			%1 setBehaviour var_console_valid_attitude;
			%1 setspeedmode var_console_valid_vitesse;
			
			if (var_console_valid_formation!=""FORMATION"") then {%1 setFormation var_console_valid_formation;};
			",(console_nom)];
	
		//No velocity for vehicles spawn from 3D
		if 	!(From3D) then
		{
			if (nomvehicule iskindof "Helicopter") then 
			  {
			  nomvehicule flyInHeight 100;
			  nomvehicule setvelocity [0,0,0];
			  };
			if (nomvehicule iskindof "Plane") then 
			  {
				nomvehicule flyInHeight 500;
				_vel = velocity nomvehicule;
				_dir = direction nomvehicule;
				_speed = 200;
				nomvehicule setpos [getpos nomvehicule select 0,getpos nomvehicule select 1,500];
				//Dunno why it doesn't work anymore
				[nomvehicule,_vel,_dir,_speed] spawn 
				{
					sleep 1.0;
					_vel=_this select 1;
					_dir=_this select 2;
					_speed=_this select 3;
				 ( _this select 0) setVelocity [(_vel select 0)+(sin _dir*_speed),(_vel select 1)+ (cos _dir*_speed),(_vel select 2)]; 
				};
				//nomvehicule setVelocity [(_vel select 0)+(sin _dir*_speed),(_vel select 1)+ (cos _dir*_speed),(_vel select 2)]; 
				
			  };
		
      
			if !(nomvehicule isKindOf "Air") then 
			{
				//nomvehicule setvelocity [0,0,0.5];
				//player sidechat "not air";
			}
			else 
			{
				nomvehicule setposatl [getposatl nomvehicule select 0,getposatl nomvehicule select 1,(getposatl nomvehicule select 2)+100];
			};
		};

		
		call compile format["	
		_vehiclegroup=[];
		{
			if (vehicle _x!=_x) then
			{
				if !((vehicle _x) in _vehiclegroup) then
				{
					[(vehicle _x),""%1 = _spawn;""+console_spawn_init+([(vehicle _x)] call vts_spawninit)] call vts_setobjectinit;
					_vehiclegroup set [count _vehiclegroup,(vehicle _x)];
				};
			};
			[_x,""%1 = _spawn;""+console_spawn_init+([_x] call vts_spawninit)] call vts_setobjectinit;
		} foreach units %1;
		",console_nom];
	


			
		};
		
		// ======================================================================================
		// ====================================== GROUPES =======================================
		// ======================================================================================
		
		if (var_console_valid_type == "Group") then
		{
			// --------------------------------------------------------------------------------------
			// -------------------- Créa du groupe_vehicule avec le nom donné -----------------------
			// --------------------------------------------------------------------------------------
			if (vts_debug) then {player sidechat "Group";};
			
			//on récupère l'array du groupe si vts custom group on converti le string en array
			_relpos=[];
			if ([console_unit_unite,1] call KRON_StrLeft=="[") then
			{
				call compile format ["_grouparray=%1;",console_unit_unite];
				_x=-2.5*((count _grouparray)/2);
				_y=0;
				//_y=-5*((count _grouparray)/2);
				for "_i" from 0 to (count _grouparray)-1 do
				{
					_relpos set [count _relpos,[_x,_y]];
					if ((_grouparray select _i) iskindof "Man") then
					{
					_x=_x+3;
					//_y=_y+3;
					};
					if ((_grouparray select _i) iskindof "Air") then
					{
					_x=_x+50;
					//_y=_y+50;
					}
					else
					{
						if !((_grouparray select _i) iskindof "Man") then
						{
						_x=_x+7;
						//_y=_y+7;
						};
					};
				};
			}
			else
			{
				//Sinon on utilise l'id du group (groupconfig & group sont des arrays paralleles)
				call compile format ["_grouparray=%1_GroupConfig select (%1_group find ""%2"");",var_console_valid_camp,console_unit_unite];
			};

			var_v_solo = var_v_solo+1;
			if (console_nom =="") then {call compile format["console_nom = ""nom_v_s%1"";",(var_v_solo)];};
			

      
			call compile format["%1 = [_pos1,%2,(_grouparray),%3,[],[],[],[-1,1],%4] call vts_fnc_spawn_group;",(console_nom),var_console_valid_side,_relpos,console_unit_orientation]; 
			
			//Make them join a new group to fix the bis function .. sigh... (else west unit spawning in east group are still west)
			call compile format["
			_grp=%1;
			_new_%1 = creategroup %2;
			{if (vehicle _x==_x) then {_x switchmove """";};[_x] joinsilent _new_%1;} foreach units %1;
			%1=_new_%1;
			deletegroup _grp;
			",(console_nom),var_console_valid_side];
			
			
			call compile format["
			%1 setFormDir console_unit_orientation;
			if (var_console_valid_formation!=""FORMATION"") then {%1 setFormation var_console_valid_formation;};
			%1 setBehaviour var_console_valid_attitude;
			%1 setspeedmode var_console_valid_vitesse;
			
			{_x call vts_setskill;} foreach units %1;

      {
		
      
      if (driver vehicle _x==_x) then 
      {
		

		
        if (vehicle _x isKindOf ""Air"") then {(vehicle _x) setposatl [getposatl (vehicle _x) select 0,getposatl (vehicle _x) select 1,(getposatl (vehicle _x) select 2)+75];};
   		
		if (vehicle _x isKindOf ""LandVehicle"") then {(vehicle _x) setposatl [getposatl (vehicle _x) select 0,getposatl (vehicle _x) select 1,(getposatl (vehicle _x) select 2)+1.0];};
		
		if (vehicle _x isKindOf ""camanbase"") then {(vehicle _x) setposatl [getposatl (vehicle _x) select 0,getposatl (vehicle _x) select 1,(getposatl (vehicle _x) select 2)+0.5];};
		
         if (vehicle _x iskindof ""Helicopter"") then 
        {
          vehicle _x setvelocity [0,0,0];
          vehicle _x setDir console_unit_orientation; 
          vehicle _x flyInHeight 100;
        };
  			if (vehicle _x iskindof ""Plane"") then 
        {
          
          vehicle _x setDir console_unit_orientation;
          vehicle _x flyInHeight 500;
          _vel = [0,0,0];
          _dir = console_unit_orientation;
          _speed = 200;        
		  vehicle _x setpos [getpos vehicle _x select 0,getpos vehicle _x select 1,500];
		  
          [vehicle _x,_vel,_dir,_speed] spawn 
		  {
		  sleep 1;
		  _vel=_this select 1;
		  _dir=_this select 2;
		  _speed=_this select 3;
		  (_this select 0) setVelocity [(_vel select 0)+(sin _dir*_speed),(_vel select 1)+ (cos _dir*_speed),(_vel select 2)];       
		  };
        };
        if !(vehicle _x iskindof ""Plane"" and vehicle _x isKindOf ""Air"") then {vehicle _x setDir console_unit_orientation;};
      };      
      } foreach units %1;

	  
		_vehiclegroup=[];
		{
			if (vehicle _x!=_x) then
			{
				if !((vehicle _x) in _vehiclegroup) then
				{
					[(vehicle _x),""%1 = _spawn;""+console_spawn_init+([(vehicle _x)] call vts_spawninit)] call vts_setobjectinit;
					_vehiclegroup set [count _vehiclegroup,(vehicle _x)];
				};
			};
			[_x,""%1 = _spawn;""+console_spawn_init+([_x] call vts_spawninit)] call vts_setobjectinit;
		} foreach units %1;
		",console_nom];
	  //player sidechat format["group : %1",console_nom];
      
      
		};	
			// ======================================================================================
			// ====================================== Materiels =======================================
			// ======================================================================================
			
		if (var_console_valid_type == "Empty" or var_console_valid_type == "Logistic" or console_unit_unite isKindOf "ReammoBox") then
		{
			if (vts_debug) then {player sidechat "Logistic";};
			
			var_v_solo = var_v_solo + 1;
			
			if (console_nom =="") then 
			{
				call compile format["console_nom = ""nom_v_s%1"";",(var_v_solo)];
			};
			
			// spawn du materiel
			
			if From3D then 
			{
				call compile format ["%1 = createVehicle [console_unit_unite, [0,0,4000], [], 0, ""NONE""]; nomvehicule = %1;nomvehicule setdir console_unit_orientation ;",(console_nom),(var_v_solo)];
				nomvehicule setdir console_unit_orientation ;
				nomvehicule setPosatl [_positX2,_positY2,_positZ2 ];
				if (vts3DAttach) then {[getposasl nomvehicule,nomvehicule] call vts_3dattach;}
				else
				{nomvehicule enablesimulation false;};
			}
			else
			{
				call compile format ["%1 = createVehicle [console_unit_unite, [_positX,_positY,0], [], 0, ""NONE""]; nomvehicule = %1;",(console_nom),(var_v_solo)];
			};
			
			// orientation du materiel
			nomvehicule setvariable ["vts_object",true,true];
			nomvehicule allowdamage false;

			call compile format ["_damaget%1 = [nomvehicule] spawn vts_DamageSecurityTempo;",(var_v_solo)];
			if !(vts3DAttach) then {nomvehicule setdir console_unit_orientation ;};
			
			//if !(nomvehicule iskindof "Plane") then 
			  //{
			  //nomvehicule setvelocity [0,0,-0.5];
			  //};
	  
			if (var_console_valid_type =="Empty") then 
			{
				clearWeaponCargoGlobal nomvehicule;
				clearMagazineCargoGlobal nomvehicule;
			};
	  
			//Post process on empty vehicles to create uav crew if needed and eventhandler related to destroyed wheels/tracks
			if ((nomvehicule iskindof "AllVehicles") && !(nomvehicule iskindof "MAN")) then
			{
				[nomvehicule,grpnull] call vts_spawn_vehicle_postprocess;
			};
	  
			
			_bbmarker="";
			/*
			if (var_console_valid_type == "Logistic") then
			{
				_bbmarker=format ["[_spawn,'%1%2',%3,%4] call vts_createbbmarker;",console_nom,(var_v_solo),[round _positX, round _positY],round console_unit_orientation];
			};
			*/
			call compile format["[nomvehicule,""%1 = _spawn;""+_bbmarker+console_spawn_init+([%1] call vts_spawninit)] call vts_setobjectinit;",console_nom,(var_v_solo)];
			

				
		};
			

			
	// ======================================================================================
	// ====================================== OBJECTS =======================================
	// ======================================================================================
			
	if (var_console_valid_type == "Object" or var_console_valid_type == "Building") then
	{
			if (vts_debug) then {player sidechat "Object";};
			
			var_v_solo = var_v_solo+1;
			if (console_nom =="") then 
			{
				call compile format["console_nom = ""nom_v_s%1"";",(var_v_solo)];
			};
			
			// spawn du materiel
			if From3D then 
			{
				call compile format ["%1 = createVehicle [console_unit_unite, [0,0,10], [], 0, ""NONE""] ;nomvehicule = %1;nomvehicule setdir console_unit_orientation ;",(console_nom),(var_v_solo)];

				nomvehicule setdir console_unit_orientation;
				nomvehicule setPosatl [_positX2,_positY2,_positZ2 ];		
				
				if (vts3DAttach) then {[getposasl nomvehicule,nomvehicule] call vts_3dattach;}
				else {nomvehicule enablesimulation false;};
				
			}
			else
			{
				call compile format ["%1 = createVehicle [console_unit_unite, [_positX,_positY,0], [], 0, ""NONE""] ;nomvehicule = %1;",(console_nom),(var_v_solo)];
			};
			
			// orientation du materiel
			if !(vts3DAttach) then {nomvehicule setdir console_unit_orientation ;};

			 //Add variable to be handled by other vts tool
			nomvehicule setvariable ["vts_object",true,true];
			 
			nomvehicule allowdamage false;
			
			//No velocity fix on building (cause damage on player)
			if !(nomvehicule iskindof "Thing") then
			{
				call compile format ["_damaget%1 = [nomvehicule,false] spawn vts_DamageSecurityTempo;",(var_v_solo)];
			}
			//Else apply velocity fix to make physic object to fall
			else
			{
				call compile format ["_damaget%1 = [nomvehicule] spawn vts_DamageSecurityTempo;",(var_v_solo)];
			};
			
			call compile format["[nomvehicule,""%1 = _spawn;""+console_spawn_init+([%1] call vts_spawninit)] call vts_setobjectinit;",console_nom,var_v_solo,[round _positX, round _positY],round console_unit_orientation];
			
			
			
	};
	
	// ======================================================================================
	// ====================================== Modules ================================
	// ======================================================================================
	
	if (var_console_valid_type == "Module" ) then
	{			
	
		if (vts_debug) then {player sidechat "Module";};
		
		var_v_solo = var_v_solo + 1;
			
		if (console_nom == "") then 
		{
				call compile format["console_nom = ""nom_v_s%1"";",(var_v_solo)];
		};
		call compile format ["%1 =(creategroup sidelogic) createUnit [console_unit_unite,[_positX,_positY,_positZ],[],0,""none""];",console_nom];
	};
	
	// ======================================================================================
	// ====================================== Base ================================
	// ======================================================================================
	
	if (var_console_valid_type == "Base" or var_console_valid_type == "Composition") then
	{
		
		if (vts_debug) then {player sidechat "Base";};
		
		// Si les objets sont des compositions :
		if (console_unit_unite != "OutPost" and console_unit_unite!="Checkpoint") then
		{
		  var_v_solo = var_v_solo+1;
		  if (console_nom =="") then {call compile format["console_nom = ""nom_v_s%1"";",(var_v_solo)];};
		  call compile format ["_composition=%1_CompositionScript select %2;",var_console_valid_camp,console_valid_unite];

		  
		  [_composition,console_unit_orientation,[_positX,_positY,_positZ]] execvm "Computer\console\Createcomposition.sqf";
      



		};
			
		// Si les objets sont des objets speciaux :
			
		if (console_unit_unite == "Checkpoint" or console_unit_unite == "Outpost") then
		{
			// protection en cas d'absence de nom
			
			var_v_solo = var_v_solo+1;
			if (console_nom =="") then {call compile format["console_nom = ""nom_v_s%1"";",(var_v_solo)];};
			
			//Variable pour le marker
			_baseformaker=objnull;
			_spawngrp=grpnull;

			if (console_unit_unite == "Outpost") then
			{
					call compile format["
					
					_spawngrp = creategroup %2;
			
					vehicule = [%1_Land,1] call VTS_takeonestringfrom; 
					soldat1 = [%1_Man,1] call VTS_takeonestringfrom;  
					soldat2 = [%1_Man,1] call VTS_takeonestringfrom;  
					soldat3 = [%1_Man,1] call VTS_takeonestringfrom;  
					soldat4 = [%1_Man,1] call VTS_takeonestringfrom;  
					soldat5 = [%1_Man,1] call VTS_takeonestringfrom;  
					arme_statique = [%1_Static,1] call VTS_takeonestringfrom;  
				",var_console_valid_camp,var_console_valid_side];
				// On spawne les éléments de base				
				_fort = createVehicle [vts_compobuildingnest, [_positX,_positY,0], [], 0, "None"];_fort setvariable ["vts_object",true,true];
				_baseformaker=_fort;
				
				_drap = createVehicle [vts_compoflag, [_positX+5,_positY+5,0], [], 0, "None"];_drap setvariable ["vts_object",true,true];
				_fire1 = createVehicle [vts_compofireplace, [_positX+3,_positY+5,0], [], 0, "None"];_fire1 setvariable ["vts_object",true,true];
				MASH1 = createVehicle [vts_compobuildingmash, [_positX,_positY-20,0], [], 0, "None"]; MASH1 setdir 0 ;MASH1 setvariable ["vts_object",true,true];
				stat1 = createVehicle [arme_statique, [_positX+7,_positY+7,0], [], 0, "None"]; stat1 setdir 45 ;stat1 setvariable ["vts_object",true,true];
				stat2 = createVehicle [arme_statique, [_positX-7,_positY-7,0], [], 0, "None"]; stat2 setdir -135 ;stat2 setvariable ["vts_object",true,true];
				
				_mur2 = createVehicle [vts_compolowwall, [_positX-5,_positY+13,0], [], 0, "None"]; _mur2 setdir 00 ;_mur2 setvariable ["vts_object",true,true];
				_mur3 = createVehicle [vts_compolowwall, [_positX,_positY+13,0], [], 0, "None"]; _mur3 setdir 00 ;_mur3 setvariable ["vts_object",true,true];
				_mur4 = createVehicle [vts_compolowwall, [_positX+5,_positY+13,0], [], 0, "None"]; _mur4 setdir 00 ;_mur4 setvariable ["vts_object",true,true];
				
				_mur5 = createVehicle [vts_compolowwall, [_positX+13,_positY-5,0], [], 0, "None"]; _mur5 setdir 90 ;_mur5 setvariable ["vts_object",true,true];
				_mur6 = createVehicle [vts_compolowwall, [_positX+13,_positY,_positZ], [], 0, "None"]; _mur6 setdir 90 ;_mur6 setvariable ["vts_object",true,true];
				_mur7 = createVehicle [vts_compolowwall, [_positX+13,_positY+5,0], [], 0, "None"]; _mur7 setdir 90 ;_mur7 setvariable ["vts_object",true,true];
				
				_mur8 = createVehicle [vts_compolowwall, [_positX-13,_positY-5,0], [], 0, "None"]; _mur8 setdir 90 ;_mur8 setvariable ["vts_object",true,true];
				_mur9 = createVehicle [vts_compolowwall, [_positX-13,_positY,_positZ], [], 0, "None"]; _mur9 setdir 90 ;_mur9 setvariable ["vts_object",true,true];
				_mur10 = createVehicle [vts_compolowwall, [_positX-13,_positY+5,0], [], 0, "None"]; _mur10 setdir 90 ;_mur10 setvariable ["vts_object",true,true];
				
				_mur11 = createVehicle [vts_compolowwall, [_positX,_positY-13,0], [], 0, "None"]; _mur11 setdir 00 ;_mur11 setvariable ["vts_object",true,true];
				_mur12 = createVehicle [vts_compolowwall, [_positX+5,_positY-13,0], [], 0, "None"]; _mur12 setdir 00 ;_mur12 setvariable ["vts_object",true,true];
				
				_barb1 = createVehicle [vts_compofence, [_positX-7,_positY+15,0], [], 0, "None"]; _barb1 setdir 0 ;_barb1 setvariable ["vts_object",true,true];
				_barb2 = createVehicle [vts_compofence, [_positX,_positY+15,0], [], 0, "None"]; _barb2 setdir 0 ;_barb2 setvariable ["vts_object",true,true];
				_barb3 = createVehicle [vts_compofence, [_positX+7,_positY+15,0], [], 0, "None"]; _barb3 setdir 0 ;_barb3 setvariable ["vts_object",true,true];
				
				_barb4 = createVehicle [vts_compofence, [_positX-7,_positY-15,0], [], 0, "None"]; _barb4 setdir 0 ;_barb4 setvariable ["vts_object",true,true];
				_barb5 = createVehicle [vts_compofence, [_positX,_positY-15,0], [], 0, "None"]; _barb5 setdir 0 ;_barb5 setvariable ["vts_object",true,true];
				_barb6 = createVehicle [vts_compofence, [_positX+7,_positY-15,0], [], 0, "None"]; _barb6 setdir 0 ;_barb6 setvariable ["vts_object",true,true];
				
				_barb7 = createVehicle [vts_compofence, [_positX+15,_positY-7,0], [], 0, "None"]; _barb7 setdir 90 ;_barb7 setvariable ["vts_object",true,true];
				_barb8 = createVehicle [vts_compofence, [_positX+15,_positY,_positZ], [], 0, "None"]; _barb8 setdir 90 ;_barb8 setvariable ["vts_object",true,true];
				_barb9 = createVehicle [vts_compofence, [_positX+15,_positY+7,0], [], 0, "None"]; _barb9 setdir 90 ;_barb9 setvariable ["vts_object",true,true];
				
				_barb10 = createVehicle [vts_compofence, [_positX-15,_positY-7,0], [], 0, "None"]; _barb10 setdir 90 ;_barb10 setvariable ["vts_object",true,true];
				_barb11 = createVehicle [vts_compofence, [_positX-15,_positY,_positZ], [], 0, "None"]; _barb11 setdir 90 ;_barb11 setvariable ["vts_object",true,true];
				_barb12 = createVehicle [vts_compofence, [_positX-15,_positY+7,0], [], 0, "None"]; _barb12 setdir 90 ;_barb12 setvariable ["vts_object",true,true];
				
				vehic = createVehicle [vehicule, [_positX-16,_positY-16,_positZ+1] findEmptyPosition [3,100], [], 0, "None"]; vehic setdir 0 ;
				//vehic setvelocity [0,0,2];
				// on spawne les unités
				
				call compile format["
				_tmpsoldier = (creategroup %1) createUnit [soldat1, [_positX+1,_positY+1,_positZ], [], 0, ""NONE""]; [_tmpsoldier] joinsilent _spawngrp;
				_tmpsoldier = (creategroup %1) createUnit [soldat2, [_positX-1,_positY-1,_positZ], [], 0, ""NONE""]; [_tmpsoldier] joinsilent _spawngrp;
				_tmpsoldier = (creategroup %1) createUnit [soldat3, [_positX+2,_positY-2,_positZ], [], 0, ""NONE""]; [_tmpsoldier] joinsilent _spawngrp; _tmpsoldier assignasgunner vehic ;_tmpsoldier moveingunner vehic;
				_tmpsoldier = (creategroup %1) createUnit [soldat4, [_positX,_positY,_positZ], [], 0, ""NONE""]; [_tmpsoldier] joinsilent _spawngrp;_tmpsoldier assignasgunner stat1 ;_tmpsoldier moveingunner stat1;
				_tmpsoldier = (creategroup %1) createUnit [soldat5, [_positX,_positY,_positZ+10], [], 0, ""NONE""]; [_tmpsoldier] joinsilent _spawngrp;_tmpsoldier assignasgunner stat2;_tmpsoldier moveingunner stat2;
				",var_console_valid_side];
				{_x call vts_setskill;} foreach units _spawngrp;
			};
			
			if (console_unit_unite == "Checkpoint") then
			{
			// ------------ checkpoint
			// On détermine le matériel selon le camp
			call compile format["
			_spawngrp = creategroup %2;
		   vehicule = [%1_Land,1] call VTS_takeonestringfrom; 
		   soldat1 = [%1_Man,1] call VTS_takeonestringfrom; 
		   soldat2 = [%1_Man,1] call VTS_takeonestringfrom; 
		   soldat3 = [%1_Man,1] call VTS_takeonestringfrom; 
		   soldat4 = [%1_Man,1] call VTS_takeonestringfrom; 
		   soldat5 = [%1_Man,1] call VTS_takeonestringfrom; 
		   arme_statique = [%1_Static,1] call VTS_takeonestringfrom; 
			",var_console_valid_camp,var_console_valid_side];
			
				// On spawne les éléments de base - selon la direction! Madame redondance, bonjour ;)
				
				if (console_unit_orientation == 0) then 
				{
					// spawn du statique
					_barb = createVehicle [vts_compofence, [_positX,_positY,_positZ], [], 0, "None"]; _barb setdir 0 ;_barb setvariable ["vts_object",true,true];
					_mur = createVehicle [vts_compolowwall, [_positX+5,_positY-5,0], [], 0, "None"]; _mur setdir 90 ;_mur setvariable ["vts_object",true,true];	
					_baseformaker=_mur;
					//_fire1 = createVehicle [vts_compofireplace, [_positX-5,_positY-15,0], [], 0, "None"];
					//MASH1 = createVehicle [vts_compobuildingmash, [_positX-13,_positY-15,0], [], 0, "None"]; MASH1 setdir 0 ;
					
					vehic = createVehicle [vehicule, [_positX-5,_positY-5,_positZ+1] findEmptyPosition [3,100], [], 0, "None"]; vehic setdir 0 ;
					//vehic setvelocity [0,0,-0.5];
					stat = createVehicle [arme_statique, [_positX+5,_positY-7,_positZ+1], [], 0, "None"]; stat setdir 0 ;
					
					// On spawne les gardes
					
					call compile format ["
					_tmpsoldier = (creategroup %1) createUnit [soldat1,[_positX,_positY-1,0],[], 0, ""NONE""]; [_tmpsoldier] joinsilent _spawngrp;
					_tmpsoldier = (creategroup %1) createUnit [soldat2,[_positX,_positY-3,0],[], 0, ""NONE""]; [_tmpsoldier] joinsilent _spawngrp;
					_tmpsoldier = (creategroup %1) createUnit [soldat3,[_positX,_positY-5,0],[], 0, ""NONE""]; [_tmpsoldier] joinsilent _spawngrp;
					",var_console_valid_side];

					h_ori setdir console_unit_orientation ;
				};
				
				if (console_unit_orientation == 45) then 
				{
					// spawn du statique
					_barb = createVehicle [vts_compofence, [_positX,_positY,_positZ], [], 0, "None"]; _barb setdir 45 ;_barb setvariable ["vts_object",true,true];
					_mur = createVehicle [vts_compolowwall, [_positX+3,_positY-7,0], [], 0, "None"]; _mur setdir 135 ;_mur setvariable ["vts_object",true,true];	
					_baseformaker=_mur;
					vehic = createVehicle [vehicule, [_positX-10,_positY,_positZ+1] findEmptyPosition [3,100], [], 0, "None"]; vehic setdir 45 ;
					//vehic setvelocity [0,0,-0.5];
					stat = createVehicle [arme_statique, [_positX+4,_positY-9,_positZ], [], 0, "None"]; stat setdir 45 ;
					
					// On spawne les gardes
					
					call compile format ["
					_tmpsoldier = (creategroup %1) createUnit [soldat1,[_positX,_positY-1,0],[], 0, ""NONE""]; [_tmpsoldier] joinsilent _spawngrp;
					_tmpsoldier = (creategroup %1) createUnit [soldat2,[_positX,_positY-3,0],[], 0, ""NONE""]; [_tmpsoldier] joinsilent _spawngrp;
					_tmpsoldier = (creategroup %1) createUnit [soldat3,[_positX,_positY-5,0],[], 0, ""NONE""]; [_tmpsoldier] joinsilent _spawngrp;
					",var_console_valid_side];
				};

				if (console_unit_orientation == 90) then 
				{
					// spawn du statique
					_barb = createVehicle [vts_compofence, [_positX,_positY,_positZ], [], 0, "None"]; _barb setdir 90 ;_barb setvariable ["vts_object",true,true];
					_mur = createVehicle [vts_compolowwall, [_positX-7,_positY-3,0], [], 0, "None"]; _mur setdir 180 ;_mur setvariable ["vts_object",true,true];	
					_baseformaker=_mur;
					vehic = createVehicle [vehicule, [_positX,_positY+10,_positZ+1] findEmptyPosition [3,100], [], 0, "None"]; vehic setdir 90 ;
					//vehic setvelocity [0,0,-0.5];
					stat = createVehicle [arme_statique, [_positX-9,_positY-3,_positZ], [], 0, "None"]; stat setdir 90 ;
					
					// On spawne les gardes
					
					call compile format ["
					_tmpsoldier = (creategroup %1) createUnit [soldat1,[_positX,_positY-1,0],[], 0, ""NONE""]; [_tmpsoldier] joinsilent _spawngrp;
					_tmpsoldier = (creategroup %1) createUnit [soldat2,[_positX,_positY-3,0],[], 0, ""NONE""]; [_tmpsoldier] joinsilent _spawngrp;
					_tmpsoldier = (creategroup %1) createUnit [soldat3,[_positX,_positY-5,0],[], 0, ""NONE""]; [_tmpsoldier] joinsilent _spawngrp;
					",var_console_valid_side];
				};
			
				if (console_unit_orientation == 135) then 
				{
					// spawn du statique
					_barb = createVehicle [vts_compofence, [_positX,_positY,_positZ], [], 0, "None"]; _barb setdir 135 ;_barb setvariable ["vts_object",true,true];
					_mur = createVehicle [vts_compolowwall, [_positX-5,_positY-3,0], [], 0, "None"]; _mur setdir 225 ;_mur setvariable ["vts_object",true,true];	
					_baseformaker=_mur;
					vehic = createVehicle [vehicule, [_positX-1,_positY+8,_positZ+1] findEmptyPosition [3,100], [], 0, "None"]; vehic setdir 135 ;
					//vehic setvelocity [0,0,-0.5];
					stat = createVehicle [arme_statique, [_positX-7,_positY-1,_positZ], [], 0, "None"]; stat setdir 135 ;
					
					// On spawne les gardes
					
					call compile format ["
					_tmpsoldier = (creategroup %1) createUnit [soldat1,[_positX,_positY-1,0],[], 0, ""NONE""]; [_tmpsoldier] joinsilent _spawngrp;
					_tmpsoldier = (creategroup %1) createUnit [soldat2,[_positX,_positY-3,0],[], 0, ""NONE""]; [_tmpsoldier] joinsilent _spawngrp;
					_tmpsoldier = (creategroup %1) createUnit [soldat3,[_positX,_positY-5,0],[], 0, ""NONE""]; [_tmpsoldier] joinsilent _spawngrp;
					",var_console_valid_side];
				};
			
				if (console_unit_orientation == 180) then 
				{
					// spawn du statique
					_barb = createVehicle [vts_compofence, [_positX,_positY,_positZ], [], 0, "None"]; _barb setdir 180 ;_barb setvariable ["vts_object",true,true];
					_mur = createVehicle [vts_compolowwall, [_positX+5,_positY+5,0], [], 0, "None"]; _mur setdir -90 ;_mur setvariable ["vts_object",true,true];	
					_baseformaker=_mur;
					vehic = createVehicle [vehicule, [_positX-5,_positY+5,_positZ+1] findEmptyPosition [3,100], [], 0, "None"]; vehic setdir 180 ;
					//vehic setvelocity [0,0,-0.5];
					stat = createVehicle [arme_statique, [_positX+6,_positY+6,_positZ], [], 0, "None"]; stat setdir 180 ;
					//_fire1 = createVehicle [vts_compofireplace, [_positX+5,_positY+15,0], [], 0, "None"];
					//MASH1 = createVehicle [vts_compobuildingmash, [_positX+13,_positY+15,0], [], 0, "None"]; MASH1 setdir 180 ;
					
					// On spawne les gardes
					
					call compile format ["
					_tmpsoldier = (creategroup %1) createUnit [soldat1,[_positX,_positY-1,0],[], 0, ""NONE""]; [_tmpsoldier] joinsilent _spawngrp;
					_tmpsoldier = (creategroup %1) createUnit [soldat2,[_positX,_positY-3,0],[], 0, ""NONE""]; [_tmpsoldier] joinsilent _spawngrp;
					_tmpsoldier = (creategroup %1) createUnit [soldat3,[_positX,_positY-5,0],[], 0, ""NONE""]; [_tmpsoldier] joinsilent _spawngrp;
					",var_console_valid_side];
				};
			
			
				if (console_unit_orientation == -135) then 
				{
					_barb = createVehicle [vts_compofence, [_positX,_positY,_positZ], [], 0, "None"]; _barb setdir -135 ;_barb setvariable ["vts_object",true,true];
					_mur = createVehicle [vts_compolowwall, [_positX+7,_positY-3,0], [], 0, "None"]; _mur setdir -45 ;_mur setvariable ["vts_object",true,true];	
					_baseformaker=_mur;
					vehic = createVehicle [vehicule, [_positX,_positY+10,_positZ+1] findEmptyPosition [3,100], [], 0, "None"]; vehic setdir -135 ;
					//vehic setvelocity [0,0,-0.5];
					stat = createVehicle [arme_statique, [_positX+11,_positY,_positZ], [], 0, "None"]; stat setdir -135 ;
					
					// On spawne les gardes
					
					call compile format ["
					_tmpsoldier = (creategroup %1) createUnit [soldat1,[_positX,_positY-1,0],[], 0, ""NONE""]; [_tmpsoldier] joinsilent _spawngrp;
					_tmpsoldier = (creategroup %1) createUnit [soldat2,[_positX,_positY-3,0],[], 0, ""NONE""]; [_tmpsoldier] joinsilent _spawngrp;
					_tmpsoldier = (creategroup %1) createUnit [soldat3,[_positX,_positY-5,0],[], 0, ""NONE""]; [_tmpsoldier] joinsilent _spawngrp;
					",var_console_valid_side];
					
				};
			
			
				if (console_unit_orientation == -90) then 
				{
					// spawn du statique
					_barb = createVehicle [vts_compofence, [_positX,_positY,_positZ], [], 0, "None"]; _barb setdir -90 ;_barb setvariable ["vts_object",true,true];
					_mur = createVehicle [vts_compolowwall, [_positX+7,_positY+3,0], [], 0, "None"]; _mur setdir 180 ;_mur setvariable ["vts_object",true,true];
					_baseformaker=_mur;
					vehic = createVehicle [vehicule, [_positX,_positY-10,_positZ+1] findEmptyPosition [3,100], [], 0, "None"]; vehic setdir -90 ;
					//vehic setvelocity [0,0,-0.5];
					stat = createVehicle [arme_statique, [_positX+9,_positY+5,_positZ], [], 0, "None"]; stat setdir -90 ;
					
					// On spawne les gardes
					
					call compile format ["
					_tmpsoldier = (creategroup %1) createUnit [soldat1,[_positX,_positY-1,0],[], 0, ""NONE""]; [_tmpsoldier] joinsilent _spawngrp;
					_tmpsoldier = (creategroup %1) createUnit [soldat2,[_positX,_positY-3,0],[], 0, ""NONE""]; [_tmpsoldier] joinsilent _spawngrp;
					_tmpsoldier = (creategroup %1) createUnit [soldat3,[_positX,_positY-5,0],[], 0, ""NONE""]; [_tmpsoldier] joinsilent _spawngrp;
					",var_console_valid_side];
				
				};
				
				if (console_unit_orientation == -45) then 
				{
					// spawn du statique
					_barb = createVehicle [vts_compofence, [_positX,_positY,_positZ], [], 0, "None"]; _barb setdir -45 ;_barb setvariable ["vts_object",true,true];
					_mur = createVehicle [vts_compolowwall, [_positX+5,_positY+3,0], [], 0, "None"]; _mur setdir 225 ;_mur setvariable ["vts_object",true,true];	
					_baseformaker=_mur;
					vehic = createVehicle [vehicule, [_positX+1,_positY-8,_positZ+1] findEmptyPosition [3,100], [], 0, "None"]; vehic setdir -45 ;
					//vehic setvelocity [0,0,-0.5];
					stat = createVehicle [arme_statique, [_positX+7,_positY+1,_positZ], [], 0, "None"]; stat setdir -45 ;
					
					// On spawne les gardes
					
					call compile format ["
					_tmpsoldier = (creategroup %1) createUnit [soldat1,[_positX,_positY-1,0],[], 0, ""NONE""]; [_tmpsoldier] joinsilent _spawngrp;
					_tmpsoldier = (creategroup %1) createUnit [soldat2,[_positX,_positY-3,0],[], 0, ""NONE""]; [_tmpsoldier] joinsilent _spawngrp;
					_tmpsoldier = (creategroup %1) createUnit [soldat3,[_positX,_positY-5,0],[], 0, ""NONE""]; [_tmpsoldier] joinsilent _spawngrp;
					",var_console_valid_side];
				};
					
				// on spawne les dernières unités
					call compile format ["
					_tmpsoldier = (creategroup %1) createUnit [soldat4,[_positX,_positY,_positZ],[], 0, ""NONE""]; [_tmpsoldier] joinsilent _spawngrp; _tmpsoldier assignasgunner stat ; _tmpsoldier moveingunner stat ; _tmpsoldier setdir console_unit_orientation ;
					_tmpsoldier = (creategroup %1) createUnit [soldat5,[_positX,_positY,_positZ],[], 0, ""NONE""]; [_tmpsoldier] joinsilent _spawngrp; _tmpsoldier assignasgunner vehic ; _tmpsoldier moveingunner vehic ; _tmpsoldier setdir console_unit_orientation ;
					",var_console_valid_side];
					{_x call vts_setskill;} foreach units _spawngrp;
				
				//On pose le vehicules bien sur le sol
				//vehic setvelocity [0,0,-0.5];
				
			};
			
			call compile format["[_baseformaker,""%1%2""] call vts_setchild;%1=_baseformaker;",console_nom,var_v_solo];
		};
		
		  //Inform GM about the composition spawned
		_code={};
		call compile format["
      _code=
      {
        if ([player] call vts_getisGM) then 
        {
          _marker=objnull;
          _marker = createMarkerLocal [""%1%2"",%3];
          _marker setMarkerTypeLocal ""mil_box"";
          _marker setMarkerColorLocal ""ColorYellow"";
          _marker setMarkerSizeLocal [1,1];
          _marker setMarkerTextLocal ""%4"";
        };
      };",console_nom,var_v_solo,[spawn_x,spawn_y,spawn_z],console_unit_unite];
      [_code] call vts_broadcastcommand;
	  
	   
		
	};
	
	//So still using this crapy move function wich doesnt create a real waypoint and so is only local. Blah...
	if (var_console_valid_mouvement!="") then
	{

		if ((var_console_valid_mouvement=="Joueur")) then
		{
			call compile format["%1 move position user1;",(console_nom)];
		};
	
		if ((var_console_valid_mouvement=="Joueur")) then
		{
			call compile format["%1 move position usere1;",(console_nom)];
		};
	
		if ((var_console_valid_mouvement=="Joueur")) then
		{
			call compile format["%1 move position useri1;",(console_nom)];
		};
	
	};
	
	/*
	//Checking VTS_HC_AI present to give him the locality of spawned group before giving them order scripts
	if !(isnil "VTS_HC_AI") then
	{
		if !(isnull VTS_HC_AI) then
		{
			private ["_currentspawn","_currentgrp","_isgroup"];
			call compile format["_currentspawn=%1;",(console_nom)]; 
			//Retrieve the group of spawn, if not already a group
			if (typename _currentspawn!="GROUP") then {_currentgrp=group _currentspawn;_isgroup=false;} else {_currentgrp=_currentspawn;_isgroup=true;};
			//Some spawn can't have a group (objet, ammobox , building etc) they don't need to be handled by the HC
			if !(isnull _currentgrp) then
			{
				//Setowner seem to cause havok in AI :( (stuck not following order then... what ever)
				_hcmachine=owner VTS_HC_AI;
				//{_x setowner _hcmachine} foreach units _currentgrp;
				
				//Instead i'll write a nice teamswap xD
				_newgrp=creategroup (side _currentgrp);
				[VTS_HC_AI] joinsilent _newgrp;
				//_x setowner _hcmachine
				player sidechat str count units _currentgrp;
				{[_x] joinsilent _newgrp;} foreach units _currentgrp;
				[VTS_HC_AI] joinsilent grpnull;
				deletegroup _currentgrp;
				
				if (_isgroup) then {call compile format["%1=_newgrp;",console_nom];} else {call compile format["%1=_currentspawn;",console_nom];};
				//Setup the group orientation again.
				call compile format["group leader %1 setFormDir console_unit_orientation;",(console_nom)];
				//Should do the trick (no sure if the squad leader while the same btw after this ...)
				//player sidechat "locality change";
			};
		};
	};
	*/
	//On process les inits un fois dispatché sur le HC ou non (ainsi tout les scripts spéciaux placé dans l'init se lance sur la bonne machine
	//On sync d'abord les nombres de spawn pour essayer de garder une synchro au niveau des noms sur tout les clients
	publicvariable "vtso_num";
	[] call vts_processobjectsinit;
	
	//Clean all waypoints before proceding to order
	call compile format["[group leader %1] call vts_clearwaypoints;",console_nom];
	
	// On vérifie si des scripts de mouvement ont été sélectionnés
	// Seulement si on est pas en 3D et que ce sont des objets sans AI
	if (!(From3D) && !(var_console_valid_type in type_objects)) then
	{
		
		if (var_console_valid_mouvement==script1Sqf) then
		{
			call compile format["_script1 = [%1,_positX,_positY] execVM ""Computer\behaviors\%2"";",(console_nom),(script1Sqf)];
		};
		
		if (var_console_valid_mouvement==script2Sqf) then
		{
			call compile format["_script2 = [%1,_positX,_positY] execVM ""Computer\behaviors\%2"";",(console_nom),(script2Sqf)];
		};
		
		if (var_console_valid_mouvement==script3Sqf) then
		{
			call compile format["_script3 = [%1,_positX,_positY] execVM ""Computer\behaviors\%2"";",(console_nom),(script3Sqf)];
		};
		
		if (var_console_valid_mouvement==script4Sqf) then
		{
			call compile format["_script4 = [%1,_positX,_positY] execVM ""Computer\behaviors\%2"";",(console_nom),(script4Sqf)];
		};
		
		if (var_console_valid_mouvement==script5Sqf) then
		{
			call compile format["_script5 = [%1,_positX,_positY] execVM ""Computer\behaviors\%2"";",(console_nom),(script5Sqf)];
		};
		
		if (var_console_valid_mouvement==script6Sqf) then
		{
			call compile format["_script6 = [%1,_positX,_positY] execVM ""Computer\behaviors\%2"";",(console_nom),(script6Sqf)];
		};
	/*
		if (var_console_valid_mouvement==script7Sqf) then
		{
			call compile format["_script7 = [%1,_positX,_positY] execVM ""Computer\behaviors\%2"";",(console_nom),(script7Sqf)];
			_spawnedwithorder=true;
		};
	*/	
		if (var_console_valid_mouvement==script14Sqf) then
		{
			call compile format["_script6 = [%1,_positX,_positY] execVM ""Computer\behaviors\%2"";",(console_nom),(script14Sqf)];
		};	
		if (var_console_valid_mouvement==script8Sqf) then
		{
			call compile format["_script8 = [%1,_positX,_positY] execVM ""Computer\behaviors\%2"";",(console_nom),(script8Sqf)];
		};
		if (var_console_valid_mouvement==script9Sqf) then
		{
			call compile format["_script9 = [%1,_positX,_positY] execVM ""Computer\behaviors\%2"";",(console_nom),(script9Sqf)];
		};  

		if (var_console_valid_mouvement==script10Sqf) then
		{
			call compile format["_script10 = [%1,_positX,_positY] execVM ""Computer\behaviors\%2"";",(console_nom),(script10Sqf)];
		};  

		if (var_console_valid_mouvement==script11Sqf) then
		{
			call compile format["_script11 = [%1,_positX,_positY] execVM ""Computer\behaviors\%2"";",(console_nom),(script11Sqf)];
		};  	

		if (var_console_valid_mouvement==script12Sqf) then
		{
			call compile format["_script12 = [%1,_positX,_positY] execVM ""Computer\behaviors\%2"";",(console_nom),(script12Sqf)];
		};  	
		if (var_console_valid_mouvement in vts_UPSMONscript) then
		{
			call compile format["
			_patrolscript = [(leader group %1),var_console_valid_mouvement,[_positX,_positY],radius,var_console_valid_attitude] execVM ""Computer\behaviors\UPSscripts.sqf"";
			",console_nom];				
		}; 
		//AI script if no using the UPS ai
		if (!(var_console_valid_mouvement in vts_UPSMONscript) && (pa_aiautomanage==1)) then
		{
			call compile format["vtsgrouporderupdated=group (leader %1);",console_nom];
			//publicvariable "vtsgrouporderupdated";			
			
			
			_code={
				_group=_this select 0;
				vtsgrouporderupdated=nil;
				if (local (leader _group)) then
				{
					_aicript = [_group] execVM "functions\ai_engaged.sqf";
					_group setvariable ["vtscurrentpatrolscript",_aicript,true];
				};
			};
			
			[vtsgrouporderupdated] spawn _code;
		};
	};
	

	//3D VIEW we also launch the AI script (no group can be spawned in 3D see next processing)
	if ((From3D) && !(var_console_valid_type in type_objects) && (pa_aiautomanage==1)) then
	{
		call compile format["vtsgrouporderupdated=group (leader %1);",console_nom];
		//publicvariable "vtsgrouporderupdated";			
		
		
		_code={
			_group=_this select 0;
			vtsgrouporderupdated=nil;
			if (local (leader _group)) then
			{
				_aicript = [_group] execVM "functions\ai_engaged.sqf";
				_group setvariable ["vtscurrentpatrolscript",_aicript,true];
			};
		};
		
		//[_code] call vts_broadcastcommand;
		[vtsgrouporderupdated] spawn _code;
	};



	//Si un groupe spawn sans ordre sur un batiment, on le dispatch à l'interieur de celui-ci.
	if (var_console_valid_mouvement=="" && (var_console_valid_type!="Base") && (var_console_valid_type!="Composition") && (var_console_valid_type!="Module")) then
	{
		_spawngroup=objnull;
		call compile format["_spawngroup=%1;",console_nom];
		if (typename _spawngroup=="GROUP") then
		{
			if ((leader _spawngroup) iskindof "Man") then
			{
				if ([_spawngroup] call vts_isgroupinbuilding) then
				{
					//_nearestbuilding=nearestbuilding (leader _spawngroup);
					_nearestbuilding=[(leader _spawngroup)] call vts_getnearestbuilding;
					_buildingposcount=_nearestbuilding call buildingPosCount;
					if (_buildingposcount>0) then
					{
						//player sidechat "group in building";
						deletewaypoint [_spawngroup,0];				
						{
		
							if (_x iskindof "Man") then
							{
								//_buildpos=(_nearestbuilding buildingpos floor(random _buildingposcount));
								_x setpos _buildpos;
								_x forcespeed 0;
								_x switchmove "";
							};
						} foreach units _spawngroup;
					};
				};
			};
		};	
	};
	
	//Execute on spawn mod script on the group after it spawned
	call compile format["[(group (leader %1))] execvm ""mods\on_spawn_script.sqf"";",console_nom];
	
	//Console_nom string var name refer to the last spawned object (ex if you spawn a group of 4 guys console_nom will return unit with vts_3 vehiclevarname)
	call compile format["%1 setvariable ['vtsmissionpreset_i',_currentsaveindex,true];",console_nom];
	
	//publicvariable "var_hom_solo";
	//publicvariable "var_v_solo";
	if (isnil "vts_build_spawn") then
	{
    _code={
    if ([player] call vts_getisGM) then {hint format["%1 spawned",var_console_valid_type];};
    };
    [_code] call vts_broadcastcommand;
  };



