//Dlg_FillListBoxLists
	private ["_idc2","_DualList","_cursel"];
	
  _idc2 = _this select 0;
  _DualList = _this select 1;
  
   if (isnil "_DualList") exitwith {};
   
  _cursel=0;
  if (count _this>2) then {_cursel = _this select 2;}; 
  lbClear _idc2;
  
  if (isnil "local_var_console_valid_camp") then 
  {
	local_var_console_valid_camp=gettext (configfile >> "cfgvehicles" >> (typeof player) >> "faction");
  };
  
  {
    call compile format ["


		if (""%2_%1""==""%2_Group"" && ""%2""!=""object"") then
		{	
			if (isnil ""%2_%1"") exitwith {};
			
			_atest=%2_%1 select 0;
			if (isnil ""_atest"") then 
			{	
				_customgroups=[] call vts_gmgetactivecustomgroup;
				if (count _customgroups>0) then
				{			
					%2_%1=[nil];
				}
				else
				{
					%2_%1=nil;
				};
			};
			
		};

	
	
    if (!(isnil ""%2_%1"") )   then
    {
      if ((count %2_%1 > 0) ) then 
      {
		
			_typeName = typeName _x;
			if (_typeName == ""ARRAY"") then
			{    
			  _Item = _x select 0;
			  _Data = _x select 1;
			  
			  _index = lbAdd [_idc2, _Item];
			  lbSetData [_idc2, _index, _Data];

				if	(count _x > 2 ) then
				{
					lbSetpicture [_idc2, _index, (_x select 2)];
				};
			}
			else
			{
			  if (_typeName == ""STRING"") then
			  {
				_Item = _x;
				
				_index = lbAdd [_idc2, _Item];
			  };
			};
		
      };
    };
      ",(_x select 1),local_var_console_valid_camp];
    
  } forEach _DualList;
  
  if (_cursel>-2) then {lbSetCurSel [_idc2, _cursel];};
