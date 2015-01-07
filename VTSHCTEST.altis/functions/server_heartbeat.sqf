//Only run on server
_hb=0;
while {true} do
{

	//Event every 5 seconds
	if (_hb mod 5==0) then
	{
		vts_server_fps=round(diag_fps);
		publicvariable "vts_server_fps";
		if !(isdedicated) then {[] call vts_updateserverfps;};
		

	};
	
	
	//Event every 10 seconds
	if (_hb mod 10==0) then
	{
		_grps=allgroups;
		vts_server_groupsnum=[{side _x==WEST} count _grps,{side _x==EAST} count _grps,{side _x==RESISTANCE} count _grps,{side _x==CIVILIAN} count _grps,
		{side _x==WEST} count allunits,{side _x==EAST} count allunits,{side _x==RESISTANCE} count allunits,{side _x==CIVILIAN} count allunits];
		publicvariable "vts_server_groupsnum";
		if !(isdedicated) then {[] call vts_updateservergroupnum;};
	};
	//Event every 120 seconds
	if (_hb mod 120==0) then
	{
		//Heartbeat script

		  //Keeping date uptodate for JIP player
		  Sync_time = date;
		  publicvariable "Sync_time";
		
	  
	  //Let see if a group have no unit alive, then we will destroy it to free ressource for moar ennemy (arma 2 is limited to 177 group) !
	  
		  _numgroup = count allGroups;
		  //{ if ((_x!=vtsdummygroup) and (_x!=vtsdummygrouphidden)) then {deleteGroup _x}; } forEach allGroups;
		  //Can only destroy empty and local group
		  {deleteGroup _x} forEach allGroups;
		  
		  
		  if (_numgroup>165) then
		  {
			//Hint the Game master about too much group create in the area
			call compile format["if ([player] call vts_getisGM) then {hint ""!!! Warning you have %1 groups on 177 maximum allowed !!!"";};",_numgroup];
		  };

			
	};

	_hb=_hb+1;
	sleep 1;
  
};
