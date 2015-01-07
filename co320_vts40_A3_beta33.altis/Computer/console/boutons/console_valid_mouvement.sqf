// mouvement




_n = _this select 0;

//private ["var_console_valid_mouvement"];

if (_n == 0) then 
	{

		console_valid_mouvement = lbdata [10218,(lbCurSel 10218)];
		nom_console_valid_mouvement = lbtext [10218,(lbCurSel 10218)];
		var_console_valid_mouvement = console_valid_mouvement ;	
		local_var_console_valid_mouvement = console_valid_mouvement ;
	}
else
{
  
_MydualList2=
  [
	[" 1- Not move",""],
	[" 2- " + script15,script15sqf],
	[" 3- " + script16,script16sqf],
	[" 4- " + script17,script17sqf],
	[" 5- " + script18,script18sqf],
	[" 6- " + script19,script19sqf],
	[" 7- " + script20,script20sqf],
	[" 8- "+script11,script11sqf],
	[" 9- "+script10,script10sqf],
	["10- "+script3,script3sqf],
	["11- " + script1,script1sqf],
	["12- " + script2,script2sqf],
	["13- " + script12,script12sqf],
	["14- " + script4,script4sqf],
	["15- " + script5,script5sqf],
	["16- " + script6,script6sqf],
	["17- " + script8,script8sqf],
	["18- " + script9,script9sqf],
	["19- " + script14,script14sqf]

	];			
if (isnil "Mouvsave") then {Mouvsave=0;};	
[10218, _MydualList2,Mouvsave] spawn Dlg_FillListBoxLists;

console_valid_mouvement = lbCurSel 10218;

};
if (true) exitWith {};
