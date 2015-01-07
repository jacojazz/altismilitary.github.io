//[test] execvm "functions\ai_engaged.sqf";
vtsai_debug=false;
vtsai_checksound=false;
vtsai_allowmovetocover=true;

vtsai_isstaticgroup=
{
	private ["_grp","_traveldistance","_isstatic","_wps"];
	_grp=_this select 0;
	_traveldistance=0;
	_isstatic=false;
	_wps=waypoints _grp;
	for "_w" from 0 to (count _wps)-1 do
	{
			_curwp=_wps select _w;
			_wppos=waypointPosition _curwp;
			_wpdist=_wppos distance leader _grp;
			_traveldistance=(_wpdist max _traveldistance);
	};
	if (vtsai_debug) then {player sidechat str _traveldistance;};
	if (_traveldistance<150) then {_isstatic=true;};
	_isstatic;
};

vtsai_sad=
{
	private ["_sadloop","_group","_wp","_target"];
	_group=_this select 0;
	if (vtsai_debug) then {player sidechat "Looping Seek and Destroy !";};
	_sadloop=true;
	while {_sadloop} do
	{
		if !(isnull _group) then
		{
			if (alive leader _group) then
			{
				_target=(leader _group) findnearestenemy (getpos (leader _group));
				if !(isnull _target) then
				{
					while {(count (waypoints _group))>0} do
					{
						deletewaypoint ((waypoints _group) select 0);
					};
					_wp=_group addwaypoint [getpos _target,0];
					_wp setwaypointtype "SEEKANDDESTROY";
				};
			};
		}
		else
		{
			_sadloop=false;
		};
		if (({alive _x} count (units _group))<1) then {_sadloop=false;};
		sleep 10;
		//Finish loop and hunt end of waypoint?
	};
};

vtsai_playerfiredevent=
{
	private ["_timetocheck","_timetolisten","_unit","_weapon","_bullet","_audible","_shotsounddistance","_distancehear"];
	_timetocheck=3;
	_timetolisten=6;
	
	if (isnil "vtsai_pfirelastcheck") then {vtsai_pfirelastcheck=time-1;};
	if (vtsai_pfirelastcheck>=time) exitwith {};
	vtsai_pfirelastcheck=time+_timetocheck;
	
	_unit=_this select 0;
	_weapon=_this select 1;
	_bullet=_this select 4;
	_audible=getnumber (configfile >> "CfgAmmo" >> _bullet >> "audiblefire");

	//player sidechat format["%1",_this];
	//Check silencer coef if Arma 3 or more (in Arma 2 audible is on bullet only)
	if (vtsarmaversion>2) then
	{
		//If using GL or different muzzle, then it mean the projectile doesnt go out of the silencer
		if (_weapon==(_this select 2)) then
		{			
			_weaponitems=[];		
			call compile "_weaponitems=_unit weaponAccessories _weapon;";
			if (count _weaponitems>0) then
			{
				_muzzleitem=_weaponitems select 0;
				if (_muzzleitem!="") then
				{
					_coef=getnumber (configfile >> "CfgWeapons" >> _muzzleitem >> "ItemInfo" >> "AmmoCoef" >> "audiblefire");
					if (_coef>0) then {_audible=_audible*_coef;};
				};
			};
		};
	};
	//hint format["%1",_audible];
	
	_shotsounddistance=
	{
		
		_unit=_this select 0;
		//_unit is not the same after respawn so using player instead of _unit
		_distancehear=_this select 1;
		_time=_this select 2;
		_lasttime=vtsai_pfirelastcheck;
		player setvariable["vtsai_dshot",_distancehear,true];
		//player sidechat "update";
		sleep _time;
		if (vtsai_pfirelastcheck==_lasttime) then 
		{
			//if !(alive player) then {waitUntil {alive player};};
			player setvariable["vtsai_dshot",0,true];
			//player sidechat "reset";
		};
		
	};
	
	//Audible distance
	_distancehear=_audible*15;
	
	[_unit,_distancehear,_timetolisten] spawn _shotsounddistance;

};

vtsai_playeriniteventhandler=
{
	private ["_unit"];
	_unit=_this select 0;
	_unit addeventhandler ["fired",
	{
		_this spawn vtsai_playerfiredevent;
	}
	];
};

