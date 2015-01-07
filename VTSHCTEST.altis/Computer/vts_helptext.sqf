private "_txt";
_txt=("The VTS mission include some functions that Game Masters  can use to improve the mission interactivity.<br/>  
Many functions require an object as argument, the argument can be the var name of a spawned object or the object himself (referenced as _spawn).<br/>  
They can be run on unit spawning via the ""Script : none"" droplist or added after spawn via the command line or the property panel.<br/>  
<br/>  
[_spawn] call vts_isPickable;<br/>  
 <br/>  
Can be used on any kind of object, the object will be pickable. If a player pick it up, the GM and players will be notified.<br/>  
 <br/>  
[_spawn] call vts_isHostage;<br/>  
 <br/>  
Can only be used on Men kind of object, the unit will have a hostage behavior. Be carefull, if enemies spot you close to it, they could kill it. If killed the GM and players are notified. Hostage can follow players.<br/>  
 <br/>  
[_spawn] call vts_isIED;<br/>  
 <br/>  
Can be used on any kind of object, the object will explose if something too noisy come close. If a player disarm the device, the GM and players will be notified. <br/>  
 <br/>  
[_spawn] call vts_isTarget;<br/>  
 <br/>  
Can be used on any kind of object, it the object is destroyed, the GM and players will be notified.<br/>  
 <br/>  
[_spawn] call vts_isVIP;<br/>  
 <br/>  
Can be used only on Men kind of object. If the object is kill, the GM and players will be notified. VIP can follow players.<br/>  
 <br/>  
[_spawn] call vts_isVIPtoCapture;<br/>  
 <br/>  
Can be used only on Men kind of object. The unit will shoot and fight enemies, if the enemy is outnumbering him, he will surrender and turn into a captured VIP. If the object is kill, the GM and players will be notified. VIP can follow players.<br/>  
 <br/>  
[_spawn] call vts_isSabotagable;<br/>  
 <br/>  
Can be used on any kind of object. If the object is sabotaged, it will lose 75% of its health and the GM and players will be notified.<br/>  
 <br/>  
[_spawn] call vts_isTransportTaxi;<br/>  
  <br/>  
Can only be used on Land / Helicopter / Ship vehicle, with AI driver. It will make the vehicle available to carry on player to a destination of their choice. Once everyone is unloaded, it will go back to base and wait for a call.<br/>  
<br/>   
[_spawn,""A clue""] call vts_isClue;<br/>  
 <br/>  
Can be used on any kind of object, the object will become interactive to players. Player activating the object will receive the associated clue text as a display pop-up.<br/>  
 <br/>  
[_spawn] call vts_isMovable;<br/>  
 <br/>  
Can be used on any kind of object, the object will become movable by players. Movable Objects can be loaded In/Out of vehicles (can be used to simulate cargo retrievable). <br/>  
 <br/>  
[_spawn] call vts_isStealableUniform;<br/>  
 <br/>  
Can be used only on Men kind of object. When the target die the uniform can be looted by a player, allowing him to impersonate the target toward target friendlies AIs. Player can then lost his disguise if staying too close to enemies or acting suspiciously.<br/>  
 <br/>  
[_spawn,1500] call vts_isParachuted; <br/>  
 <br/>  
Can be used on any kind of object. Teleport the object to the specified altitude and bind it an auto opening parachute/vehicle parachute (depending of the weight of the object). Players don't receive the auto opening parachute.<br/>  
 <br/>  
[_spawn,10000] call vts_IsNavigableCargoHalo;<br/>  
 <br/>  
Can be used on any kind of vehicle/object you can walk on/inside. When a leader walk in, he will have an action to choose the destination. Doing so the target and all its passengers will be teleported to the destination at the specified height (eg: 10000). After all passengers gone, the target will then return to its initial position.<br/>  
 <br/>  
[_spawn,10000] call vts_setHeight;<br/>  
 <br/>  
Can be used on any kind of object. Define the height position to teleport the target.<br/>  
 <br/>  
[_spawn,WEST] call vts_isShop; <br/>  
 <br/>  
Can be used on any kind of object. Players will have the action to open the shop of the specified side, if a side is specified (eg: WEST,EAST,RESISTANCE,CIVILIAN) or a custom shop if a string is specified (eg: ""custom"",""Support""). GMs can then edit shops of the different types.<br/>  
 ");
 _txt;