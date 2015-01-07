hint "Changing class";



	_currentunit=player;
	//hint _currentname;
	  
	//Check if the class is a valid one before running the script;
	if !(isClass (configFile >> "CfgVehicles" >> skin_unit_unite)) exitwith {hint "Invalid Unit";vtskincooldown=0;};
  
	_isleader=false;

	_currentgroup=group _currentunit; 
	_currentname=vehicleVarName _currentunit;
	if (leader  _currentgroup==_currentunit) then {_isleader=true;};
  
	_dir=direction _currentunit;
	if (isnil "vtsdummygroup") then 
	{
		vtsdummygroup=createGroup (side _currentunit);
	}
	else
	{
		if (isnull vtsdummygroup) then {vtsdummygroup=createGroup (side _currentunit);};
	};
	_posatl=getposatl _currentunit;
	_newUnit=vtsdummygroup createunit [skin_unit_unite,[1,1,1],[],0,"NONE"];
	_init=format["%1=_spawn;_spawn setVehicleVarName ""%1"";publicvariable ""%1"";[_spawn,true] spawn vts_ZeusProcessInit;",_currentname];
	[_newUnit,_init] call vts_setobjectinit;
	[] call vts_processobjectsinit;
	
	_currentunit setposatl [_posatl select 0,_posatl select 1,10000];
	
	
	
	
	
	_newUnit setposatl _posatl;
	_newUnit setDir _dir;
	addSwitchableUnit _newUnit;
	_currentdamage=damage _currentunit;
	selectplayer _newUnit;
	_newUnit setdamage _currentdamage;
	
	[_currentunit,_newUnit] call vts_copytasks;
	
	deletevehicle _currentunit;

	
	
	[_newUnit] joinsilent _currentgroup;
	waituntil {(group _newUnit)==_currentgroup};
	if (_isleader) then {_currentgroup selectleader _newUnit;};
  
	//Handling respawn if activated
	[_newUnit] spawn vts_addeventhandlers;

	//No weapon on class if weapon at start is disabled
	
	//if (pa_startingammo==0) then	{[_newUnit] call vts_stripunitweapons;	};
	
	[_newUnit,true] spawn vts_checkloadoutconformity;
  
  sleep 2;
  vtskincooldown=0;
