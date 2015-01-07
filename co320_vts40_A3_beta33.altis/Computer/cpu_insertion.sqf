if (local server) then {

deletevehicle insertion ;
deleteMarker "marqueur_insertion" ;
insertion = vts_emptyhelipad createVehicle [destination2_x,destination2_y ,destination2_z] ; 
markerobj2 = createMarker["marqueur_insertion",position insertion] ; 
markerobj2 setMarkerShape "ICON" ; 
"marqueur_insertion" setMarkerType "mil_Dot" ; 
"marqueur_insertion" setMarkerText "Insertion" ; 
"marqueur_insertion" setMarkerColor "ColorBlue"; 
base = true ;
insertion_ok = true ; 
publicvariable "insertion_ok";
publicvariable "base";

};
if (true) exitWith {};