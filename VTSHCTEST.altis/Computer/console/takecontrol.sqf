
disableSerialization;

_isLeader = false;
//if ( _GMGroup == grpNull) then {_GMGroup = creategroup WEST;};

// Attention! il faut faire passer en global toutes les variables sur l'unité!
// **********  mettre des ennemis dans les batiments **************

//Methods de prise de control
takeControl = 
{  

				_code={
				_this allowDamage false;
				_this hideObject true;
				_this disableAI "AUTOTARGET";
				};

				player setCaptive true;
				[_code,player] call vts_broadcastcommand; 
				sleep 0.15;
				istakecontrol=true;
              //On prends toujours le drivers du vehicule
              //if (vehicle _newguy != _newguy) then 
              //{
              //  hint "In vehicle";
                if ( _newguy != driver vehicle _newguy) then 
                {
                _newguy = driver vehicle _newguy;
                //hint "Forcing driver";
                vehicle _newguy setVariable ["GMMENU",1,TRUE];
                };
              //};

 
              
      				//Gestion du groupe, on prend le controle
      				 _grp = group _newguy;
      				_grpGM = group player;
      				_leader = leader _grp;
      				_isLeader = false;
      				_units = units _grp;
      				_side = side _newguy;
					_newGrp = createGroup _side;
					_newGrpSelect = createGroup _side;
              
					_newGrp copyWaypoints _grp;
					_newGrpSelect copyWaypoints _grp;
                            			
      				if  (_leader == driver _newguy) then {_isLeader = true;}; 
              
					[player] joinSilent _newGrp;
                
					{[_x] joinSilent _newGrp} forEach _units;
					_oldguy = player;
					selectPlayer _newguy;
					{[_x] joinSilent _newGrpSelect} forEach _units;
					
					//Disabling ai of our old unit (no shooting or moving)
					_oldguy enablesimulation false;
					
					//Face aléatoire pour la nouvelle unité
					_faces=[(configfile >> "CfgFaces") select 1] call bis_fnc_subclasses;
					_random=floor(random(count _faces));
					_face=configName (_faces select _random);
					
					//Copy tasks to the unit so GM can be keep up to date with it
					[_oldguy,_newguy] call vts_copytasks;
					
					//Make it MP compatible
					_code={};
					call compile format["
					_code={
					_this setFace ""%1"";
					[_this] spawn vts_ZeusProcessInit;
                    };
					",_face];
					[_code,_newguy] call vts_broadcastcommand; 
             
              
					//{[_x] joinSilent _newGrp} forEach _units;
     
					if (_isLeader) then {_newGrpSelect selectLeader _newguy; _newguy groupChat "as Leader";};			
				
					  //Verifie si l'unité est en véhicule 
					  
					  _newrole = _newguy;
					  _pos="";
					  _inVehicle="FASLE";
					  _vehicle =  vehicle _newrole;
					  
              /*
              if ( _vehicle != _newrole ) then
              {
              _inVehicle="TRUE";
              if (_target == driver _target) then {_pos = "driver";_newrole groupChat "driver";};
              if (_target == gunner _target) then {_pos = "gunner";_newrole groupChat "gunner";};
              if (_target == crew _target) then {_pos = "crew";_newrole groupChat "crew";};
              if (_target == commander _target) then {_pos = "commander";_newrole groupChat "commander";};
              };
              if (_inVehicle == "TRUE") then {moveOut _newrole;_newrole groupChat "out";};
              */
					//Nettoyage de toute les events
					//_newrole sidechat "cleaned";
					/*
					driver _newrole removeAllEventHandlers "killed"; 
					driver _newrole removeAllEventHandlers "respawn";
					*/
      				//Sauvegarde de variables
      				driver _newrole addEventHandler ["respawn", {_this execvm "Computer\console\takecontrolback.sqf"}];
					_backaction = driver _newrole addAction ["Back to GameMaster","Computer\console\takecontrolback.sqf",_target, 1, false, false,"teamSwitch","(player in (crew (vehicle player)))"];
					if (_vehicle getVariable "GMMENU" == 1) then 
					{
					//_backactionvehicle = _vehicle addAction ["Back to GameMaster","Computer\console\takecontrolback.sqf",_target, 1, false, false,"teamSwitch","(vehicle player==player) && (player in (crew (vehicle player)))"];
					//_vehicle setVariable ["TKCACTIONVEH",_backactionvehicle,TRUE];
					};
              //Sauvegarde l'id de l'action pour la virer plus tard
              driver _newrole setVariable ["TKCACTION",_backaction,TRUE];
              driver _newrole setVariable ["GMABLE","FALSE",TRUE];
      	      driver _newrole setVariable ["GMCONTROL",_oldguy,TRUE];
			 
      	      /*
      	      if (_pos == "driver") then {_newrole moveInDriver _vehicle;};
      	      if (_pos == "gunner") then {_newrole moveInGunner _vehicle;};
      	      if (_pos == "crew") then {_newrole moveInCargo _vehicle;};
      	      if (_pos == "commander") then {_newrole moveInCommander _vehicle;};
      	      */
      	      /*
              if (dialog) then 
              {
			         	[] call Dlg_StoreParams;
                closeDialog 0
              };
              */
              
              ctrlShow [19000,true];
      	      _oldguy disableAI "MOVE";
};



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
				_marker_Take = createMarkerLocal ["Takemarker",[spawn_x,spawn_y,spawn_z]];
				_marker_Take setMarkerShapeLocal "ELLIPSE";
				//		_marker_Take setMarkerTypeLocal "mil_Dot";
				_marker_Take setMarkerSizeLocal [5, 5];
				_marker_Take setMarkerDirLocal 0;
				_marker_Take setMarkerColorLocal "Colorred";
				_marker_Take setMarkerAlphaLocal 0.5;
				
				// Détecte la première unité depuis le centre du click
				_list = [[spawn_x,spawn_y,0],["CAManBase","Car","Truck","Tank","Helicopter","Plane","Ship"],1000] call vts_nearestobjects2d;
				//On ne prends le control que d'un seul homme
				//_list = nearestObjects  [[spawn_x,spawn_y,spawn_z],["CAManBase"],1000];
				
				_newguy = _list select 0;
				
				
				
				//Sécurité de control d'unité
        if ((isPlayer driver _newguy) && (alive driver _newguy)) then
        {

          if ((driver _newguy) getVariable ["GMABLE",false] ) then 
          {
		  if (!vts_stopcam) then
			{
				vts_fromfreecam=true;
				_pos=screenToWorld[0.5,0.5];
				spawn_x=position VTS_Freecam select 0;
				spawn_y=position VTS_Freecam select 1;
				vts_cameraheight=position VTS_Freecam select 2;
				rot_y=direction VTS_Freecam;
				vts_cameravectorup=[VectorDir VTS_FreeCam,VectorUp VTS_FreeCam];
				vts_stopcam=true;
				sleep 0.25;
			};
		  if (istakecontrol) then {_script=[player,"null","null"] execvm "computer\console\takecontrolback.sqf";sleep 0.5; };
		  //Protection du personnage dmique (pas qu'un autre dm le take control ou lui même)
		  player setVariable ["NOTGMABLE",true,true];
		  player setVariable ["GMSIDE",side player,TRUE];
		  [_newguy] call takeControl; 
          sleep 1;
          _random=round(random 80)+10;


          //_newguy setIdentity "gamemaster";
           }
          else 
          {
                     hint "!!! Cannot control Player !!!";
          };
        };
        if (!(isPlayer driver _newguy) && (alive driver _newguy)) then
		{
			if !((driver _newguy) getVariable ["NOTGMABLE",false]) then
			{
			  if (!vts_stopcam) then
				{
					vts_fromfreecam=true;
					_pos=screenToWorld[0.5,0.5];
					spawn_x=position VTS_Freecam select 0;
					spawn_y=position VTS_Freecam select 1;
					vts_cameraheight=position VTS_Freecam select 2;
					rot_y=direction VTS_Freecam;
					vts_cameravectorup=[VectorDir VTS_FreeCam,VectorUp VTS_FreeCam];
					vts_stopcam=true;
					sleep 0.25;
				};			
				if (istakecontrol) then {_script=[player,"null","null"] execvm "computer\console\takecontrolback.sqf";sleep 0.5; };
				player setVariable ["NOTGMABLE",true,true];
				player setVariable ["GMSIDE",side player,TRUE];
				 [_newguy] call takeControl;
				  _newguy setVariable ["GMABLE","TRUE",TRUE];
				  sleep 1;
			_random=round(random 80)+10;
			}
			else
			{
				  hint "!!! Cannot control yourself !!!";
			};

        };
        //Si on a selectionné un vehicule sans pilote
    		if (isNull driver _newguy) then {hint "!!! No driver in vehicle !!!"};	
				sleep 0.5;
				deletemarker "Takemarker";
				
			};
			clic1 = false;

	}; 
		sleep 0.5;
		"" spawn vts_gmmessage;
		breakclic = 0; 
		//	waitUntil {(clic1)};
};
If (true) ExitWith {};
