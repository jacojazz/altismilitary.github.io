vtsgroup_retrievegroupfromstring=
{
	_grouptxt=_this select 0;
	
	_groups=allgroups;
	
	_grp=grpnull;
	for "_i" from 0 to (count _groups)-1 do
	{
		_curgroup=_groups select _i;
		{
			if (name _x==_grouptxt) then {_grp=_curgroup;};
		} foreach units _curgroup;
	};
	_grp;
};


vtsgroup_refreshgroups=
{
	sleep 0.25;
	_groups=allgroups;
	_colorsel=0;
	_countvalid=-1;
	_groupside=[];
	for "_i" from 0 to (count _groups)-1 do
	{
		_curgroup=_groups select _i;
		//&& (isplayer leader _curgroup)
		if ((side _curgroup==side player) && (isplayer leader _curgroup)) then
		{
			if (({alive _x} count units _curgroup)>0) then
			{
				_groupside set [count _groupside,[format["%1",_curgroup]+" : "+name leader _curgroup,name leader _curgroup]];
				_countvalid=_countvalid+1;
				if (_curgroup==group player) then {_colorsel=_countvalid;};
				
			};
		};
	};
	//player sidechat format["%1",_groupside];
	[1500,_groupside] call Dlg_FillListBoxLists;
	//systemchat str _colorsel;
	if (_countvalid>-1) then {lbSetColor [1500,_colorsel,[0,1,0,1]];};
	if (count _this>0) then 
	{
		_index=_this select 0;
		lbSetCurSel [1500,_index];
	};
	
};

vtsgroup_joingroup=
{
	if (group player==vtsgroupselected) exitwith {hint "!!! Group : You are already in this squad !!!";};
	if ((isnull vtsgroupselected) or ((count units vtsgroupselected)<1)) exitwith {hint "!!! Squad : The squad is no more valid !!!";};
	if (({alive _x} count units vtsgroupselected)<1) exitwith {hint "!!! Squad : The squad is no more valid !!!";};
	
	_currentgroup=group player;
	[player] joinsilent vtsgroupselected;
	deletegroup _currentgroup;
	player assignteam "MAIN";
	hint format["Squad : You joined %1, in %2 squad",name (leader vtsgroupselected),format["%1",vtsgroupselected]];
	_timing=
	{
	_currentgroup=_this select 0;
	_time=time+5;
	waituntil {((group player)!=_currentgroup) or (time>_time)};		
	[vtsgroupselection] spawn vtsgroup_refreshgroups;
	};
	[_currentgroup] spawn _timing;
};

vtsgroup_leadgroup=
{
	if ((count units group player<2) or (leader group player==player)) exitwith {hint "!!! Squad : You are already leading. !!!";};
	
	_code={(group _this) selectleader _this;};

	[_code,player] call vts_broadcastcommand;
	
	
	_timing=
	{
	hint format["Group : You are now leader of %1 group.",group player]; 
	_time=time+5;
	waituntil {((leader player)==player) or (time>_time)};	
	[vtsgroupselection] spawn vtsgroup_refreshgroups;
	};
	[] spawn _timing;
};

vtsgroup_leavegroup=
{
	if (count units group player<2)  exitwith {hint "!!! Squad : You can't leave your own squad. !!!";};
	_currentgroup=group player;
	_newgroup=creategroup side group player;
	[player] joinsilent _newgroup;
	deletegroup _currentgroup;
	player assignteam "MAIN";
	hint format["Squad : You LEFT %1 squad.",name (leader vtsgroupselected)]; 
	_timing=
	{
	_currentgroup=_this select 0;
	_time=time+5;
	waituntil {(group player!=_currentgroup) or (time>_time)};
	[vtsgroupselection] spawn vtsgroup_refreshgroups;
	};
	[_currentgroup] spawn _timing;

};

