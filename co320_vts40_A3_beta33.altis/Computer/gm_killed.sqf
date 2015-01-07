waituntil {alive player};

	if ([player] call vts_getisGM) then 
		{
		_cpuaction=vehicle (player) addaction ["Computer (Teamswitch key)","Computer\cpu_dialog.sqf",player, 1, false, false,"","player in (crew (vehicle player))"];
		} ;

if (true) exitWith {};
