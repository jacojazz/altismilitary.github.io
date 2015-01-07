
disableSerialization;

// Attention! il faut faire passer en global toutes les variables sur l'unité!
// **********  mettre des ennemis dans les batiments **************

private ["_source","_target"];


//Début de script
if  (breakclic <= 1 ) then
{
	clic1 = false;
	_clic2valid = false;
	_display = finddisplay 8000;
	_txt = _display displayctrl 200;

	_txt CtrlSetText "Left click on the map to select the unit to group";
	_txt CtrlSetTextColor [0.9,0.9,0.9,1];

	Ctrlshow [200,true];sleep 0.2; CtrlShow [200,false];sleep 0.2;Ctrlshow [200,true];

	_count=0;
	_count2=0;
	
  //Récuperation des coordonnées de la carte
			// Clic 1
	onMapSingleClick "spawn_x1 = _pos select 0;
	spawn_y1 = _pos select 1;
	spawn_z1 = _pos select 2;
	clic1 = true;
	onMapSingleClick """";" ;
		
	for "_j" from 10 to 0 step -1 do 
	{
		format["Select the first Unit (Click On Map %1)",_j] spawn vts_gmmessage;
		if (clic1) then
		{
			"" spawn vts_gmmessage;
			_j=0;
			clic1 = false;
		_list = [[spawn_x1,spawn_y1],["CAManBase","Car","Truck","Tank","Helicopter","Plane"],500] call vts_nearestobjects2d;
		if (count _list<1) exitwith {hint " Error : No unit found";clic1 = false;clic2 = false;_source=objnull;};
		_source = _list select 0;	
		_group = group _source;
	    _count=0;
	    {
          _count=_count+1;
          call compile format["_marker=createMarkerLocal [""Gmarker%1"",getpos _x]; _marker setMarkerTypeLocal ""mil_Dot"";_marker setMarkerSizeLocal [1, 1]; _marker setMarkerAlphaLocal 0.5; _marker setMarkerColorLocal ""ColorGreen"";",_count];
        } foreach units _group;
		
		//sleep 1;
		
		_txt CtrlSetTextColor [0.9,0.9,0.9,1];
		_txt CtrlSetText "Left click on the map to group with the selected unit";
		Ctrlshow [200,false];sleep 0.2;CtrlShow [200,true];
		};
		clic1 = false;
		sleep 1;
	}; 

	if (isnull _source) exitwith {	breakclic = 0;};
	
	// Clic 2
	onMapSingleClick "spawn_x2 = _pos select 0;
	spawn_y2 = _pos select 1;
	spawn_z2 = _pos select 2 ;
	
	
	clic2 = true;
	onMapSingleClick """";" ;
	
	for "_j" from 10 to 0 step -1 do 
	{
		format["Select the second Unit (Click On Map %1) or wait to ungroup the selected unit",_j] spawn vts_gmmessage;
		if (clic2) then
		{
			"" spawn vts_gmmessage;
			_j=0;
			clic2 = false;
   
      _list = [[spawn_x2,spawn_y2],["CAManBase","Car","Truck","Tank","Helicopter","Plane"],500] call vts_nearestobjects2d;
      if (count _list<1) exitwith {hint " Error : No unit found";clic1 = false;clic2 = false;_target=objnull;};
			_target = _list select 0;
			_group = group _target;
			_count2=0;
			{
			  _count2=_count2+1;
			  call compile format["_marker=createMarkerLocal [""G2marker%1"",getpos _x]; _marker setMarkerTypeLocal ""mil_Dot"";_marker setMarkerSizeLocal [1, 1]; _marker setMarkerAlphaLocal 0.5; _marker setMarkerColorLocal ""ColorGreen"";",_count2];
			} foreach units _group;
			sleep 0.5;
			while {_count>0} do
			{
			  call compile format["deletemarker ""Gmarker%1"";",_count];
			  _count=_count-1;
			};
			while {_count2>0} do
			{
			  call compile format["deletemarker ""G2marker%1"";",_count2];
			  _count2=_count2-1;
			};
			_clic2valid = true;
	
		};
		clic2 = false;
		sleep 1;
	}; 
	//sleep 0.5;
	

	if (_clic2valid) then
	{
	(units group _source) join leader _target;
	hint format["Unit group %1 joined to group %2",_source,_target];
	}else{
		while {_count>0} do
		{
		  call compile format["deletemarker ""Gmarker%1"";",_count];
		  _count=_count-1;
		};
		while {_count2>0} do
		{
		  call compile format["deletemarker ""G2marker%1"";",_count2];
		  _count2=_count2-1;
		};
	clic2 = false;
	[_source] join GrpNull;
	hint format["Unit %1 unjoined",_source];
	};
	breakclic = 0;
	//	waitUntil {(clic1)};
};
If (true) ExitWith {};
