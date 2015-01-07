moveOnLHD = 
{
  _unit = _this select 0;
  _lhdpos = LHDPOS;
  _unit setPosASL [(_lhdpos select 0), (_lhdpos select 1), (_lhdpos select 2)+15.9];
 };

{
  if (isPlayer _x and getposASL _x select 2 < 2) then {[_x] call moveOnLHD;hint "Back on carrier";};
}forEach _this;
