_n = _this select 0;

if (_n == 0) then 
	{
	
	heure_active = true; 
	publicvariable "heure_active";
	
	if (valid_heure < 0) then {valid_heure = 23};
	if (valid_heure > 23) then {valid_heure = 0};

	if (valid_heure == 0) then {heure_valid = "0" ; heure = 0 ;};
	if (valid_heure == 1) then {heure_valid = "1" ; heure = 1 ;};
	if (valid_heure == 2) then {heure_valid = "2" ; heure = 2 ;};
	if (valid_heure == 3) then {heure_valid = "3" ; heure = 3 ;};
	if (valid_heure == 4) then {heure_valid = "4" ; heure = 4 ;};
	if (valid_heure == 5) then {heure_valid = "5" ; heure = 5 ;};
	if (valid_heure == 6) then {heure_valid = "6" ; heure = 6 ;};
	if (valid_heure == 7) then {heure_valid = "7" ; heure = 7 ;};
	if (valid_heure == 8) then {heure_valid = "8" ; heure = 8 ;};
	if (valid_heure == 9) then {heure_valid = "9" ; heure = 9 ;};
	if (valid_heure == 10) then {heure_valid = "10" ; heure = 10 ;};
	if (valid_heure == 11) then {heure_valid = "11" ; heure = 11 ;};
	if (valid_heure == 12) then {heure_valid = "12" ; heure = 12 ;};
	if (valid_heure == 13) then {heure_valid = "13" ; heure = 13 ;};
	if (valid_heure == 14) then {heure_valid = "14" ; heure = 14 ;};
	if (valid_heure == 15) then {heure_valid = "15" ; heure = 15 ;};
	if (valid_heure == 16) then {heure_valid = "16" ; heure = 16 ;};
	if (valid_heure == 17) then {heure_valid = "17" ; heure = 17 ;};
	if (valid_heure == 18) then {heure_valid = "18" ; heure = 18 ;};
	if (valid_heure == 19) then {heure_valid = "19" ; heure = 19 ;};
	if (valid_heure == 20) then {heure_valid = "20" ; heure = 20 ;};
	if (valid_heure == 21) then {heure_valid = "21" ; heure = 21 ;};
	if (valid_heure == 22) then {heure_valid = "22" ; heure = 22 ;};
	if (valid_heure == 23) then {heure_valid = "23" ; heure = 23 ;};

	publicvariable "valid_heure";
	ctrlSetText [10036,heure_valid]; 
	};
	
	
if (_n == 1) then 

	{
	publicvariable "heure";
	_code={};
	call compile format[
	"_code={[%1] call vts_SetHour;};"
	,heure];
	[_code] call vts_broadcastcommand;
	"Time validated" call vts_gmmessage;
	Sync_time = [date select 0, date select 1, date select 2, heure, date select 4];publicvariable "Sync_time";
	};
if (true) exitWith {};
