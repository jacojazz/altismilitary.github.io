//************** FUNCTIONS ******************
//[] call vts_perfstart;
vts_loadconfig_CleanArray=
{
  _fname=_this select 0;
  call compile format["
  %1_Man=nil;
  %1_Land=nil;
  %1_Air=nil;
  %1_Ship=nil;
  %1_Static=nil;
  %1_Logistic=nil;
  %1_Animal=nil;
  %1_Group=nil;
  %1_GroupConfig=nil;
  %1_Object=nil;
  %1_Building=nil;
  %1_Composition=nil;
  %1_CompositionScript=nil;
  %1_Empty=nil;
  %1_Base=nil;
  %1_Module=nil;
  ",_fname];
};


vts_loadconfig_ShowProgress=
{
  _hint=("Loading :\n"+(_this select 0));
  hintsilent _hint;
  vts_mphint=_hint;
  publicvariable "vts_mphint";
};

vts_loadconfig_CreateFactionArray=
{
  _faction=_this select 0;
  _type=_this select 1;
  _data=_this select 2;
  _enforce=false;
  _cfgdata=nil;
  
  if (count _this >3) then {_enforce=_this select 3;};
  if (count _this >4) then {_cfgdata=_this select 4;};
  
  if !(_enforce) then
  {
      _allside=west_factions+east_factions+resistance_factions+civilian_factions;
      
      //Creating a global factions (same in each side) if the specified one in the config is not in side.
      if !(_faction in _allside) then
      {

        //Checking if the faction class as a specified side somewhere in its path. else, add the faction to all side *sigh* 
        _westcheck=true;
        _eastcheck=true;
        _resistancecheck=true;
        _civiliancheck=true;
        
        if !(isnil "_cfgdata") then
        {
          _cfgstring=format["%1",_cfgdata];        
          if (([_cfgstring,"west"] call KRON_StrInStr)) then {_westcheck=true;_eastcheck=false;_resistancecheck=false;_civiliancheck=false;};
          if (([_cfgstring,"east"] call KRON_StrInStr)) then {_westcheck=false;_eastcheck=true;_resistancecheck=false;_civiliancheck=false;};
          if (([_cfgstring,"guerrila"] call KRON_StrInStr)) then {_westcheck=false;_eastcheck=false;_resistancecheck=true;_civiliancheck=false;};
          if (([_cfgstring,"civilian"] call KRON_StrInStr)) then {_westcheck=false;_eastcheck=false;_resistancecheck=false;_civiliancheck=true;};
        };
        
        if (_westcheck) then {west_factions=west_factions+[count west_factions,_faction];}; 
        if (_eastcheck) then {east_factions=east_factions+[count east_factions,_faction];};
        if (_resistancecheck) then {resistance_factions=resistance_factions+[count resistance_factions,_faction];};
        if (_civiliancheck) then {civilian_factions=civilian_factions+[count civilian_factions,_faction];};
          
      };
  };
  call compile format["
  if (isnil ""%1_%2"") then
  {
    call compile format[""%1_%2=[];"",_faction];
    [""%1_%2""] call vts_loadconfig_ShowProgress;  
  };
  %1_%2 set [count %1_%2,_data];
  ",_faction,_type];  
};

vts_loadconfig_filterstring=
{
	private ["_text","_filter","_textArray","_filterArray","_space"];
	_text = _this select 0;
	_filter = _this select 1;
	_space=false;
	if (_filter==" ") then {_space=true;};
	_textArray = toarray (tolower _text);
	_filterArray = toarray (tolower _filter);
	{
		if !(_space) then
		{
			if (_x in _filterArray) then 
			{
				_textArray set [_foreachindex,-1];
			}
		}
		else
		{
			if (_x==32) then 
			{
				_textArray set [_foreachindex,-1];
			};
		};		
	} foreach _textArray;
	_textArray = _textArray - [-1];
	tostring _textArray;
};

vts_loadconfig_GetConfigName=
{
  _config=_this select 0;
  _txt=configName _config;
  _txt=toUpper([_txt," "] call vts_loadconfig_filterstring);

  _txt
};
vts_loadconfig_SpareSpace=
{
  _txt=_this select 0;
  _txt=toUpper([_txt," "] call vts_loadconfig_filterstring);

  _txt
};
//*****************************************


//Gentlemen, start your engine
_hint="Loading Ressource...";
hint _hint;



//Creating side arrays
west_factions=[];
east_factions=[];
resistance_factions=[];
civilian_factions=[];
//That one isn't generated dynamicly
object_factions=["Object"];

ShopLandList=[];
ShopAirList=[];
ShopStaticList=[];
ShopManList=[];


//First, i look at the factions per side 

_factions=configFile >> "CfgFactionClasses";


//Temp var for cross referencing use
//Retrieve faction name to reassociate junk addons class not referencing correctly their side per class (using name referencement like used in the buggy BIS editor... Talk about quality over quantity)
_tempfactionlistclassname=[];
_tempfactionlistname=[];

//Filling side arrays with factions
_n=(count _factions)-1;
//Starting at 1 to avoid the false class named (access) in cfgfactions
for "_i" from 0 to _n do
{
  if (isclass(_factions select _i)) then 
  {
	//player sidechat format["%1",_factions select _i];
    call compile format["
    _exist=getnumber (_factions select %1 >> ""side"");
    if !(isnil ""_exist"") then 
	{    
		_factionside=getnumber ((_factions select %1) >> ""side"");
		if (_factionside == 1) then {west_factions=west_factions+[count west_factions,[(_factions select %1)] call vts_loadconfig_GetConfigName];[configName(_factions select %1)] call vts_loadconfig_CleanArray;};
		if (_factionside == 0) then {east_factions set [count east_factions,[(_factions select %1)] call vts_loadconfig_GetConfigName];[configName(_factions select %1)] call vts_loadconfig_CleanArray;};
		if (_factionside == 2) then {resistance_factions set [count resistance_factions,[(_factions select %1)] call vts_loadconfig_GetConfigName];[configName(_factions select %1)] call vts_loadconfig_CleanArray;}; 
		if (_factionside == 3) then {civilian_factions set [count civilian_factions,[(_factions select %1)] call vts_loadconfig_GetConfigName];[configName(_factions select %1)] call vts_loadconfig_CleanArray;};
	
		
		if !(([(_factions select %1)] call vts_loadconfig_GetConfigName) in _tempfactionlistclassname) then
		{
		_tempfactionlistclassname set [count _tempfactionlistclassname,[(_factions select %1)] call vts_loadconfig_GetConfigName];;
		_tempfactionlistname set [count _tempfactionlistname,gettext ((_factions select %1) >> ""DisplayName"")];
		};
		
    };
    ",_i];  
  };
  //hint format["%1",(configName(_factions select 4))];
};


["Object"] call vts_loadconfig_CleanArray;

//*****************************
//Deleting existing units arrays
//*****************************



//*****************************
//Creating units arrays (ouch)
//*****************************
_loadvehicles=[] spawn 
{
	_cfg=configFile >> "CfgVehicles";
	_n=(count _cfg)-1;

	for "_i" from 0 to _n do
	{
	  //Working class
	  _class=_cfg select _i;
	  
	  
	  if (isclass(_class)) then 
	  {
		//*******************************
		//*** Special object unscoped ***
		//*******************************
		
		//Sound object
		/*
		if (gettext(_class>>"vehicleclass")=="Sounds") then
		{
		  GlobalSoundList=GlobalSoundList+[[configName(_class),configName(_class)]];   
		};    
		
		//********************************
		*/
		 
		//Veryfing scope (wich determine if it can be viewed in the editor
		_scope=getnumber (_class >> "scope");
		
		if (typename _scope != typename 0) then
		{
			_scope = call compile _scope;
			
		};
		
		//Working on class available in the editor scope=2;
		if (!(isnil "_scope") and (_scope>1) ) then
		{
		  
		  
		  //Taking the classname
		  _classname=configName(_class);
		  //Taking Class type
		  _classtype=gettext (_class>>"vehicleclass");
		  //*******************
		  
		  //Working with man
		  if (_classname iskindof "Man") then
		  {
			_faction=gettext (_class>>"faction");
			if (!(isnil "_faction") && _faction!="") then 
			{
			  _faction=[_faction] call vts_loadconfig_SpareSpace;
			  [_faction,"Man",_classname,false,_class] call vts_loadconfig_CreateFactionArray;
			  ShopManList set [count ShopManList,"'CfgVehicles'>>'"+_classname+"'"];            
			};
		  };
		  
		  //Working with modules
		  if (_classtype=="Modules") then
		  {
			   _faction="Object";
			  [_faction,"Module",_classname,true,_class] call vts_loadconfig_CreateFactionArray;   			
		  };
		  
		  
		  //Working with Land vehicles
		  if ((_classname iskindof "LandVehicle") and !(_classname iskindof "StaticWeapon")) then
		  {
			_faction=gettext(_class>>"faction");
			if (!(isnil "_faction") && _faction!="") then 
			{
			  _faction=[_faction] call vts_loadconfig_SpareSpace;
			  [_faction,"Land",_classname,false,_class] call vts_loadconfig_CreateFactionArray;
			  [_faction,"Empty",_classname,false,_class] call vts_loadconfig_CreateFactionArray;    
			  ShopLandList set [count ShopLandList,"'CfgVehicles'>>'"+_classname+"'"];      
			};
		  };
		  
		  //Working with air vehicles
		  if (_classname iskindof "Air") then
		  {
			_faction=gettext(_class>>"faction");
			if (!(isnil "_faction") && _faction!="") then 
			{
			  _faction=[_faction] call vts_loadconfig_SpareSpace;
			  [_faction,"Air",_classname,false,_class] call vts_loadconfig_CreateFactionArray;
			  [_faction,"Empty",_classname,false,_class] call vts_loadconfig_CreateFactionArray;    
			  ShopAirList set [count ShopAirList,"'CfgVehicles'>>'"+_classname+"'"];   
			};
			
		  };  
	  
		  if (_classname iskindof "Ship") then
		  {
			_faction=gettext(_class>>"faction");
			if (!(isnil "_faction") && _faction!="") then 
			{
			  _faction=[_faction] call vts_loadconfig_SpareSpace;
			  [_faction,"Ship",_classname,false,_class] call vts_loadconfig_CreateFactionArray;
			  [_faction,"Empty",_classname,false,_class] call vts_loadconfig_CreateFactionArray;
			  //Only items with pictures are added to the shop
			  if (gettext(_class>>"picture")!="") then
			  {        
				ShopLandList set [count ShopLandList,"'CfgVehicles'>>'"+_classname+"'"];
			  };   
			};
			
		  };  
		
		  //Working with static vehicles
		  if (_classname iskindof "StaticWeapon") then
		  {
			_faction=gettext(_class>>"faction");
			if (!(isnil "_faction") && _faction!="") then 
			{
			  _faction=[_faction] call vts_loadconfig_SpareSpace;
			  [_faction,"Static",_classname,false,_class] call vts_loadconfig_CreateFactionArray;
			  [_faction,"Empty",_classname,false,_class] call vts_loadconfig_CreateFactionArray;
			  
			  //Only disassemblable Static are listed in the shop
			  if (isclass (_class >> "assembleInfo")) then
			  {    
				ShopStaticList set [count ShopStaticList,"'CfgVehicles'>>'"+_classname+"'"];
			  };   
			};
			
		  };  
		  
		  //********* SPECIFIC OBJECTS ***********
		  
			
		  //Ammobox doesn't have faction value.
		   if ((_classname iskindof "ReammoBox") or (_classname iskindof "ReammoBox_F") or (_classtype=="Ammo") or (_classtype=="ACE_Ammunition") or (_classtype=="ACE_Ammunition_Rope")  or (_classtype=="ACE_Ammunition_CSW")  or (_classtype=="ACE_AmmunitionTransportCSW") or (_classtype=="ACE_AmmunitionTransportUS ") or (_classtype=="ACE_AmmunitionTransportRU") or (_classtype=="ACE_Ammunition_Ruck")) then
		  {        
			 if (gettext (_class >> "vehicleclass")!="BackPacks") then
			 {
			  _faction="Object";
			  [_faction,"Logistic",_classname,true,_class] call vts_loadconfig_CreateFactionArray;    
			 };
		   
		  };
			  
		  
		  //Camp_Fire, on request
		  if (_classname iskindof "Land_Fire") then
		  {
			  _faction="Object";
			  [_faction,"Object",_classname,true,_class] call vts_loadconfig_CreateFactionArray;
			 
		  };   
		  
	 
		  //Other editor objects
		  if (_classtype=="Small_items" or _classtype=="Wrecks" or _classtype=="Wreck" or _classtype=="IEDs" or _classtype=="Dead_bodies" or _classtype=="Flag" or _classtype=="Shelters" or _classtype=="Cargo" or _classtype=="Container" or _classtype=="Helpers" or _classtype=="Garbage" or _classtype=="Lamps" or _classtype=="Communication" or _classtype=="Fortifications" or _classtype=="Furniture" or _classtype=="Military" or _classtype=="Signs" or _classtype=="Training" or _classtype=="Market") then
		  {
			   _faction="Object";
			  [_faction,"Object",_classname,true,_class] call vts_loadconfig_CreateFactionArray;    
			  
		  };  
		  
		  //Target   
		  if (_classname iskindof "TargetBase" ) then
		  {
			   _faction="Object";
			  [_faction,"Object",_classname,true,_class] call vts_loadconfig_CreateFactionArray;    
			  
		  };  
	 
		  //End of Config work  
		};
		
		

		
		//Working on class not available in the editor but working, mainly building, so scope=1 or above;
		if (!(isnil "_scope") and (_scope>0) ) then
		{
		  
		  
		  //Taking the classname
		  _classname=configName(_class);
		  //Taking Class type
		  _classtype=gettext(_class>>"vehicleclass");
		  //*******************
		  //Buildings  checking they a model referenced to avoid  crash
		  if (((_classname iskindof "Building") or  (_classname iskindof "Fortress") or (_classname iskindof "Thing")) && ((getText ( _class >> "model"))!="")) then
		  {
			   _faction="Object";
			  [_faction,"Building",_classname,true,_class] call vts_loadconfig_CreateFactionArray;    
			  
		  };
		  
		  //Working with animal
		  
		  if (_classname iskindof "Animal") then
		  {
			_faction=gettext (_class>>"faction");
			if (!(isnil "_faction") && _faction!="") then 
			{
			  //_faction=[_faction] call vts_loadconfig_SpareSpace;
			  _faction="Object";
			  [_faction,"Animal",_classname,true,_class] call vts_loadconfig_CreateFactionArray;
			  
			};
		  };		  
		  
		//End of Config work        		  
		}; 
		//End of Config Class check
	  };
	  //End of Config loop
	};
};

//**** Working with Groups *********
_loadgroups=[_tempfactionlistclassname,_tempfactionlistname] spawn
{
	_tempfactionlistclassname=_this select 0;
	_tempfactionlistname=_this select 1;
	_cfg=(configFile >> "CfgGroups");
	_n=(count _cfg)-1;
	for "_i" from 0 to _n do
	{
	  //Group Side class
	  _class=_cfg select _i;
	  
	  
	  _cfg2=(configFile >> "CfgGroups" >> configName(_class));
	  _n2=(count _cfg2)-1;
	  if (_n2<0) then {_n2=0;};
	  //hint format["%1",_i];
	  sleep 1;
	  for "_i2" from 0 to _n2 do
	  {	
		//Group Faction class
		_class2=_cfg2 select _i2;
		
		 
		_cfg3=(configFile >> "CfgGroups" >> configName(_class) >> configName(_class2));
		_n3=(count _cfg3)-1;
		if (_n3<0) then {_n3=0;};
		for "_i3" from 0 to _n3 do
		{
			//Group Category class
		  _class3=_cfg3 select _i3;
		  
		  
		  _cfg4=(configFile >> "CfgGroups" >> configName(_class) >> configName(_class2) >> configName(_class3));
		  _n4=(count _cfg4)-1;
		  if (_n4<0) then {_n4=0;};
		  for "_i4" from 0 to _n4 do
		  {
			//Group class
			_class4=_cfg4 select _i4;
			if (isclass(_class4)) then
			{ 
			   //Taking the classname
				_classname=configName(_class4);
				//*******************
		
				//Working with Group
		
				_faction=gettext(_class4>>"faction");
				//Check if the faction is wrong or not referenced in the group class... (Using cross referencing based on name and class)
				if (_faction=="") then
				{
					_groupfactiondisplayname=gettext(_class2 >> "Name");
					_findindex=_tempfactionlistname find _groupfactiondisplayname;
					if (_findindex>-1) then 
					{
						_faction=_tempfactionlistclassname select _findindex;
					};
				};
				
				if (!(isnil "_faction") && _faction!="") then 
				{
				  _faction=[_faction] call vts_loadconfig_SpareSpace;
				  [_faction,"Group",_classname,false,_cfg4] call vts_loadconfig_CreateFactionArray;
				  [_faction,"GroupConfig",(configFile >> "CfgGroups" >> configName(_class) >> configName(_class2) >> configName(_class3) >> configName(_class4) ),false,_cfg4] call vts_loadconfig_CreateFactionArray; 
				  
				};
			};
		  
		  };
		  
		};
		
	  };
		
	};
};


//Parsing object composition.
_cfg=configFile >> "CfgObjectCompositions";
_n=(count _cfg)-1;

for "_i" from 0 to _n do
{
  //Working class
  _class=_cfg select _i;
  if (isclass(_class)) then 
  {  
    //Gettin class name
    _classname=configName(_class);
    
    //Checking this class as a objectscript and so is a composition class
    _objscript=gettext(_class>>"objectScript");
    if (!(isnil "_objscript") && _objscript!="") then
    {
      _faction="Object";    
     [_faction,"Composition",_classname,true,_class] call vts_loadconfig_CreateFactionArray;
     [_faction,"CompositionScript",_objscript,true,_class] call vts_loadconfig_CreateFactionArray;
    };      
  };
};



// Creating gear list, with glasses first
ShopGearList=[];
_count =  count (configFile >> "CfgGlasses");
for "_x" from 0 to (_count-1) do
{
	_class=((configFile >> "CfgGlasses") select _x);
	if (isClass _class) then
	{
		_classname=configName _class;
		if (_classname!="None") then
		{
			 _scope=getnumber(_class>>"scope");
			if (_scope> 1) then   
			{
				_pic=gettext(_class>>"picture");
				if (!(isnil "_pic") && _pic!="") then 
				{
					ShopGearList set [count ShopGearList,"'CfgGlasses'>>'"+_classname+"'"]; 
				};
			}
		};
	};
};


//Loading Weapons  and dispatch them either in gear or weapon list (wich is used for weapon and items)
_loadweapons=[] spawn 
{
	vts_NVGogglesList=[];
	ShopWeaponList=[];
	ShopWeaponItemList=[];
	_cfg=(configFile >> "CfgWeapons");
	_n=(count _cfg)-1;
	//player sidechat format["%1",_n];
	["Weapons"] call vts_loadconfig_ShowProgress;
	for "_i" from 0 to _n do
	{
	  //Working class
	  _class=_cfg select _i;
	  //player sidechat format["%1",configName(_class)];
	  if (isclass(_class)) then 
	  {  
		//Gettin class name
		_classname=configName(_class);
		
		//Checking this class as a objectscript and so is a composition class
		_scope=getnumber(_class>>"scope");
		
		if (typename _scope != typename 0) then
		{
			_scope = call compile _scope;
			
		};    
		_pic=gettext(_class>>"picture");
		_dname=gettext(_class>>"displayname");
		_type=getnumber (_class>>"type");
		
		//Filtering out duplicate acre radio sigh..
		if (_scope>0) then
		{
			if (gettext(_class>>"simulation")=="ItemRadio" or getnumber(_class>>"ACE_is_radio")==1) then
			{
				_weaponname=gettext (_class>>"DisplayName");
				if (isnil "vts_itemradios") then {vts_itemradios=[];};
				if (_weaponname in vts_itemradios) then 
				{
					_scope=0;
				}
				else
				{
					vts_itemradios set [count vts_itemradios,_weaponname];
				};
			};
		};
		
		if (!(isnil "_scope") and (_scope>1) and !(isnil "_pic") and !(_pic=="") and !(_dname=="")) then
		{
			_itemtype=getnumber(_class>>"ItemInfo">>"type");
			//Filter gears from equipment
			switch (true) do
			{
			 case ((_itemtype==801) or (_itemtype==701) or (_itemtype==605)) :  {ShopGearList set [count ShopGearList,"'CfgWeapons'>>'"+_classname+"'"];};
			 case ((_type==131072) && ((_itemtype==101) or (_itemtype==201) or (_itemtype==301))) :  {ShopWeaponItemList set [count ShopWeaponItemList,"'CfgWeapons'>>'"+_classname+"'"];};
			 default 
				{
					//Check if we display or not weapons with default attachement on
					if !((pa_shopshowonlynakedweapon==1) && ((count (_class >> "LinkedItems"))>0)) then
					{
							ShopWeaponList set [count ShopWeaponList,"'CfgWeapons'>>'"+_classname+"'"];
					};			
				};
			};

			if (gettext (_class >> "Simulation")=="NVGoggles") then
			{
				vts_NVGogglesList set [count vts_NVGogglesList,_classname];
			};
		};

	  };
	};
};

//Loading backpacks
_loadbackpacks=[] spawn
{
	ShopBackPackList=[];
	_cfg=(configFile >> "CfgVehicles");
	_n=(count _cfg)-1;
	//player sidechat format["%1",_n];
	["BackPacks"] call vts_loadconfig_ShowProgress;
	for "_i" from 0 to _n do
	{
	  //Working class
	  _class=_cfg select _i;
	  //player sidechat format["%1",configName(_class)];
	  if (isclass(_class)) then 
	  {  
		//Gettin class name
		_classname=configName(_class);
		
		//Checking this class as a objectscript and so is a composition class
		_scope=getnumber(_class>>"scope");
		
		if (typename _scope != typename 0) then
		{
			_scope = call compile _scope;
			
		};    
		
		_pic=gettext(_class>>"picture");
		if (!(isnil "_scope") and (_scope>1) and !(isnil "_pic") and !(_pic=="") and (gettext (_class >> "vehicleclass")=="BackPacks")) then
		{        
		  ShopBackPackList set [count ShopBackPackList,"'CfgVehicles'>>'"+_classname+"'"];
		};

	  };
	};
};

//Loading Magazines
_loadmagazines=[] spawn
{
	ShopMagazineList=[];
	ShopArtyAmmoList=[];
	_cfg=(configFile >> "CfgMagazines");
	_n=(count _cfg)-1;
	//player sidechat format["%1",_n];
	["Magazines"] call vts_loadconfig_ShowProgress;
	for "_i" from 0 to _n do
	{
	  //Working class
	  _class=_cfg select _i;
	  //player sidechat format["%1",configName(_class)];
	  if (isclass(_class)) then 
	  {  
		//Gettin class name
		_classname=configName(_class);
		
		//if (_classname=="16Rnd_9x21_Mag") then {player sidechat _classname;};
		
		//Checking this class as a objectscript and so is a composition class
		_scope=getnumber(_class>>"scope");
		
		//if (_classname=="16Rnd_9x21_Mag") then {player sidechat (str _scope+"");};
		
		if (typename _scope != typename 0) then
		{
			_scope = call compile _scope;
			
		};    
		
		_pic=gettext(_class>>"picture");
		
		if (!(isnil "_scope") and (_scope>1) and !(isnil "_pic") and !(_pic=="")) then
		{        
		  ShopMagazineList set [count ShopMagazineList,"'CfgMagazines'>>'"+_classname+"'"];
		  
		};
		
		//Filling Artillery ammo list if Magazine is for Arty
		_arty=gettext(_class>>"arty_ballistics");
		if ((_scope>1) and (_arty!="")) then
		{        
		  //ShopArtyAmmoList set [count ShopArtyAmmoList,"""CfgAmmo"">>"""+_classname+""""];
		  ShopArtyAmmoList set [count ShopArtyAmmoList,[gettext(_class>>"displayname"),gettext(_class>>"ammo")]];
		};    
	  };
	};
	//Check empty
	if (count ShopArtyAmmoList<1) then {ShopArtyAmmoList=["None yet in"];};
};

//Initialise the spawnable ammunition (Bomb, smoke etc...)
_loadammos=[] spawn
{
	["Spawnable ammunition list"] call vts_loadconfig_ShowProgress;
	SpawnableAmmoList=[];
	_ammo=(configfile >> "CfgAmmo");
	_num=(count _ammo)-1;
	for "_i" from 0 to _num do
	{
		_class=_ammo select _i;
		if (isclass _class) then
		{
			_parents=[_class,true] call bis_fnc_returnparents;
			if (("MissileBase" in _parents) or ("Grenade" in _parents) or ("BombCore" in _parents) or ("RocketCore" in _parents) or ("GrenadeCore" in _parents) or ("TimeBombCore" in _parents)) then
			{
				if (gettext (_class >> "model")!="") then
				{
					SpawnableAmmoList set [count SpawnableAmmoList,[configname _class,configname _class]];
				};
			};
			
		};
	};
};
//player sidechat format["%1",SpawnableAmmoList];

/*
//Initialise player default respawn weapon array, the one with the unit class begin (which will be unlocked at the shop)
ShopInitEquipementAvailable=[];
//First we fill an array with all the equipment player is carring at the launch
_players=[];
{_players set [count _players,_x];} forEach playableUnits;
//Then we take info on all weapons & magazine to put them one time in the equipment array
_equipement=[];
{
	_equipement=_equipement+(weapons _x);
	_equipement=_equipement+(items _x);	
} foreach _players;

//Then we remove the duplicate
_uniqueitems=[];
{
	if !(_x in _uniqueitems) then {_uniqueitems set [count _uniqueitems,_x];};
} foreach _equipement;
//We finish by checkin if they are weapon or magazine and adding them to the final array; (yeah i love foreach)

{
	_cfgm=nil;
	_cfgw=nil;
	if (isclass (configfile >> "CfgMagazines" >> _x)) then 
	{
		_cfgm="""CfgMagazines"">>"""+_x+"""";
	};
	if (isclass (configfile >> "CfgWeapons" >> _x)) then 
	{
		_cfgw="""CfgWeapons"">>"""+_x+"""";
	};
	if !(isnil "_cfgm") then { if !(_cfgm in ShopInitEquipementAvailable) then {ShopInitEquipementAvailable set [count ShopInitEquipementAvailable,_cfgm];};};
	if !(isnil "_cfgw") then { if !(_cfgw in ShopInitEquipementAvailable) then {ShopInitEquipementAvailable set [count ShopInitEquipementAvailable,_cfgw];};};
	
} foreach _uniqueitems;
*/

/*
//Loading Artilley ammo
ShopArtyAmmoList=[];
_cfg=(configFile >> "CfgAmmo");
_n=(count _cfg)-1;
//player sidechat format["%1",_n];
["Artillery Ammunitions"] call vts_loadconfig_ShowProgress;
for "_i" from 0 to _n do
{
  //Working class
  _class=_cfg select _i;
  //player sidechat format["%1",configName(_class)];
  if (isclass(_class)) then 
  {  
    //Gettin class name
    _classname=configName(_class);
    
    //Checking if the ammo is some kind of artillery and as FX
    
    _arty=gettext (_class>>"arty_trailfx");
 
    _effect=gettext(_class>>"explosioneffects");
    if (isnil "_effect") then {_effect="";};
    
    _model=gettext(_class>>"model");
    if (isnil "_model") then {_model="";};
    
    if (!(isnil "_arty") and (_model!="") and (_effect!="")) then
    {        
      //ShopArtyAmmoList set [count ShopArtyAmmoList,"""CfgAmmo"">>"""+_classname+""""];
      ShopArtyAmmoList set [count ShopArtyAmmoList,_classname,_classname];
    };
  };
};
*/
//hintc format["%1",ShopArtyAmmoList];

//Loading musics 
GlobalMusicList=[];
_cfg=configFile >> "CfgMusic";
_n=(count _cfg)-1;
["Musics"] call vts_loadconfig_ShowProgress;
for "_i" from 0 to _n do
{
  //Working class
  _class=_cfg select _i;
  if (isclass(_class)) then 
  {  
    //Gettin class name
    _classname=configName(_class);
    
    //Checking this class as a objectscript and so is a composition class
    _name=gettext(_class>>"name");
    if (!(isnil "_name") && _name!="") then
    {
      _loc=[_name,1] call KRON_StrLeft;
      if (_loc=="$") then 
      {
        _namecount=[_name] call KRON_StrLen;
        _name=localize([_name,(_namecount-1)] call KRON_StrRight);
      };  
    }
    else
    {
		_name=_classname;
    }; 
    GlobalMusicList=GlobalMusicList+[[_name,_classname]];     
  };
};
_cfg=missionconfigFile >> "CfgMusic";
_n=(count _cfg)-1;
for "_i" from 0 to _n do
{
  //Working class
  _class=_cfg select _i;
  if (isclass(_class)) then 
  {  
    //Gettin class name
    _classname=configName(_class);
    
    //Checking this class as a objectscript and so is a composition class
    _name=gettext(_class>>"name");
    if (!(isnil "_name") && _name!="") then
    {
      _loc=[_name,1] call KRON_StrLeft;
      if (_loc=="$") then 
      {
        _namecount=[_name] call KRON_StrLen;
        _name=localize([_name,(_namecount-1)] call KRON_StrRight);
      };  
    }
    else
    {
		_name=_classname;
    }; 
    GlobalMusicList=GlobalMusicList+[[_name,_classname]];     
  };
};

//Loading Sounds 
GlobalSoundList=[];
_cfg=(configFile >> "CfgSFX");
_n=(count _cfg)-1;
//player sidechat format["%1",_n];
["Sounds"] call vts_loadconfig_ShowProgress;
for "_i" from 0 to _n do
{
  //Working class
  _class=_cfg select _i;
  //player sidechat format["%1",configName(_class)];
  if (isclass(_class)) then 
  {  
    //Gettin class name
    _classname=configName(_class);
    
    //Checking this class as a objectscript and so is a composition class
    _name=gettext (_class>>"name");
    
    if (!(isnil "_name") && _name!="") then
    {
      _loc=[_name,1] call KRON_StrLeft;
      if (_loc=="$") then 
      {
        _namecount=[_name] call KRON_StrLen;
        _name=localize([_name,(_namecount-1)] call KRON_StrRight);
      };  
    }
    else
    {
    _name=_classname;
    };
    if (_name=="") then {_name=_classname;};
    
    GlobalSoundList=GlobalSoundList+[[_name,_classname]];     
  };
};


waituntil {sleep 0.1;scriptdone _loadgroups && scriptdone _loadweapons && scriptdone _loadbackpacks && scriptDone _loadvehicles && scriptDone _loadmagazines && scriptDone _loadammos};
systemchat "VTS : Data loaded";

//Detecting if Combined Arms is installed, if not remove the A2 factions from side
//Removing factions that don't have units (bad config, override or anything that doesn't need to be in the menu)
["Cleaning factions"] call vts_loadconfig_ShowProgress;

_cleanside=
{
_side=_this select 0;
_nf=(count _side)-1;
_i=0;
_nfremove=[];
for "_i" from 0 to _nf do
{
  _nkeep=false;
  _nfaction=_side select _i;
  {call compile format["if !(isnil ""%2_%1"") then {_nkeep=true;};",_x,_nfaction];} foreach globalcamp_types;
  if !(_nkeep) then {_nfremove=_nfremove+[_nfaction];};
};
_side=_side-_nfremove;
_side
};

west_factions=[west_factions] call _cleanside;
east_factions=[east_factions] call _cleanside;
resistance_factions=[resistance_factions] call _cleanside;
civilian_factions=[civilian_factions] call _cleanside;



//Here we add specific stuff to each faction
all_factions=west_factions+east_factions+resistance_factions+civilian_factions;

_n=(count all_factions)-1;
_i=0;
private "_script";
for "_i" from 0 to _n do
{
  _faction=all_factions select _i;
  //call compile format["_script = [] execvm ""mods\config\factions\%1.sqf"";",_faction];
  
  if !(_faction in object_factions) then {call compile format["%1_Base=[""Checkpoint"",""Outpost""];",_faction]};
  //waitUntil {scriptDone _script};
}; 

//Adding object faction for the broadcasting
all_factions=west_factions+east_factions+resistance_factions+civilian_factions+object_factions;



//***************************************************************************
//Broadcasting array to everyone (so the script can be run on the server side)
//***************************************************************************
{
  _n=(count globalcamp_types)-1;
  for "_i" from 0 to _n do
  {
    call compile format["
    if !(isnil ""%1_%2"") then 
    {
      publicvariable ""%1_%2"";
      if (""%2""==""Group"") then { publicvariable ""%1_GroupConfig""};
      if (""%2""==""Composition"") then { publicvariable ""%1_CompositionScript""};
    };
    ",_x,(globalcamp_types select _i)];  
  };
} foreach all_factions;

publicvariable "west_factions";
publicvariable "east_factions";
publicvariable "resistance_factions";
publicvariable "civilian_factions";
publicvariable "object_factions";
publicvariable "GlobalMusicList";
publicvariable "ShopLandList";
publicvariable "ShopAirList";
publicvariable "ShopStaticList";
publicvariable "ShopManList";
publicvariable "ShopWeaponList";
publicvariable "ShopWeaponItemList";
publicvariable "ShopMagazineList";
publicvariable "ShopArtyAmmoList";
publicvariable "ShopBackPackList";
publicvariable "ShopGearList";
publicvariable "ShopInitEquipementAvailable";
publicvariable "SpawnableAmmoList";
publicvariable "GlobalSoundList";
publicvariable "vts_NVGogglesList";	
//Used to turn on some system
vtsdataloaded=true;
publicvariable "vtsdataloaded";

//********************************************
//Finishing log
//********************************************
_hint="Resources Loaded.";
hint _hint;
vts_mphint=_hint;
publicvariable "vts_mphint";
//[] call vts_perfstop;