vtsai_patrolinsidebuilding=
{
	private ["_unit","_building","_patrolbuilding"];
	_unit=_this select 0;
	//_building=nearestbuilding _unit;
	_building=[_unit] call vts_getnearestbuilding;
	
	if (vtsai_debug) then {player sidechat "AI patroling building";};
	
	
	if ((isnull _building) or !(alive _unit)) exitwith {};
	
	//Avoid unit to run out the formation and the move orders (IE leaving the house)
	_unit setCombatMode "YELLOW";
	_unit setBehaviour "SAFE";
	_unit setSpeedMode "LIMITED";
	//Disable AI target avoid them flanking or move to engage target (but still shoot them).
	_unit disableAI "AUTOTARGET";
	//_unit disableAI "TARGET";
	(group _unit) enableAttack false;
	
	if (vtsai_debug) then {player sidechat format["b : %1, c: %2",behaviour _unit, combatmode _unit];};
	
	_patrolbuilding=true;
	
	while {alive _unit && alive _building && _patrolbuilding && ((count waypoints group _unit)<1) && (local _unit)} do
	{
		_pos=_building call buildingposcount;
		if (_pos<1) then 
		{
			if (vtsai_debug) then {player sidechat format["!!! AI building NO POS FUND for %1",_unit];};
			_patrolbuilding=false;
		}
		else
		{	
			_unit setUnitPos "UP";
			_unit doWatch (_unit findNearestEnemy position _unit);
			_newpos=(_building buildingPos floor(random(_pos)));
			if ((_newpos select 0 !=0) && (_newpos select 1 !=0) && (_newpos select 2 !=0)) then
			{
				if (vtsai_debug) then {player sidechat format["AI BUILD POS %2 : %1",_newpos,_unit];};
				_unit forceSpeed -1;
				_unit domove _newpos;
				_limit=time + 30;
				waitUntil {sleep 1;(unitready _unit)};	
				_unit forceSpeed 0;
				_unit doWatch (_unit findNearestEnemy _newpos);
				if (vtsai_debug) then {player sidechat format["AI building move done %1",_unit];};
			};
		};
		sleep (30 + random(30));	
	};
	_unit forceSpeed -1;
	_unit enableAI "AUTOTARGET";
	//_unit enableAI "TARGET";
	(group _unit) enableAttack true;
	
	if (vtsai_debug) then {player sidechat format["AI End of building patrol %1",_unit];};
};


vtsai_movetocover=
{
	private ["_group","_isinsidebuilding","_backtoleader","_updatewaypoint"];
	_group=_this select 0;
	_updatewaypoint=false;
	if ((count _this)>1) then {_updatewaypoint=_this select 1;};
	_isinsidebuilding=[_group] call vts_isgroupinbuilding;
	
	_backtoleader=
	{
		_unittoregroup=_this select 0;
		_timeout=time+20;
		waitUntil {sleep 1;(time>_timeout) or (unitready _unittoregroup)};
		if ((leader _unittoregroup)!=_unittoregroup) then {_unittoregroup dofollow (leader _unittoregroup);};
		if (vtsai_debug) then {player sidechat "Regrouping after cover !";};
		//_unittoregroup suppressfor 10;
		//if (vtsai_debug) then {player sidechat "Suppress fire !";};
	};
	
	//Group mainly outside
	if (!_isinsidebuilding && vtsai_allowmovetocover) then
	{
		for "_i" from 0 to (count units _group)-1 do
		{
			_unit=(units _group) select _i;
			if (leader _group==_unit) then
			{
				if (alive _unit) then
				{				
					_covers=[];
					_objects=nearestObjects [getpos _unit, [], 25];
					{
						_bbox = boundingBox _x;

						_sizex = ((_bbox select 1) select 0) - ((_bbox select 0) select 0);
						_sizey = ((_bbox select 1) select 1) - ((_bbox select 0) select 1);
						_sizez = ((_bbox select 1) select 2) - ((_bbox select 0) select 2);

						if (!(vehicle _x isKindOf "Man")) then
						{
							if (((getPosATL _x) select 2) < 0.2) then
							{
								if ((_sizez > 1.5) && (_sizez < 20) && ((_sizex min _sizey) > 0.3) && ((_sizex max _sizey) > 1.5)) then
								{
									_covers set [count _covers,_x];
								};
							};
						};
					} forEach _objects;
					_objects=_covers;
					
					if (count _objects >0) then 
					{
						_object=_objects select floor(random(count _objects));
						_unit forceSpeed -1;
						if (vehicle _unit iskindof "Man") then
						{
							_unit doMove getpos _object;
							if (_updatewaypoint) then {[group _unit,currentWaypoint (group _unit)] setwaypointposition  [(getpos _object),0];};
							[_unit] spawn _backtoleader;
						}
						else
						{
							_vehpos=[((getposatl vehicle _unit) select 0)+15*sin(direction (vehicle _unit)),((getposatl vehicle _unit) select 1)+15*cos(direction (vehicle _unit))] findEmptyPosition [5,50];
							if (count _vehpos>0) then
							{
							_unit domove _vehpos;
							[_unit] spawn _backtoleader;
							};
						};
					};
				};
			};
		};
	}
	//Group mainly inside building
	else
	{
		if (vtsai_allowmovetocover) then
		{
			{[_x] spawn vtsai_patrolinsidebuilding;} foreach units _group;
			//[leader _group] spawn vtsai_patrolinsidebuilding;
		};
	};
};

