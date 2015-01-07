
disableSerialization;

_n = _this select 0;       
 
console_valid_showtexttype = lbCurSel 10932;




if (_n == 0) then
{

  vts_showtexttype=lbText [10932, console_valid_showtexttype];

}
else
{
  //Array
  _MydualList2=[
  "Typed",
  "Title Center",
  "Text Bottom Left",
  "Title Center with black screen",
  "Title Center with White screen",
  "Pop-up",
  "HQ West (West players only)",
  "HQ East (East players only)",
  "HQ Resistance (Resistance players only)",
  "HQ Civilian (Civilian players only)"];
  
  if (vtsarmaversion==3) then {_MydualList2 set [count _MydualList2,"UAV"];};

 
  if (isnil "ShowTextTypeSave") then {ShowTextTypeSave=0;};	 
  [10932, _MydualList2,ShowTextTypeSave] call Dlg_FillListBoxLists;
  
};

