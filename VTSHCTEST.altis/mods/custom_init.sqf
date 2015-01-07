//This script is executed by everybody (server included) when the mission is entering the briefing or when the player is JIP
//player sidechat "Entering the briefing";
//You can find out if player is JIP or not with this var :  T_JIP (True or False)
//if (T_JIP) then {hint "I'm a machine joining after the briefing, the mission has already been launched since X time";}:


//Generate basee spawn position (let on one if you want to use the mission on any world)
//If set to false, the Respawn_West, Respawn_East, Respawn_Guerilla and Respawn_Civilian markers will be the initial static spawn for each side.
//(So If you want to put the west base always on an airpot turn the generation off and drag the respawn_west marker in the mission editor to the airport)
vts_generate_spawn_position=true;

//Fastrope
vts_FastRopeEnabled=true;
vts_FastRopeLength=25;

//Helicopter Lifting
vts_HelicopterLiftEnabled=true;
//Helictoper lift weight check (if false anything can be carried ie : Tank)
vts_HelicopterLiftWeightCheck=true;

//Freefall improvement keybinding (Dive faster / Slower)
vts_FreeFallImprovement=true;