vtsai_shareinformation=
{
	private ["_group","_target","_accuracy","_allgroups"];
	_group=_this select 0;
	_target=_this select 1;
	_accuracy=_this select 2;
	_allgroups=allgroups;
	for "_i" from 0 to (count _allgroups)-1 do
	{
		_workinggroup=_allgroups select _i;
		if (side _workinggroup==side _group) then
		{
			if (({alive _x} count (units _workinggroup))>0) then
			{
				if (((getpos (leader _workinggroup)) distance (getpos (leader _group)))<600) then
				{
					if (!((_workinggroup knowsAbout _target)>0) && !((leader _workinggroup distance _target)>1000)) then
					{
						_workinggroup reveal [_target,_accuracy];
						if (vtsai_debug) then {player sidechat "Support call received !";};
					};
				};
			};
		};
	}; 
};

vtsai_lookatnoise=
{
	private ["_listener","_soundsource","_awaremode"];
	_listener=_this select 0;
	_soundsource=_this select 1;
	_awaremode=_this select 2;
	if (_listener getvariable["vtsai_looking",false]) exitwith {};
	if (vtsai_debug) then {player sidechat "AI Engaged : Player heard !";};
	_dist=(_listener distance _soundsource);
	_listener dowatch (_soundsource modelToWorld [0-(_dist/2)+(random _dist),0-(_dist/2)+(random _dist),1.5]);
	//"sign_sphere100cm_f" createvehicle (_soundsource modelToWorld [0-(_dist/2)+(random _dist),0-(_dist/2)+(random _dist),1.5]);
	if(_awaremode && (behaviour _listener=="SAFE")) then 
	{
		_listener setBehaviour "AWARE";
	};
	//Local var used, coz script must run localy
	_listener setvariable["vtsai_looking",true];
	sleep 10.0;
	_listener dowatch objnull;
	_listener setvariable["vtsai_looking",false];
};

//Player handler
if (typename (_this select 0)=="OBJECT") exitwith
{
	if (isplayer (_this select 0)) then 
	{
		if (vtsai_checksound) then 
		{
			[(_this select 0)] call vtsai_playeriniteventhandler;
		};
	};
};
_group=_this select 0;

//How many man in the group ?
_groupcount={alive _x} count (units _group);

//Running check
//No AI script on civilian (better turn them opfor for this)
if (side _group==civilian) exitwith {};
//No AI script on carelesss (they are the I DONT GIVE A FUCK of arma) and unit already in combat following orders (given by GM per example)
if (((count (waypoints _group)>1) && (behaviour (leader _group)=="COMBAT")) or (behaviour (leader _group)=="CARELESS")) exitwith {};

//Only move to cover 1 time in the loop life.
_movedtocover=false;


