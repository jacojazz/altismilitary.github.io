//Retour sur l'unité maitre

_newrole=_this select 0;
_respawning=false;


//Handling the respawn or if the GM is just getting out of the unit (From respawn array (2 params) or action array (3 params) )
if (count _this >2) then {_respawning = false;}
else {_respawning = true;};

              //Verifie si l'unité est en véhicule
             
              
              _pos="";
              _inVehicle="FALSE";
              _itsVehicle =  vehicle _newrole;
              _owner = objNull;
          
  /*          
              if ( player != vehicle player ) then
              {
              _inVehicle="TRUE";
              if (_newrole == driver _vehicle) then {_pos = "driver" ;_newrole groupChat "driver";};
              if (_newrole == gunner _vehicle) then {_pos = "gunner" ;_newrole groupChat "gunner";};
              if (_newrole == crew _vehicle) then {_pos = "crew";_newrole groupChat "crew";};
              if (_newrole == commander _vehicle) then {_pos = "commander";_newrole groupChat "commander";};
              };
             

              
			if   ( _inVehicle == "TRUE" ) then {moveOut player;_newrole groupChat "getout"};   
			*/           
			
			//Check Camera to avoid bug
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
			
			
			_newrole removeAction (_newrole getVariable "TKCACTION");
			if (_itsVehicle != _newrole) then 
			{
			_itsVehicle removeAction (_itsVehicle getVariable "TKCACTIONVEH");
			_itsVehicle setVariable ["GMABLE","TRUE",TRUE];
			};
			_newrole setVariable ["GMABLE","TRUE",TRUE];
			_owner = _newrole getVariable "GMCONTROL";
			//If dead lets wait a bit to understand the npc is dead
			//if (!alive _newrole) then {sleep 3;};
			waituntil {alive _newrole};
			_side=_owner getVariable "GMSIDE";
			selectPlayer _owner;
			
			//Copy back task  to GM to ensure compatibilty if change were made
			[_newrole,_owner] call vts_copytasks;
			
			//Renable AI and stuff
			_owner enablesimulation true;
			
			removeSwitchableUnit _newrole;

			//Deleting the vehicle if it's on the death & respawn of the unit controled by the GM
			if (_respawning) then {deletevehicle _newrole;};

			//on remelt le GM dans son groupe de départ (hum... west toujours ?)
			_sidegrp = creategroup _side;
			[_owner] join _sidegrp;
			[player] join _sidegrp;

			
			/*
    
      	      if (_pos == "driver") then {_newrole moveInDriver _vehicle;};
      	      if (_pos == "gunner") then {_newrole moveInGunner _vehicle;};
      	      if (_pos == "crew") then {_newrole moveInCargo _vehicle;};
      	      if (_pos == "commander") then {_newrole moveInCommander _vehicle;};
      	      
      	      
_newrole groupChat "getout"};  
*/	
			istakecontrol=false;
			if !(player getvariable ["vts_gm_hidden",false]) then
			{
				_code={
				_this allowDamage true;
				_this hideObject false;
				_this enableAI "AUTOTARGET";
				[_this] spawn vts_ZeusProcessInit;
				};
				player setCaptive false;
				player setvariable ["vts_gm_hidden",false,true];
				[_code,player] call vts_broadcastcommand; 
			};


if ([player] call vts_getisGM) then {ctrlShow [19000,false];};
