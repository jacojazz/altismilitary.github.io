// script_commande.sqf


_n = _this select 0;

if (_n == 0) then 
{
	if (script_commande < 0) then 
    {
        script_commande = (count vts_rtscript_array);
    };
    
	if (script_commande > ((count vts_rtscript_array)) ) then 
    {
        script_commande = 0;
    };

	if (script_commande == 0) then 
	{
		var_console_script_commande = "None";
	}
	else
	{
		var_console_script_commande = vts_rtscript_array select (script_commande - 1);
	};
	//hint format["%1",script_commande];

	ctrlSetText [10246,var_console_script_commande]; 
};
	
if (_n == 1) then 
{
    _ligne_joueur = format ["%1",ctrlText 10243];
	
	if (_ligne_joueur!="") then
	{
		if (isnil "vts_command_history") then  {vts_command_history=[];};
		//_processed=[_ligne_joueur,"""",""""""] call KRON_Replace;
		_last="";
		if (count vts_command_history>0) then
		{
			_last=vts_command_history select ((count vts_command_history)-1);
			if (_ligne_joueur!=_last) then
			{
				vts_command_history=vts_command_history+[_ligne_joueur];
				publicvariable "vts_command_history";
			};
		}
		else
		{
			vts_command_history=vts_command_history+[_ligne_joueur];
			publicvariable "vts_command_history";
		};

	};
	//We don't want to broadcast script execution only command line
	//publicvariable "var_console_script_commande";
	
	"Command/Script executed" call vts_gmmessage;
	
	_code=compile _ligne_joueur;
	
	[_code] call vts_broadcastcommand;
	
	
	
	// on exécute ensuite sur toutes les machines

	if (var_console_script_commande in vts_rtscript_array) then
	{
		[] execVM var_console_script_commande;
	};
	
};

if (_n == 2) then 
{
	if (isnil "vts_command_history") exitwith {};
	//player sidechat "up";
	ctrlSetFocus ((finddisplay 8000) displayctrl 10243);
	_curindex = (vts_command_history_index - 1);
	if (_curindex < 0) then {_curindex= (count vts_command_history)-1;};
	ctrlsettext [10243,vts_command_history select _curindex];
	vts_command_history_index=_curindex;
	playsound ["computerok",true];
};

if (_n == 3) then 
{
	if (isnil "vts_command_history") exitwith {};
	//player sidechat "down";
	ctrlSetFocus ((finddisplay 8000) displayctrl 10243);
	_curindex = (vts_command_history_index + 1);
	if (_curindex > ((count vts_command_history)-1)) then {_curindex=0;};
	ctrlsettext [10243,vts_command_history select _curindex];
	vts_command_history_index=_curindex;	
	playsound ["computerok",true];
};

//sleep 1;
scriptrun = 0;
if (true) exitWith {};
