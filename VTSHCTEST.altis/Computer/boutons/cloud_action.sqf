_n = _this select 0;

if (_n == 0) then 
	{
	
	cloud_active = true; 
	publicvariable "pluie_active";
	
	if (valid_cloud < 0) then {valid_cloud = 10};
	if (valid_cloud > 10) then {valid_cloud = 0};

	if (valid_cloud == 0) then {cloud_valid = "0" ; vtscloud = 0 ;};
	if (valid_cloud == 1) then {cloud_valid = "1" ; vtscloud = 0.1 ;};
	if (valid_cloud == 2) then {cloud_valid = "2" ; vtscloud = 0.2 ;};
	if (valid_cloud == 3) then {cloud_valid = "3" ; vtscloud = 0.3 ;};
	if (valid_cloud == 4) then {cloud_valid = "4" ; vtscloud = 0.4 ;};
	if (valid_cloud == 5) then {cloud_valid = "5" ; vtscloud = 0.5 ;};
	if (valid_cloud == 6) then {cloud_valid = "6" ; vtscloud = 0.6 ;};
	if (valid_cloud == 7) then {cloud_valid = "7" ; vtscloud = 0.7 ;};
	if (valid_cloud == 8) then {cloud_valid = "8" ; vtscloud = 0.8 ;};
	if (valid_cloud == 9) then {cloud_valid = "9" ; vtscloud = 0.9 ;};
	if (valid_cloud == 10) then {cloud_valid = "10" ; vtscloud = 1 ;};

	publicvariable "valid_cloud";
	ctrlSetText [10055,cloud_valid]; 
	};
	
	
if (_n == 1) then 

	{
	publicvariable "vtscloud";
	_code={};
	call compile format[
	"_code={[%1] call vts_SetCloud;};"
	,vtscloud];
	[_code] call vts_broadcastcommand;
	"Overcast validated" call vts_gmmessage;
	};
if (true) exitWith {};
