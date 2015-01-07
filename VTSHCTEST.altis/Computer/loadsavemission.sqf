//Hide arma 3 copy past button, since the function has been disabled
if (vtsarmaversion>=3) then 
{
	ctrlShow [20504,false];
	ctrlShow [20505,false];
};

//LoadSave panel
if (isnil "vts_loadsavefilter") then {vts_loadsavefilter="None";};

if (count _this>0) then
{
	switch (true) do
	{
		case (vts_loadsavefilter=="None"):{vts_loadsavefilter="Shop";};
		case (vts_loadsavefilter=="Shop"):{vts_loadsavefilter="Spawn";};
		case (vts_loadsavefilter=="Spawn"):{vts_loadsavefilter="Building";};
		case (vts_loadsavefilter=="Building"):{vts_loadsavefilter="None";};
	};
};
ctrlsettext[20503,"Filter : "+vts_loadsavefilter];

_loadsavearray=0;
_text="[";

if (vts_loadsavefilter=="None" or vts_loadsavefilter=="Shop") then
{
	vts_shopsavelist_west="";
	vts_shopsavelist_east="";
	vts_shopsavelist_guer="";
	vts_shopsavelist_civ="";
	//Building Balance arrays
	_text=_text+format["[1,[%1,%2,%3,%4],[",vts_shopbalance_WEST,vts_shopbalance_EAST,vts_shopbalance_GUER,vts_shopbalance_CIV];
	_list1=[] spawn
	{
		for "_x" from 0 to ((count vts_shopunlocklist_west)-1) step 2 do
		{
		  if (_x>0) then {vts_shopsavelist_west=vts_shopsavelist_west+","};	  
		  _cfgtxt=(vts_shopunlocklist_west select _x);
		  vts_shopsavelist_west=vts_shopsavelist_west+""""+_cfgtxt+""","+str(vts_shopunlocklist_west select (_x+1));
		};
	};
	_list2=[] spawn
	{
		for "_x" from 0 to (count vts_shopunlocklist_east)-1 step 2 do
		{
		  if (_x>0) then {vts_shopsavelist_east=vts_shopsavelist_east+","};	  
		  _cfgtxt=(vts_shopunlocklist_east select _x);
		  vts_shopsavelist_east=vts_shopsavelist_east+""""+_cfgtxt+""","+str(vts_shopunlocklist_east select (_x+1));
		};
	};
	_list3=[] spawn
	{	
		for "_x" from 0 to (count vts_shopunlocklist_guer)-1 step 2 do
		{
		  if (_x>0) then {vts_shopsavelist_guer=vts_shopsavelist_guer+","};	  
		  _cfgtxt=(vts_shopunlocklist_guer select _x);
		  vts_shopsavelist_guer=vts_shopsavelist_guer+""""+_cfgtxt+""","+str(vts_shopunlocklist_guer select (_x+1));
		};
	};
	_list4=[] spawn
	{	
		for "_x" from 0 to (count vts_shopunlocklist_civ)-1 step 2 do
		{
		  if (_x>0) then {vts_shopsavelist_civ=vts_shopsavelist_civ+","};	  
		  _cfgtxt=(vts_shopunlocklist_civ select _x);
		  vts_shopsavelist_civ=vts_shopsavelist_civ+""""+_cfgtxt+""","+str(vts_shopunlocklist_civ select (_x+1));
		};	
	};
	waituntil {0.1;scriptdone _list1 && scriptdone _list2 && scriptdone _list3 && scriptdone _list4};
	_text=_text+vts_shopsavelist_west+"],["+vts_shopsavelist_east+"],["+vts_shopsavelist_guer+"],["+vts_shopsavelist_civ;
	_loadsavearray=_loadsavearray+1;
	_text=_text+"]]";
};

//Build a list of the valid mission preset index (which are still on the map)
_vtsmissionpresetindexlist=[];
_missionobject=allMissionObjects "all";
for "_i" from 0 to (count _missionobject)-1 do
{
	_currento=_missionobject select _i;
	_var=_currento getvariable ["vtsmissionpreset_i",-1];	
	if (_var>=0) then 
	{
		if !(_var in _vtsmissionpresetindexlist) then 
		{
			
			_vtsmissionpresetindexlist set [count _vtsmissionpresetindexlist,_var];
		};
		
	};
};

//Spawn arrays
_n=count _vtsmissionpresetindexlist;

//Building text from the array (format & str are limited to 2048 chars...)
for "_x" from 0 to (_n)-1 do
{
	
	_preset=[];
	
	call compile ("if !(isnil 'vtsmissionpreset_"+(str (_vtsmissionpresetindexlist select _x))+"') then
	{
		_preset=vtsmissionpreset_"+(str (_vtsmissionpresetindexlist select _x))+";	
	};");
	
	//call compile ("_preset=vtsmissionpreset_"+(str (_vtsmissionpresetindexlist select _x)));
	if (count _preset>0) then
	{
		_datatype=_preset select 0;
		if ((_datatype==0 && (vts_loadsavefilter=="Spawn" or vts_loadsavefilter=="None")) or (_datatype==2 && (vts_loadsavefilter=="Building" or vts_loadsavefilter=="None"))) then
		{
			if (_loadsavearray>0) then {_text=_text+",";};
			_text=_text+(str _preset);
			_loadsavearray=_loadsavearray+1;
		};
	};
	//_text=_text+(str _x);
};


_text=_text+"]";
ctrlsettext[20301,_text];

ctrlsettext[20302,"Here is the history of the current VTS activities, its include : Team Balance, Unlocked Items, 2D and 3D spawns. You can store it somewhere or load your own histories to build a mission from scratch. !!! Warning !!! This doesn't save post spawn modifications. If you want to update a group or an object, delete it (object or the complete group) and respawn it with the correct oreders or/and positions."];
