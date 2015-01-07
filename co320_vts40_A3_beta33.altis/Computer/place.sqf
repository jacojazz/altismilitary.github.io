   "Spawned" spawn vts_gmmessage;
  
	if (killscript) exitwith {_killscript=false;};
	
	
	
	//closeDialog 0;
	//camUseNVG false;
	//sleep 1;


	//deleteVehicle Obj;
	//spawn_x = getpos object3D select 0;
	//spawn_y =getpos object3D select 1;
	//spawn_z =(object3D modelToWorld [0,0,0]) select 2;
	//sleep 3;
	_pos = asltoatl visiblepositionasl object3D;

	spawn_x = _pos  select 0;
	spawn_y = _pos  select 1;
	spawn_z = _pos  select 2;
	
	local_spawn_x=spawn_x;
	local_spawn_y=spawn_y;
	local_spawn_z=spawn_z;

	_pos2 = asltoatl visiblepositionasl object3D;
	
	spawn_x2=_pos2 select 0;
	spawn_y2=_pos2 select 1;
	spawn_z2=_pos2 select 2;

	local_spawn_x2=spawn_x2;
	local_spawn_y2=spawn_y2;
	local_spawn_z2=spawn_z2;
	
	console_unit_orientation = getdir object3D;
	local_console_unit_orientation=console_unit_orientation;
	
	//detach object3D;
	object3D hideObject true;
	object3D enablesimulation false;
	sleep 0.1;
	
	
	/*
	if (isServer) then 
	{
	if ((var_console_valid_type == "Vehicle") or (var_console_valid_type == "Matrl") or (var_console_valid_type == "Empty") or (var_console_valid_type == "Ship") or (var_console_valid_type == "Land")) then {
	sleep 2;
	//VtsHight =VtsHight + 6;
	_pos = getposASL Obj;
	_newheight = (_pos select 2) +6;
	//if (_newheight > 6) then {_newheight=6;};
	Obj setposASL [_pos select 0, _pos select 1, _newheight];
	};
	};
	*/
	//object3D attachTo [Obj,[0,0,VtsHight]];
	object3D hideObject false;
	object3D enablesimulation true;
	_pos= getposASL Obj;
	From3D = true;
	local_From3D=From3D;
	
	//deleteVehicle object3D;

	nom_du_marqueur = "";

	[] call vts_initiatespawn;
	
  sleep 0.25;
  From3D = false;
  local_From3D=From3D;
  vts3DAttach= false;
  local_vts3DAttach=vts3DAttach;
  placingdone=0;
