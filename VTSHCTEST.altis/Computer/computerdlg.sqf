//Dlg_FillListBoxLists
	private ["_idc2","_DualList","_cursel","_sort"];
	
  _idc2 = _this select 0;
  _DualList = _this select 1;
  
  if (isnil "_DualList") exitwith {};
  
  _cursel=0;
  if (count _this>2) then {_cursel = _this select 2;};

  _sort=[];
  if (count _this>3) then {_sort = _this select 3;};
  
  
  lbClear _idc2;
  {
	if !(isnil "_x") then 
	{
		_typeName = typeName _x;
		if (_typeName == "ARRAY") then
		{  
		  if	(count _x > 0 ) then
		  {
		  
			_Item = _x select 0;
			_Data = _x select 1;
		  
			_index = lbAdd [_idc2, _Item];
			lbSetData [_idc2, _index, _Data];
			//third param = picture
			if	(count _x > 2 ) then
			{
				lbSetpicture [_idc2, _index, (_x select 2)];
			};
			//fourth param = tooltip
			if	(count _x > 3 ) then
			{
				//lbSetTooltip [_idc2, _index, (_x select 3)];
			};			
		  };

		  
		}
		else
		{
		  if (_typeName == "STRING") then
		  {
			_Item = _x;
			
			_index = lbAdd [_idc2, _Item];
		  };
		};
	};
  } forEach _DualList;
  if (count _sort>0) then {lbSort ((finddisplay (_sort select 0)) displayctrl (_sort select 1));};
  if (_cursel>-2) then {lbSetCurSel [_idc2, _cursel];};
