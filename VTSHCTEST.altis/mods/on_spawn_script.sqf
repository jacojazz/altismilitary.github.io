//This script is executed after each spawn done by the GM interface
//_group = the group of the spawned unit(s)
//You can then run other script or manipulation on the group if needed

_group=_this select 0;
//If the spawn is not in a group (ie : a building, crates etc..) exit
if (isnull _group) exitwith {};
//Else
//player sidechat str _group;
