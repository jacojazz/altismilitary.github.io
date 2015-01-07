disableSerialization;
_n = _this select 0;

private "_myDualList2";

_camp=var_console_valid_camp;

console_valid_type = lbCurSel 10305;

_name=lbtext [10305, console_valid_type]; 
_type=lbdata [10305, console_valid_type]; 

if (_n == 0) then 
{

		nom_console_valid_type = _name ;
		var_console_valid_type = _type ;
		local_var_console_valid_type = _type ;


		//call compile format ["_MydualList2 = %1_%2 call Dlg_GenerateList",_camp,_type];
		call compile format ["if (isnil ""%1_%2"") exitwith {};_MydualList2 = %1_%2",_camp,_type];
				
		if (isnil "_MydualList2") exitwith {};
		
		lbClear 10306;
		
		//player sidechat str _MydualList2;
			
		//Checking if filter is on for objects:
		//[] call vts_perfstart;
		if ((sideobjectfilter!="")) then
		{
			private ["_Newlist"];
			_filter=sideobjectfilter;
			_display = finddisplay 8000;
			_txt = _display displayctrl 200;
			_color=[1,1,1,1];
			_txt CtrlSetText "Filtering object";
			_Newlist=nil;
			call compile format ["if !(isnil ""%1_%2_%3"") then {_Newlist=%1_%2_%3;} else {_Newlist=nil;};",_camp,_type,_filter];
			if (isnil "_Newlist") then 
			{
				_Newlist=[];
				for "_f" from 0 to (count _MydualList2)-1 do
				{
					_curarr=_MydualList2 select _f;
					if (_color select 1 == 1) then {_txt CtrlSetTextColor [1,0,0,1];} else {_txt CtrlSetTextColor [1,1,1,1];};
					if ([([ _curarr,_type] call vts_GetClassDisplayName)+" - "+_curarr,_filter] call KRON_StrInStr) then 
					{
						_Newlist set [count _Newlist,_curarr];
					};
				};
				call compile format ["%1_%2_%3=_Newlist;",_camp,_type,_filter];
			};
			_txt CtrlSetText "";
			_MydualList2=_Newlist;
		};
		//[] call vts_perfstop;
		
		//Checking if we add the customgroup to the array
		if (_type=="Group") then
		{
			_customgrouplist=[] call vts_gmgetactivecustomgroup;
			_MydualList2=_customgrouplist+_MydualList2;
		};
		
	
		
		_Newlist=[];
		for "_i" from 0 to (count _MydualList2)-1 do
		{
			
			_CurItem=_MydualList2 select _i;
			if (typename _CurItem=="STRING") then
			{
				_Newlist set [count _Newlist,[([ _CurItem,_type] call vts_GetClassDisplayName)+" - "+_CurItem,_CurItem,([_CurItem,_type] call vts_GetVehicleIcon)]];
			};
		};
		_MydualList2=_Newlist;
		
		_vts_currentspawn_list=[];
		{
			_vts_currentspawn_list set [ count _vts_currentspawn_list,(_x select 0)];
			_vts_currentspawn_list set [ count _vts_currentspawn_list,(_x select 1)];
		} foreach _MydualList2;
		vts_currentspawn_list=_vts_currentspawn_list;
		
		if (isnil "Unitsave") then {Unitsave=0;};
		[10306, _MydualList2,Unitsave,[8000,10306]] call Dlg_FillListBoxLists;
		//((finddisplay 8000) displayctrl 10306)
		
		// On montre l'attitude
		ctrlShow [10211,true];
		ctrlShow [10212,true];
		ctrlShow [10213,true];
			
		// On montre la vitesse
		ctrlShow [10214,true];
		ctrlShow [10215,true];
		ctrlShow [10216,true];
		
		// On montre le mouvement
		ctrlShow [10217,true];
		ctrlShow [10218,true];
		ctrlShow [10219,true];
		
		// On montre le moral
		ctrlShow [10220,true];
		
		// On montre le 3D & Preview
		ctrlShow [10210,true];
		ctrlShow [10399,true];
		
		ctrlShow [10225,true];
		ctrlShow [10226,true];

		
		//Formation up
		ctrlShow [10307,true];
		
	//Hidding group preview and 3D
	if (_type == "Group" ) then 
	{
	 	ctrlShow [10210,false];
		ctrlShow [10399,false];

	};
		
	//Object
	if (_type in type_objects) then 
	{
	/*
	lbSetCursel [10218,0];
	console_valid_mouvement = 0 ;
		_n = [0] execVM "computer\console\boutons\console_valid_mouvement.sqf";waitUntil {scriptDone _n};
	*/	
		// On masque l'attitude
		ctrlShow [10211,false];
		ctrlShow [10212,false];
		ctrlShow [10213,false];
		
		// On masque la vitesse
		ctrlShow [10214,false];
		ctrlShow [10215,false];
		ctrlShow [10216,false];
		
		// On masque le mouvement
		ctrlShow [10217,false];
		ctrlShow [10218,false];
		ctrlShow [10219,true];
		ctrlShow [10304,false];
		
		// On montre le 3D & Preview
		ctrlShow [10210,true];
		ctrlShow [10399,true];
		
		// On masque le moral
		ctrlShow [10220,false];
		
		ctrlShow [10225,false];
		ctrlShow [10226,false];

		
		// On masque la formation
		ctrlShow [10307,false];
	};

	if (_type == "Base" or _type == "Composition") then 
	{
	/* 
	  lbSetCursel [10218,0];
		console_valid_mouvement = 0;
		_n = [0] execVM "computer\console\boutons\console_valid_mouvement.sqf";waitUntil {scriptDone _n};
	*/	
		// On montre l'attitude
		ctrlShow [10211,false];
		ctrlShow [10212,false];
		ctrlShow [10213,false];
		
		// On cache la vitesse
		ctrlShow [10214,false];
		ctrlShow [10215,false];
		ctrlShow [10216,false];
		
		// On cache le mouvement
		ctrlShow [10217,false];
		ctrlShow [10218,false];
		//ctrlShow [10219,false];
		ctrlShow [10304,false];
		ctrlShow [10220,true];
		
		// On cache le 3D & Preview
		ctrlShow [10210,false];
		ctrlShow [10399,false];
		
		// On montre le moral
		
		ctrlShow [10225,true];
		ctrlShow [10226,true];

	};

//No movements for statics	
if (_type == "Static") then 
{		
    /*	
	  lbSetCursel [10218,0];
		console_valid_mouvement = 0;
		*/
		// On cache le mouvement
		ctrlShow [10217,false];
		ctrlShow [10218,false];


};
	/*
	_n = [0] execVM "computer\console\boutons\console_joueur_scripteur.sqf";waitUntil {scriptDone _n};
	_n = [0] execVM "computer\console\boutons\console_valid_unite.sqf";waitUntil {scriptDone _n};
	*/
	
	
};


//if (!(isnil "Typesave") and (Typesavewait>1))then {lbSetCurSel [10305, Typesave];Typesave=nil;Typesavewait=0}; 
//Typesavewait=Typesavewait+1;

if (true) exitWith {};
