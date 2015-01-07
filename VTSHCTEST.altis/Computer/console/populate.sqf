_populatemover=
{
		  _unit = _this select 0;
	      _side = _this select 1;
		  _buildingpos = _this select 2;
		  
		  _movergroup = createGroup _side;
		  [_unit] joinsilent _movergroup,
		  
		  //3 waypoints per wanderer, should be enough
		  _pos=_buildingpos select (floor(random (count _buildingpos)));
		  _initialpos = _pos;
          _wp = _movergroup addWaypoint [_pos, 0];
          _wp setWaypointType "MOVE";
		  _wp setWaypointHousePosition 0;
          _wp setWaypointSpeed "LIMITED";
          _wp setWaypointBehaviour "SAFE";
		  
		  for "_i" from 1 to 2 do
		  {
			_pos=_buildingpos select (floor(random (count _buildingpos)));
			_wp = _movergroup addWaypoint [_pos, 0];
			_wp setWaypointType "MOVE";
			_wp setWaypointTimeout [10, 20, 15];
			/*
			if (floor(random 2)==1) then
			{
				_object=nearestobject [_pos,"House"];
				if !(isnull _object) then
				{
					_poscount=_object call buildingPosCount;
					if (_poscount>0) then
					{
						_wp waypointAttachObject ([_object] call getBuildingdID);
						_wp setWaypointHousePosition floor(random _poscount);
						player sidechat "wp inside";
					};
				};
			};
			*/
			
		  };
		    
           _wp = _movergroup addWaypoint [_initialpos, 0];            
           _wp setWaypointType "CYCLE";           
       
};	

	
        _pos=_this select 0;
        
        //****************************************************
        //************* SETTINGS FREE TO MODIFY **************
        //****************************************************
        
				//Options, percentage is per buildings detected in the area (100% = 1 spawn per building)
				_SpawnUnit=true; //Spawn unit ?
				_SpawnVehicle=true; //Spawn vehicle ?
				_SpawnSide=civilian; //Side of the group
				_populatepermeter=500; //number of meter square per spawn
				_vehiclepercent=5; //% of vehicle
				//_areasize=100; //Size of the area to populate
				_areasize=_this select 2;
				_movingpercent=30; //% of units spawned that will move (following sentry waypoint)
				_interiorspawnchance=25; //Chance in % to fill a position.
				
				//Here to define wich units to randomly spawn
				_vehiclestospawn=[];
				_unitstospawn=[];
				_people=_this select 1;
				call compile format["if !(isnil '%1_Land') then {_vehiclestospawn=%1_Land;};",_people];
				call compile format["_unitstospawn=%1_Man;",_people];

				//****************************************************
				//***************** End of settings ******************
				//****************************************************
				
				
				
				//Variables inits !!! DO NOT TOUCH !!!
				private ["_randompos","_validpos"];
				_unitsnum=count _unitstospawn;
				_vehiclesnum=count _vehiclestospawn;
				
				_dir=0;
				_numofunittospawn=0;
				_numofvehicletospawn=0;
				_numbuildingpos=0;
				_building=objnull;
				_unitspawnedinside=0;
				_isinside=false;
				_unitstomove=0;
				_unitstomovearray=[];
				
				//Looking for buildings in the area
				_buildings=nearestObjects  [[_pos select 0, _pos select 1],["House","Ruins","Church","FuelStation"],_areasize];
				_buildingscount=count _buildings;
	      
	      //No buildings in area will end the script
	      if (_buildingscount<1) exitwith {hint "!!! No buildings in the area !!!";};
	      
		  //Generating building pos
	      _buildingpos=[];
		  for "_i" from 0 to (_buildingscount-1) do
		  {
			_currentbuilding=_buildings select _i;
			_posnum=_currentbuilding call buildingPosCount;
			if (_posnum>0) then
			{
				for "_p" from 0 to (_posnum-1) do
				{
					_buildingpos set [count _buildingpos,_currentbuilding buildingpos _p];
				};
			};
		  };
		  
		  if (count _buildingpos<1) exitwith {hint "!!! no  building positions !!!";};
		  
		//player sidechat format["%1",_buildingpos];
        
        //Units populatation
        if (_SpawnUnit) then
        {
		  _group = createGroup _SpawnSide;
          //_numofunittospawn=round((count _buildings)*(_populatepercent/100));
		  
		  //_squaremeters=((_areasize/2)^2)*3.14;
		  _squaremeters=(round(count _buildings))*50;
		  
		  _numofunittospawn=round(_squaremeters/_populatepermeter);
		  if (_numofunittospawn<1) then {_numofunittospawn=1;};
          _unitstomove=round(_numofunittospawn*(_movingpercent/100));
          
         //Lets have alway an happy mover
         if (_unitstomove<1) then {_unitstomove=1;}; 
		

          for "_x" from 0 to _numofunittospawn do
          {
			//Safety to avoid overkill more than 64 unit group performance killer
			if ((_x!=0) && (_x mod 64==0)) then {_group = createGroup _SpawnSide;};
            ///Random pos in area
            //Random pos in area based on buildings (more coherant for humans being)
            _building=_buildings select (round(random(_buildingscount-1)));
            //_numbuildingpos = _building call buildingPosCount;
			_numbuildingpos=count _buildingpos;
  
            if (_numbuildingpos>0) then
            {
              _validpos=_buildingpos select (floor(random(_numbuildingpos))); 
			  _buildingpos=_buildingpos-_validpos;
			  
              if (count (_validpos nearEntities [["CAManBase"], 1])<1) then
              { 
                _unitspawnedinside=_unitspawnedinside+1;
                _isinside=true;
              }
              else 
              {
                _randompos=getpos _building;
                _validpos=_randompos findEmptyPosition [1,_areasize];
              };
            }
            else //Or outside if the buldings doesnt have interior
            {
              _randompos=getpos _building;
              _validpos=_randompos findEmptyPosition [1,_areasize];
            };
            //Avoid men onroad spawn
			/*
            while {isonroad _validpos} do
            {
              _randompos=getpos (_buildings select (round(random(_buildingscount-1))));
              _validpos=_randompos findEmptyPosition [1,_areasize];
            };
			*/            
            //_unit =_group createunit [_unitstospawn select (round(random(_unitsnum-1))),_validpos,[],0,"NONE"];
            //_group = createGroup _SpawnSide;
			
            _unit =_group createUnit [_unitstospawn select (round(random(_unitsnum-1))),_validpos,[],0,"NONE"];
			_unit call vts_setskill;
			_unit switchmove "";
			_unit setbehaviour "SAFE";
            //Readjust position if inside a building
            if (_isinside) then {_unit setpos _validpos};
            //Readjust position if on roof of a building with no position
            if ((!_isinside) and ((getposatl _unit select 2)>2)) then {_unit setposatl [getposatl _unit select 0,getposatl _unit select 1,0];};
            //Random group direction
            //player sidechat format["d %1",_unit];
            //Handle the moving and stopped units
            if (_x > _unitstomove) then 
			{
				_unit forcespeed 0;
			}
			//Make this one a wanderer
			else 
			{
				_unitstomovearray set [count _unitstomovearray,_unit];
			};
            

     				_marker_test = createMarkerLocal ["testmarker",_validpos];
    				_marker_test setMarkerShapeLocal "ELLIPSE";
    				_marker_test setMarkerSizeLocal [2, 2];
    				_marker_test setMarkerDirLocal 0;
    				_marker_test setMarkerColorLocal "Colorred";
					_marker_test setMarkerAlphaLocal 0.5;
					//sleep 0.1;
    	
    				deleteMarkerLocal "testmarker";
    				_numbuildingpos=0;
    				_isinside=false;

          };
			
		 //Then we run the move init on the wanderer
		 {[_x,_SpawnSide,_buildingpos] spawn _populatemover;} foreach _unitstomovearray;
          
          
        };
        
        //Vehicles population
        if (_SpawnVehicle && (_vehiclesnum>0)) then
        {
           //_numofvehicletospawn=round(_buildingscount*(_vehiclepercent/100));

		  _squaremeters=(round(count _buildings))*5;
		  //_squaremeters=((_areasize/10)^2)*3.14;
		  _numofvehicletospawn=round(_squaremeters/_populatepermeter);
		  if (_numofvehicletospawn<1) then {_numofvehicletospawn=1;};

		  
           _roadlist = [_pos select 0, _pos select 1] nearRoads _areasize;
           
          for "_x" from 0 to _numofvehicletospawn do
          {        
            _roadnum = count _roadlist;
            _road = _roadlist select round(random (_roadnum-1));
            _roadlist = _roadlist - [_road];
            _validpos=getpos _road;
            _vehicle= _vehiclestospawn select (round(random(_vehiclesnum-1))) createVehicle _validpos;
            //Random direction on the road
            if (round(random 1)>0) then {_dir=0} else {_dir=180};			
			_roaddir=0;
			_roadconnected=(roadsConnectedTo _road) select 0;
			//Get the road orientation from the position of two roads piece because direction on road not work anymore
			if !(isnull _roadconnected) then 
			{
				_roaddir=((getposatl _road select 0) - (getposatl _roadconnected select 0)) atan2 ((getposatl _road select 1) - (getposatl _roadconnected select 1));
			};
			//player sidechat format["%1",_roaddir];
            _vehicle setDir _roaddir+_dir;
            //Put the vehicle on the right of the road
            _Offset = [3.5,0,0];
            _validpos = _vehicle modelToWorld _Offset;
            //Make sure the vehicle is not in a wall on the road side
            _newvalidpos = _validpos findEmptyPosition [0.1,10,typeof _vehicle];
			if (count _newvalidpos>0) then
			{
            _vehicle setpos _validpos;
			};
            //Velocity to make sur the vehicle follow the slope
            _vehicle setvelocity [0,0,1];
          
    				_marker_testv = createMarkerLocal ["testmarkerv",_validpos];
    				_marker_testv setMarkerShapeLocal "ELLIPSE";
    				_marker_testv setMarkerSizeLocal [5, 5];
    				_marker_testv setMarkerDirLocal 0;
    				_marker_testv setMarkerColorLocal "Colorred";
					_marker_testv setMarkerAlphaLocal 0.5;
    				//sleep 0.1;
    				deletemarker "testmarkerv";
          };
        };
   
	      _code=nil;
	      call compile format["
	      _code={
        if ([player] call vts_getisGM) then {""Spawned : %2 unit(s) ( %4 moving and %5 inside buildings) and %3 vehicle(s) for %1 building(s)"" spawn vts_gmmessage;};
        };
        ",_buildingscount,_numofunittospawn,_numofvehicletospawn,_unitstomove,_unitspawnedinside];
        //hint format["Spawned : %2 unit(s) ( %4 moving and %5 inside buildings) and %3 vehicle(s) for %1 building(s)",];
        [_code] call vts_broadcastcommand; 
        sleep 2;
        
        //[[_pos select 0,_pos select 1,0],_people,_areasize,5000] execvm "computer\console\fillroads.sqf";
