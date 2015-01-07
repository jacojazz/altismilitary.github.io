
disableSerialization;

_gmable=player getVariable "GMABLE";If !([player] call vts_getisGM) then {if (isnil "_gmable") then {killscript=true;breakclic=0;};}; if (killscript) exitwith {killscript=false;};

private ["_source"];

//Début de script OnmapClick
if  (breakclic <= 1 ) then
{
	clic1 = false;

if ((nom_joueurX != "Mort") and (nom_joueurX != "")) then

{
_display = finddisplay 8000;
_txt = _display displayctrl 200;

	
_txt CtrlSetText "Left click on the map";
_txt CtrlSetTextColor [0.9,0.9,0.9,1];

	Ctrlshow [200,true];sleep 0.2; CtrlShow [200,false];sleep 0.2;Ctrlshow [200,true] ;

  //Récuperation des coordonnées de la carte
	  onMapSingleClick "
    spawn_x = _pos select 0;
		spawn_y = _pos select 1;
		spawn_z = _pos select 2;

		clic1 = true;
	  onMapSingleClick """";
     ";
	 
		for "_j" from 10 to 0 step -1 do 
		{	
		format["Click On Map %1, or wait for cancellation",_j] spawn vts_gmmessage;
    sleep 1;
    if (clic1) then
		{
				"" spawn vts_gmmessage;
				_j=0;
				joueursolo_telep=local_joueursolo_telep;
				
				_code={};
				call compile format
					["
					_code={
					if (player==%1) then 
					{
						hint ""Teleporting you... Done"";cutText ["""",""BLACK OUT"",0.5];

						sleep 0.5;
						vehicle %1 setVelocity [0,0,0];
						moveout %1;
						sleep 0.5;
						%1 setVelocity [0,0,0];
						%1 setPosasl ([[%2,%3,%4],true] call vts_SetPosAtop);
						cutText ["""",""BLACK IN"",2];
					};
					};
					
					",joueursolo_telep,spawn_x,spawn_y,spawn_z];		
				[_code] call vts_broadcastcommand;


       }; 
		};
		hint format["%1 - %2 teleported",joueursolo_telep,call compile format["name %1",joueursolo_telep]];
		clic1 = false;
};
sleep 0.25;

breakclic = 0; 							
};
if (true) exitWith {};
