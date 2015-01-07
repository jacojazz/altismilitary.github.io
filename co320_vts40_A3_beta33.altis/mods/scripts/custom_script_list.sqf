//***********************
//***********************
//** Free to edit here **
//***********************
//Be sure to use the comma
//correctly to seperate 
//each scripts in the array.
//The last one don't need comma
//***********************
//***********************

vts_script_array=
[
"spawnwrecks.sqf",
"lgbimpact.sqf"
];


//Script specific to version or mod (only appear if the class is loaded (check is client side for now unfortunaly)
if (isclass (configfile >> "cfgvehicles" >> "Land_LHD_house_1")) then
{
	vts_script_array set [count vts_script_array,"CreateLHD.sqf"];
};

//***********************
//***********************
//***********************
//** Do not edit this ! *
vts_script_array;
//***********************
//***********************
//***********************
//***********************