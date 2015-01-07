// orientation

_n = _this select 0;

if (_n == 0) then 
	{
	
	if (console_valid_orientation < 0) then {console_valid_orientation = 7};
	if (console_valid_orientation > 7) then {console_valid_orientation = 0};

	// On décline les possibilités
	
	_nom_dir_txt="";
	_var_dir_num=0;
	
	if (console_valid_orientation == 0) then 
		{
		_nom_dir_txt = "N" ;
		_var_dir_num = 0;
		};
	
	if (console_valid_orientation == 1) then 
		{
		_nom_dir_txt = "N-E" ;
		_var_dir_num = 45;
		};
		
	if (console_valid_orientation == 2) then 
		{
		_nom_dir_txt = "E" ;
		_var_dir_num = 90;
		};
		
	if (console_valid_orientation == 3) then 
		{
		_nom_dir_txt = "S-E" ;
		_var_dir_num = 135;
		};
		
	if (console_valid_orientation == 4) then 
		{
		_nom_dir_txt = "S" ;
		_var_dir_num = 180;
		};
		
	if (console_valid_orientation == 5) then 
		{
		_nom_dir_txt = "S-W" ;
		_var_dir_num = -135;
		};
		
	if (console_valid_orientation == 6) then 
		{
		_nom_dir_txt = "W" ;
		_var_dir_num = -90;
		};
		
	if (console_valid_orientation == 7) then 
		{
		_nom_dir_txt = "N-W" ;
		_var_dir_num = -45;
		};

	nom_console_valid_orientation = _nom_dir_txt ;
	console_unit_orientation = _var_dir_num;		
	local_console_unit_orientation = _var_dir_num;		

	ctrlSetText [10229,nom_console_valid_orientation]; 
	};
if (true) exitWith {};