_loop=true;
_loopcount=1;
_seekanddestroy=false;
while {(_loop) && (({alive _x} count (units _group))>0) && (local leader _group)} do
{
	playableunits;
	_target=objnull;
	_underattack=false;
	//Checking only if leader is in building while looping to avoid cpu hog
	_groupinbuilding=[_group,"FAST"] call vts_isgroupinbuilding;
	
	//If the squad is losing for unknow reason, make them spread
	if ((({alive _x} count (units _group))<_groupcount) && !(_movedtocover))  then
	{
		if (vtsai_debug) then {player sidechat "AI Engaged : One man down !";};
		[_group] spawn vtsai_movetocover;
		_movedtocover=true;
	};
	
	//AI listener function	
	if (isnil "acre_api_fnc_isSpeaking") then {acre_api_fnc_isSpeaking={false;};};
	//Can be cpu intensive for server
	if (vtsai_checksound) then
	{
		_voicedistance=21;
		//Check player speaking only each two loop
		if ((_loopcount mod 1)==0) then
		{
			_players=playableunits;
			for "_i" from 0 to (count _players)-1 do
			{
				_currentp=_players select _i;
				if ((_group knowsAbout _currentp)<1) then 
				{
					_pgunshotdisance=_currentp getvariable ["vtsai_dshot",0];
					_pvoiceon=[_currentp] call acre_api_fnc_isSpeaking;
					//player sidechat format["%1 & %2",_pgunshotdisance,_pvoiceon];
					if ((_pgunshotdisance>0) or (_pvoiceon)) then
					{
						{
							_blook=false;
							_baware=false;
							if ((_pgunshotdisance>0) && ((_x distance _currentp)<_pgunshotdisance)) then 
							{
								_blook=true;
								_baware=true;
							};							
							if (_pvoiceon && ((_x distance _currentp)<_voicedistance)) then 
							{
								_blook=true;				
							};
							if (_blook) then
							{
								[_x,_currentp,_baware] spawn vtsai_lookatnoise;	
							};
						} foreach units _group;
					};
				};
			};
		};
	};
	
	//Check if the group has already been underattack before checking if we set them under attack
	//This allow the group to receiver new order while beeing under attack
	_lastime=_group getvariable ["vtsai_lasttime_aiengaged",0];
	if ((_lastime==0) or ((_lastime+600)<time)) then
	{
		//Check if units knowsabout players (could be to all units but.. would be ressource overkill
		{
			if ((((side _group) getfriend (side _x)) < 0.6) && ((_group knowsAbout _x) > 0)) then
			{
				_underattack=true;
				_loop=false;
				_target=_x;
			};
			
		} foreach playableunits;
	};
	//Check if the unit still alive since the knowsabout (because knowsabout can be positive even if all units are dead)
	if (_underattack && ({alive _x} count (units _group))>0) then
	{
		if (vtsai_debug) then {player sidechat "AI Engaged !";};
		_group setvariable ["vtsai_lasttime_aiengaged",time,true];
		
		//Increase spot distance of alerted enemy so they can respond to player fire farer long distance
		{
			_x setskill ["spotDistance",1];
		} foreach units _group;
		
		_skill=skill (leader _group);
		//Skilled team don't spread while hunting and they together (combat mode yellow)
		if (_skill>0.49) then 
		{	
			if (vtsai_debug) then {player sidechat "AI teamplay !";};
			_group setCombatMode "YELLOW";
			_group setSpeedMode "NORMAL";
		}
		else 
		{
			if (vtsai_debug) then {player sidechat "AI splitted !";};
			_group setCombatMode "RED";
			_group setSpeedMode "FULL";
		};
		_group setbehaviour "COMBAT";
		//Check if the group was a static one or patroling
		_isstaticgroup=[_group,_target] call vtsai_isstaticgroup;

		//Check current waypoint used (if SAD turn hunting one what ever the patrol the unit is doing)
		if ((waypointType [_group,currentWaypoint _group])=="SAD") then
		{
			_isstaticgroup=false;
		};
		
		//Then clean current waypoints if any
		while {(count (waypoints _group))>0} do
		{
			deletewaypoint ((waypoints _group) select 0);
		};
		
		//Group in building don't get waypoint
		if !(_groupinbuilding) then
		{
			if (_isstaticgroup) then 
			{
				//_wp=_group addwaypoint [getpos leader _group,0];
				//_wp setwaypointtype "Sentry";	
				//_group setCombatMode "GREEN";				
				//_group setCombatMode "RED";	
				//_group setCombatMode "YELLOW";
				_group enableAttack false;
				 {_x disableai "TARGET";} forEach units _group;
				_wp=_group addwaypoint [getpos (leader _group),0];
				_wp setwaypointtype "Hold";	
				_wp=_group addwaypoint [getpos (leader _group),0];
				_wp setwaypointtype "Cycle";	
				if (vtsai_debug) then {player sidechat "AI Sentry !";};

			}
			else 
			{
				_wp=_group addwaypoint [getpos _target,0];
				_wp setwaypointtype "SEEKANDDESTROY";
				_seekanddestroy=true;
				if (vtsai_debug) then {player sidechat "AI Hunting !";};
			};
		};
		//Make them use covers
		if !(_movedtocover) then 
		{
			[_group,_isstaticgroup] spawn vtsai_movetocover;
			_movedtocover=true;		
		};
		//Give X seconds (+ the current loop state) to the player before they call for support
		//It's about the time AI shoot back
		sleep 5.0;
		_groupalive=true;
		if (({alive _x} count (units _group))<1) then 
		{
			_groupalive=false;
			if (vtsai_debug) then {player sidechat "AI dead !";};
		};
		if (_groupalive) then 
		{
			if (vtsai_debug) then {player sidechat "Call support !";};
			[_group,_target,(_group knowsAbout _target)] spawn vtsai_shareinformation;
		};		
	};
	_loopcount=_loopcount+1;
	sleep 3;
};

if (_seekanddestroy) then
{
	[_group] call vtsai_sad;
};
if (vtsai_debug) then {player sidechat "AI Scripted behavior terminated !";};
