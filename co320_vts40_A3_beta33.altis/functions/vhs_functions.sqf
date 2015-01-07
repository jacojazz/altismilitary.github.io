vhs_start=
{
	private ["_unit"];
	_unit=_this select 0;
	_unit addeventhandler ["HandleDamage",{_this call vhs_handledamage;0;}]; 
	_unit addeventhandler ["HitPart",{_this call vhs_hitpartdamage;}]; 
	_unit addeventhandler ["HandleHeal",{_this spawn vhs_handleheal;}];

};

vhs_DefaultHitPartCount=["",0,"head",0,"spine3",0,"spine1",0,"leftarm",0,"leftforearm",0,"rightarm",0,"rightforearm",0,"leftupleg",0,"leftleg",0,"leftfoot",0,"rightupleg",0,"rightleg",0,"rightfoot",0];
vhs_DefaultEngineDamagePartValue=["",0,"head",0,"body",0,"hands",0,"legs",0];
vhs_DefaultVHSDamagePartValue=["",0,"head",0,"spine3",0,"spine1",0,"leftarm",0,"leftforearm",0,"rightarm",0,"rightforearm",0,"leftupleg",0,"leftleg",0,"leftfoot",0,"rightupleg",0,"rightleg",0,"rightfoot",0];;
vhs_DefaultBodyCluster=["spine3","spine1"];
vhs_DefaultArmCluster=["leftarm","leftforearm","rightarm","rightforearm"];
vhs_DefaultLegCluster=["leftupleg","leftleg","leftfoot","rightupleg","rightleg","rightfoot"];
vhs_DefaultEngineDeadlyPart=["head","body"];

vhs_handleheal=
{
	private ["_unit","_healer","_anim","_damage","_hitstatus","_damagestatus","_i","_v"];
	_unit=_this select 0;
	_healer=_this select 1;
	_damagestatus=_unit getvariable ["vhs_enginedamagestatus",vhs_DefaultEngineDamagePartValue];
	_hitstatus=_unit getvariable ["vhs_enginehitstatus",vhs_DefaultHitPartCount];	
	_damage=damage _unit;
	sleep 0.5;
	_anim=animationState _healer;
	waituntil {sleep 0.1;animationState _healer!=_anim};
	if !(isplayer _healer) exitwith
	{
		//Allow AI to use FAK and Medikit to heal player;
	};
	//systemchat "ok";
	sleep 0.5;
	_unit setvariable ["vhs_enginedamagestatus",_damagestatus];
	_unit setvariable ["vhs_enginehitstatus",_hitstatus];
	_unit setdamage _damage;
	
	for "_i" from 0 to (count _damagestatus)-1 step 2do
	{

		_unit sethit [(_damagestatus select _i),(_damagestatus select (_i+1))];
		//systemchat ((str (_damagestatus select _i))+" "+(str (_damagestatus select (_i+1))));
	};
};


vhs_handledamage=
{
	private ["_unit","_part","_hitdamage","_shooter","_ammo","_status","_index","_damage"];	
	_unit=_this select 0;
	_part=_this select 1;
	_hitdamage=_this select 2;
	
	//Why some unit don't have the same hit part ???
	switch (true) do
	{
		case (_part=="leg_l") :{_part="legs";};
		case (_part=="hand_l") :{_part="hands";};
	};
	
	if(_hitdamage <= 0.01) exitWith {};  
	_shooter=_this select 3;
	_ammo=_this select 4;
	_status=_unit getvariable ["vhs_enginedamagestatus",vhs_DefaultEngineDamagePartValue];
	//systemchat str _status;
	_index=_status find _part;
	//Keep "" part for custom damage value
	//systemchat str _part;
	if (_index<0 or _part=="") exitwith {};
	_damage=_hitdamage+(_status select (_index+1));
	if !(_part in vhs_DefaultEngineDeadlyPart) then
	{
		if (_damage>0.90) then {_damage=0.90};
	};
	_status set [(_index+1),_damage];
	_unit setvariable ["vhs_enginedamagestatus",_status];
	//systemchat str _status;
	systemchat (_part+" " +(str _damage));
	//Check different kind of part
	[_unit,_part,_damage] spawn {(_this select 0) sethit [(_this select 1),(_this select 2)];};
	
};


