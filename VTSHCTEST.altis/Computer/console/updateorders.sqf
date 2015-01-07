disableSerialization;

_group = _this select 0;

_movement = lbCurSel 10218;
_speed = lbCurSel 10215;
_behaviour = lbCurSel 10212;
_posleader = getpos (leader _group);

private ["_posclick","_posclick2","_posclick3"];

//On efface tous les waypoints
_wp=0;


//hint format["%1",count waypoints _group];
sleep 0.25;

_end=false;
_2click=false;
_orderdone=false;
//Clear current waypoints
_wpstop=[];
if (var_console_valid_mouvement=="") then {_end=true;[_group] call vts_clearwaypoints;_wpstop=_group addWaypoint [getpos leader _group,0];_wpstop setWaypointType "Move";};
//Clear current patrol script if any
vtsgrouporderupdated=_group;
_code={
	_group=_this;
	vtsgrouporderupdated=nil;
	if (local leader _group) then
	{
		{
			_x land "NONE";
			_x forcespeed -1;
			_x dofollow leader _x;
			_x enableAI "FSM";
			_x enableAI "TARGET";
			_x enableattack true;
		} foreach units _group;

	};
			
	_currentpatrolscript=_group getvariable ["vtscurrentpatrolscript",nil];
	//player sidechat str _currentpatrolscript;
	if !(isnil "_currentpatrolscript") then 
	{
		terminate _currentpatrolscript;
		if (local leader _group) then 
		{ 
			_group setvariable ["vtscurrentpatrolscript",nil,true];
		};
	};
};
[_code,vtsgrouporderupdated] call vts_broadcastcommand;

//***********************************
//SCRIPT NE NECESSITANT PAS CLIC MAP
//************************************
if (var_console_valid_mouvement!="") then
{
    
		if (var_console_valid_mouvement=="objectif") then
		{
		  [_group] call vts_clearwaypoints;
			_wpo=_group addWaypoint [position objectif,0];
			_wpo setWaypointType "Move"; 
			_wpo setWaypointBehaviour var_console_valid_attitude;
			_wpo setWaypointSpeed var_console_valid_vitesse;
			_orderdone=true;
			_end=true;
		};
	
		if (var_console_valid_mouvement=="insertion") then
		{
		  [_group] call vts_clearwaypoints;
			_wpo=_group addWaypoint [position insertion,0];
			_wpo setWaypointType "Move";
			_wpo setWaypointBehaviour var_console_valid_attitude;
			_wpo setWaypointSpeed var_console_valid_vitesse;
			_orderdone=true;
			_end=true;
		};
	
		if ((var_console_valid_mouvement=="Joueur")) then
		{
		  [_group] call vts_clearwaypoints;
			_wpo=_group addWaypoint [position player,0];
			_wpo setWaypointType "Move";
			_wpo setWaypointBehaviour var_console_valid_attitude;
			_wpo setWaypointSpeed var_console_valid_vitesse;
			_orderdone=true;
			_end=true;
		};
	
		if ((var_console_valid_mouvement=="Joueur")) then
		{
		  [_group] call vts_clearwaypoints;
			_wpo=_group addWaypoint [position usere1,0];
			_wpo setWaypointType "Move";
			_wpo setWaypointBehaviour var_console_valid_attitude;
			_wpo setWaypointSpeed var_console_valid_vitesse;
			_orderdone=true;
			_end=true;
		};
	
		if ((var_console_valid_mouvement=="Joueur")) then
		{
		  [_group] call vts_clearwaypoints;
			_wpo=_group addWaypoint [ position useri1,0];
			_wpo setWaypointType "Move";
			_wpo setWaypointBehaviour var_console_valid_attitude;
			_wpo setWaypointSpeed var_console_valid_vitesse;
			_orderdone=true;
			_end=true;
		};
/*		
		if (var_console_valid_mouvement==script7Sqf) then
    {
          [_group] call vts_clearwaypoints;
      		call compile format["_script7 = [_group,_positX,_positY] execVM ""Computer\behaviors\%2"";",(console_nom),(script7Sqf)];
      		_orderdone=true;
      		_end=true;
    };
*/
	//???????????????
   	if (_orderdone) then {{_x enableAI "MOVE";_x setUnitPos "AUTO";_x setUnitPosWeak "AUTO";} foreach units _group;};
};

