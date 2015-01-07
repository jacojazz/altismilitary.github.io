gps_eni_valid = gps_eni_valid+1;

if (gps_eni_valid > 1) exitwith {gps_eni_valid = 0;"GM All units markers OFF" call vts_gmmessage;};
if (gps_eni_valid == 1)then {"GM All units markers ON" call vts_gmmessage;};

gps_unitlist=[];
_nmarker=0;	

  

  while{gps_eni_valid==1} do 
  {


      //Lets find all unit, Dead one include
	  /*
      _Units=[];
      _grp=[];
      _ngrp=0;
      {
        _grp=units _x;
        _ngrp=count _grp;
        for "_u" from 0 to _ngrp-1 do 
        {
          _Units set [count _Units,(_grp select _u)];
        };
      } forEach allGroups;
	  */
	  //_Units=[];
	  //_Units=allUnits+allDead;
      //And Vehicles
      //_vehicles=vehicles;
      //_Units=_Units+_vehicles;
	  _Units=allMissionObjects "ALL";
      
  
      {
        if (!isnull _x) then
			{ 
			  //Runnig markers script on each unit who doesnt already have a marker
			  _unitmarker=_x getVariable "vtsmakername";   
			  if  (isnil "_unitmarker") then
			  {
				if ((typeof _x)=="WeaponHolderSimulated") then
				{
					_x setVariable ["vtsmakername",""];
				}
				else
				{
					[_x] spawn gmgps_unit;
				};
			  };
			  
			};
		
      }
      forEach _Units;
      
      sleep vts_gpsrefresh;
   
  };
  
  //Cleaning up marker on exit
 
  
if (true) exitWith {};
