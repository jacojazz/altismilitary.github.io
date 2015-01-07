// formation


_n = _this select 0;

//private ["var_console_valid_mouvement"];

if (_n == 0) then 
	{

	console_valid_formation = lbCurSel 10307;

	_nom_form_txt="";
	_var_form_txt="";
	
	// On décline les possibilités
	if (console_valid_formation == 0) then 
		{
		_nom_form_txt = "FORMATION" ;
		_var_form_txt = "FORMATION" ;
		};

	if (console_valid_formation == 1) then 
		{
		_nom_form_txt = "COLUMN" ;
		_var_form_txt = "COLUMN" ;
		};

	if (console_valid_formation == 2) then 
		{
		_nom_form_txt = "STAG COLUMN" ;
		_var_form_txt = "STAG COLUMN" ;
		};

	if (console_valid_formation == 3) then 
		{
		_nom_form_txt = "WEDGE" ;
		_var_form_txt = "WEDGE" ;
		};

	if (console_valid_formation == 4) then 
		{
		_nom_form_txt = "ECH LEFT" ;
		_var_form_txt = "ECH LEFT" ;
		};

	if (console_valid_formation == 5) then 
		{
		_nom_form_txt = "ECH RIGHT" ;
		_var_form_txt = "ECH RIGHT" ;
		};

	if (console_valid_formation == 6) then 
		{
		_nom_form_txt = "VEE" ;
		_var_form_txt = "VEE" ;
		};

	if (console_valid_formation == 7) then 
		{
		_nom_form_txt = "LINE" ;
		_var_form_txt = "LINE" ;
		};

	if (console_valid_formation == 8) then 
		{
		_nom_form_txt = "FILE" ;
		_var_form_txt = "FILE" ;
		};


	if (console_valid_formation == 9) then 
		{
		_nom_form_txt = "DIAMOND" ;
		_var_form_txt = "DIAMOND" ;
		};
		
	nom_console_valid_formation = _nom_form_txt ;
	var_console_valid_formation = _var_form_txt ;
	local_var_console_valid_formation = _var_form_txt ;


	}
else
{
  //Musiques Maestro !!!
  _MydualList2=
      [
        ["FORMATION","0"],
        ["COLUMN","1"],
        ["STAG COLUMN","2"],
        ["WEDGE","3"],
        ["ECH LEFT","4"],
        ["ECH RIGHT","5"],
        ["VEE","6"],
        ["LINE","7"],
        ["FILE","8"],
        ["DIAMOND","9"]
       ];
 
  if (isnil "Formsave") then {Formsave=0;};
  [10307,_MydualList2,Formsave] spawn Dlg_FillListBoxLists;
};

if (true) exitWith {};
