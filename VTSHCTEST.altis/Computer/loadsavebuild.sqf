if (vts_build_spawn) exitwith {hint "!!! Already Building !!!"};

hint "Building Mission ... Please do not touch the GM interface";

private ["_code"];

_text=ctrlText 20301;
call compile ("_code="+_text+";");
_typename=typeName _code;
//hint format["%1",_code];
if (isnil "_code")  exitWith { hint "!!! Error in mission code setup !!!"; };
if ((_typename!="ARRAY") or ((count _code)<1)) exitWith { hint "!!! Error in mission code setup !!!"; };

//Counting number of spawn in the code
_numspawn=count _code;

//hint format["%1",_numspawn];

//Storing current interface setup
_currentsetup=[true] call vts_storespawnsetup;


vts_build_spawn=true;
publicvariable "vts_build_spawn";

for "_xspawn" from 0 to (_numspawn-1) do
{
  
  _currentspawn=_code select _xspawn;
  //player sidechat format["%1",_currentspawn];
  _datatype=_currentspawn select 0;
  
  //Spawn 2D or 3D
  if (_datatype==0 or _datatype==2) then
  {
	  
	[_currentspawn] call vts_restorespawnsetup;
	//player sidechat format["%1",_currentspawn]; 
	//Clean spawning status
	vts_server_spawningdone=false;
	//Spawning
	[false] call vts_initiatespawn;
	//Wait until server say spawn is done
	waituntil {vts_server_spawningdone};
	vts_server_spawningdone=false;
    hintsilent "Building Mission ... Please do not touch the GM interface";
    //player globalchat "Building Mission ... Please do not touch the GM interface";
  };


  
  //Balance and weapons unlocks
  if (_datatype==1) then
  {
    //Balance for each side
    _teambalance=_currentspawn select 1;
    
    vts_shopbalance_WEST=_teambalance select 0;
    vts_shopbalance_EAST=_teambalance select 1;
    vts_shopbalance_GUER=_teambalance select 2;
    vts_shopbalance_CIV=_teambalance select 3;
    
    
    vts_shopunlocklist_WEST=_currentspawn select 2;
	vts_shopunlocklist_EAST=_currentspawn select 3;
	vts_shopunlocklist_GUER=_currentspawn select 4;
	vts_shopunlocklist_CIV=_currentspawn select 5;
    
    publicvariable "vts_shopbalance_WEST";
    publicvariable "vts_shopbalance_EAST";
    publicvariable "vts_shopbalance_GUER";
    publicvariable "vts_shopbalance_CIV";
    publicvariable "vts_shopunlocklist_WEST";
	publicvariable "vts_shopunlocklist_EAST";
	publicvariable "vts_shopunlocklist_GUER";
	publicvariable "vts_shopunlocklist_CIV";
  };
  
};

//Resynchronising the server with the GM interface
sleep 1.0;
[_currentsetup] call vts_restorespawnsetup;

//Build done
hint "Building Completed";

vts_build_spawn=false;
publicvariable "vts_build_spawn";
closeDialog 8002; 

