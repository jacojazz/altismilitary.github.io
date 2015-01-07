disableSerialization;
// side

_n = _this select 0;

private "_MydualList";

if (_n == 0) then 
{
	

		_factionlist=[];
		_MydualList=[];
		call compile format ["_factionlist=%1_factions;",var_skin_valid_side];
		for "_i" from 0 to (count _factionlist)-1 do
		{
			
			_faction=_factionlist select _i;
			//player sidechat str _faction;
			_add=false;
			call compile format["
			if !(isnil ""%1_man"") then
			{
				if (count %1_man>0) then
				{
					_add=true;
				};
			};
			",_faction];
			if (_faction=="Default" or _faction=="Other") then {_add=false};
			if (_add) then
			{
				
				_MydualList set [count _MydualList,[gettext (configfile >> "CfgFactionClasses" >> _faction >> "displayName"),_faction,gettext (configfile >> "CfgFactionClasses" >> _faction >> "icon")]];
			};
		};

		[10203, _MydualList] spawn Dlg_FillListBoxLists;
	
 	
	ctrlSetText [10206,nom_skin_valid_side]; 
	//_n = [0] execVM "computer\console\boutons\console_valid_camp.sqf";waitUntil {scriptDone _n};
};
	
if (true) exitWith {};
