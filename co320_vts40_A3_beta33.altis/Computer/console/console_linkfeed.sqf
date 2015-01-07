linkfeedtable="Land_CampingTable_small_F";
linkfeedscreen="UserTexture1m_F";

vtslinkfeedactioned=
{
	_unit=_this select 1;
	_obj=_this select 0;
	_dummy=(_this select 0) getvariable "dummy";
	
	//Maybe the best is to put the public var on the dummy vehicle
	//Not working
	//The best i think is to make sure there is always only one rendertotarget used by camera and not two camera using the same r2t
	//player sidechat  format["%1",_dummy];
	
	if ((vehiclevarname player)=="") exitwith {hint "Only valid named unit can link with a feed";};
	
	_currentfeed=_dummy getvariable ["currentfeed",objnull];

	if (isnull _currentfeed) then
	{
		hint "Connecting . . .";
		_dummy setvariable ["currentfeed",_unit,true];
	}
	else
	{
	
		//then enjoy !
		if (_currentfeed==_unit) then {hint "Disconnecting . . .";_dummy setvariable ["currentfeed",objnull,true];}
		else {_dummy setvariable ["currentfeed",_unit,true];hint "Reconfiguring link . . .";};
	};
	
	
};

vtslinkeedcameraupdate=
{

	_obj=_this select 0;
	_screen=_this select 1;	
	_fakescreen=_this select 2;	
	_dummy=_this select 3;
	
	//Shoulder pos
	_headcampos=[0.21,-0.10,.15];
	
	//Distance from the player to determinate if he is playing or is in freecam, spectator or what ever
	_incontroldist=5;

	//Generating the r2t feed for this feed console (local to each players)
	if (isnil "vtslastfeed") then {vtslastfeed=0;}
	else {vtslastfeed=vtslastfeed+1};
	_feed=("vtsfeed"+(str vtslastfeed));
	
	//Creating the local camera
	_camera = "camera"  camcreate (position _screen);				
	_camera cameraEffect ["INTERNAL", "BACK", _feed];
	_camera camsetfov 0.6;
	_camera camcommit 0;	
	
	
	while {alive _obj} do
	{


		_currentfeed=_dummy getvariable ["currentfeed",objnull];
		if !(isnull _currentfeed) then
		{
			
			//Applying the correct feed r2t to the screen
			call compile format["
			_screen setobjecttexture [0,""#(argb,512,512,1)r2t(%1,1.0)""];
			",_feed];	
			

			//player sidechat "cam already here";
			//Refreshing camera if the player enter a vehicle
			if ((vehicle _currentfeed)!=_currentfeed) then
			{

				//player sidechat format["veh %1 cam %2",vehicle _currentfeed,_camera];
				//detach _camera;
				_camera attachto [(vehicle _currentfeed),[0,1.5,0],"pilot"];
				
			}
			else //Back in helmet cam when on foot
			{	
				//detach _camera;
				//player sidechat format["Attaching camera to unit : %1",_camera];
				_camera attachTo [_currentfeed,_headcampos,"head"];
			};
			
			//Refreshing the current vision mode based on the player vision
			if (currentVisionMode _currentfeed>0) then {_feed setpipeffect [1];}
			else {_feed setpipeffect [0];};
			
			//After the player gone on another camera, the feed is blank
			//Checking if the current camera is near or far from the player (far = maybe spectator or something so we don't reinit the camera for sure);
			_campos=positionCameraToWorld [0,0,0];
			if ((_campos distance player)<_incontroldist) then 
			{
					
					//player sidechat ("refresh + "+_feed);
					_camera cameraEffect ["INTERNAL", "BACK", _feed];						
			};
			

		}
		else
		{
			//Turning off the screen (noise or not?)	
			_screen setobjecttexture [0,"#(rgb,8,8,3)color(0,0,0.3,1)"];
			
			

		};
		sleep 3.0;
	};
	//Console is dead or delete, we cut the feed, because camdestroy don't cut it :( (and only 8 feeds are allowed). 
	//But still I don't want people in other cam to be perturbed.
	_campos=positionCameraToWorld [0,0,0];
	if ((_campos distance player)<_incontroldist) then 
	{	
		_camera cameraEffect["Terminate","BACK"];
	};
	//Cleaning up stuff then
	camdestroy _camera;
	deletevehicle _screen;
	deletevehicle _fakescreen;
	deletevehicle _dummy;
};

//Creation on the map
if ((count _this) <1) then
{
	//First we create the props


	//player sidechat "spawn";
	_dummy=vts_dummyvehicle createVehicle (position player);
	_table=linkfeedtable createVehicle (position player);
	_dummy attachto [_table,[0,0,1.5]];
	//_dummy enablesimulation false;
	//Very usefull this method
	_table setdir ((direction player));
	_frontpos=[(getPosatl player select 0) + (1 * sin(direction player)), (getPosatl player select 1) + (1 * cos(direction player)), (getPosatl player select 2)];
	_table setPosatl _frontpos;
	
	_screen=linkfeedscreen createvehicle (getpos _table);
	_screen attachto [_table,[0,-0.01,0.90]];
	_fakescreen=linkfeedscreen createvehicle (getpos _table);
	
	_fakescreen attachto [_table,[0,0.01,0.90]];	 	
	_fakescreen setdir 180;
	
	_dummy setvariable ["feedconsole",_table,true];
	_dummy setvariable ["feedscreen",_screen,true];
	_dummy setvariable ["fakescreen",_fakescreen,true];
	_table setvariable ["vts_object",true,true];
	_table setvariable ["vts_children",[_dummy,_screen,_fakescreen],true];
	_table setvariable ["dummy",_dummy,true];
	[_dummy,"_spawn hideobject true;_spawn allowDamage false;feed=[_spawn] execvm ""Computer\console\console_linkfeed.sqf"";"] call vts_setobjectinit;
	
	[] call vts_processobjectsinit;
	
} else
//JIP or after spawn
{
	sleep 1;
	_obj=(_this select 0) getvariable "feedconsole";
	_screen=(_this select 0) getvariable "feedscreen";
	_fakescreen=(_this select 0) getvariable "fakescreen";
	_dummy=_this select 0;
	
	_screen setobjecttexture [0,"#(rgb,8,8,3)color(0,0,0.3,1)"];
	_fakescreen setobjecttexture [0,"#(rgb,8,8,3)color(0.0,0.0,0.0,1)"];
	//((finddisplay 8000) displayctrl 105) ctrlSetText "#(argb,512,512,1)r2t(vtsfeed1,1.0)";
	//((finddisplay 8000) displayctrl 105) ctrlSetText "#(rgb,8,8,3)color(0,0,0.3,1)";
	
	//We add the addaction to the object 
	_obj addaction ["Link/Unlink","Computer\console\console_linkfeedaction.sqf"];
	_obj addaction ["[GAMEMASTER] Specify a link","Computer\console\console_gmlinkfeedaction.sqf",[],100,false,false,"","[_this] call vts_getisgm"];
	
	//We add the feed if already existing (for jip people)
	[_obj,_screen,_fakescreen,_dummy] call vtslinkeedcameraupdate;
	
	//player sidechat format["%1",_screen];
	//_screen setobjecttexture [0,"#(argb,512,512,1)r2t(render01,1.0)"]; 
};