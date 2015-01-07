_canchange=true;
if (!(isnil "vts_respawn_abletointeract") && _canchange) then {_canchange=[player] call vts_respawn_abletointeract;};
if !(_canchange) exitwith {};
[] call vtsgroup_opendialog;
