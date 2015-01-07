//Add variable eventhandler
vts_shopaddevent=
{
	private ["_side"];
	_side=_this select 0;
	call compile format["
		""vts_shopunlockmodifier_%1"" addpublicvariableeventhandler 
		{
			[vts_shopunlockmodifier_%1 select 0,vts_shopunlockmodifier_%1 select 1,true,vts_shopunlockmodifier_%1 select 2] call vts_shopitemsetcount;
			vts_shopunlockmodifier_%1=nil;
			if (!isnull (finddisplay 8004)) then 
			{
				[true] call vts_shoprefreshitemcountstate;
			};		
		};
		""vts_shopbalance_%1"" addpublicvariableeventhandler {[] call vts_shopdisplaybalance;};
	",_side];
	//Server side shop handling
	if (isserver) then
	{
		if (isnil "vts_shoplist") then
		{
			vts_shoplist=[];
		};
		if !(_side in vts_shoplist) then
		{
			vts_shoplist set [count vts_shoplist,_side];
			publicvariable "vts_shoplist";
		};
		
		if (vtsarmaversion>2) then
		{
			if (isnil "vts_shopserverloadout_initdone") then
			{
			for "_i" from 0 to 26 do
			{
				call compile format ["
				vts_shopserverloadout_%1=profileNamespace getVariable [""vts_shopserverloadout_%1"",nil];
				if !(isnil ""vts_shopserverloadout_%1"") then {publicVariable ""vts_shopserverloadout_%1"";};
				""vts_shopserverloadout_%1"" addpublicvariableeventhandler  
					{
						profileNamespace setVariable [""vts_shopserverloadout_%1"",vts_shopserverloadout_%1];
						saveProfileNamespace;
					};
				",_i];
			};
				vts_shopserverloadout_initdone=true;
			};
		};
	};
};

if (isnil "vts_shop_event") then 
{
	{
		[_x] call vts_shopaddevent;
	} foreach [west,east,resistance,civilian];
	vts_shop_event=true;
	
	if (isserver) then
	{
		"vts_shopjip" addPublicVariableEventHandler 
		{
			{
			//player sidechat "syncshop";
			call compile format["		
					if (isnil ""vts_shopunlocklist_%1"") then {vts_shopunlocklist_%1=[]};
					(owner vts_shopjip) publicVariableClient ""vts_shopunlocklist_%1"";
				",_x];
			} foreach vts_shoplist;
		};
	};
};


vts_shopsidenameandcolor=
{
	private ["_sidetxt","_sidecolor","_sidestring","_return"];
	_sidetxt="";
	_sidecolor=[];
	_sidestring="";
	if (typename vts_shopside=="SIDE") then
	{
		switch (true) do
		{
			case (vts_shopside==west):{_sidetxt="West";_sidecolor=[0.3,0.3,1.0, 1];_sidestring="west";};
			case (vts_shopside==east):{_sidetxt="East";_sidecolor=[0.9,0.3,0.3, 1];_sidestring="east";};
			case (vts_shopside==resistance):{_sidetxt="Resistance";_sidecolor=[0.3,0.8,0.3, 1];_sidestring="guer";};
			case (vts_shopside==civilian):{_sidetxt="Civilian";_sidecolor=[0.85,0.55,0.2, 1];_sidestring="civ";};
		};
	}
	else
	{
		_sidetxt=(vts_shopside);
		_sidecolor=[1,1,1,1];
		_sidestring=(vts_shopside);
	};
	_return=[_sidetxt,_sidecolor,_sidestring];
	_return;
};

//update filter
vts_shopsetfilter=
{
	private ["_txt"];
	//Update list with the new filter
	_txt="";
	if (vts_shop_filter=="") then 
	{
		_txt="Filter disabled";
	}
	else
	{
		_txt=format["Filtering shop items with : %1",vts_shop_filter];
	};
	playsound "computer";
	hint _txt;
    [_txt] call vts_shopdisplaymessage; 
	[vts_shopcurrentarray,vts_shopcurrentconfig,vts_shopcurrenttype] call vts_shopgeneratelist;  
};

//Get the price of a loadout (mean all it contain :x)
vts_shopreturnloadoutprice=
{
	private ["_loadout","_liitemprice","_liprice","_n"];
	_loadout=_this select 0;
	//hint format["%1",_loadout];
	//copytoclipboard format["%1",_loadout];
	_liitemprice=0;
	_liprice=0;
	_n=0;
	
	for "_a" from 0 to ((count _loadout)-1) do
	{
		_arrayitem=_loadout select _a;
		
		if (typename _arrayitem=="ARRAY") then
		{
			for "_i" from 0 to ((count _arrayitem)-1) do
			{
				if (typename (_arrayitem select _i)!="ARRAY") then
				{
					if ((_arrayitem select _i)!="") then 
					{
						//player sidechat format["%1",(_arrayitem select _i)];
						_liitemprice=["""null""",(_arrayitem select _i)] call vts_shopgetPrice;
						_liprice=_liprice+_liitemprice;
						_n=_n+1;
					};
				};
			};
		}
		else
		{
			if (_arrayitem!="") then 
			{
				_liitemprice=["""null""",_arrayitem] call vts_shopgetPrice;
				_liprice=_liprice+_liitemprice;
				_n=_n+1
				
			};
		};
		
	};
	
	//player sidechat format["object compté %1 pour %2",_n,_liprice];
	_liprice
	
};

//Fill the interface with detail about the selected loadout (weapons etc).
vts_shoploadoutinfo=
{
	private ["_txt","_loadoutindex","_loadoutdata","_persloadout","_numitem","_items","_itemstext","_itemname","_icons","_iconstext","_pretext"];
	_txt="";
	_pretext="";
	if (count _this>0) then {_pretext=_this select 0;};
	_loadoutindex=lbCurSel 133036;
	_loadoutdata=lbData [133036,_loadoutindex];
	_persloadout=nil;
	if (vts_shoploadouttype==0) then
	{
		_persloadout=profileNamespace getVariable ("vts_loadout_"+_loadoutdata);
		
	};
	if (vts_shoploadouttype==1) then
	{
		call compile format["vts_shoploadoutallyuser=%1;",_loadoutdata];
		if (isnull vts_shoploadoutallyuser) exitwith {[] spawn vts_shopdisplayloadouts;};
		if !(alive vts_shoploadoutallyuser) exitwith {[] spawn vts_shopdisplayloadouts;};
		_persloadout=[vts_shoploadoutallyuser] call vts_getloadout;
	};	
	if (vts_shoploadouttype==2) then
	{
		if !(isnil ("vts_shopserverloadout_"+_loadoutdata)) then 
		{
			call compile format ["
			_persloadout=vts_shopserverloadout_%1 select 1;
			",_loadoutdata];
		};	
	};	
	
	//Checking if the loadout is existing
	if (isnil "_persloadout") exitwith
	{	
	  _txt=format["There is no loadout data for the %1 !",lbText [133036,_loadoutindex]];
	  hint _txt;
	  [_txt] call vts_shopdisplaymessage;  
	};	
	//player sidechat format["%1",_persloadout];
	//Checking the array, main weapons are in sub
	_numitem=0;
	_itemname=[];
	_items=[];
	_icons=[];
	{
		_pict="";
		if (typename _x=="STRING") then
		{
			_class=(configFile >> "CfgWeapons" >> _x);
			if (isclass _class) then
			{
				if !((configname _class) in _itemname) then
				{
					_pict=Gettext (_class >> "picture");
					if (_pict!="") then {_pict="<img size='2.5' image='"+_pict+"'/>";};	
					_items set [count _items,(gettext (_class >> "displayname"))];
					_icons set [count _icons,_pict];
					_itemname set [count _itemname,(configname _class)];
				};
			};
			_class=(configFile >> "CfgVehicles" >> _x);
			if (isclass _class) then
			{
				if !((configname _class) in _itemname) then
				{
					_pict=Gettext (_class >> "picture");
					if (_pict!="") then {_pict="<img size='2.5' image='"+_pict+"'/>";};	
					_items set [count _items,(gettext (_class >> "displayname"))];
					_icons set [count _icons,_pict];
					_itemname set [count _itemname,(configname _class)];
				};
			};			
		};
		_numitem=_numitem+1;
	} foreach _persloadout;
	
	_iconstext="";
	{
		_iconstext=_iconstext+_x;
	} foreach _icons;	
	_itemstext="";
	{
		_itemstext=_itemstext+" "+_x+",";
	} foreach _items;
	
	if ((count _items)<1) then
	{
		_txt=format["%1 is empty !",lbText [133036,_loadoutindex]];
	}
	else
	{
		_txt=format["%3<br/>%1 is packed with :%2 and other things",lbText [133036,_loadoutindex],_itemstext,_iconstext];
		if (_pretext!="") then 
		{
			_txt=_pretext+_txt;
		};		
	};
    //hint parsetext _txt;
    [_txt] call vts_shopdisplaymessage;  
	
};

//Check if loadout items are available in the shop if no, delete them
vts_checkloadoutconformity=
{
	disableSerialization;
	private ["_unit","_getcfgstring","_totalchange","_updatetotalchangearray","_getitemcount","_failitem","_checkinv","_changeclass","_allitemlist"];
	_unit=_this select 0;
	_changeclass=false;
	if (count _this>1) then
	{
		//No uniform remove if the player is changing class instead of loading loadout
		_changeclass=_this select 1;
	};
	if (_changeclass) then
	{
		_scripdone={};
		vtsscriptsetloadout=[] spawn _scripdone;
		if (isnil "vts_shopside") then {vts_shopside=side (group player);};
	};	
	_getcfgstring=
	{
		_classname=_this select 0;
		_classcfg="";
		if (isclass (configfile >> "CfgVehicles" >> _classname)) then {_classcfg="'CfgVehicles'>>'"+_classname+"'";};
		if (isclass (configfile >> "CfgMagazines" >> _classname)) then {_classcfg="'CfgMagazines'>>'"+_classname+"'";};
		if (isclass (configfile >> "CfgWeapons" >> _classname)) then {_classcfg="'CfgWeapons'>>'"+_classname+"'";};
		if (isclass (configfile >> "CfgGlasses" >> _classname)) then {_classcfg="'CfgGlasses'>>'"+_classname+"'";};
		_classcfg;
	};
	//Update total item count change in on array;
	_totalchange=[];	
	_updatetotalchangearray=
	{
		_string=_this select 0;
		_count=_this select 1;
		_indexfind=-1;
		for "_c" from 0 to (count _totalchange)-1 do 
		{		
			_currentarray=_totalchange select _c;
			if (_currentarray select 0==_string) then
			{	
				_indexfind=_c;
			};
		};
		if (_indexfind<0) then 
		{
			_totalchange=_totalchange+[_this];
		}
		else
		{
			_totalchange set [_indexfind,_this];
		};
	};
	
	_getitemcount=
	{
		_count=0;
		_string=_this select 0;
		_indexfind=-1;
		for "_c" from 0 to (count _totalchange)-1 do 
		{
			
			_currentarray=_totalchange select _c;
			if (_currentarray select 0==_string) then
			{	
				_indexfind=_c;
			};
		};
		if (_indexfind<0) then 
		{
			_count=[_string] call vts_shopitemgetitemcount;
		}
		else
		{
			_count=(_totalchange select _indexfind) select 1;
		};
		
		_count;
	};
	
	_allitemlist=(ShopWeaponList+ShopWeaponItemList+ShopMagazineList+ShopBackPackList+ShopGearList);
	
	//Check item and delete or update shop
	_failitem=0;
	_checkinv=
	{
		private ["_listitem","_noammount","_getlist","_checkparentclass","_testcfg","_itemcount","_cfgstring"];
		_getlist=_this select 0;
		_noammount=_this select 1;
		_checkparentclass=false;
		if (count _this>2) then {_checkparentclass=_this select 2;};
		_listitem=[];
		call compile _getlist;
		for "_i" from 0 to (count _listitem)-1 do 
		{
			_item=_listitem select _i;
			_cfgstring=[_item] call _getcfgstring;
			//systemchat _cfgstring;
			if (_cfgstring!="") then
			{
				if !(_cfgstring in _allitemlist) then
				{
					call compile ("_testcfg=[configname (inheritsFrom (configfile >> "+_cfgstring+"))] call _getcfgstring;");
					//systemchat _cfgstring;
					if ((_testcfg in _allitemlist) && (_checkparentclass)) then
					{
						_cfgstring=_testcfg;
						_itemcount=[_cfgstring] call _getitemcount;	
						//systemchat _cfgstring;
					}
					else 
					{
						_itemcount=0;
					};
				}
				else
				{	
					_itemcount=[_cfgstring] call _getitemcount;	
				};
				
				_itemcount=_itemcount-1;
				
				if (_itemcount<0 ) then
				{
					//_unit sidechat _item;
					call compile _noammount;
					_failitem=_failitem+1;
				}
				else
				{
					[_cfgstring,_itemcount] call _updatetotalchangearray;
				};
			};	
		};
	};
	
	if (vtsarmaversion<3) then
	{
		["_listitem=magazines _unit;","_unit removemagazine _item;"] call _checkinv;
		["_listitem=weapons _unit;","_unit removeweapon _item;"] call _checkinv;
	}
	else
	{
		waituntil {(scriptdone vtsscriptsetloadout)};
		["_listitem=assignedItems _unit;","_unit unassignitem _item;_unit removeitem _item;"] call _checkinv;
		["_listitem=magazines _unit;","_unit removemagazine _item;"] call _checkinv;
		["_listitem=(items _unit)-(magazines _unit);","_unit removeitem _item;"] call _checkinv;
		["_listitem=primaryWeaponItems _unit;","_unit removePrimaryWeaponItem _item;"] call _checkinv;
		["_listitem=Weapons _unit;","_unit removeweapon _item;",true] call _checkinv;
		["_listitem=[vest _unit];","removevest _unit;"] call _checkinv;
		["_listitem=[backpack _unit];","removebackpack _unit;",true] call _checkinv;
		["_listitem=[headgear _unit];","removeheadgear _unit;"] call _checkinv;
	};
	if (_failitem>0) then
	{
		[format["%1 item(s) of your loadout were out of stock in the shop ! Check your gear to adapt it.",_failitem]] call vts_shopdisplaymessage; 
	};
	[_totalchange] call vts_shopitemsetcount;	
};

//Function to handle radio mod like ACRE or TFR (need to reset custom radio and set the initial one, to avoid player in conflict)
vts_shopradiomodcompatibility=
{
	private ["_player","_items","_assigneditems","_itype","_r","_cname","_supclass","_icount"];
	_p=_this select 0;
	_pitems=items _p;
	_assigneditems=assignedItems _p;
	_itype="";
	_cname="";
	_icount=(count _pitems);
	for "_r" from 0 to _icount-1 do 
	{
		_cname=(_pitems select _r);
		_itype=gettext (configfile >> "CfgWeapons" >> _cname >> "Simulation");
		if (_itype=="ItemRadio") then 
		{
			_supclass=inheritsFrom (configfile >> "CfgWeapons" >> _cname);
			if (getnumber (_supclass >> "Scope")>1) then
			{
				if (vtsarmaversion>2) then
				{	
					call compile "
					_p removeitem _cname;
					_p additem (configname _supclass);
					";
				};
			};
			
		};
	};
	_icount=(count _assigneditems);
	for "_r" from 0 to _icount-1 do 
	{
		_cname=(_assigneditems select _r);
		_itype=gettext (configfile >> "cfgweapons" >> _cname >> "Simulation");
		if (_itype=="ItemRadio") then 
		{
			_supclass=inheritsFrom (configfile >> "CfgWeapons" >> _cname);
			if (getnumber (_supclass >> "Scope")>1) then
			{
				_p removeweapon _cname;
				_p addweapon (configname _supclass);					
			};			
		};		
	};	
};


//Check if we can buy before loading the loadout
vts_shoploadoutload=
{
	disableSerialization;
	private ["_loadoutindex","_loadoutdata","_persloadout","_loadoutprice","_currentbalance","_txt","_import","_loadoutname"];
	_loadoutindex=lbCurSel 133036;
	_loadoutdata=lbData [133036,_loadoutindex];
	_persloadout=nil;
	_loadoutname=lbText [133036,_loadoutindex];
	
	_import=false;
	if (count _this>0) then 
	{
		_import=true;
		_persloadout=_this select 0;
		_loadoutname=_this select 1;
	};
	
	if !(_import) then
	{
		if (vts_shoploadouttype==0) then
		{
			_persloadout=profileNamespace getVariable ("vts_loadout_"+_loadoutdata);
			
		};
		if (vts_shoploadouttype==1) then
		{
			call compile format["vts_shoploadoutallyuser=%1;",_loadoutdata];
			if (isnull vts_shoploadoutallyuser) exitwith {[] spawn vts_shopdisplayloadouts;};
			if !(alive vts_shoploadoutallyuser) exitwith {[] spawn vts_shopdisplayloadouts;};
			_persloadout=[vts_shoploadoutallyuser] call vts_getloadout;		
		};
		if (vts_shoploadouttype==2) then
		{
			if !(isnil ("vts_shopserverloadout_"+_loadoutdata)) then 
			{
				call compile format ["_persloadout=vts_shopserverloadout_%1 select 1;",_loadoutdata];
			};
		};
		//Checking if the loadout is existing
		if (isnil "_persloadout") exitwith
		{
		  _txt=format["There is no loadout data for the %1 !",_loadoutname];
		  hint _txt;
		  [_txt] call vts_shopdisplaymessage;  
		};	
	};
	//Checking if the balance is right
	_loadoutprice=[_persloadout] call vts_shopreturnloadoutprice;
	_currentbalance=vts_shopbalance;
	if (((_currentbalance - _loadoutprice) <0) && !([player] call vts_getisGM)) exitwith 
	{
      _txt=format["You don't have enough money to gear yourself with the %1 !",_loadoutname];
      hint _txt;
      [_txt] call vts_shopdisplaymessage;      
	}; 
	_txt=format["You bought the loadout at %1 for %2 !",_loadoutname,_loadoutprice];
	
	//Applying the loadout on the player
	[player,_persloadout,true] call vts_setloadout;
	
	
	//Updating the balance if not game master
	if !([player] call vts_getisGM) then
	{
		//Check if loadout is conform to shop quantity (only if the loadout isnt set to be free in the mission params)
		if (pa_shopfreeloadouttypes!=-1) then
		{
			if ((pa_shopfreeloadouttypes!=vts_shoploadouttype) ) then 
			{
				[player] call vts_checkloadoutconformity;		
				_newbalance=_currentbalance-_loadoutprice;
				[vts_shopside,_newbalance] call vts_shopupdatebalance;
			}
			else
			{
				_txt=format["You bought the loadout at %1 for free !",_loadoutname,_loadoutprice];
			};
		} 
		else
		{
			_txt=format["You bought the loadout at %1 for free !",_loadoutname,_loadoutprice];
		};
	};
	
	//Make sure we reset radio on loadout to avoid conflict if ACRE or TFR radio mod are used
	[player] call vts_shopradiomodcompatibility;
	
	playsound "computer";
    
	if ([player] call vts_getisGM) then {_txt=_txt+" (for FREE as game master)";};
    hint _txt;
    [_txt] call vts_shopdisplaymessage;   
 
	//Refreshing player inv
	//Wrapping a sleep because the loadout script have sleep inside himself, refreshing now while be not correct until the loadout is finished equipping
	[] execvm "shop\shop_refreshplayerlist.sqf";
};

//Save the loadout in the profilenamespace (player profile so persistent over games)
vts_shoploadoutsave=
{
	disableSerialization;
	//Save loadout name on loadout save
	[] call vts_shopsetloadoutname;

	private ["_loadoutindex","_loadoutdata","_loadout","_loadoutprice","_txt","_refresh"];
	_loadoutindex=lbCurSel 133036;
	_loadoutdata=lbData [133036,_loadoutindex];
	_loadout=[player] call vts_getloadout;
	_refresh=true;
	
	if (vts_shoploadouttype==0) then
	{
	
		profileNamespace setVariable [("vts_loadout_"+_loadoutdata),_loadout];
		call compile "saveProfileNamespace;";
		_txt=format["You saved your current loadout on the %1 !",lbText [133036,_loadoutindex]];
	};
	if (vts_shoploadouttype==2) then
	{
		if (serverCommandAvailable "#reassign") then
		{	
			call compile format [
			"
				vts_shopserverloadout_%1 = [([_loadoutdata] call vts_shopgetloadoutname),_loadout];
				publicVariable ""vts_shopserverloadout_%1"";
				if (isserver) then 
				{
					profileNamespace setVariable [""vts_shopserverloadout_%1"",vts_shopserverloadout_%1];
					saveProfileNamespace;				
				};
			",_loadoutdata];

			_txt=format["You saved your current loadout on Server : %1 !",lbText [133036,_loadoutindex]];
			diag_log ("Loadout slot "+_loadoutdata+" saved by Player : "+(name player)+" id: "+(getPlayerUID player));
		}
		else
		{
				call compile format [
			"
				vts_shopserverloadout_%1 = [([_loadoutdata] call vts_shopgetloadoutname),_loadout];
				publicVariable ""vts_shopserverloadout_%1"";
				if (isserver) then 
				{
					profileNamespace setVariable [""vts_shopserverloadout_%1"",vts_shopserverloadout_%1];
					saveProfileNamespace;	
				};
			",_loadoutdata];
		};
	};
    hint _txt;
    [_txt] call vts_shopdisplaymessage;   
	playsound "computer";
	//Refresh player pers slot
	if (_refresh) then {["Loadout Saved : <br/>"] call vts_shoploadoutselect;};
};


//Get information of the selected laodout
vts_shoploadoutselect=
{
	private ["_price","_txt","_loadoutindexselect","_loadoutdataselect","_persloadout","_loadoutname","_pretext"];
	_price=0;
	_txt="";
	_loadoutname="";
	_pretext="";
	if (count _this>0) then {_pretext=_this select 0;};
	_loadoutindexselect=lbCurSel 133036;
	_loadoutdataselect=lbData [133036,_loadoutindexselect];
	//player sidechat format["%1",_loadoutdataselect];
	_persloadout=nil;
	if (vts_shoploadouttype==0) then
	{
		_persloadout=profileNamespace getVariable [("vts_loadout_"+_loadoutdataselect),nil];
		if (isnil "_persloadout") then
		{
			_txt="Empty loadout";
		}
		else
		{
			_price=[_persloadout] call vts_shopreturnloadoutprice;
			_txt=format["%1 $",[_price] call vts_numbertotext];
		};
	};
	if (vts_shoploadouttype==1) then
	{
		call compile format["vts_shoploadoutallyuser=%1;",_loadoutdataselect];
		if (isnull vts_shoploadoutallyuser) exitwith {[] spawn vts_shopdisplayloadouts;};
		if !(alive vts_shoploadoutallyuser) exitwith {[] spawn vts_shopdisplayloadouts;};
		
		_persloadout=[vts_shoploadoutallyuser] call vts_getloadout;

		_price=[_persloadout] call vts_shopreturnloadoutprice;
		_txt=format["%1 $",[_price] call vts_numbertotext];
		
	};	
	if (vts_shoploadouttype==2) then
	{
		if !(isnil ("vts_shopserverloadout_"+_loadoutdataselect)) then 
		{
			call compile format ["_persloadout=vts_shopserverloadout_%1 select 1;",_loadoutdataselect];
		};
		if !(isnil "_persloadout") then
		{
			_price=[_persloadout] call vts_shopreturnloadoutprice;
			_txt=format["%1 $",[_price] call vts_numbertotext];		
		}
		else
		{_txt="Empty loadout";};
	};
	//Checking if the loadout is existing
	if (isnil "_persloadout") then
	{	
	  _errortxt=format["There is no loadout data for the %1 !",lbText [133036,_loadoutindexselect]];
	  hint _errortxt;
	  [_errortxt] call vts_shopdisplaymessage;  
	} 
	else
	{
		if (_pretext=="") then
		{
			hint ("Loadout : "+([_loadoutdataselect] call vts_shopgetloadoutname));
		};
		[_pretext] call vts_shoploadoutinfo; 
	};
	
	ctrlSetText [133031,_txt];
	
	if (vts_shoploadouttype==0) then
	{
		_loadoutname=([_loadoutdataselect] call vts_shopgetloadoutname);
		//player sidechat ("ok:"+_loadoutname);
		ctrlSetText [133043,_loadoutname];
	};
	if (vts_shoploadouttype==2) then
	{
		_loadoutname=([_loadoutdataselect] call vts_shopgetloadoutname);
		//player sidechat ("ok:"+_loadoutname);
		ctrlSetText [133043,_loadoutname];
	};	
};

//Retrive config and return type number or iteminfo type number      
vts_shopgetobjettype=
{	
		private ["_config","_num"];
		_config=_this select 0;
		_num=0;
		if (getNumber (_config >> "ItemInfo" >> "Type" )!=0) then
		{
		_num=getNumber (_config >> "ItemInfo" >> "Type" );
		}
		else
		{
		_num=getNumber (_config >> "type");
		};
		_num
}; 

vts_shopsetloadoutname=
{
	private ["_slotloadoutname","_loadoutindex","_loadoutdata","_refresh"];
	_slotloadoutname=(ctrlText 133043);
	_loadoutindex=lbCurSel 133036;
	_loadoutdata=lbData [133036,_loadoutindex];
	_refresh=true;
	if 	(vts_shoploadouttype==0) then
	{
		profileNamespace setVariable [("vts_loadoutslotname_"+_loadoutdata),_slotloadoutname];
		call compile "saveProfileNamespace;";
		[("Loadout slot: "+_loadoutdata+" has been renamed to "+_slotloadoutname)] call vts_shopdisplaymessage; 
		hint ("Loadout slot: "+_loadoutdata+" has been renamed to "+_slotloadoutname);
	};
	if 	(vts_shoploadouttype==2) then
	{
		if (serverCommandAvailable "#kick") then
		{
			if (isnil ("vts_shopserverloadout_"+_loadoutdata)) then 
			{
				call compile format [
				"vts_shopserverloadout_%1 = [_slotloadoutname,nil];
				publicVariable ""vts_shopserverloadout_%1"";
				if (isserver) then 
				{
					profileNamespace setVariable [""vts_shopserverloadout_%1"",vts_shopserverloadout_%1];
					saveProfileNamespace;				
				};

				",_loadoutdata];
			}
			else
			{
				call compile format [
				"vts_shopserverloadout_%1 = [_slotloadoutname,vts_shopserverloadout_%1 select 1];
				publicVariable ""vts_shopserverloadout_%1"";
				if (isserver) then 
				{
					profileNamespace setVariable [""vts_shopserverloadout_%1"",vts_shopserverloadout_%1];
					saveProfileNamespace;				
				};

				",_loadoutdata];		
			};
			[("Server Loadout slot: "+_loadoutdata+" has been renamed to "+_slotloadoutname)] call vts_shopdisplaymessage; 
			hint ("Server Loadout slot: "+_loadoutdata+" has been renamed to "+_slotloadoutname);
			diag_log ("Loadout slot "+_loadoutdata+" renamed in "+_slotloadoutname+" by Player : "+(name player)+" id: "+(getPlayerUID player));
		}
		else
		{
			_refresh=false;
			["Error : You must be connectd as GM and server ADMIN to modify Server loadout"] call vts_shopdisplaymessage; 
			hint "Error : You must be connectd as GM and server ADMIN to modify Server loadout";
		};
	};	
	playsound "computer";
	if (_refresh) then 
	{
		[] call vts_shopdisplayloadouts;
		lbSetCurSel [133036,_loadoutindex];
	};
};
vts_shopgetloadoutname=
{
	private ["_index","_slotname"];
	//Index is string
	_index=_this select 0;
	//player sidechat _index;
	_slotname=nil;
	if (vts_shoploadouttype==0) then {_slotname=profileNamespace getVariable [("vts_loadoutslotname_"+_index),nil];};
	if (vts_shoploadouttype==2) then {call compile format ["if !(isnil ""vts_shopserverloadout_%1"") then {_slotname=vts_shopserverloadout_%1 select 0;};",_index];};
	if (isnil "_slotname") then
	{
		switch (true) do
		{
		case (_index=="1"):{_slotname="Alpha";};
		case (_index=="2"):{_slotname="Bravo";};
		case (_index=="3"):{_slotname="Charlie";};
		case (_index=="4"):{_slotname="Delta";};
		case (_index=="5"):{_slotname="Echo";};
		case (_index=="6"):{_slotname="Fox";};
		case (_index=="7"):{_slotname="Golf";};
		case (_index=="8"):{_slotname="Hotel";};
		case (_index=="9"):{_slotname="India";};
		case (_index=="10"):{_slotname="Juliet";};
		case (_index=="11"):{_slotname="Kilo";};
		case (_index=="12"):{_slotname="Lima";};
		case (_index=="13"):{_slotname="Mike";};
		case (_index=="14"):{_slotname="November";};
		case (_index=="15"):{_slotname="Oscar";};
		case (_index=="16"):{_slotname="Papa";};
		case (_index=="17"):{_slotname="Quebec";};
		case (_index=="18"):{_slotname="Romeo";};
		case (_index=="19"):{_slotname="Sierra";};
		case (_index=="20"):{_slotname="Tango";};
		case (_index=="21"):{_slotname="Uniform";};
		case (_index=="22"):{_slotname="Victor";};
		case (_index=="23"):{_slotname="Whiskey";};
		case (_index=="24"):{_slotname="Xray";};
		case (_index=="25"):{_slotname="Yankee";};
		case (_index=="26"):{_slotname="Zulu";};
		};
	};
	_slotname;
};
//generate loadout list
vts_shopdisplayloadouts=
{
	private ["_loadoutsarray","_selindex"];
	_selindex=0;
	
	_loadoutsarray=[];
	if (vts_shoploadouttype==0) then
	{
		for "_i" from 1 to 20 do 
		{
		_loadoutsarray set [count _loadoutsarray,[(str(_i)+": "+([str (_i)] call vts_shopgetloadoutname)),str(_i)]];
		};
		//};
		[133036,_loadoutsarray,_selindex] call Dlg_FillListBoxLists;
	};
	if (vts_shoploadouttype==1) then
	{
		
		_players=playableUnits;
		for "_p" from 0 to (count _players)-1 do 
		{
			_curplayer=_players select _p;
			if !(isnull _curplayer) then
			{
				if (alive _curplayer) then
				{
					if (side _curplayer==side player) then 
					{
						if ((vehicleVarName _curplayer)!="") then
						{
							_loadoutsarray set [count _loadoutsarray,[name _curplayer,vehicleVarName _curplayer]];
						};
					};
				};
			};
		
		};
		
		[133036,_loadoutsarray,_selindex] call Dlg_FillListBoxLists;
		
	};
	if (vts_shoploadouttype==2) then
	{
		for "_i" from 1 to 26 do 
		{
		_loadoutsarray set [count _loadoutsarray,["Server "+(str(_i)+": "+([str (_i)] call vts_shopgetloadoutname)),str(_i)]];
		};
		
		[133036,_loadoutsarray,_selindex] call Dlg_FillListBoxLists;		
	};	
	//player sidechat str _loadoutsarray;
};

vts_shopgetcompatibleitems=
{
	private ["_cfg","_muzzle","_pointer","_slot","_retrivevalidclass","_return"];
	_cfg=_this select 0;
	_retrivevalidclass=
	{
		private ["_arrayofvalidclass","_classlist","_currentclass"];
		_arrayofvalidclass=[];
		_classlist=((_this select 0) >> "WeaponSlotsInfo" >> (_this select 1) >> "compatibleitems");
		for "_a" from 0 to (count _classlist)-1 do
		{
			_currentclass= _classlist select _a;
			if (getnumber ((_this select 0) >> "WeaponSlotsInfo" >> (_this select 1) >> "compatibleitems" >> (configName _currentclass))==1) then {_arrayofvalidclass set [count _arrayofvalidclass,(configName _currentclass)];};
		};
		_arrayofvalidclass;
	};
	
	if (isarray (_cfg >> "WeaponSlotsInfo" >> "MuzzleSlot" >> "compatibleitems")) then 
	{
		_muzzle=getarray (_cfg >> "WeaponSlotsInfo" >> "MuzzleSlot" >> "compatibleitems");
	}
	else
	{
		_muzzle=[_cfg,"MuzzleSlot"] call _retrivevalidclass;
	};
	if (isarray (_cfg >> "WeaponSlotsInfo" >> "CowsSlot" >> "compatibleitems")) then 
	{
		_slot=getarray (_cfg >> "WeaponSlotsInfo" >> "CowsSlot" >> "compatibleitems");
	}
	else
	{
		_slot=[_cfg,"CowsSlot"] call _retrivevalidclass;
	};	
	if (isarray (_cfg >> "WeaponSlotsInfo" >> "PointerSlot" >> "compatibleitems")) then 
	{
		_pointer=getarray (_cfg >> "WeaponSlotsInfo" >> "PointerSlot" >> "compatibleitems");
	}
	else
	{
		_pointer=[_cfg,"PointerSlot"] call _retrivevalidclass;
	};		
	_return=_muzzle+_slot+_pointer;
	_return;
};

vts_shopgetcompatibleclass=
{
	//if (true) exitwith {[]};
	private ["_cfg","_vts_shopsellitemcompatiblity","_linkedmags","_linkeditems","_linkedmuzzles","_classname","_caching","_lowercasearray","_checkall","_itype","_checkmags","_checkitems"];
	_cfg=_this select 0;
	_checkall=false;
	if (count _this>1) then {_checkall=_this select 1;};
	
	
	//Optimization to check the list only what we need, magazines only ? attachements only, name if [] or everything ?
	_checkmags=false;
	_checkitems=false;
	if (_checkall) then 
	{
		_checkmags=true;
		_checkitems=true;
	}
	else
	{
		_itype=[_cfg] call vts_shopgetitemtype;
		switch (true) do
		{
			//Same type let the name highlight
			case (_itype==vts_shopselectedtype) : {	_checkmags=false;_checkitems=false;};
			//Magazines so only check magazines of items
			case (((vts_shopselectedtype mod 16)==0) && (vts_shopselectedtype<=2048)) : {_checkmags=true;_checkitems=false;};
			//Attachement so only check attachement of others items
			case ((vts_shopselectedtype==101) or (vts_shopselectedtype==201) or (vts_shopselectedtype==301)) : {_checkmags=false;_checkitems=true;};
			//Other stuff that don't need to check compatilibty
			case ((((vts_shopselectedtype mod 16)!=0) && (vts_shopselectedtype<=2048)) or vts_shopselectedtype==131072 or vts_shopselectedtype==605 or vts_shopselectedtype==701 or vts_shopselectedtype==801 or vts_shopselectedtype==0) : {_checkmags=false;_checkitems=false;};
			//Unknow, check for it just in case
			default {_checkmags=true;_checkitems=true;};
		};
	};
	
	_vts_shopsellitemcompatiblity=[];
	
	if (_checkmags or _checkitems) then
	{
		_classname=configname _cfg;
		_caching=server getvariable [("vts_"+_classname),nil];
		//call compile format ["if !(isnil ""vts_shopitems_%1"") exitwith {vts_shopitems_%1;};",_classname];
		//Check after if the item need to be read
		if (isnil "_caching") then 
		{
			_linkedmags=getarray (_cfg >> "magazines");
			_linkeditems=[_cfg] call vts_shopgetcompatibleitems;
			//_linkeditems=(getarray (_cfg >> "WeaponSlotsInfo" >> "MuzzleSlot" >> "compatibleitems"))+(getarray (_cfg >> "WeaponSlotsInfo" >> "CowsSlot" >> "compatibleitems"))+(getarray (_cfg >> "WeaponSlotsInfo" >> "PointerSlot" >> "compatibleitems"));
			_linkedmuzzles=getarray (_cfg >> "muzzles");
			if ((count _linkedmuzzles)>0) then
			{
				for "_i" from 0 to (count _linkedmuzzles)-1 do
				{
					if (isclass (_cfg >> (_linkedmuzzles select _i))) then
					{
						_muzzlemags=getarray (_cfg >> (_linkedmuzzles select _i) >> "magazines");
						if (count _muzzlemags>0) then {_linkedmags=_linkedmags+_muzzlemags;};
					};
				};
			};
			_caching=[_linkedmags,_linkeditems];	
			//player sidechat format["%1",_vts_shopsellitemcompatiblity];
			//call compile format ["if (isnil ""vts_shopitems_%1"") then {vts_shopitems_%1=_vts_shopsellitemcompatiblity;};",_classname];
			server setvariable [("vts_"+_classname),_caching];
		}; 
		if (_checkmags) then {_vts_shopsellitemcompatiblity=_vts_shopsellitemcompatiblity+(_caching select 0);};
		if (_checkitems) then {_vts_shopsellitemcompatiblity=_vts_shopsellitemcompatiblity+(_caching select 1);};
	};
	_vts_shopsellitemcompatiblity;
};

vts_shopgetitemtype=
{
	private ["_cfg"];
	_cfg=_this select 0;
	if (getnumber (_cfg >> "ItemInfo" >> "type")!=0) exitwith {getnumber (_cfg >> "ItemInfo" >> "type");};
	getnumber (_cfg >> "type");
};

//Make compatible item of selected player object highlighet in the list
vts_shophighlightcompatible=
{

	//[] call vts_perfstart;
	//if (true) exitwith {};
	private ["_cfg","_panel","_sidepanel","_gm","_highlight","_selectioncfg","_selectionclassname","_selectioncompatible","_classcompatible","_firstlb","_secondlb","_firstcheck","_secondcheck","_caching"];
	_cfg=_this select 0;
	_panel=_this select 1;
	//Player list = 133003;
	//Shop list = 133002
	_sidepanel=133002;
	if (_panel==_sidepanel) then {_sidepanel=133003;};
	disableSerialization;
	vts_shoplasthighlight=_cfg;
	vts_shoplasthighlightpanel=_panel;
	
	_gm=[player] call vts_getisGM;
	_highlight=false;
	_selectioncfg="";
	call compile ("_selectioncfg=(configfile >> "+_cfg+");");
	//_selectioncfg=(configfile >> "cfgweapons" >> "hgun_ACPC2_F");
	_selectionclassname=configname _selectioncfg;
	vts_shopselectedtype=[_selectioncfg] call vts_shopgetitemtype;
	//player sidechat str vts_shopselectedtype;
	_selectioncompatible=[_selectioncfg,true] call vts_shopgetcompatibleclass;
	//player sidechat str _selectioncompatible;
	
	_firstlb=((findDisplay 8004)  displayCtrl _panel);
	if (isclass _selectioncfg) then
	{
		for "_i" from 0 to (lbsize _firstlb)-1 do
		{
			if (_i!=lbcursel _firstlb) then
			{
				_lbclass=_firstlb lbData _i;
				if (_lbclass!="") then
				{
					//_lbcfg="";
					//call compile ("_lbcfg=(configfile >> "+_lbclass+");");
					_lbcfg=server getvariable [("vts_cachecfg_"+_lbclass),nil];
					if (isnil "_lbcfg") then {call compile ("_lbcfg=(configfile >> "+_lbclass+");");server setvariable [("vts_cachecfg_"+_lbclass),_lbcfg];};
					//_lbcfg=(configfile >> "cfgweapons" >> "srifle_EBR_ACO_F");
					_lbclassname=configname _lbcfg;
					//if (_lbclassname=="optic_hamr") then {player sidechat format["meh %1 %2",_selectioncompatible,_lbclassname]; };
					//Using count instead of in because of case sensitive issue between classes
					_firstcheck=false;					
					if (!_firstcheck && {({_x==_lbclassname} count _selectioncompatible>0)}) then {_firstcheck=true;};
					if (!_firstcheck && {({_x==_selectionclassname} count ([_lbcfg] call vts_shopgetcompatibleclass)>0)}) then {_firstcheck=true;}; 
					if (!_firstcheck && {(_lbclassname==_selectionclassname)}) then {_firstcheck=true;}; 
					if (_firstcheck) then
					{
						_firstlb lbSetColor [_i,[0.25,1,0.25,1]];
						_highlight=true;
					}
					else
					{
						if (_gm) then
						{
							if (_panel==133002) then
							{
								if (([_lbclass] call vts_shopitemgetitemcount)<1) then
								{
									_firstlb lbSetColor [_i,[1,0.25,0.25,1]];
								}
								else
								{
									_firstlb lbSetColor [_i,[1,1,1,1]];
								};
								
							}
							else
							{
								_firstlb lbSetColor [_i,[1,1,1,1]];
							};
						}
						else
						{
							_firstlb lbSetColor [_i,[1,1,1,1]];
						};	
					};
					
					
				};
			};
		};
		
		_secondlb=((findDisplay 8004)  displayCtrl _sidepanel);
		for "_i" from 0 to (lbsize _secondlb)-1 do
		{
			_lbclass=_secondlb lbData _i;
			if (_lbclass!="") then
			{
				//_lbcfg="";
				//call compile ("_lbcfg=(configfile >> "+_lbclass+");");
				_lbcfg=server getvariable [("vts_cachecfg_"+_lbclass),nil];
				if (isnil "_lbcfg") then {call compile ("_lbcfg=(configfile >> "+_lbclass+");");server setvariable [("vts_cachecfg_"+_lbclass),_lbcfg];};
				//_lbcfg=(configfile >> "cfgweapons" >> "srifle_EBR_ACO_F");
				_lbclassname=configname _lbcfg;
				//player sidechat format["meh %1 %2",_secondlb lbData _i,_classname]; 
				_secondcheck=false;
				if (!_secondcheck && {{_x==_lbclassname} count _selectioncompatible>0}) then {_secondcheck=true;}; 
				if (!_secondcheck && {{_x==_selectionclassname} count ([_lbcfg] call vts_shopgetcompatibleclass)>0}) then {_secondcheck=true;};  
				if (!_secondcheck && {_lbclassname==_selectionclassname}) then {_secondcheck=true;}; 
				if (_secondcheck) then
				{
					_secondlb lbSetColor [_i,[0.25,1,0.25,1]];
					_highlight=true;
				}
				else
				{
					if (_gm) then
					{
						if (_sidepanel==133002) then
						{
							if (([_lbclass] call vts_shopitemgetitemcount)<1) then
							{
								_secondlb lbSetColor [_i,[1,0.25,0.25,1]];
							}
							else
							{
								_secondlb lbSetColor [_i,[1,1,1,1]];
							};
						}
						else
						{
							_secondlb lbSetColor [_i,[1,1,1,1]];
						};						
					}
					else
					{
						_secondlb lbSetColor [_i,[1,1,1,1]];
					};
				};
				
			};
		};
		if (_highlight) then
		{
			_firstlb lbSetColor [lbCurSel _firstlb,[0.25,1,0.25,1]];
		};
		
	};
	
	//[] call vts_perfstop;
};

vts_shopgetsidestring=
{
	private ["_side","_number"];
	_side="";
	_number=_this select 0;
	if (typename _number=="STRING") then
	{
		_number=3;
		
	};
	switch (_number) do
	{
		case 0:{_side="(East)";};
		case 1:{_side="(West)";};
		case 2:{_side="(Resistance)";};
		case 3:{_side="(Civilian)";};
	};
	_side;
};

//Generate shop weapons list
vts_shopgeneratelist=
{

	
	
	private ["_ShopArray","_ShopConfig","_ShopType","_oldselection","_n","_totalshoplist","_firstdisplay","_ditemclass"];
	
  disableserialization;
	
  _ShopArray=_this select 0;
  _ShopConfig=_this select 1;
  _ShopType=[];
  if (count _this>2) then {_ShopType=_this select 2;};
 
  _firstdisplay=false;
  if (count _this>3) then {_firstdisplay=_this select 3;};
  if !(_firstdisplay) then
  {
	if !(isnil "vts_shopfirstdisplay") then {terminate vts_shopfirstdisplay;vts_shopfirstdisplay=nil;};
  };
  
   
  vts_shopcurrentconfig=_ShopConfig;
  vts_shopcurrentarray=_ShopArray;
  vts_shopcurrenttype=_ShopType;
  //hint format["%1",_ShopType];
  
  if (isnil "vts_shop_filter") then {vts_shop_filter="";};
  
  _oldselection=lbCurSel 133002;
  
  _n=count _ShopArray;
  _totalshoplist=[];
  if (_n>0) then
  {
    for "_x" from 0 to (_n-1) do
    {
      
      _item=_ShopArray select _x;
      _ditemclass="";
	  call compile format["_ditemclass=(configfile >> %1);",_item];
	
      //First  we verify that the player have the existing class on its side.. because serveur could run addons, he doesnt have...
      if (isclass (call compile format["(configFile >> %1 )",_item])) then
      {
		//player sidechat format["%1",_item];
        _add=true;
        
        //Checking if the item has been unlocked or is accessible since begining
		_startingavailablelist=[];
		//_startingavailablelist=ShopInitEquipementAvailable;		
		//if (pa_startingammo==0 && pa_shopallunlocked!=1) then {_startingavailablelist=[];};
		
        if (([_item] call vts_shopitemgetitemcount<1) and !(_item in _startingavailablelist) and !([player] call vts_getisGM)) then {_add=false;}
        else
        {
          //If we are using type to classify objects, else we display them all
          if (count _ShopType > 0) then
          {
            _type=0;
            call compile format["_type=getNumber (configFile >> %1 >> ""type"");",_item];
            //player sidechat format["%2 : %1",_item,_type];
            //hint format["%1",_type];
            if (_type in _ShopType) then
            {
              _add=true;
            }
            else
            {
              _add=false;
            };
          };
        };  
		//Check if filter is active before adding the object to the list
		if (_add) then
		{			
			
			
			if (vts_shop_filter!="") then
			{
				if (typename _ditemclass=="CONFIG") then
				{
					_add=false;
					_dnametofilter=gettext(_ditemclass >> "displayname");
					_descshorttofilter=gettext(_ditemclass >> "descriptionshort");
					_desctofilter=gettext(_ditemclass >> "Description");
					if (([_dnametofilter,vts_shop_filter] call KRON_StrInStr) or ([_descshorttofilter,vts_shop_filter] call KRON_StrInStr) or ([_desctofilter,vts_shop_filter] call KRON_StrInStr)) then 
					{
						_add=true;
					};
				};
			};		
		};
		//Check if the item is an uniform (hidding uniform not the same side of the player (BIS limitation)
		if (_add) then
		{
			if (typename _ditemclass=="CONFIG") then
			{
				if (getnumber (_ditemclass >> "ItemInfo" >> "type")==801) then
				{
					//player sidechat "uniform";
					_uniformunit=gettext (_ditemclass >> "ItemInfo" >> "uniformclass");
					if (_uniformunit!="") then
					{					
						if !(isclass (configfile >> "CfgVehicles" >> _uniformunit)) then 
						{
							_add=false;
						}
						else
						{
							_uniformside=getnumber (configfile >> "CfgVehicles" >> _uniformunit >> "side");
							_bsameside=false;
							
							switch (_uniformside) do
							{
								case 0:{if (side player==EAST) then {_bsameside=true;};};
								case 1:{if (side player==WEST) then {_bsameside=true;};};
								case 2:{if (side player==RESISTANCE) then {_bsameside=true;};};
								case 3:{if (side player==CIVILIAN) then {_bsameside=true;};};
							};
							
							_uniformsidearray=getarray (configfile >> "CfgVehicles" >> _uniformunit >> "modelsides");
							if ((getnumber (configfile >> "CfgVehicles" >> (typeof player) >> "side")) in _uniformsidearray) then
							{
								_bsameside=true;
							};
							
							if !(_bsameside) then {_add=false;};
						};
					};	
				};
			};
			
		};
		
		//If everything ok lets add the items to the list
        if (_add) then
        {
			
			_displayname="";
			_picture="";
			call compile format["
			_displayname=gettext(configFile >> %1 >> 'displayname');
			_picture=gettext(configFile >> %1 >> 'picture');
			if (isNumber (configFile >> %1 >> 'Iteminfo' >> 'side')) then
			{
				
				_displayname=_displayname+"" ""+([getnumber(configFile >> %1 >> 'iteminfo' >> 'side')] call vts_shopgetsidestring);
			};
			if (isNumber (configFile >> %1 >> 'side')) then
			{				
				_displayname=_displayname+"" ""+([getnumber(configFile >> %1 >> 'side')] call vts_shopgetsidestring);
			};
			",_item];
			_totalshoplist set [count _totalshoplist,[_displayname,_item,_picture]];	
        };
        
      };
    };

  };
  //If no items found and filter active, let inform the player that the filter didn't found any items in the selected type.
  if ((vts_shop_filter!="") && (count _totalshoplist<1)) then
  {
		_txt=format ["No object found with the filter : %1",vts_shop_filter];
		hint _txt;
		[_txt] call vts_shopdisplaymessage; 
  };
  
  //Adding a blank at the end to avoid the bug where there is an item out of the scrollbar in multiplayer sometime (dunnoy why)
  _totalshoplist set [count _totalshoplist,["~",""]];
  
  
  [133002,_totalshoplist] call Dlg_FillListBoxLists;
  
  lbSort ((findDisplay 8004)  displayCtrl 133002);

  //Clean shop inv menu if shop is empty 
  if (_n<1) exitwith {[3] call vts_shopitemselect;};
  
  lbSetCurSel [133002,_oldselection]; 
  lbSetCurSel [133003,lbCurSel 133003]; 

};

//Scan empty vehicle around the player to see if they can sell them
vts_shopscanforvehicletosell=
{
	private ["_vehicletosell","_vehiclesaround","_n"];
  _vehicletosell=[];
  _vehiclesaround=nearestObjects [player, ["LandVehicle","Air","Ship"], 50];
  _n=count _vehiclesaround;
  for "_i" from 0 to (_n-1) do
  {
    //Only adding empty and not so damaged vehicles to sell
    _vehicle=_vehiclesaround select _i;
    _cansell=[_vehicle] call vts_shopvehiclecanbesell;
    if (_cansell) then
    {
      _vehicletosell set [count _vehicletosell,typeof (_vehiclesaround select _i)];
    };
  };
  [_vehicletosell,"CfgVehicles"] call vts_shopclassnametoconfigstring;
};

//Convert an array of string to config
vts_shopclassnametoconfigstring={
	private ["_array","_cfg","_newarray","_n"];
  _array=_this select 0;
  _cfg=_this select 1;
  
  private "_class";
  _newarray=[];
  _n=count _array;
  for "_x" from 0 to (_n-1) do
  {
    _item=_array select _x;
	if (_item!="" &&  typeName _item=="STRING") then
	{
		_newarray set [count _newarray,"'"+_cfg+"'>>'"+_item+"'"];
	};
  };
  _newarray;
};

//Shop Player item refresh
vts_shoprefreshplayeritems=
{
	private ["_returncount","_oldselection","_playerselllist","_n","_playerselllistarray","_playername"];
  _returncount=false;
  if (count _this>0)  then {_returncount=_this select 0;};
  
  _oldselection=lbCurSel 133003;
  
  private "_class";
  
  _playerselllist=[];
  
  //Arma 3
  if (vtsarmaversion>2) then
  { 
	  //Primary weapon
	  if !((primaryweapon player)=="") then 
	  {
	  _playerselllist=_playerselllist+([[primaryweapon player],"CfgWeapons"] call vts_shopclassnametoconfigstring);
	  //_playerselllist=_playerselllist+([primaryWeaponItems player,"CfgWeapons"] call vts_shopclassnametoconfigstring); 
	  };
	  
	  //Secondary  weapon
	  if !((secondaryweapon player)=="") then 
	  {
	  _playerselllist=_playerselllist+([[secondaryweapon player],"CfgWeapons"] call vts_shopclassnametoconfigstring);
	  //_playerselllist=_playerselllist+([secondaryWeaponItems player,"CfgWeapons"] call vts_shopclassnametoconfigstring); 
	  };

	  //Magazine
	  _playerselllist=_playerselllist+([magazines player,"CfgMagazines"] call vts_shopclassnametoconfigstring);
	  
	 //Arma 3 functions Handguns Items, Equipeds, BackPacks, Helmet, Uniform, Vest, Uniform
	//Handgun
	call compile "
	  if !((handgunWeapon player)=="""") then 
	  {
	  _playerselllist=_playerselllist+([[handgunWeapon player],""CfgWeapons""] call vts_shopclassnametoconfigstring);
	  
	  };
	  ";
	  
	  //_items
	  _playerselllist=_playerselllist+([(items player)-(magazines player),"CfgWeapons"] call vts_shopclassnametoconfigstring);
	  
	  //_EquipedItems (equiped item are mainly from cfgweapons, but some are from cfgglasses or other config...)
	  call compile "
	  _playerselllist=_playerselllist+([assignedItems player,""CfgWeapons""] call vts_shopclassnametoconfigstring); 
		";
		
	  //Backpack
	  call compile "
	  if !((backpack player)=="""") then 
	  {
	  _playerselllist=_playerselllist+([[backpack player],""CfgVehicles""] call vts_shopclassnametoconfigstring);
	  };  
	  ";
	  
	 
	  
	  
	  //HeadGear	  
	  call compile "
	  if !((headgear player)=="""") then {_playerselllist=_playerselllist+([[headgear player],""CfgWeapons""] call vts_shopclassnametoconfigstring);}; 
	  ";
	  
	  
	  //Uniform
	  call compile "
	  if !((uniform player)=="""") then {_playerselllist=_playerselllist+([[uniform player],""CfgWeapons""] call vts_shopclassnametoconfigstring);}; 
	  ";
	  
	  //Vest
	  call compile "
	  if !((vest player)=="""") then {_playerselllist=_playerselllist+([[vest player],""CfgWeapons""] call vts_shopclassnametoconfigstring);}; 
	  ";
	  
	  //Google
	  //Removing goggle from the _playerselllist, because the goggles are in cfgglasses, no cfgweapons
	  call compile "
	  if !((Goggles player)=="""") then 
	  {
		_gogglearray=[[Goggles player],""CfgWeapons""] call vts_shopclassnametoconfigstring;
		_playerselllist=_playerselllist-_gogglearray;
		_playerselllist=_playerselllist+([[Goggles player],""CfgGlasses""] call vts_shopclassnametoconfigstring);
	  }; 
	   ";
   }
   else
   {
		//Arma 2
		_weapons=[(weapons player),"CfgWeapons"] call vts_shopclassnametoconfigstring;
		_magazines=[(magazines player),"CfgMagazines"] call vts_shopclassnametoconfigstring;
		_playerselllist=_playerselllist+_weapons+_magazines
   };
  
  //Vehicles
  _playerselllist=_playerselllist+([] call vts_shopscanforvehicletosell);
  
  
  
  _n=count _playerselllist;
  
  _playerselllistarray=[];
  
  if (_n>0) then
  {
    for "_x" from 0 to (_n-1) do
    {
      _item=_playerselllist select _x;
      call compile format["_class=(configFile >> %1 );",_item];
      //player sidechat format["%1",gettext(_class>>"displayname")];
      _playerselllistarray set [count _playerselllistarray,[gettext(_class>>"displayname"),_item,gettext(_class>>"picture")]];
    }; 
  };
  //Return itemcount if requested
  if (_returncount) exitwith {count _playerselllistarray};
  
  //hint format["%1",_playerselllistarray];
  [133003,_playerselllistarray] call Dlg_FillListBoxLists;

  
  //Setup the player name
  _playername=name player;
  if ([player] call vts_getisGM) then {_playername="(GAMEMASTER) "+_playername;};
  ctrlSetText [133016,_playername];
  
	//Setup class name
	_playerclass=typeof player;
	_playerclassstring=gettext (configFile >> "CfgVehicles" >> _playerclass >> "displayname");
	_candisablemine=getNumber (configFile >> "CfgVehicles" >> _playerclass >> "candeactivatemines");
	_canhidebodies=getNumber (configFile >> "CfgVehicles" >> _playerclass >> "canhidebodies");
	_canrepair=getNumber (configFile >> "CfgVehicles" >> _playerclass >> "engineer");
	_isattendant=getNumber (configFile >> "CfgVehicles" >> _playerclass >> "attendant");
	_classname="";
	  
	if (_canhidebodies==1) then {_classname=" (SpecOp)";};
	if (_candisablemine==1) then {_classname=" (Demo)";};
	if (_canrepair==1) then {_classname=" (Engineer)";};
	if (_isattendant==1) then {_classname=" (Medic)";};
	ctrlSetText [133048,(_playerclassstring+_classname)];
	
  //Clean player menu if inv is empty 
  if (_n<1) exitwith {[2] call vts_shopitemselect;};
  
  lbSetCurSel [133003,_oldselection]; 
};

//Shop item on select
vts_shopitemselect={
	private ["_side","_classselection","_class","_pic","_name","_description","_control"];
  disableSerialization;
  //hint "selected";
  _side=_this select 0;
  private ["_selectionlistid","_pictureid","_nameid","_descriptionid","_priceid","_cfg"];
  
  //For Shop inventory
  if (_side==0 or _side==3) then
  {
    _selectionlistid=133002;
    _pictureid=133004;
    _nameid=133005;
    _descriptionid=133006;
    _priceid=133007;
  };
  //For player inventory
  if (_side==1 or _side==2) then
  {
    _selectionlistid=133003;
    _pictureid=133010;
    _nameid=133011;
    _descriptionid=133012;
    _priceid=133013;  
  };
  //Clean up (for empty inventory)
  if (_side==2) exitwith
  {
    //hint "done";
    ctrlSetText [_nameid,""];
	_control = (findDisplay 8004)  displayCtrl _descriptionid;
	_control ctrlSetStructuredText (parsetext "");
	ctrlSetText [_pictureid,"#(argb,8,8,3)color(0,0,0,1)"];
	ctrlSetText [_priceid,""];
    vts_shopsellprice=0;
    vts_shopsellitemname="";
    vts_shopsellitemclass=""; 
    vts_shopsellconfigstring="";
	vts_shopsellitemcompatiblity=[];
  };
  //Clean up (for empty shop)
  if (_side==3) exitwith
  {
    //hint "done";
    ctrlSetText [_nameid,""];
	_control = (findDisplay 8004)  displayCtrl _descriptionid;
	_control ctrlSetStructuredText (parsetext "");
	ctrlSetText [_pictureid,"#(argb,8,8,3)color(0,0,0,1)"];
	ctrlSetText [_priceid,""];
    vts_shopbuyprice=0;
    vts_shopbuyitemname="";
    vts_shopbuyitemclass="";
    vts_shopbuyconfigstring="";    
  };
    
  _classselection = lbCurSel _selectionlistid;
  //_class=lbText [133002, _classselection];
  _class=lbData [_selectionlistid, _classselection];
  
  //hint format["%1",_class];
  //player sidechat _class;
  if (_class=="") exitwith 
  {
	//player sidechat "nothin";
	vts_shopbuyprice=0;
	vts_shopbuyitemname="Nothing";
	vts_shopbuyitemclass=(configfile >> "Null");
	vts_shopbuyconfigstring="";	
	ctrlSetText [_pictureid,"#(argb,8,8,3)color(0,0,0,1)"];
	ctrlSetText [_nameid,"Nothing"];
	
	_control = (findDisplay 8004)  displayCtrl _descriptionid;
	_control ctrlSetStructuredText (parsetext "");	
	
	ctrlSetText [_priceid,"0 $"];
  };
  
  call compile format["_cfg=(configFile >> %1 );",_class];
  
  _pic=gettext (_cfg >> "picture");
  _name=gettext (_cfg >> "displayname");
	if (isNumber (_cfg >> "Iteminfo" >> "side")) then
	{
		
		_name=_name+" "+([getnumber ( _cfg >> "Iteminfo" >> "side")] call vts_shopgetsidestring);
	};
	if (isNumber (_cfg >> "side")) then
	{				
		_name=_name+" "+([getnumber ( _cfg >> "side")] call vts_shopgetsidestring);
	};

  _description=gettext (_cfg >> "descriptionshort");
  
  if (isnil "_description" or _description=="") then 
  {
    //hint "Big description";
    _description=gettext (_cfg >> "Library" >> "libtextdesc");
  };
  
  //Add weapon attachement to description;
  if (isclass (_cfg >> "LinkedItems" >> "LinkedItemsOptic" )) then
  {
	_attach=gettext (_cfg >> "LinkedItems" >> "LinkedItemsOptic" >> "item" );
	_dname=gettext (ConfigFile >> "CfgWeapons" >> _attach >> "displayname");
	if (_dname!="") then {_description=_description+"<br/>"+_dname;};
  };
  if (isclass (_cfg >> "LinkedItems" >> "LinkedItemsMuzzle" )) then
  {
	_attach=gettext (_cfg >> "LinkedItems" >> "LinkedItemsMuzzle" >> "item" );
	_dname=gettext (ConfigFile >> "CfgWeapons" >> _attach >> "displayname");
	if (_dname!="") then {_description=_description+"<br/>"+_dname;};
  };
  if (isclass (_cfg >> "LinkedItems" >> "LinkedItemsAcc" )) then
  {
	_attach=gettext (_cfg >> "LinkedItems" >> "LinkedItemsAcc" >> "item" );
	_dname=gettext (ConfigFile >> "CfgWeapons" >> _attach >> "displayname");
	if (_dname!="") then {_description=_description+"<br/>"+_dname;};
  };  
  //hint format["%1 - %2 - %3",_pic,_name,_description];

	ctrlSetText [_pictureid,_pic];
	ctrlSetText [_nameid,_name];
	
	_control = (findDisplay 8004)  displayCtrl _descriptionid;
	_control ctrlSetStructuredText (parsetext _description);
	
	//hint format["%1",_class];
	_price = [_class] call vts_shopgetPrice;
	
	//Setting up variable
	//Shop thread
	if (_side==0) then 
	{
		vts_shopbuyprice=_price;
		vts_shopbuyitemname=_name;
		vts_shopbuyitemclass=_cfg;
		vts_shopbuyconfigstring=_class;
		[] call vts_shoprefreshitemcountstate;
		[_class,133002] call vts_shophighlightcompatible;
	};
	//Player Thread
    if (_side==1) then 
	{
		_price=_price*0.75;
		vts_shopsellprice=_price;
		vts_shopsellitemname=_name;
		vts_shopsellitemclass=_cfg;
		vts_shopsellconfigstring=_class;
		[_class,133003] call vts_shophighlightcompatible;
		//hint format["%1",vts_shopsellitemcompatiblity];
	};
	//player sidechat format["%1",vts_shopbuyitemclass];
	ctrlSetText [_priceid,format["%1 $",[_price] call vts_numbertotext]];
  
  //[] spawn vts_shoprefreshplayeritems;
   
};

//Shop message cleanup
vts_shopcleanmessage={
	private ["_delete"];
  _delete=_this select 0;  
  sleep 10;
 
  if (vts_shopmessage==_delete) then
  {
    disableSerialization;
    _control = (findDisplay 8004)  displayCtrl 133009;
    _control ctrlSetStructuredText (parsetext "");
  };
  
};

//Shop message display
vts_shopdisplaymessage={
	private ["_text","_control"];
  _text=_this select 0;
  _control = (findDisplay 8004)  displayCtrl 133009;
  _control ctrlSetStructuredText (parsetext _text);
  
  if (isnil "vts_shopmessage") then {vts_shopmessage=0;} else {vts_shopmessage=vts_shopmessage+1};
  
  [vts_shopmessage] spawn vts_shopcleanmessage;
};

//Buy and send on ground (usefull when inventory packed or to help newbie to get stuff)
vts_ShopBuySendToGround=
{
	_ground=createVehicle [vts_weaponholder, getpos player, [], 0, "NONE"];
	_ground addmagazinecargoglobal ["RPG32_HE_F",1];
	_pos=(player modeltoworld [0,1,0]);
	if  !(surfaceiswater _pos) then
	{
	_ground setposatl _pos; 
	}
	else
	{
	_ground setposasl _pos;
	};
};

//Retrieve magazine for weaponclass
vts_ShopGetWeaponMagzine=
{
	private ["_weapon","_cfg","_mag"];
	_weapon=_this select 0;
	_mag="";
	_cfg=getarray (configfile >> "CfgWeapons" >> _weapon >> "magazines");
	if (count _cfg>0) then
	{
		_mag=_cfg select 0;
	};
	_mag;
};

//Buy button
vts_shopbuy={

  private ["_classname","_classcfg","_itemcount","_pocketitems"];
  
  //Checking if the balance is right
  if ((vts_shopbalance-vts_shopbuyprice<0) && !([player] call vts_getisGM)) exitwith 
  {
      _txt=format["You don't have enough money to buy %1 !",vts_shopbuyitemname];
      hint _txt;
      [_txt] call vts_shopdisplaymessage;      
  };
  
  
	_classname=configname vts_shopbuyitemclass;  
	//Checking there is enough item in the store
	_classcfg="";
	/*
	if (isclass (configfile >> "CfgVehicles" >> _classname)) then {_classcfg="'CfgVehicles'>>'"+_classname+"'";};
	if (isclass (configfile >> "CfgMagazines" >> _classname)) then {_classcfg="'CfgMagazines'>>'"+_classname+"'";};
	if (isclass (configfile >> "CfgWeapons" >> _classname)) then {_classcfg="'CfgWeapons'>>'"+_classname+"'";};
	if (isclass (configfile >> "CfgGlasses" >> _classname)) then {_classcfg="'CfgGlasses'>>'"+_classname+"'";};
	*/
	if !(isnil "vts_shopbuyconfigstring") then {_classcfg=vts_shopbuyconfigstring;};
	//player sidechat format["cfg %1",_classcfg];
	_itemcount=[_classcfg] call vts_shopitemgetitemcount;
	if ((_itemcount<1) && !([player] call vts_getisGM)) exitwith
	{
		_txt=format["There is no more %1 in the store !",vts_shopbuyitemname];
		hint _txt;
		[_txt] call vts_shopdisplaymessage;      
	};
  
	private ["_additem"];
  

	
	
  
  //Checking type of item bought in shop
  
  if (isclass (configfile >> "CfgVehicles" >> _classname)) then
  {
	//Checking if we are buying a backpack first
	if (gettext (vts_shopbuyitemclass >> "vehicleclass")=="BackPacks") then
	{
		if (vtsarmaversion>2) then 
		{
		call compile "_pocketitems=backpackItems player;";
		};
		_currentbackpack=unitBackpack player;
		player addbackpack _classname;
		if !(isnull _currentbackpack) then {deletevehicle _currentbackpack};
		if (vtsarmaversion>2) then 
		{
		call compile "clearAllItemsFromBackpack player;{player additemtobackpack _x} foreach _pocketitems;";
		};
		_currentbuyprice=vts_shopbuyprice;
		_txt=format["You bought backpack : %1 for %2 $",vts_shopbuyitemname,[_currentbuyprice] call vts_numbertotext];
		if ([player] call vts_getisGM) then {_txt=_txt+" (for FREE as a game master)";};
		hint _txt;
		[_txt] call vts_shopdisplaymessage;
		_additem=true;
	}
	else
	{
		//Vehicles
		_pos=(getpos player) findEmptyPosition [10,500,_classname];
		
		if ((count _pos)>0) then 
		{
		  _object=_classname createVehicle _pos;
		  _object setVelocity [0, 0.5, 0]; 
		  		
		  clearWeaponCargoGlobal _object;
		  clearMagazineCargoGlobal _object;
		  
		  _currentbuyprice=vts_shopbuyprice;
		  _txt=format["You bought vehicle : %1 for %2 $",vts_shopbuyitemname,[_currentbuyprice] call vts_numbertotext];
		  if ([player] call vts_getisGM) then {_txt=_txt+" (for FREE as a game master)";};
		  hint _txt;
		  [_txt] call vts_shopdisplaymessage;
		  
			//Check if it's an UAV then create uav crew
			if (getnumber (configfile >> "CfgVehicles" >> _classname >> "isuav")==1) then 
			{
				call compile "createVehicleCrew _object;";
			};		  
			("SHOP: "+(name player)+" buy vehicle "+vts_shopbuyitemname) call vts_addlog;
		  _additem=true;
		}
		else
		{
		  _txt="There isn't enough space for the delivery";
		  hint _txt;
		  [_txt] call vts_shopdisplaymessage;
		  _additem=false;
		};   
	};
  }
  else
  {
    //Weapons and ammo
    
	_additem=false;
	
	_buyitemname=configname vts_shopbuyitemclass;
	_buytitemtype=[vts_shopbuyitemclass] call vts_shopgetobjettype;
	//Debug give config & id
	//player sidechat  format["%1 & %2",_buytitemtype,vts_shopbuyitemclass select 0];
	//Counting new item to be sure the add worked
	_buyitemsimulation=gettext (vts_shopbuyitemclass >> "simulation");
	
	//Arma 3
	if (vtsarmaversion>2) then
	{
		//Gear, Weapons & Items
		switch (_buytitemtype) do
		{
			//Gears
			case 801: {call compile "_pocketitems=uniformItems player;removeuniform player;player adduniform _buyitemname;{player addItemToUniform _x} foreach _pocketitems;_additem=true;";};
			case 605: {call compile "removeheadgear player;player addheadgear _buyitemname;_additem=true;";};
			case 701: {call compile "_pocketitems=vestItems player;removevest player;player addvest _buyitemname;{player addItemToVest _x} foreach _pocketitems;_additem=true;";};
		
			//Primary weapon
			case 1: 
			{
				if ([_buyitemsimulation,"Item"] call KRON_StrInStr) then 
				{
				call compile "player additem _buyitemname;";
				}
				else 
				{
					_sweap=primaryweapon player;
					if (_sweap!="") then {player removeweapon _sweap;};
					player addmagazine ([_buyitemname] call vts_ShopGetWeaponMagzine);
					player addweapon _buyitemname;
					//player action ["handgunoff",player];
				};
				_additem=true;
				
			};
			//Primary weapon using 2 slot
			case 5: 
			{
				if ([_buyitemsimulation,"Item"] call KRON_StrInStr) then 
				{
				call compile "player additem _buyitemname;";
				}
				else 
				{
					_sweap=primaryweapon player;
					if (_sweap!="") then {player removeweapon _sweap;};
					player addmagazine ([_buyitemname] call vts_ShopGetWeaponMagzine);
					player addweapon _buyitemname;
					//player action ["handgunoff",player];
				};
				_additem=true;
				
			};			
			//Secondary weapon
			case 4:  
			{	
				if ([_buyitemsimulation,"Item"] call KRON_StrInStr) then 
				{
				call compile "player additem _buyitemname;";
				}
				else 
				{
				_sweap=secondaryweapon player;
				if (_sweap!="") then {player removeweapon _sweap;};
				player addmagazine ([_buyitemname] call vts_ShopGetWeaponMagzine);
				player addweapon _buyitemname;
				//player action ["handgunoff",player];
				};
				_additem=true;
				
			};
			//Handgun
			case 2:
			{	
				call compile "
				_sweap=handgunWeapon player;
				if (_sweap!="""") then {player removeweapon _sweap;};
				player addmagazine ([_buyitemname] call vts_ShopGetWeaponMagzine);
				player addweapon _buyitemname;
				
				";
		
				_additem=true;
				
			};	
			//Binocular (yeah still a  weapon sigh...)
			case 4096:
			{
				player addweapon _buyitemname;
				_additem=true;
			};
			

		};
		
		//Items... (alot of different stuff ...) and switch only accept bool ?
		if (_buytitemtype==131072 or _buytitemtype==616 or _buytitemtype==619 or _buytitemtype==401 or _buytitemtype==301 or _buytitemtype==4096 or _buytitemtype==620 or _buytitemtype==201 or _buytitemtype==101 or _buytitemtype==621) then
		{
			_count=count (items player); 
			call compile "player additem _buyitemname;";
			if (_count<count (items player)) then {_additem=true};
		};
		
		//Handling goggles
		if (isclass (configfile >> "CfgGlasses" >> _classname)) then
		{	
			call compile "
			removeGoggles player;
			player addGoggles _buyitemname;";
			_additem=true;
		};


		
		//Then ammunition (as long they are in cfgmagazine, just add mag will do it ... don't want to mess with the magazine type.
		if ("CA_Magazine" in ([vts_shopbuyitemclass,true]call bis_fnc_returnParents)) then 
		{
			_count=count (magazines player); 
			player addmagazine _buyitemname;
			if (_count<count (magazines player)) then {_additem=true};
		};
	
	}
	else
	{
		//Arma 2
		_additem=[player,vts_shopbuyitemclass] call bis_fnc_invadd;
	};
	
	
	
    if (_additem) then
    {
	  _currentbuyprice=vts_shopbuyprice;
      _txt=format["You bought : %1 for %2 $",vts_shopbuyitemname,[_currentbuyprice] call vts_numbertotext];
	  if ([player] call vts_getisGM) then {_txt=_txt+" (for FREE as a game master)";};
      hint _txt;
      [_txt] call vts_shopdisplaymessage;
      
    }
    else
    {
      _txt="You don't have enough space in your inventory for this item";
      hint _txt;
      [_txt] call vts_shopdisplaymessage;
    };
    
  };
  //Updating the balance
  if (_additem) then
  {
	playsound "computer";
	if ([player] call vts_getisGM) then 
	{
		vts_shopbuyprice=0;
	}
	else
	{
		_newbalance=vts_shopbalance-vts_shopbuyprice;
		[vts_shopside,_newbalance] call vts_shopupdatebalance;
	};
  };
  //Updating unlocks / item counts (only for GM selling)
  
  if (_additem && !([player] call vts_getisGM)) then
  {
	//player sidechat format["test %1",_classcfg];
	if (_classcfg!="") then
	{
		
		_itemcount=_itemcount-1;
		if (_itemcount<0) then {_itemcount=0;};
		[_classcfg,_itemcount] call vts_shopitemsetcount;
	};
  };
  
  //Refreshing player inv
  [] call vts_shoprefreshplayeritems;  
};

//Arma 3 Remove item in inventory or equiped
vts_shopremoveitemfrominv=
{
	private ["_unit","_item","_numitem"];
	call compile "
		_unit=_this select 0;
		_item=_this select 1;
		_numitem=count (items _unit)+count (assignedItems _unit);
		_unit removeitem _item;
		if (_numitem==(count (items _unit)+count (assignedItems _unit))) then
		{
			if (_item in (assignedItems _unit)) then
			{
				player unassignitem _item;
				_unit removeitem _item;
			};
		};
	";
};

//Sell button
vts_shopsell={
  private ["_sell","_currentobjectscount","_classname"];
  //Selling vehicles
  _sell=false;

  if (typename vts_shopsellitemclass=="STRING") exitwith
  {  
    _txt="You have nothing to sell !";
     hint _txt;
    [_txt] call vts_shopdisplaymessage;
  };
 
  _currentobjectscount=[true] call vts_shoprefreshplayeritems;
  
  _classname=configname vts_shopsellitemclass;
  //IsKindof only work on vehicles

  //Then vehicle
  //hint format["%1",vts_shopsellitemclass]; 
  if (_classname iskindof "AllVehicles") then
  {

	_vehiclesaround=nearestObjects [player, [_classname], 50];
	_n=count _vehiclesaround;
	//hint format["%1",_n]; 
	_scandone=false;
	for "_i" from 0 to (_n-1) do
	{
	  //Only adding empty and not so damaged vehicles to sell
	  _vehicle=_vehiclesaround select _i;
	  _cansell=[_vehicle] call vts_shopvehiclecanbesell;
	  if (_cansell and (!_scandone)) then
	  {
		//Teleporting the vehicle far from the player since the delete is a bit long to do.. and so it could be scanned again when
		//it is still in delete...
		_vehicle setpos [0,10000,0];    
		deletevehicle _vehicle;
		_scandone=true;
		_currentsellprice=vts_shopsellprice;
		_txt=format["You sell : %1 for %2 $",vts_shopsellitemname,[_currentsellprice] call vts_numbertotext];
		if ([player] call vts_getisGM) then {_txt=_txt+" (for FREE as a game master)"};
		hint _txt;
		[_txt] call vts_shopdisplaymessage;
		("SHOP: "+(name player)+" sell vehicle "+vts_shopsellitemname) call vts_addlog;
		_sell=true;
	  };
	};
	//if scandone still false, mean that he player didn't the selected vehicle
	if (!_scandone) then
	{
		_txt="Unable to sell";
		hint _txt;
		[_txt] call vts_shopdisplaymessage;
	};
    
 
  }
  //selling weapons or ammo or backpack
  else
  {

	
    if (typename vts_shopsellitemclass=="CONFIG") then
    {
		//Arma 3
		if (vtsarmaversion>2) then
		{
		  _removeitemcount=count (items player);
		  _itemtodelname=configName vts_shopsellitemclass;
		  _itemparents=[vts_shopsellitemclass,true] call bis_fnc_returnParents;
		  _itemtypeinfo=getnumber (vts_shopsellitemclass >> "ItemInfo" >> "type");
	
		  //systemchat str _itemtodelname;
		  //In to checkarray is case sensitive
		  switch (true) do
		  {
			case ("CA_Magazine" in _itemparents): {player removemagazine _itemtodelname;_sell=true;};
			case ("RifleCore" in _itemparents): {call compile "if (primaryweapon player==_itemtodelname) then {player removeweapon _itemtodelname;} else {player removeitem _itemtodelname;};_sell=true;";};
			case ("LauncherCore" in _itemparents): {call compile "if (secondaryweapon player==_itemtodelname) then {player removeweapon _itemtodelname;} else {player removeitem _itemtodelname;};_sell=true;";};
			case ("PistolCore" in _itemparents): {call compile "if (handgunWeapon player==_itemtodelname) then {player removeweapon _itemtodelname;} else {player removeitem _itemtodelname;};_sell=true;";};
			case ("NVGoggles" in _itemparents): {[player,_itemtodelname] call vts_shopremoveitemfrominv;player removeweapon _itemtodelname;_sell=true;};
			case ("Binocular" in _itemparents): {[player,_itemtodelname] call vts_shopremoveitemfrominv;player removeweapon _itemtodelname;_sell=true;};
			case ("DetectorCore" in _itemparents): {[player,_itemtodelname] call vts_shopremoveitemfrominv;_sell=true;};
			case (isclass (configFile >> "CfgGlasses" >>_itemtodelname)): {call compile "removeGoggles player;_sell=true;";};
			case (gettext (vts_shopsellitemclass >> "vehicleclass")=="BackPacks"): {call compile "removebackpack player;_sell=true;";};
			case (_itemtypeinfo==801): {call compile "if (uniform player==_itemtodelname) then {removeuniform player;} else {player removeitem _itemtodelname;};_sell=true;";};
			case (_itemtypeinfo==701): {call compile "if (vest player==_itemtodelname) then {removevest player;} else {player removeitem _itemtodelname;};_sell=true;";};
			case (_itemtypeinfo==605): {call compile "if (headgear player==_itemtodelname) then {removeheadgear player;} else {player removeitem _itemtodelname;};_sell=true;";};
			case ("ItemCore" in _itemparents): {[player,_itemtodelname] call vts_shopremoveitemfrominv;_sell=true;};
			
		  };
		  
		}
		else
		{
			//Arma 2
			_removeitem=[player,vts_shopsellitemclass] call bis_fnc_invremove;
			_sell=true;
		};
	       
    }
    else
    {
      _txt="You have nothing to sell !";
      hint _txt;
      [_txt] call vts_shopdisplaymessage;
    };
  }; 
  //Check if the player correctly sell the stuff (to avoid cash abuse bug)
  if !([true] call vts_shoprefreshplayeritems<_currentobjectscount) then 
  {
	_sell=false;
    _txt="This item can't be currently sell";
    hint _txt;
    [_txt] call vts_shopdisplaymessage;	
  };
  
  //Doing Sell work like updating the balance when the item is sell
  if (_sell) then
  {
	playsound "computer";
	_currentsellprice=vts_shopsellprice;
    _txt=format["You sell : %1 for %2 $",vts_shopsellitemname,[_currentsellprice] call vts_numbertotext];
	if ([player] call vts_getisGM) then {_txt=_txt+" (for FREE as a game master)"};
    hint _txt;
    [_txt] call vts_shopdisplaymessage; 
	
	//Update balance only if not a GM
	if !([player] call vts_getisGM) then 
	{
		_newbalance=vts_shopbalance+vts_shopsellprice;
		[vts_shopside,_newbalance] call vts_shopupdatebalance;
    };
	
    //Updating unlocks / items count
	
	if ((pa_shopunlockmethod==1) && !([player] call vts_getisGM)) then
	{
		//player sidechat format["unlock %1",vts_shopsellconfigstring];
		_itemcount=[vts_shopsellconfigstring] call vts_shopitemgetitemcount;
		_itemcount=_itemcount+1;
		//player sidechat format["num %1",_itemcount];
		[vts_shopsellconfigstring,_itemcount] call vts_shopitemsetcount;
	};

  };
  
  //Refreshing player inv
  []  call vts_shoprefreshplayeritems;
};

//Check if the vehicle can be sell
vts_shopvehiclecanbesell={
	private ["_vehicle","_canbesell"];
  _vehicle=_this select 0;
  _canbesell=false;
  
  if ((count (crew _vehicle)<1) and ((damage _vehicle)<0.6)) then 
  {
    _canbesell=true;
  };
  _canbesell;
};

//Display the balance for the player side
vts_shopdisplaybalance={
  private ["_shopside","_currentbalance","_txt"];
  _shopside=side player;
  if (!isnil "vts_shopside") then
  {
	_shopside=vts_shopside;
  };
  
  call compile format["
  if (isnil ""vts_shopbalance_%1"") then 
  {
    vts_shopbalance_%1=10000000;
    vts_shopbalance=vts_shopbalance_%1;   
  }
  else 
  {
    vts_shopbalance=vts_shopbalance_%1;  
  };
  ",_shopside];
  _currentbalance=vts_shopbalance;
  _txt=format[(([] call vts_shopsidenameandcolor) select 0)+" balance : \n\n%1 $",[_currentbalance] call vts_numbertotext]; 
  ctrlSetText [133017,_txt];
  
  //Updating GM interface
  /*
  if ([player] call vts_getisGM) then 
  {
	if (local_var_console_valid_side!="OBJECT") then
	{
		[] call vts_shopsupdategmbalancedisplay;
	};
  };
  */
};

//Update balance on all player
vts_shopupdatebalance={
	private ["_shopside","_balance"];
  _shopside=_this select 0;
  _balance=_this select 1;
  
  call compile format["vts_shopbalance_%1=%2;publicvariable ""vts_shopbalance_%1"";",_shopside,_balance];
  [] call vts_shopdisplaybalance;
};



//Get price of a class ... serisously why does some magazine have the same classname than weapon *sigh*
vts_shopgetPrice={
  private ["_class","_classname","_classcfg","_price"];
  _classcfg=_this select 0;
  if (_classcfg=="") exitwith {_price=0;_price;};
  
  _classok=false;  
  if ((count _this)<2 ) then
  {
	call compile format["_class=(configFile >> %1 );",_classcfg];
	_classname=configname _class;	
	_classok=true;
  }
  else
  {
	//In case we send directly the classname without knowing the parent from class
	_classname=_this select 1;
	if (isclass (configfile >> "CfgVehicles" >> _classname)) then {_classcfg="'CfgVehicles'>>'"+_classname+"'";_classok=true;};
	if (isclass (configfile >> "CfgMagazines" >> _classname)) then {_classcfg="'CfgMagazines'>>'"+_classname+"'";_classok=true;};
	if (isclass (configfile >> "CfgWeapons" >> _classname)) then {_classcfg="'CfgWeapons'>>'"+_classname+"'";_classok=true;};
	if (isclass (configfile >> "CfgGlasses" >> _classname)) then {_classcfg="'CfgGlasses'>>'"+_classname+"'";_classok=true;};
	call compile format["_class=(configFile >> %1 );",_classcfg];	
  };
  if !(_classok) exitwith {0;};
  
  /*
  player sidechat format["c: %1",_classcfg];
  player sidechat format["n: %1",_classname];
  player sidechat format["c: %1",_class];
  */
  //hint format["%1 & %2",_classname,_classcfg];
  _price=0;
  //Vehicles
  if (isclass (configFile >> "CfgVehicles" >> _classname)) then
  {
    _cost=getnumber (_class >> "cost");
    _armor=getnumber (_class >> "armor" );
    _speed=getnumber (_class >> "maxspeed" );
    
    _price=_cost+(_armor*15)+(_speed*15);
    if ((typename _price)!="SCALAR" ) then {call compile format["_price=%1;",_price];};
    //_price=getnumber (configFile >> "CfgVehicles" >> _class >> "cost"); 
    if (_price<500) then {_price=500;};
  };
  
  //Weapons
  if (!(isclass (_class >> "InventoryPlacements")) and (isclass (configFile >> "CfgWeapons" >> _classname))) then
  {
    //Damn i hate config bug.
    //It's a mess... trying to generate a coherant price for a weapon
    _bonus=0;
    _value=getnumber (_class>>"value");
    _maxrange=getnumber (_class>>"maxrange");
    _midrange=getnumber (_class>>"midrange");
    _dispersion=getnumber (_class>>"dispersion");
    _htmax =getnumber (_class>>"htmax");
	if (isnil "_htmax") then {_htmax=0;};
    _muzzles=getArray (_class >> "muzzles") ;
    if (count _muzzles>1) then {_bonus=_bonus+150;};
    _modeloptics=gettext(_class>>"modeloptics");
    if (_modeloptics!="-") then {_bonus=_bonus+200;};
    _type=getnumber(_class>>"type");
    //Pistol hearn more
    if (typename _type=="STRING") then {_type=0;};
    if (_type==2) then {_bonus=_bonus+500;};
    //hint format["%1 %2 %3",_value,_maxrange,_opticsflare];
    _price=((_maxrange*1.25)+(_midrange*1.75)+(_htmax*5)+_bonus+(_value*2)); 
    _price=_price/4;
    
    if ((typename _price)!="SCALAR" ) then {call compile format["_price=%1;",_cost];};
    if (isnil "_price") then {_price=250;};
    if (_price<250) then {_price=250;};
  };
  
  //Magazines
  if ((isclass (_class >> "InventoryPlacements")) and (isclass (configFile >> "CfgMagazines" >> _classname))) then
  {
    _ammo=gettext (configFile >> "CfgMagazines" >> _classname >> "ammo");
    _count=getnumber (configFile >> "CfgMagazines" >> _classname >> "count");
    _cost= getnumber (configFile >> "CfgAmmo" >> _ammo >> "cost");
    _price=_count*(_cost*1.5);
    if (isnil "_price") then {_price=500;};
    if (_price<1) then {_price=500;};
    //hint format["%1",_price];
  };
  
  //Goggles
  if (isclass (configFile >> "CfgGlasses" >> _classname)) then
  {
	_mass=getnumber (configFile >> "CfgGlasses" >> _classname >> "mass");
	_price=(_mass*75);
  };
  round (_price);
};

vts_shopitemgetitemcount=
{
	//if (true) exitwith {999;};
	private ["_initialcountallunlock","_initialcountnounlock","_gitemstring","_returnfail","_shopside","_gitemcount","_size","_index"];
	_initialcountallunlock=9999;
	_initialcountnounlock=0;
	
	_gitemstring=_this select 0;
	
	//if !((_gitemstring in ShopBackPackList) or (_gitemstring in ShopMagazineList) or (_gitemstring in ShopWeaponList)) exitwith {_gitemcount=0;_gitemcount;};
	
	_returnfail=false;
	if (count _this>1) then {_returnfail=_this select 1;};
	_shopside=vts_shopside;
	if (count _this>2) then {_shopside=_this select 2;};
	_gitemcount=-999;
	if !(isnil "_gitemstring") then
	{
		call compile format["
		

			_index=vts_shopunlocklist_%1 find _gitemstring;
			if (_index>-1) then 
			{
				_gitemcount=vts_shopunlocklist_%1 select (_index+1);
			};

			if ((_gitemcount==-999) && !(_returnfail)) then
			{
				if (vts_shopallunlocked_%1) then {_gitemcount=_initialcountallunlock;} else {_gitemcount=_initialcountnounlock;};
				
			};
		",_shopside];
	};
	_gitemcount;
};

//Check if item is locked or unlocked
vts_shoprefreshitemcountstate=
{
	private ["_onlytxt","_itemstorecount","_counttxt"];
	_onlytxt=false;
	if (count _this>0) then {_onlytxt=_this select 0;};
	if !(isnil "vts_shopbuyconfigstring") then 
	{
		_itemstorecount=[vts_shopbuyconfigstring] call vts_shopitemgetitemcount;	
		if (_itemstorecount<0) then {_itemstorecount=0;};
		if !(_onlytxt) then {ctrlSetText [133039,(str _itemstorecount)];};
		_counttxt=("In store: "+(str _itemstorecount));
		//if ([player] call vts_getisGM) then {_counttxt=_counttxt+" (Gamemaster)";};
		ctrlSetText [133037,_counttxt];
	};	
};

vts_shopitemsetcountgui=
{
	private ["_vts_shop_gmitemcount","_classname","_classcfg"];
	_vts_shop_gmitemcount=parsenumber (ctrlText 133039);
	if (count _this>0) then {_vts_shop_gmitemcount=_this select 0;};
	_classname=configname vts_shopbuyitemclass;
	_classcfg="";
	/*
	if (isclass (configfile >> "CfgVehicles" >> _classname)) then {_classcfg="'CfgVehicles'>>'"+_classname+"'";};
	if (isclass (configfile >> "CfgMagazines" >> _classname)) then {_classcfg="'CfgMagazines'>>'"+_classname+"'";};
	if (isclass (configfile >> "CfgWeapons" >> _classname)) then {_classcfg="'CfgWeapons'>>'"+_classname+"'";};
	if (isclass (configfile >> "CfgGlasses" >> _classname)) then {_classcfg="'CfgGlasses'>>'"+_classname+"'";};
	*/
	if !(isnil "vts_shopbuyconfigstring") then {_classcfg=vts_shopbuyconfigstring;};
	if (_classcfg!="") then
	{
		_txt=format["%1 count set to : %2 !",gettext (vts_shopbuyitemclass >> "displayname"),_vts_shop_gmitemcount];
		hint _txt;
		[_txt] call vts_shopdisplaymessage; 
		[_classcfg,_vts_shop_gmitemcount,false,vts_shopside] call vts_shopitemsetcount;
	};
};

//Handling lock/unlock button of the GM
vts_shopitemsetcount={
  private ["_configstring","_newvalue","_local","_shopside","_updateitemsarray"];
  //Item already in the list, update it
  _configstring=_this select 0;
  
  //hintc format["%1",_this];
  
  _newvalue=0;
  if (count _this>1) then {_newvalue=_this select 1;};
 
  _local=false;
  if (count _this>2) then {_local=_this select 2;}; 
  
  _shopside=vts_shopside;
   if (count _this>3) then {_shopside=_this select 3;}; 
  
  if (typename _shopside=="SIDE") then {_shopside=str _shopside;};
  
  _updateitemsarray=
  {
	  _string=_this select 0;
	  _value=_this select 1;
	  _shopside=_this select 2;
	  call compile format["
	  if (([_string,true,""%1""] call vts_shopitemgetitemcount)!=-999) then
	  {
		_index=vts_shopunlocklist_%1 find _string;
		
		if (_index>-1) then 
		{
			vts_shopunlocklist_%1 set [_index,_string];
			vts_shopunlocklist_%1 set [_index+1,_value];
		};
		
	  }
	  else
	  {
		vts_shopunlocklist_%1 set [count vts_shopunlocklist_%1,_string];    
		vts_shopunlocklist_%1 set [count vts_shopunlocklist_%1,_value];    
	  };

	  ",_shopside];
  };
  
  
  //Simple item updating
  if (typename _configstring=="STRING") then
  {
	call compile format["[_configstring,_newvalue,""%1""] call _updateitemsarray;",_shopside];
  };
	
  //Full list items updating
  if (typename _configstring=="ARRAY") then
  {
	for "_l" from 0 to (count _configstring)-1 do
	{
		_string=(_configstring select _l) select 0;
		_value=(_configstring select _l) select 1;
		call compile format["[_string,_value,""%1""] call _updateitemsarray;",_shopside];
	};
  };
  
  [_local] call vts_shoprefreshitemcountstate;
  //player sidechat format["%1",vts_shopunlocklist];
  if !(_local) then
  {
	call compile format["
	vts_shopunlockmodifier_%1=[_configstring,_newvalue,""%2""];
	publicvariable ""vts_shopunlockmodifier_%1"";
	",vts_shopside,([] call vts_shopsidenameandcolor) select 2];
  };
  
};


//Handling the modification of the 
vts_shopsetbalancebygm={
  private ["_side","_balance","_code"];
  _balance=0;
  _balance=parseNumber (ctrlText 133044);
  format["Balance set for %1 side",vts_shopside] spawn vts_gmmessage;
  call compile format["_side=""%1"";",([] call vts_shopsidenameandcolor) select 2];
  call compile format["vts_shopbalance_%1=%2;publicvariable ""vts_shopbalance_%1"";",_side,_balance];
 
  _code={[] call vts_shopdisplaybalance;};
  [_code] call vts_broadcastcommand; 
  
};

//Handling display of side balance on the GM interface
vts_shopsupdategmbalancedisplay={
  
  if (local_var_console_valid_side=="OBJECT") then
  {
    //ctrlShow [10046,false];
	ctrlSetText [10046,sideobjectfilter];
    
	//ctrlShow [10047,false];
    
	//ctrlShow [10048,false];
	ctrlSetText [10048,"Filter :"];
  }
  else
  {
    ctrlShow [10046,true];
    ctrlShow [10047,true];
    ctrlShow [10048,true];  
	_txtside=format["balance $"];
	ctrlSetText [10048,_txtside];
    private "_side";
    _balance=0;
    call compile format["_side=%1;",local_var_console_valid_side];
    call compile format["_balance=vts_shopbalance_%1;",_side];
    _txt=[_balance] call vts_numbertotext;
    ctrlSetText [10046,_txt];
  };
};

//Handling the shop closing (keeping track of loadout in user var
vts_shopclosed=
{
	vtsloadout = [player] call vts_getloadout;
};

vts_shopunlockall=
{
	private ["_side","_txt"];
	_side=vts_shopside;
	call compile format["
	vts_shopunlocklist_%1=[];
	publicVariable ""vts_shopunlocklist_%1"";
	vts_shopallunlocked_%1=true;
	publicVariable ""vts_shopallunlocked_%1"";
	",_side];
	_txt=format["Every items of %1 shop has been set to 9999",_side];
    hint _txt;
	playsound "computer";
    [_txt] call vts_shopdisplaymessage;  
	[] call vts_shoprefreshitemcountstate;
	["'cfgvehicles' >> 'logic'",133002] call vts_shophighlightcompatible;
};

vts_shoplockall=
{
	private ["_side","_txt"];
	_side=vts_shopside;
	call compile format["
	vts_shopunlocklist_%1=[];
	publicVariable ""vts_shopunlocklist_%1"";
	vts_shopallunlocked_%1=false;
	publicVariable ""vts_shopallunlocked_%1"";
	",_side];
	_txt=format["Every items of %1 shop has been set to 0",_side];
    hint _txt;
	playsound "computer";
    [_txt] call vts_shopdisplaymessage;  
	[] call vts_shoprefreshitemcountstate;
	["'cfgvehicles' >> 'logic'",133002] call vts_shophighlightcompatible;
};

vts_shoplocklist=
{
	private ["_shoplist","_i","_data"];
	_shoplist=(findDisplay 8004) displayCtrl 133002;
	for "_i" from 0 to (lbSize _shoplist)-1 do
	{
		_data=(_shoplist lbData _i);
		if (_data!="") then
		{
			_shoplist lbSetColor [_i,[1,0.25,0.25,1]];
			[_data,0,true,vts_shopside] call vts_shopitemsetcount;
		};
	};
	call compile format["publicVariable ""vts_shopunlocklist_%1"";",vts_shopside];
	_txt=format["Every items of current list for %1 shop has been set to 0",vts_shopside];
    hint _txt;
	playsound "computer";
    [_txt] call vts_shopdisplaymessage;  
	[] call vts_shoprefreshitemcountstate;
};

vts_shopunlocklist=
{
	private ["_shoplist","_i","_data"];
	_shoplist=(findDisplay 8004) displayCtrl 133002;
	for "_i" from 0 to (lbSize _shoplist)-1 do
	{
		_data=(_shoplist lbData _i);
		if (_data!="") then
		{
			_shoplist lbSetColor [_i,[1,1,1,1]];
			[_data,9999,true,vts_shopside] call vts_shopitemsetcount;
		};
	};
	call compile format["publicVariable ""vts_shopunlocklist_%1"";",vts_shopside];
	_txt=format["Every items of current list for %1 shop has been set to 9999",vts_shopside];
    hint _txt;
	playsound "computer";
    [_txt] call vts_shopdisplaymessage;  
	[] call vts_shoprefreshitemcountstate;
};

vts_shoploadoutimportexport_ver=1;

vts_shoploadoutimportexport=
{
	private ["_curloadout"];
	createDialog "VTS_Rscshoploadoutimportexport";
	_curloadout=[player] call vts_getloadout;
	_curloadout=["NameMe",vts_shoploadoutimportexport_ver,_curloadout];
	((findDisplay 8007) displayCtrl 20301) ctrlSetText (str _curloadout);
};

vts_shoploadoutimportexportapply=
{
	private ["_strdata","_version","_var","_type","_loadout","_name"];
	playsound "computer";
	_var=nil;
	_strdata=ctrlText ((findDisplay 8007) displayCtrl 20301);
	call compile ("_var="+_strdata+";");
	if (isnil "_var") exitwith {closedialog 8007;["ERROR : Imported Loadout data is corrupt"] call vts_shopdisplaymessage;};
	_type=typename _var;
	if (_type!="ARRAY") exitwith {closedialog 8007;["ERROR : Imported Loadout data is invalid (waiting for an ARRAY)"] call vts_shopdisplaymessage;};
	_type=typename (_var select 1);
	if (_type!="SCALAR") exitwith {closedialog 8007;["ERROR : Imported Loadout data is invalid"] call vts_shopdisplaymessage;};
	_type=(_var select 1);
	if (_type<vts_shoploadoutimportexport_ver) exitwith {closedialog 8007;["ERROR : Imported Loadout data is deprecated (you may have to update your data manually to make it compatible with the current version)"] call vts_shopdisplaymessage;};
	_loadout=_var select 2;
	_name=_var select 0;
	closedialog 8007;
	[_loadout,_name] spawn vts_shoploadoutload;
};