vtsgroup_getteamcolor=
{
	_unit=_this select 0;
	_color=[1,1,1,1];
	_curteam=assignedteam _unit;
	switch (true) do
	{
		case (_curteam=="RED") : {_color=[1,0.6,0.6,1];};
		case (_curteam=="GREEN") : {_color=[0.6,1,0.6,1];};
		case (_curteam=="BLUE") : {_color=[0.6,0.6,1,1];};
		case (_curteam=="YELLOW") : {_color=[1,1,0.6,1];};
	};
	_color;
};

vtsgroup_jointeam=
{
	_c=_this select 0;
	_code={(_this select 0) assignteam (_this select 1);};
	[_code,[player,_c]] call vts_broadcastcommand;
	hint format["Squad : You joined %1 team of %2 squad",_c,group player];
	[] spawn vtsgroup_refreshgroups;
};

vtsgroup_selectgroup=
{
	_display = finddisplay 8005;
	_dialogtxt = _display displayctrl 1100;
	
	_grpindexselect=lbCurSel 1500;
	_grpdataselect=lbData [1500,_grpindexselect];
	
	_grp=[_grpdataselect] call vtsgroup_retrievegroupfromstring;
	
	if (isnull _grp) exitwith {_dialogtxt CtrlSetText "No Squad selected";};

	vtsgroupselection=_grpindexselect;
	vtsgroupselected=_grp;
	
	
	//Update text info
	_grpunits=[];
	{
		if (_x!=leader _grp) then {_grpunits set [count _grpunits,_x];};
	} foreach units _grp;
	_colorarray=[[],[]];
	_txt=[];
	_txt=_txt+[format ["%1",_grp]+" : "+str(count units _grp)+" member(s)"]+[""];
	
	//Leader a top of the list
	_col=[leader _grp] call vtsgroup_getteamcolor;
	_txt=_txt+[(rank leader _grp)+" "+(name leader _grp)];
	_colorarray=_colorarray+[_col];
	_class=gettext (configfile >> "CfgVehicles" >> (typeof leader _grp) >> "Displayname");
	if (_class!="") then 
	{
		_txt=_txt+[_class];
		_colorarray=_colorarray+[_col];
	};
	_txt=_txt+[""];	
	_colorarray=_colorarray+[[]];
	
	{
		if (alive _x) then
		{
			_col=[_x] call vtsgroup_getteamcolor;
			_txt=_txt+[(rank _x)+" "+(name _x)];
			_colorarray=_colorarray+[_col];
			_class=gettext (configfile >> "CfgVehicles" >> (typeof _x) >> "Displayname");
			if (_class!="") then 
			{
				_colorarray=_colorarray+[_col];
				_txt=_txt+[_class];
			};
			_txt=_txt+[""];
			_colorarray=_colorarray+[[]];
		};
	} foreach _grpunits;
	
	//Evalute display of group button
	ctrlShow [1600,true];
	ctrlShow [1601,true];
	ctrlShow [1602,true];
	
	ctrlShow [1604,true];
	ctrlShow [1605,true];
	ctrlShow [1606,true];
	ctrlShow [1607,true];
	ctrlShow [1608,true];
	
	//Join
	if (_grp==group player) then 
	{
			ctrlShow [1600,false];
	};
	//Takelead
	if ((_grp!=group player) or (count units _grp<2) or (leader _grp==player && count units _grp>1)) then
	{
			ctrlShow [1601,false];
	};
	
	//Leave group
	if (((leader _grp==player) && (count units _grp<2)) or (_grp!=group player)) then
	{
			ctrlShow [1602,false];
			
			ctrlShow [1604,false];
			ctrlShow [1605,false];
			ctrlShow [1606,false];
			ctrlShow [1607,false];
			ctrlShow [1608,false];
	};
	
	
	[1100,_txt] call Dlg_FillListBoxLists;
	
	for "_i" from 0 to (count _colorarray)-1 do
	{
		_c=_colorarray select _i;
		if ((count _c)>0) then
		{
			lbSetColor [1100,_i,_c];
		};
	};	
	//_dialogtxt CtrlSetText _txt;
};

vtsgroup_opendialog=
{
	createdialog "vts_rscgroup";
	[] spawn vtsgroup_refreshgroups;
};
