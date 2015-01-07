_n = _this select 0;

if (_n == 0) then 
	{
	
	brume_active = true; 
	publicvariable "brume_active";
	
	if (valid_brume < 0) then {valid_brume = 10};
	if (valid_brume > 10) then {valid_brume = 0};

	if (valid_brume == 0) then {brume_valid = "0" ; brume = [0,brume select 1] ;};
	if (valid_brume == 1) then {brume_valid = "1" ; brume = [0.1,brume select 1] ;};
	if (valid_brume == 2) then {brume_valid = "2" ; brume = [0.2,brume select 1] ;};
	if (valid_brume == 3) then {brume_valid = "3" ; brume = [0.3,brume select 1] ;};
	if (valid_brume == 4) then {brume_valid = "4" ; brume = [0.4,brume select 1] ;};
	if (valid_brume == 5) then {brume_valid = "5" ; brume = [0.5,brume select 1] ;};
	if (valid_brume == 6) then {brume_valid = "6" ; brume = [0.6,brume select 1] ;};
	if (valid_brume == 7) then {brume_valid = "7" ; brume = [0.7,brume select 1] ;};
	if (valid_brume == 8) then {brume_valid = "8" ; brume = [0.8,brume select 1] ;};
	if (valid_brume == 9) then {brume_valid = "9" ; brume = [0.9,brume select 1] ;};
	if (valid_brume == 10) then {brume_valid = "10" ; brume = [1,brume select 1] ;};
	

	publicvariable "valid_brume";
	ctrlSetText [10032,brume_valid]; 
	};
	
	
if (_n == 1) then 

	
	{
	brume_affiche = valid_brume ; 
	_code={};
	call compile format ["
	_code=
	{
		%1 call vts_setfog;
	};
	",brume];
	[_code] call vts_broadcastcommand;
	_mf = [] execVM "computer\msge_brume_valid.sqf" ;
	"Fog validated" call vts_gmmessage;
	sleep 1 ;
	//Just updating network var for JIP
	publicvariable "brume";
	
	};
if (true) exitWith {};