vhs_hitgetpartcount=
{
	private ["_unit","_part","_hitstatus","_index"];
	_unit=_this select 0;
	_part=_this select 1;
	_hitstatus=_unit getvariable ["vhs_enginehitstatus",vhs_DefaultHitPartCount];
	_index=_hitstatus find _part;
	if (_index<0) exitwith {};
	_index=_index+1;
	(_hitstatus select _index);
};

vhs_hitupdatecount=
{
	private ["_unit","_part","_hitstatus","_index","_count"];
	_unit=_this select 0;
	_part=_this select 1;
	_count=_this select 2;
	_hitstatus=_unit getvariable ["vhs_enginehitstatus",vhs_DefaultHitPartCount];
	_index=_hitstatus find _part;
	if (_index<0) exitwith {};
	_index=_index+1;
	_hitstatus set [_index,_count];
	_unit setvariable ["vhs_enginehitstatus",_hitstatus];	
};

vhs_hitpartdamage=
{
	private ["_param","_unit","_part","_hitstatus","_shooter","_ammo","_status","_hitnumber"];
	_param=_this select 0;
	_unit=_param select 0;
	_part=((_param select 5) select 0);
	//systemchat str _part;
	_hitnumber=[_unit,_part] call vhs_hitgetpartcount;
	_hitnumber=_hitnumber+1;
	if (_hitnumber>10) then {_hitnumber=10;};
	[_unit,_part,_hitnumber] call vhs_hitupdatecount;
	//systemchat ((str _part)+" "+(str _hitnumber));
};

	
vhs_getpartdamagefromcluster=
{
	private ["_unit","_part","_damagespecific","_last","_current","_max","_clusterdamage","_hitstatus","_cluster","_hitpart"];
	_unit=_this select 0;
	_part=_this select 1;

	_damagespecific=0;
	_cluster=[];
	_hitpart="";
	
	switch (true) do
	{
		case (_part in vhs_DefaultBodyCluster)  : {_cluster=vhs_DefaultBodyCluster;_hitpart="hitbody";};
		case (_part in vhs_DefaultArmCluster)  : {_cluster=vhs_DefaultArmCluster;_hitpart="hithands";};
		case (_part in vhs_DefaultLegCluster) : {_cluster=vhs_DefaultLegCluster;_hitpart="hitlegs";};
	};
		
	if ((count _cluster)>0) then
	{
		_clusterdamage=_unit gethitpointdamage _hitpart;
		_hitstatus=_unit getvariable ["vhs_enginehitstatus",vhs_DefaultHitPartCount];
		//systemchat str _hitstatus;
		_last=0;
		{
			_max=(_hitstatus select ((_hitstatus find _x)+1)) max _last;
			_last=_max;
		} foreach _cluster;
		if (_max>0) then
		{
			_current=_clusterdamage/_max;
			_damagespecific=_current*(_hitstatus select ((_hitstatus find _part)+1));
		};
	};
	//systemchat str _damagespecific;
	_damagespecific;
};

vhs_getpartdamage=
{
	private ["_param","_unit","_part","_damage","_damagespecific","_shooter","_ammo","_status"];	
	_unit=_this select 0;
	_part=_this select 1;
	_damage=0;

	switch (true) do
	{
		case (_part==""):{_damage=damage _unit;};
		case (_part=="head"):{_damage=_unit gethitpointdamage "hithead";};
		default {_damage=[_unit,_part] call vhs_getpartdamagefromcluster;};	
	};
	_damage;
};