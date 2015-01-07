
//Run Undead mod config ?
if (isClass (configFile >> "CfgPatches" >> "CHN_Undead")) then
{
  UNDEADMOD=true;
  //CHN_UNDEAD_MAINSCOPE = server; _script = _this execVM '\CHN_UNDEAD\scripts\UNDEAD_MODULE_INIT.sqf'; waituntil {scriptdone _script};
  //CHN_UNDEAD_MAINSCOPE = server; _script = _this execVM '\CHN_UNDEAD\scripts2\UNDEAD_MODULE_INIT.sqf'; waituntil {scriptdone _script};
};
