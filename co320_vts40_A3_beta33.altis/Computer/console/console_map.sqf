disableSerialization;
// Attention! il faut faire passer en global toutes les variables sur l'unité!

_mapspawnmarker={
							_marker_spawn = createMarkerLocal ["Nspawnmarker",[spawn_x,spawn_y,spawn_z]];
            	_marker_spawn setMarkerShapeLocal "ELLIPSE";
            	_marker_spawn setMarkerSizeLocal [radius, radius];
            	_marker_spawn setMarkerDirLocal 0;
            	_marker_spawn setMarkerColorLocal "ColorGreen";  
				_marker_spawn setMarkerAlphaLocal 0.5;
};

_maprandompos={
	//player sidechat "random";
	_randomrad=local_radius;
	
	spawn_x=(spawn_x-(_randomrad/2))+random(_randomrad);
	spawn_y=(spawn_y-(_randomrad/2))+random(_randomrad);
	spawn_z=0;
	local_spawn_x=spawn_x;
	local_spawn_y=spawn_y;
	local_spawn_z=spawn_z;
};

_spawnrandom=false;
if (count _this>0) then {_spawnrandom=_this select 0;};

if  (breakclic <= 1 ) then
{
	clic1 = false;
	clic2 = false;
	_display = finddisplay 8000;
	_txt = _display displayctrl 200;


	if ((var_console_valid_type == "Base") or (var_console_valid_type == "Static") or (var_console_valid_type == "Object") or (var_console_valid_type == "Logistic") or (var_console_valid_type == "Composition") or (var_console_valid_type == "Empty")) then {

		_txt CtrlSetText "Left click on the map";
		_txt CtrlSetTextColor [0.9,0.9,0.9,1];

		Ctrlshow [200,true];sleep 0.2; CtrlShow [200,false];sleep 0.2;Ctrlshow [200,true] ;
		
		onMapSingleClick "spawn_x = _pos select 0;
		spawn_y = _pos select 1;
		spawn_z = _pos select 2 ;
		local_spawn_x=spawn_x;
		local_spawn_y=spawn_y;
		local_spawn_z=spawn_z;
		
		
		console_nom = format [""%1"",ctrlText 10231];
		console_init = format [""%1"",ctrlText 10232];
		local_console_nom=console_nom;
		local_console_init=console_init;
				
		nom_du_marqueur = console_nom;
		

		
		clic1 = true;
		onMapSingleClick """";" ; 
		for "_j" from 10 to 0 step -1 do 
		{
			format["Click On Map %1, or wait for cancellation",_j] spawn vts_gmmessage;
			sleep 1;
			if (clic1) then
			{			
				"" spawn vts_gmmessage;
				_j=0;
				clic1 = false;
				if (_spawnrandom) then {[] call _maprandompos;};
				[] call vts_initiatespawn;
				[] call _mapspawnmarker;
    
			};
			clic1 = false;

		}; 
				
	} else {

		switch (var_console_valid_mouvement) do 
		{
		//Go to Mark 1
		/*
			case script7sqf: 
			{
				if check_Go2marker then
				{
					_txt CtrlSetText "Left click on the map";
					_txt CtrlSetTextColor [0.9,0.9,0.9,1];

					Ctrlshow [200,true];sleep 0.2; CtrlShow [200,false];sleep 0.2;Ctrlshow [200,true] ;
					onMapSingleClick "spawn_x = _pos select 0;
					spawn_y = _pos select 1;
					spawn_z = _pos select 2 ;
					local_spawn_x=spawn_x;
					local_spawn_y=spawn_y;
					local_spawn_z=spawn_z;
										

					console_nom = format [""%1"",ctrlText 10231];
					console_init = format [""%1"",ctrlText 10232];
					local_console_nom=console_nom;
					local_console_init=console_init;

					nom_du_marqueur = console_nom;


					clic1 = true;
					onMapSingleClick """";" ;
					for "_j" from 10 to 0 step -1 do 
					{
						format["Click On Map %1, or wait for cancellation",_j] spawn vts_gmmessage;
						sleep 1;
						if (clic1) then
						{
							"" spawn vts_gmmessage;
							_j=0;
							clic1 = false;
						  if (_spawnrandom) then {[] call _maprandompos;};
						  [] call vts_initiatespawn;
						  [] call _mapspawnmarker; 

						};
						clic1 = false;

					}; 
					
				}else{
					_txt CtrlSetText "Go2marker not found, please place it";
					_txt CtrlSetTextColor [0.9,0.9,0.9,1];

					Ctrlshow [200,true];sleep 0.2; CtrlShow [200,false];sleep 0.2;Ctrlshow [200,true];
					
				};

			}; 
			*/
			//Land (GetOut/GetIn)
			case script6sqf: 
			{
					_txt CtrlSetText "Left click on the map to put the first point";
					_txt CtrlSetTextColor [1,0,0,1];

					Ctrlshow [200,true];sleep 0.2; CtrlShow [200,false];sleep 0.2;Ctrlshow [200,true] ;
					
					// Clic 1
					onMapSingleClick "spawn_x = _pos select 0;
					spawn_y = _pos select 1;
					spawn_z = _pos select 2;
					local_spawn_x=spawn_x;
					local_spawn_y=spawn_y;
					local_spawn_z=spawn_z;
										
					clic1 = true;
					onMapSingleClick """";" ;
						
					for "_j" from 10 to 0 step -1 do 
					{
						format["Click On Map %1, or wait for cancellation",_j] spawn vts_gmmessage;
						sleep 1;
						if (clic1) then
						{
							"" spawn vts_gmmessage;
							_j=0;
							clic1 = false;
						_marker1 = createMarkerLocal ["marker1",[spawn_x,spawn_y]];
						_marker1 setMarkerTypeLocal "mil_Dot";
						_marker1 setMarkerSizeLocal [0.5, 0.5];

						_marker1 setMarkerColorLocal "Colorgreen";
						_marker1 setMarkerAlphaLocal 0.5;
						sleep 1;
						
						_txt CtrlSetTextColor [0.9,0.9,0.9,1];
						_txt CtrlSetText "Left click on the map to put the second point";
						Ctrlshow [200,true];sleep 0.2; CtrlShow [200,false];sleep 0.2;Ctrlshow [200,true] ;
						};
						clic1 = false;

					}; 
	
						
						// Clic 2
						onMapSingleClick "spawn_x2 = _pos select 0;
						spawn_y2 = _pos select 1;
						spawn_z2 = _pos select 2 ;
						local_spawn_x2=spawn_x2;
						local_spawn_y2=spawn_y2;
						local_spawn_z2=spawn_z2;
										

						console_nom = format [""%1"",ctrlText 10231];
						console_init = format [""%1"",ctrlText 10232];
						local_console_nom=console_nom;
						local_console_init=console_init;
				
						nom_du_marqueur = console_nom;
						

						clic2 = true;
						onMapSingleClick """";" ;
						
						for "_j" from 10 to 0 step -1 do 
						{
							format["Click On Map %1, or wait for cancellation",_j] spawn vts_gmmessage;
							sleep 1;
							if (clic2) then
							{
								"" spawn vts_gmmessage;
								_j=0;
								clic2 = false;
								_marker2 = createMarkerLocal ["marker2",[spawn_x2,spawn_y2]];
								_marker2 setMarkerTypeLocal "mil_Dot";
								_marker2 setMarkerSizeLocal [0.5, 0.5];

								_marker2 setMarkerColorLocal "Colorred";
								_marker2 setMarkerAlphaLocal 0.5;
								
								_marker_line = createMarkerLocal ["LineMarker",[spawn_x,spawn_y]];
								_marker_line setMarkerShapeLocal "RECTANGLE";
								_marker_line setMarkerColorLocal "Colorblack";
								_marker_line setMarkerAlphaLocal 0.5;
								_marker_line setmarkerposlocal [(([spawn_x,spawn_y] select 0) + ([spawn_x2,spawn_y2] select 0)) / 2, (([spawn_x,spawn_y] select 1) + ([spawn_x2,spawn_y2] select 1)) / 2];
								_marker_line setmarkerdirlocal (([spawn_x,spawn_y] select 0) - ([spawn_x2,spawn_y2] select 0)) atan2 (([spawn_x,spawn_y] select 1) - ([spawn_x2,spawn_y2] select 1));
								_marker_line setmarkersizelocal [2.5, ([spawn_x,spawn_y] distance [spawn_x2,spawn_y2]) / 2];
								_marker_line setmarkerbrushlocal "SolidBorder";
																	
								sleep 1;
								deletemarker "marker1";
								deletemarker "marker2";
								deletemarker "LineMarker";
								
								if (_spawnrandom) then {[] call _maprandompos;};
								[] call _mapspawnmarker;
								[] call vts_initiatespawn;
							};
							clic1 = false;

						}; 

			};

			//Unload
			case script14sqf: 
			{
					_txt CtrlSetText "Left click on the map to put the first point";
					_txt CtrlSetTextColor [1,0,0,1];

					Ctrlshow [200,true];sleep 0.2; CtrlShow [200,false];sleep 0.2;Ctrlshow [200,true] ;
					
					// Clic 1
					onMapSingleClick "spawn_x = _pos select 0;
					spawn_y = _pos select 1;
					spawn_z = _pos select 2;
					local_spawn_x=spawn_x;
					local_spawn_y=spawn_y;
					local_spawn_z=spawn_z;
										
					clic1 = true;
					onMapSingleClick """";" ;
						
					for "_j" from 10 to 0 step -1 do 
					{
						format["Click On Map %1, or wait for cancellation",_j] spawn vts_gmmessage;
						sleep 1;
						if (clic1) then
						{
							"" spawn vts_gmmessage;
							_j=0;
							clic1 = false;
						_marker1 = createMarkerLocal ["marker1",[spawn_x,spawn_y]];
						_marker1 setMarkerTypeLocal "mil_Dot";
						_marker1 setMarkerSizeLocal [0.5, 0.5];

						_marker1 setMarkerColorLocal "Colorgreen";
						_marker1 setMarkerAlphaLocal 0.5;
						sleep 1;
						
						_txt CtrlSetTextColor [0.9,0.9,0.9,1];
						_txt CtrlSetText "Left click on the map to put the second point";
						Ctrlshow [200,true];sleep 0.2; CtrlShow [200,false];sleep 0.2;Ctrlshow [200,true] ;
						};
						clic1 = false;

					}; 
	
						
						// Clic 2
						onMapSingleClick "spawn_x2 = _pos select 0;
						spawn_y2 = _pos select 1;
						spawn_z2 = _pos select 2 ;
						local_spawn_x2=spawn_x2;
						local_spawn_y2=spawn_y2;
						local_spawn_z2=spawn_z2;
										

						console_nom = format [""%1"",ctrlText 10231];
						console_init = format [""%1"",ctrlText 10232];
						local_console_nom=console_nom;
						local_console_init=console_init;
				
						nom_du_marqueur = console_nom;
						

						clic2 = true;
						onMapSingleClick """";" ;
						
						for "_j" from 10 to 0 step -1 do 
						{
							format["Click On Map %1, or wait for cancellation",_j] spawn vts_gmmessage;
							sleep 1;
							if (clic2) then
							{
								"" spawn vts_gmmessage;
								_j=0;
								clic2 = false;
								_marker2 = createMarkerLocal ["marker2",[spawn_x2,spawn_y2]];
								_marker2 setMarkerTypeLocal "mil_Dot";
								_marker2 setMarkerSizeLocal [0.5, 0.5];

								_marker2 setMarkerColorLocal "Colorred";
								_marker2 setMarkerAlphaLocal 0.5;
								
								_marker_line = createMarkerLocal ["LineMarker",[spawn_x,spawn_y]];
								_marker_line setMarkerShapeLocal "RECTANGLE";
								_marker_line setMarkerColorLocal "Colorblack";
								_marker_line setMarkerAlphaLocal 0.5;
								_marker_line setmarkerposlocal [(([spawn_x,spawn_y] select 0) + ([spawn_x2,spawn_y2] select 0)) / 2, (([spawn_x,spawn_y] select 1) + ([spawn_x2,spawn_y2] select 1)) / 2];
								_marker_line setmarkerdirlocal (([spawn_x,spawn_y] select 0) - ([spawn_x2,spawn_y2] select 0)) atan2 (([spawn_x,spawn_y] select 1) - ([spawn_x2,spawn_y2] select 1));
								_marker_line setmarkersizelocal [2.5, ([spawn_x,spawn_y] distance [spawn_x2,spawn_y2]) / 2];
								_marker_line setmarkerbrushlocal "SolidBorder";
																	
								sleep 1;
								deletemarker "marker1";
								deletemarker "marker2";
								deletemarker "LineMarker";
								
								if (_spawnrandom) then {[] call _maprandompos;};
								[] call _mapspawnmarker;
								[] call vts_initiatespawn;
							};
							clic1 = false;

						}; 

			};
			
			//Go to a point
			case script4sqf: 
			{
					_txt CtrlSetText "Left click on the map to put the first point";
					_txt CtrlSetTextColor [1,0,0,1];

					Ctrlshow [200,true];sleep 0.2; CtrlShow [200,false];sleep 0.2;Ctrlshow [200,true] ;
					
					// Clic 1
					onMapSingleClick "spawn_x = _pos select 0;
					spawn_y = _pos select 1;
					spawn_z = _pos select 2;
					local_spawn_x=spawn_x;
					local_spawn_y=spawn_y;
					local_spawn_z=spawn_z;
										
					clic1 = true;
					onMapSingleClick """";" ;
						
					for "_j" from 10 to 0 step -1 do 
					{
						format["Click On Map %1, or wait for cancellation",_j] spawn vts_gmmessage;
						sleep 1;
						if (clic1) then
						{
							"" spawn vts_gmmessage;
							_j=0;
							clic1 = false;
						_marker1 = createMarkerLocal ["marker1",[spawn_x,spawn_y]];
						_marker1 setMarkerTypeLocal "mil_Dot";
						_marker1 setMarkerSizeLocal [0.5, 0.5];

						_marker1 setMarkerColorLocal "Colorgreen";
						_marker1 setMarkerAlphaLocal 0.5;
						sleep 1;
						
						_txt CtrlSetTextColor [0.9,0.9,0.9,1];
						_txt CtrlSetText "Left click on the map to put the second point";
						Ctrlshow [200,true];sleep 0.2; CtrlShow [200,false];sleep 0.2;Ctrlshow [200,true] ;
						};
						clic1 = false;

					}; 
	
						
						// Clic 2
						onMapSingleClick "spawn_x2 = _pos select 0;
						spawn_y2 = _pos select 1;
						spawn_z2 = _pos select 2 ;

						local_spawn_x2=spawn_x2;
						local_spawn_y2=spawn_y2;
						local_spawn_z2=spawn_z2;
												
						console_nom = format [""%1"",ctrlText 10231];
						console_init = format [""%1"",ctrlText 10232];
						local_console_nom=console_nom;
						local_console_init=console_init;
						
						nom_du_marqueur = console_nom;
						
						
						
						clic2 = true;
						onMapSingleClick """";" ;
						
						for "_j" from 10 to 0 step -1 do 
						{
							format["Click On Map %1, or wait for cancellation",_j] spawn vts_gmmessage;
							sleep 1;
							if (clic2) then
							{
								"" spawn vts_gmmessage;
								_j=0;
								clic2 = false;
								_marker2 = createMarkerLocal ["marker2",[spawn_x2,spawn_y2]];
								_marker2 setMarkerTypeLocal "mil_Dot";
								_marker2 setMarkerSizeLocal [0.5, 0.5];

								_marker2 setMarkerColorLocal "Colorred";
								_marker2 setMarkerAlphaLocal 0.5;
								
							
								_marker_line = createMarkerLocal ["LineMarker",[spawn_x,spawn_y]];
								_marker_line setMarkerShapeLocal "RECTANGLE";
								_marker_line setMarkerColorLocal "Colorblack";
								_marker_line setMarkerAlphaLocal 0.5;
								_marker_line setmarkerposlocal [(([spawn_x,spawn_y] select 0) + ([spawn_x2,spawn_y2] select 0)) / 2, (([spawn_x,spawn_y] select 1) + ([spawn_x2,spawn_y2] select 1)) / 2];
								_marker_line setmarkerdirlocal (([spawn_x,spawn_y] select 0) - ([spawn_x2,spawn_y2] select 0)) atan2 (([spawn_x,spawn_y] select 1) - ([spawn_x2,spawn_y2] select 1));
								_marker_line setmarkersizelocal [2.5, ([spawn_x,spawn_y] distance [spawn_x2,spawn_y2]) / 2];
								_marker_line setmarkerbrushlocal "SolidBorder";
									
								sleep 1;
								deletemarker "marker1";
								deletemarker "marker2";
								deletemarker "LineMarker";
								
								if (_spawnrandom) then {[] call _maprandompos;};
								[] call _mapspawnmarker;
								[] call vts_initiatespawn;
								

							};
							clic1 = false;

						}; 
			};
		
			//Patrol between 2 points
			case script5sqf: 
			{
				_txt CtrlSetText "Left click on the map to put the first point";
				_txt CtrlSetTextColor [0.9,0.9,0.9,1];

				Ctrlshow [200,true];sleep 0.2; CtrlShow [200,false];sleep 0.2;Ctrlshow [200,true] ;
				
				// Clic 1
				onMapSingleClick "spawn_x = _pos select 0;
				spawn_y = _pos select 1;
				spawn_z = _pos select 2;
				local_spawn_x=spawn_x;
				local_spawn_y=spawn_y;
				local_spawn_z=spawn_z;
								
				clic1 = true;
				onMapSingleClick """";" ;
						for "_j" from 10 to 0 step -1 do 
					{
						format["Click On Map %1, or wait for cancellation",_j] spawn vts_gmmessage;
						sleep 1;
						if (clic1) then
						{
							"" spawn vts_gmmessage;
							_j=0;
							clic1 = false;
							_marker1 = createMarkerLocal ["marker1",[spawn_x,spawn_y]];
							_marker1 setMarkerTypeLocal "mil_Dot";
							_marker1 setMarkerSizeLocal [0.5, 0.5];

							_marker1 setMarkerColorLocal "Colorgreen";
							_marker1 setMarkerAlphaLocal 0.5;
							sleep 1;
							
							_txt CtrlSetTextColor [0.9,0.9,0.9,1];
							_txt CtrlSetText "Left click on the map to put the second point";
							Ctrlshow [200,true];sleep 0.2; CtrlShow [200,false];sleep 0.2;Ctrlshow [200,true] ;
						};
						clic1 = false;
				
					}; 
		
				
				
				// Clic 2
				onMapSingleClick "spawn_x2 = _pos select 0;
				spawn_y2 = _pos select 1;
				spawn_z2 = _pos select 2 ;

				local_spawn_x2=spawn_x2;
				local_spawn_y2=spawn_y2;
				local_spawn_z2=spawn_z2;
								
				console_nom = format [""%1"",ctrlText 10231];
				console_init = format [""%1"",ctrlText 10232];
				local_console_nom=console_nom;
				local_console_init=console_init;
				
				nom_du_marqueur = console_nom;

				
				clic2 = true;
				onMapSingleClick """";" ;
				for "_j" from 10 to 0 step -1 do 
					{
						format["Click On Map %1, or wait for cancellation",_j] spawn vts_gmmessage;
						if (clic2) then
						{
							"" spawn vts_gmmessage;
							_j=0;
							clic2 = false;
							_marker2 = createMarkerLocal ["marker2",[spawn_x2,spawn_y2]];
							_marker2 setMarkerTypeLocal "mil_Dot";
							_marker2 setMarkerSizeLocal [0.5, 0.5];

							_marker2 setMarkerColorLocal "Colorred";
							_marker2 setMarkerAlphaLocal 0.5;
							
							
							_marker_line = createMarkerLocal ["LineMarker",[spawn_x,spawn_y]];
							_marker_line setMarkerShapeLocal "RECTANGLE";
							_marker_line setMarkerColorLocal "Colorblack";
							_marker_line setMarkerAlphaLocal 0.5;
							_marker_line setmarkerposlocal [(([spawn_x,spawn_y] select 0) + ([spawn_x2,spawn_y2] select 0)) / 2, (([spawn_x,spawn_y] select 1) + ([spawn_x2,spawn_y2] select 1)) / 2];
							_marker_line setmarkerdirlocal (([spawn_x,spawn_y] select 0) - ([spawn_x2,spawn_y2] select 0)) atan2 (([spawn_x,spawn_y] select 1) - ([spawn_x2,spawn_y2] select 1));
							_marker_line setmarkersizelocal [2.5, ([spawn_x,spawn_y] distance [spawn_x2,spawn_y2]) / 2];
							_marker_line setmarkerbrushlocal "SolidBorder";
								

							
							sleep 1;
							deletemarker "marker1";
							deletemarker "marker2";
							deletemarker "LineMarker";

							if (_spawnrandom) then {[] call _maprandompos;};
							[] call _mapspawnmarker;
							[] call vts_initiatespawn;						

						};
						clic2 = false;
						sleep 1;
					}; 
	
			};

			default 
			{
				_txt CtrlSetText "Left click on the map";
				_txt CtrlSetTextColor [0.9,0.9,0.9,1];

				Ctrlshow [200,true];sleep 0.2; CtrlShow [200,false];sleep 0.2;Ctrlshow [200,true] ;
				
				onMapSingleClick "spawn_x = _pos select 0;
				spawn_y = _pos select 1;
				spawn_z = _pos select 2 ;
				
				local_spawn_x=spawn_x;
				local_spawn_y=spawn_y;
				local_spawn_z=spawn_z;
				
				console_nom = format [""%1"",ctrlText 10231];
				console_init = format [""%1"",ctrlText 10232];
				local_console_nom=console_nom;
				local_console_init=console_init;
				
				nom_du_marqueur = console_nom;
				
				
				clic1 = true;
				
				onMapSingleClick """";" ; 
				for "_j" from 10 to 0 step -1 do 
				{
					format["Click On Map %1, or wait for cancellation",_j] spawn vts_gmmessage;
					sleep 1;
					if (clic1) then
					{
						"" spawn vts_gmmessage;
						_j=0;
						clic1 = false;

						if (_spawnrandom) then {[] call _maprandompos;};
						[] call _mapspawnmarker;
						[] call vts_initiatespawn;
					};
					clic1 = false;

				}; 
			};
		};
	};
	//Spawn feedback
	(nom_console_valid_unite+" spawned") spawn vts_gmmessage;
	sleep 0.5;
	//"" spawn vts_gmmessage;
	breakclic = 0; 
	deletemarker "Nspawnmarker";
};

If (true) ExitWith {};
