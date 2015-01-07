_n = _this select 0;

if (_n == 0) then 
	{
	
	wind_active = true; 
	publicvariable "pluie_active";
	
	if (valid_wind < 0) then {valid_wind = 10};
	if (valid_wind > 10) then {valid_wind = 0};

	if (valid_wind == 0) then {wind_valid = "0" ; vtswindpower = 0 ;};
	if (valid_wind == 1) then {wind_valid = "1" ; vtswindpower = 1 ;};
	if (valid_wind == 2) then {wind_valid = "2" ; vtswindpower = 2 ;};
	if (valid_wind == 3) then {wind_valid = "3" ; vtswindpower = 3 ;};
	if (valid_wind == 4) then {wind_valid = "4" ; vtswindpower = 4 ;};
	if (valid_wind == 5) then {wind_valid = "5" ; vtswindpower = 5 ;};
	if (valid_wind == 6) then {wind_valid = "6" ; vtswindpower = 6 ;};
	if (valid_wind == 7) then {wind_valid = "7" ; vtswindpower = 7 ;};
	if (valid_wind == 8) then {wind_valid = "8" ; vtswindpower = 8 ;};
	if (valid_wind == 9) then {wind_valid = "9" ; vtswindpower = 9 ;};
	if (valid_wind == 10) then {wind_valid = "10" ; vtswindpower = 10 ;};

	publicvariable "valid_wind";
	ctrlSetText [10136,wind_valid]; 
	};
	
	
if 	(_n == 1) then 
	{
		_ns=([1,-1] select (floor random 2));
		_we=([1,-1] select (floor random 2));
		vtswind=[(vtswindpower*_ns),(vtswindpower*_we),true];
		publicvariable "vtswind";
		_code={setwind _this;};
		[_code,vtswind] call vts_broadcastcommand;
		"Wind validated" call vts_gmmessage;
	};
if (true) exitWith {};
