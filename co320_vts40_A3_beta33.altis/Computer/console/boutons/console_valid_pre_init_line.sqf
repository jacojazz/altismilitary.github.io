disableSerialization;

_n = _this select 0;      
 
//console_valid_pre_init_line = lbCurSel 10608;

if (_n == 0) then
{
          _txt=lbText [10608,(lbCurSel 10608)];
          if (_txt=="Script : none") then {_txt="";};
          ctrlSetText[10232,_txt];
}
else
{
	_MydualList2=
      [
                ["Script : none","0","",""],
                ["[_spawn] call vts_isPickable","1","",""],
                ["[_spawn] call vts_isHostage","2",""],
                ["[_spawn] call vts_isIED","3",""],
                ["[_spawn] call vts_isTarget","4",""],
                ["[_spawn] call vts_isVIP","5",""],
				["[_spawn] call vts_isVIPtoCapture","6",""],
				["[_spawn] call vts_isSabotagable","7",""],	
				["[_spawn,""A clue""] call vts_isClue","8",""],			
				["[_spawn] call vts_isMovable","8",""],		
				["[_spawn] call vts_isStealableUniform","9",""],
				["[_spawn,1500] call vts_isParachuted","10",""],	
				["[_spawn] call vts_isTransportTaxi","11",""],
				["[_spawn,10000] call vts_IsNavigableCargoHalo","11",""],			
				["[_spawn,10000] call vts_setHeight","12",""],					
				["[_spawn,WEST] call vts_isShop","13",""],
				["[_spawn,EAST] call vts_isShop","14",""],
				["[_spawn,RESISTANCE] call vts_isShop","15",""],
				["[_spawn,CIVILIAN] call vts_isShop","16",""],
				["[_spawn,""custom""] call vts_isShop","17",""]
        ];
	_MydualList2=_MydualList2+vts_customfunctions;
 
  [10608, _MydualList2] spawn Dlg_FillListBoxLists;
  [10674, _MydualList2] spawn Dlg_FillListBoxLists;
};
