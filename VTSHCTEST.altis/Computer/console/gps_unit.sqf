// [unit] execvm "Computer\console\gps_unit.sqf"

_unit=_this select 0;

private ["_unitmarker","_timer","_mtype"];

_getvehiclecolor=
{
   _v=_this select 0;
   _color="ColorWhite";         
   if(side  _v == west) then {_color="ColorBlue";};
   if(side  _v == east) then {_color="ColorRed";};
   if(side  _v == resistance) then {_color="ColorGreen";};
   if(side  _v == civilian) then {_color="ColorOrange";};
   if(count (crew _v) < 1) then {_color="ColorYellow";};
   if (!alive _v) then {_color="ColorBlack";};
   _color
};


//No marker script on a unit who already run the script
_checkmarker=_unit getVariable ["vtsmakername",nil];  
if !(isnil "_checkmarker") exitwith {};

//player sidechat " marker script run :(";

while {(gps_eni_valid==1) && (!isnull _unit)} do
{
    //Get current markername var on the object
    _variable=_unit getVariable ["vtsmakername",nil];   
    //Make sure we don't change the variable in a loop
    if (!isnil "_variable") then {_unitmarker=_variable;};
    
    if (isnil "_unitmarker") then
    {
    
        if !(isnull _unit) then
        {
          //Creating a new marker if the unit doesnt have one
          //hint "Creating a new marker"; 
          //Checking if nmarker is initated
          if (isnil "vtsnmarker") then {vtsnmarker=0;};
          //Creating markers
          _vclass=typeOf _unit;
          
          _mtype="empty";
          _msize=[0.75,0.75];
          _timer=3.0;
          if (_vclass iskindof "CAManBase") then {_mtype="mil_Dot";_msize=[0.4, 0.4];};
          if (_vclass iskindof "Motorcycle") then {_mtype="n_unknown"};
          if (_vclass iskindof "Tank") then {_mtype="n_armor"};
          if (_vclass iskindof "Tracked_APC" or _vclass iskindof "APC" or _vclass iskindof "Wheeled_APC") then {_mtype="n_armor"};
          if (_vclass iskindof "Ship") then {_mtype="n_unknown"};
          if (_vclass iskindof "StaticWeapon") then {_mtype="n_mortar"};
          if (_vclass iskindof "Helicopter") then {_mtype="n_air";_timer=1.0;};
          if (_vclass iskindof "Car") then {_mtype="n_unknown"};
          if (_vclass iskindof "Truck") then {_mtype="n_recon"};
          if (_vclass iskindof "Plane") then {_mtype="n_plane";_timer=1.0;};
          if (_vclass iskindof "Static" or _vclass iskindof "Thing") then {_mtype="RECTANGLE"};
          if (_vclass iskindof vts_smallworkdummy) then {_mtype="mil_unknown";_msize=[0.4, 0.4];};
  
          if (_mtype=="empty") exitwith {};
		  
          _unitmarker = createMarkerLocal[format["AIMarker%1",vtsnmarker], getPosATL _unit];
          if (_mtype=="RECTANGLE") then 
		  {
			_unitmarker setMarkerShapeLocal _mtype;	
			_mx=(((boundingBox _unit) select 1) select 0)-(((boundingBox _unit) select 0) select 0);
			_my=(((boundingBox _unit) select 1) select 1)-(((boundingBox _unit) select 0) select 1);
			_unitmarker setMarkerSizelocal [_mx/2,_my/2];			
		  }
		  else
		  {
			_unitmarker setMarkerTypeLocal _mtype;
			_unitmarker setMarkerSizeLocal _msize;			
		  };
      	  
      
          _unit setvariable ["vtsmakername",_unitmarker];
          
          //Incrementing markers
          
          vtsnmarker=vtsnmarker+1;
          };           
    };
	if (_mtype=="empty") exitwith {};
    _mcolor=[_unit] call _getvehiclecolor;
	_unitmarker setMarkerDirLocal (direction _unit);   
    _unitmarker setMarkerPosLocal (getPosATL _unit);           
    _unitmarker setMarkerColorLocal _mcolor;
    
    sleep _timer;
};

//Cleaning up marker on exit
//hint "End of marker";

if !(isnil "_unitmarker") then 
{
	deleteMarkerLocal _unitmarker;
	_unit setvariable ["vtsmakername",nil];
};

//player sidechat " marker script end :)";

