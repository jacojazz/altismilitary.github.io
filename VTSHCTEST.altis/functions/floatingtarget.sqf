if (isserver) then
{
  sleep 3;
  
  _water=surfaceIsWater getpos this;
  if (!_water) exitwith {deletevehicle this;};

  
    _boat = _this select 0;
    _boat allowDamage false;
    _boat lock true;
    
    _target1 = "TargetEpopup" createvehicle getpos _boat;
    _target1 attachTo [_boat,[-0.65,0.75,-0.25]]; 
    _target1 setdir 90;
    [_target1,1,true] execVM "functions\popuptarget.sqf";
    
    sleep 1;
    
    _target2 = "TargetEpopup" createvehicle getpos _boat;
    _target2 attachTo [_boat,[0.65,-0.75,-0.25]]; 
    _target2 setdir -90;
    [_target2,1,true] execVM "functions\popuptarget.sqf";
  
};
