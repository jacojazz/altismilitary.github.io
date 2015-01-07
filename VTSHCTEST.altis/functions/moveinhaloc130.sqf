 if (vehicle player!=player) then {moveout player};
 sleep 0.25;
 player moveInCargo haloc130;
 haloc130 addaction ["Jump Out","mods\scripts\halojumpout.sqf"];
 clientcode=nil;
