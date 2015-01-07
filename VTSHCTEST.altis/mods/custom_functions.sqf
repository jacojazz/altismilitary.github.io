//*************************************************************************************
//*************************************************************************************
//************************** Free to edit here ****************************************
//********** if vts_debug=true this file is read each time the CPU is opened **********
//**************** (perfect for testing script update on the fly) *********************
//*************************************************************************************

//****************************************
//*** Fuctions as it appear in the list ***
//****************************************

vts_customfunctions=
[
	"[_spawn] call vts_SaluteOnSpawn;"
];

//*********************************************************
//******************* Functions library *******************
//*********************************************************
//***** _object is the unit where the function is run ****
//*********************************************************

vts_SaluteOnSpawn=
{	
	_unit=_spawn;
	if (local _unit) then
	{
		if (_unit iskindof "Man") then
		{
			_unit action ["salute",_unit];

			hint "Salute !";
			player sidechat "Salute";
		
		};
	};
};