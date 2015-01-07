
disableSerialization;

_gmable=player getVariable "GMABLE";If !([player] call vts_getisGM) then {if (isnil "_gmable") then {killscript=true;breakclic=0;};}; if (killscript) exitwith {killscript=false;};


//Artillery Shell life
vts_artilleryshell=
{

  _shell=_this select 0;
  //hint format["%1 boom",_shell];
  _name=typeof _shell;
  _class=(configfile >> "CfgAmmo" >> _name);
  _alt=getNumber (configFile >> "CfgAmmo" >> _name >> "arty_deployaltitude");
  _deployOnImpact = getText (configFile >> "CfgAmmo" >> _name >> "ARTY_DeployOnImpact");
  _deployFlare = getText (configFile >> "CfgAmmo" >> _name >> "ARTY_DeployFlare");

  _deployNetshell = getText (configFile >> "CfgAmmo" >> _name >> "arty_netshell");
  _isSADARM = getNumber (configFile >> "CfgAmmo" >> _name >> "ARTY_SADARMShell");
  _isLaser = getNumber (configFile >> "CfgAmmo" >> _name >> "ARTY_LaserShell");  

  _incomingSounds = getArray (configFile >> "CfgAmmo" >> _name >> "ARTY_IncomingSounds");
  _soundCount = count _incomingSounds;
  _soundAlt = getNumber (configFile >> "CfgAmmo" >> _name >> "ARTY_IncomingSoundAlt");
  _soundAltError = getNumber (configFile >> "CfgAmmo" >> _name >> "ARTY_IncomingSoundAltError");
  _soundAlt = _soundAlt + (random(_soundAltError*2) - _soundAltError);
  _useSound = _incomingSounds select (floor(random(_soundCount)));
  
  _fx=gettext(_class>>"arty_trailfx");
  
  _doImpactDeploy = false;
  _isFlareShell = false;
  if (_deployOnImpact != "") then {_doImpactDeploy = true;};
  if (_deployFlare != "") then {_isFlareShell = true;};
  
  if (_fx != "") then {_fxscript = compile preprocessFileLineNumbers _fx; [_shell] call _fxscript;};

  _deployed=false;
  _down=false;
  _soundPlayed=false;
  _impact=false;
  
  waitUntil
  {
    if (!isNull (_shell)) then
    {
      _pos=getpos _shell;

      // Play sound if there are sounds configured.
      if (_soundCount > 0) then
      {
        if (!_soundPlayed && _alt < _soundAlt) then 
        {
          _shell say _useSound;
          _soundPlayed = true;
        };
      };
      
      //Deploy on height
      if (((_pos select 2) < (_alt)) and !(_deployed)) then
      {
        _deployed=true;
        //hint "deployed";
        //hint format["%1",_pos select 2];
        if (_isSADARM==1) then
        {
          //hint "sadarm";
          //_sadar = compile preprocessFileLineNumbers "\ca\modules\arty\data\scripts\ARTY_sadarmDeploy.sqf";
          //[_shell] spawn _sadar;
          [_shell] spawn BIS_ARTY_F_SadarmDeploy;
         
        };
        
        if (_isLaser==1) then
        {
          //hint "laser";
          //_laser = compile preprocessFileLineNumbers "\ca\modules\arty\data\scripts\ARTY_laserDeploy.sqf";
          //[_shell,_shell,civilian] spawn _laser;
          [_shell,_shell,civilian] spawn BIS_ARTY_F_LaserDeploy;
        };        
      
        if (_deployFlare!="") then 
        {
          //hint "Flare";
          _flare=_deployFlare createvehicle (getpos _shell);
          _flare setpos (getpos _shell);            
        };                        
          
        
      };
      
      //Deployement on impact
      if (((_pos select 2) < 1) and !(_impact)) then
      {
        //hint "grounded";
        _impact=true;
        if (_deployOnImpact!="") then 
        {
          _groundimpact=_deployOnImpact createvehicle (getpos _shell);
        };
            
      };
      
    };
       
    isnull _shell;
  };
  

};

//Artillery spawn function
_artillerylaunch={

				
        _arty=Artyvalid;
        _class=(configfile >> "CfgAmmo" >> _arty);
        _classname=configname _class;
        _thrust=getnumber(_class>>"thrust");        
        _alt=getnumber(_class>>"arty_deployaltitude");
        
        if (isnil "_alt") then {_alt=500;};

        
        _num=round(radius/10);
        if (_num<1) then {_num=1;};
        hint format["Artillery fired : %1 shells incoming",_num];
        
        for "_n" from 0 to (_num-1) do
        {
          _pos=[spawn_x-(radius/2)+random(radius),spawn_y-(radius/2)+random(radius),spawn_z+(_alt+1500)];
          
          _bullet=_classname createvehicle _pos;
          _shell=nearestObject [_pos,_classname];
          //hint format["%1",isnull _shell];
          [_shell] spawn vts_artilleryshell;
          //[_shell,(typeof _shell),server,1,false] spawn BIS_ARTY_F_shellmonitor;
          
          
          //_shell setVelocity [0, 0, (_thrust/2)*-1];
          _random=random (5);
          _random=_random+0.05;
          sleep _random;
        };

};

//Début de script OnmapClick
if  (breakclic <= 1 ) then
{
	clic1 = false;

	_display = finddisplay 8000;
	_txt = _display displayctrl 200;

	_txt CtrlSetText "Left click on the map";
	_txt CtrlSetTextColor [0.9,0.9,0.9,1];

	Ctrlshow [200,true];sleep 0.2; CtrlShow [200,false];sleep 0.2;Ctrlshow [200,true];

  //Récuperation des coordonnées de la carte
	onMapSingleClick "spawn_x = _pos select 0;
		spawn_y = _pos select 1;
		spawn_z = _pos select 2;

		
		clic1 = true;
		
	onMapSingleClick """";";
		for "_j" from 10 to 0 step -1 do 
		{
		format["Click On Map %1, or wait for cancellation",_j] spawn vts_gmmessage;
		sleep 1;
		//hint "pause";
		
			//if (_clic1) exitWith {};
			if (clic1) then
			{
				"" spawn vts_gmmessage;
				_j=0;
				clic1 = false;
				_posclick = [spawn_x,spawn_y,spawn_z];
				_marker_Take = createMarkerLocal ["Nmarker",_posclick];
				_marker_Take setMarkerShapeLocal "ELLIPSE";
				//		_marker_Take setMarkerTypeLocal "mil_Dot";
				_marker_Take setMarkerSizeLocal [radius, radius];
				_marker_Take setMarkerDirLocal 0;
				_marker_Take setMarkerColorLocal "Coloryellow";
				
        //******************************
        //***** Code come here *********
		//******************************
				
		//hint "Launching Artillery";
        [] spawn _artillerylaunch;
    		sleep 0.25;		
				

        			
				//******************************
			
      	sleep 0.5;
  			deletemarker "Nmarker";
  			//clean marker

								
			};
			clic1 = false;

	}; 
		sleep 0.5;
		//"" spawn vts_gmmessage;
		breakclic = 0; 
		//	waitUntil {(clic1)};
};
If (true) ExitWith {};
