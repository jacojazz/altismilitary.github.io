_n = _this select 0;

if (_n == 0) then 
	{
	
	pluie_active = true; 
	publicvariable "pluie_active";
	
	if (valid_pluie < 0) then {valid_pluie = 10};
	if (valid_pluie > 10) then {valid_pluie = 0};

	if (valid_pluie == 0) then {pluie_valid = "0" ; pluie = 0 ;};
	if (valid_pluie == 1) then {pluie_valid = "1" ; pluie = 0.1 ;};
	if (valid_pluie == 2) then {pluie_valid = "2" ; pluie = 0.2 ;};
	if (valid_pluie == 3) then {pluie_valid = "3" ; pluie = 0.3 ;};
	if (valid_pluie == 4) then {pluie_valid = "4" ; pluie = 0.4 ;};
	if (valid_pluie == 5) then {pluie_valid = "5" ; pluie = 0.5 ;};
	if (valid_pluie == 6) then {pluie_valid = "6" ; pluie = 0.6 ;};
	if (valid_pluie == 7) then {pluie_valid = "7" ; pluie = 0.7 ;};
	if (valid_pluie == 8) then {pluie_valid = "8" ; pluie = 0.8 ;};
	if (valid_pluie == 9) then {pluie_valid = "9" ; pluie = 0.9 ;};
	if (valid_pluie == 10) then {pluie_valid = "10" ; pluie = 1 ;};

	publicvariable "valid_pluie";
	ctrlSetText [10028,pluie_valid]; 
	};
	
	
if (_n == 1) then 

	{
	publicvariable "pluie";
	_code={};
	call compile format[
	"_code={[%1] call vts_SetRain;};"
	,pluie];
	[_code] call vts_broadcastcommand;
	"Rain validated" call vts_gmmessage;
	};
if (true) exitWith {};
