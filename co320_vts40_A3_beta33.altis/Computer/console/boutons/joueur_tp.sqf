// joueur_tp.sqf

_n = _this select 0;
_bidule = true ;
_pid=lbData [10297,(lbCurSel 10297)];

if (_n == 0) then 
{

local_joueursolo_telep=_pid;
		
};

if (_n == 1) then 
{
  _MydualList2=[];
  _n=1;
 
  while {_n<=(count vts_player_list)} do
  {
    _name="";
    _player=objnull;
    call compile format["if !(isnil ""user%1"") then {_name=name user%1;_player=user%1;};",_n];
    if (_name=="Error: No unit") then {_name=""};
    if (_name=="Error: No vehicle") then {_name=""};
    if (!isnull _player) then
    {
      if (((getpos _player) select 0)<0 and ((getpos _player) select 1)<0) then {_name=""};
      if (!alive _player) then {_name=""};
    };
    if (_name!="") then 
	{
		call compile format["_MydualList2 set [count _MydualList2,[""user%1  %2"",""user%1""]];",_n,_name];
	};
     
     _n=_n+1;
  };
  if !(isnil "HC_AI") then
  {
	if !(isnull HC_AI) then {_MydualList2 set [count _MydualList2,["HC_AI  HeadLess client","HC_AI"]];};
  };
  [10297, _MydualList2] spawn Dlg_FillListBoxLists;
};
	
//ctrlSetText [10295,code_joueurX]; 
//ctrlSetText [10297,nom_joueurX]; 
if (true) exitWith {};