//********************************************
//******* SCRIPT NECESSITANT 1 CLICK MAP *****
//********************************************

if !(_end) then
{


	clic1 = false;

	_display = finddisplay 8000;
	_txt = _display displayctrl 200;

	_txt CtrlSetText "Left click on the map to put the first waypoint";
	_txt CtrlSetTextColor [0.9,0.9,0.9,1];

	Ctrlshow [200,true];sleep 0.2; CtrlShow [200,false];sleep 0.2;Ctrlshow [200,true];

  //Récuperation des coordonnées de la carte
	onMapSingleClick "
  spawn_x = _pos select 0;
	spawn_y = _pos select 1;
	spawn_z = _pos select 2;

	clic1 = true;
	onMapSingleClick """";
  ";
	
	for "_j" from 10 to 0 step -1 do 
		{
		format["Click On Map %1, or wait for cancellation",_j] spawn vts_gmmessage;
		sleep 1;
		//hint "pause";
		
			//if (_clic1) exitWith {};
			if (clic1) then
			{
				"" spawn vts_gmmessage;
				_orderdone=true;
				[_group] call vts_clearwaypoints;
				_j=0;
				clic1 = false;
				_posclick = [spawn_x,spawn_y,spawn_z];
				_marker_Take = createMarkerLocal ["Nmarker0",_posclick];
				_marker_Take setMarkerTypeLocal "mil_Dot";
				_marker_Take setMarkerSizeLocal [1, 1];
				_marker_Take setMarkerDirLocal 0;
				_marker_Take setMarkerColorLocal "Colorred";
				_marker_Take setMarkerAlphaLocal 0.5;
				
        //******************************
        //***** Code come here *********
		//******************************
      				
      	// On vérifie si des scripts d'init ont été sélectionnés
      	_positX=spawn_x;
      	_positY=spawn_y;
      	_positZ=spawn_z;
      	
      	spawn_x2=spawn_x;
      	spawn_y2=spawn_y;
      	spawn_z2=spawn_z;


                         	
       	if (var_console_valid_mouvement==script1Sqf) then
      	{
			_marker_Take setMarkerShapeLocal "ELLIPSE";
			_marker_Take setMarkerSizeLocal [radius, radius];
      		call compile format["_script1 = [_group,_positX,_positY] execVM ""Computer\behaviors\%2"";",(console_nom),(script1Sqf)];
      	};
  	
      	if (var_console_valid_mouvement==script2Sqf) then
      	{
			_marker_Take setMarkerShapeLocal "ELLIPSE";
			_marker_Take setMarkerSizeLocal [radius, radius];
      		call compile format["_script2 = [_group,_positX,_positY] execVM ""Computer\behaviors\%2"";",(console_nom),(script2Sqf)];
      	};
      	
       	if (var_console_valid_mouvement==script3Sqf) then
      	{
			_marker_Take setMarkerShapeLocal "ELLIPSE";
			_marker_Take setMarkerSizeLocal [radius, radius];
      		call compile format["_script3 = [_group,_positX,_positY] execVM ""Computer\behaviors\%2"";",(console_nom),(script3Sqf)];
      	};

      	if (var_console_valid_mouvement==script4Sqf) then
      	{
      		call compile format["_script8 = [_group,_positX,_positY] execVM ""Computer\behaviors\%2"";",(console_nom),(script4Sqf)];
      	};

         if (var_console_valid_mouvement==script6Sqf) then
         {
         	call compile format["_script6 = [_group,_positX,_positY] execVM ""Computer\behaviors\%2"";",(console_nom),(script6Sqf)];
         };     	 

		if (var_console_valid_mouvement==script14Sqf) then
         {
         	call compile format["_script14 = [_group,_positX,_positY] execVM ""Computer\behaviors\%2"";",(console_nom),(script14Sqf)];
         };    
 		 
      	if (var_console_valid_mouvement==script8Sqf) then
      	{
      		call compile format["_script8 = [_group,_positX,_positY] execVM ""Computer\behaviors\%2"";",(console_nom),(script8Sqf)];
      	};
     	   	
      	if (var_console_valid_mouvement==script9Sqf) then
      	{
      		call compile format["_script9 = [_group,_positX,_positY] execVM ""Computer\behaviors\%2"";",(console_nom),(script9Sqf)];
      	};   

      	if (var_console_valid_mouvement==script10Sqf) then
      	{
      		call compile format["_script10 = [_group,_positX,_positY] execVM ""Computer\behaviors\%2"";",(console_nom),(script10Sqf)];
      	};   

      	if (var_console_valid_mouvement==script11Sqf) then
      	{
      		call compile format["_script11 = [_group,_positX,_positY] execVM ""Computer\behaviors\%2"";",(console_nom),(script11Sqf)];
      	};   


      	if (var_console_valid_mouvement==script12Sqf) then
      	{
			_marker_Take setMarkerShapeLocal "ELLIPSE";
			_marker_Take setMarkerSizeLocal [radius, radius];
      		call compile format["_script12 = [_group,_positX,_positY] execVM ""Computer\behaviors\%2"";",(console_nom),(script12Sqf)];
      	};   
 
		
		if (var_console_valid_mouvement in vts_UPSMONscript) then
		{
			//UPS need to be executed on the local machine (not like waypoint order that are global :'( )
			//player sidechat "reassign ups";
			vtsgrouporderupdated=_group;
			_code={};
			call compile format["
			_code={
				_group=_this;
				vtsgrouporderupdated=nil;
			if (local (leader _group)) then
			{
				_patrolscript = [(leader _group),""%1"",%2,%3,""%4""] execVM ""Computer\behaviors\UPSscripts.sqf"";
				_group setvariable [""vtscurrentpatrolscript"",_patrolscript,true];
			};
			};
			",(var_console_valid_mouvement),[_positX,_positY],radius,var_console_valid_attitude];
			[_code,vtsgrouporderupdated] call vts_broadcastcommand;

		};  
		
          	
			
      	if (var_console_valid_mouvement==script5Sqf) then
      	{
      		_2click=true;
       	};
      	
      	if !(_2click) then
        {
		_marker_line = createMarkerLocal ["LineMarker0",_posleader];
		_marker_line setMarkerShapeLocal "RECTANGLE";
		_marker_line setMarkerColorLocal "Colorblack";
		_marker_line setMarkerAlphaLocal 0.5;
        _marker_line setmarkerposlocal [((_posleader select 0) + (_posclick select 0)) / 2, ((_posleader select 1) + (_posclick select 1)) / 2];
        _marker_line setmarkerdirlocal ((_posleader select 0) - (_posclick select 0)) atan2 ((_posleader select 1) - (_posclick select 1));
        _marker_line setmarkersizelocal [2.5, (_posleader distance _posclick) / 2];
		_marker_line setmarkerbrushlocal "SolidBorder";
	     };
	      // ??????????????????
	       {_x enableAI "MOVE";_x setUnitPos "AUTO";_x setUnitPosWeak "AUTO";} foreach units _group;
				//******************************
			
        sleep 0.5;
								
			};
			clic1 = false;
	}; 

		sleep 0.25;
		"" spawn vts_gmmessage;
		breakclic = 0; 
};


//********************************************
//**** SCRIPT NECESSITANT A 2nd CLICK MAP ****
//********************************************

if (_2click) then
{
    
	clic1 = false;

	_display = finddisplay 8000;
	_txt = _display displayctrl 200;

	_txt CtrlSetText "Left click on the map to put the second waypoint";
	_txt CtrlSetTextColor [0.9,0.9,0.9,1];

	Ctrlshow [200,true];sleep 0.2; CtrlShow [200,false];sleep 0.2;Ctrlshow [200,true];

  //Récuperation des coordonnées de la carte
	onMapSingleClick "
  spawn_x3 = _pos select 0;
	spawn_y3 = _pos select 1;
	spawn_z3 = _pos select 2;

	clic1 = true;
	onMapSingleClick """";
  ";
	
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
				_orderdone=true;
				clic1 = false;
				_posclick2 = [spawn_x3,spawn_y3,spawn_z3];
				_marker_Take = createMarkerLocal ["Nmarker",_posclick2];
				_marker_Take setMarkerTypeLocal "mil_Dot";
				//		_marker_Take setMarkerTypeLocal "mil_Dot";
				_marker_Take setMarkerSizeLocal [1, 1];
				_marker_Take setMarkerDirLocal 0;
				_marker_Take setMarkerColorLocal "Colorred";
				_marker_Take setMarkerAlphaLocal 0.5;
				
        //******************************
        //***** Code come here *********
		//******************************
      				

      	if (var_console_valid_mouvement==script5Sqf) then
      	{
      		call compile format["_script5 = [_group,spawn_x3,spawn_y3] execVM ""Computer\behaviors\%2"";",(console_nom),(script5Sqf)];
      	};
      	

  			
				_marker_line = createMarkerLocal ["LineMarker",_posclick];
				_marker_line setMarkerShapeLocal "RECTANGLE";
				_marker_line setMarkerColorLocal "Colorblack";
				_marker_line setMarkerAlphaLocal 0.5;
				_marker_line setmarkerposlocal [((_posclick select 0) + (_posclick2 select 0)) / 2, ((_posclick select 1) + (_posclick2 select 1)) / 2];
				_marker_line setmarkerdirlocal ((_posclick select 0) - (_posclick2 select 0)) atan2 ((_posclick select 1) - (_posclick2 select 1));
				_marker_line setmarkersizelocal [2.5, (_posclick distance _posclick2) / 2];
				_marker_line setmarkerbrushlocal "SolidBorder";
		 
				_marker_Take2 = createMarkerLocal ["Nmarker2",_posclick];
				_marker_Take2 setMarkerTypeLocal "mil_Dot";
				_marker_Take2 setMarkerSizeLocal [1, 1];
				_marker_Take2 setMarkerDirLocal 0;
				_marker_Take2 setMarkerColorLocal "Colorgreen";	 
				_marker_Take2 setMarkerAlphaLocal 0.5;
        // ??????????????????
        {_x enableAI "MOVE";_x setUnitPos "AUTO";_x setUnitPosWeak "AUTO";} foreach units _group;   
	      //******************************
			
      sleep 0.5;
			};
		clic1 = false;
	}; 
	

		sleep 0.25;
		"" spawn vts_gmmessage;
		breakclic = 0; 
		_2click=false;
};
    //Marker cleaining up
	deletemarker "Nmarker0";
	deletemarker "LineMarker0";

	//Clean up marker
	deletemarker "Nmarker";
	deletemarker "Nmarker2";
	deletemarker "LineMarker";
	  
	//Apply vts AI script if not using UPS ai
	if (!(var_console_valid_mouvement in vts_UPSMONscript) && (pa_aiautomanage==1)) then
	{
		vtsgrouporderupdated=_group;			
		
		
		_code={
				_group=_this;
				vtsgrouporderupdated=nil;
			if (local (leader _group)) then
			{
				_aicript = [_group] execVM "functions\ai_engaged.sqf";
				_group setvariable ["vtscurrentpatrolscript",_aicript,true];
			};
		};
		
		[_code,vtsgrouporderupdated] call vts_broadcastcommand;
	};

//Can use local var in exitwith somehow...	
if !(_orderdone) then {_wpstop setwaypointbehaviour var_console_valid_attitude;_wpstop setWaypointFormation var_console_valid_formation;_wpstop setWaypointspeed var_console_valid_vitesse;};
if !(_orderdone) exitwith{breakclic=0;"Order confirmed : Stop" call vts_gmmessage;};
format["Order confirmed : %1, at %2 speed in %4 with %3 behaviour",nom_console_valid_mouvement,var_console_valid_vitesse,var_console_valid_attitude,nom_console_valid_formation] call vts_gmmessage;
_orderdone=false;
