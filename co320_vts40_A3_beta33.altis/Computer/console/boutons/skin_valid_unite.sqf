disableSerialization;

_n = _this select 0;

skin_valid_unite = lbCurSel 10306;

_unitname=lbText [10306, skin_valid_unite]; 
_unitclass=lbdata [10306, skin_valid_unite]; 

//hint _unitclass;

if (_n == 0) then 
{

			nom_skin_valid_unite = _unitname;
			skin_unit_unite = _unitclass;
			
			
	
			_icon=getText (configFile >> "CfgVehicles" >> skin_unit_unite >> "picture"); 
			_text=getText (configFile >> "CfgVehicles" >> skin_unit_unite >> "displayName"); 
			ctrlSetText [10502,_text];
			
			//Arma 3 alpha
			_pic=getText (configFile >> "CfgVehicles" >> skin_unit_unite >> "portrait"); 
			if (_pic=="" && vtsarmaversion>2) then
			{
				_icon=getText (configFile >> "CfgVehicles" >> skin_unit_unite >> "icon"); 
				_pic=getText (configFile >> "CfgVehicleIcons" >> _icon); 
				ctrlSetText [10500,_pic];
				ctrlSetText [10501,_pic];
			}
			else
			{
				ctrlSetText [10500,_pic];
				ctrlSetText [10501,_icon];
			};
			
			
			//Constructing the class description
			_camouflage=getNumber (configFile >> "CfgVehicles" >> skin_unit_unite >> "camouflage");
			_candisablemine=getNumber (configFile >> "CfgVehicles" >> skin_unit_unite >> "candeactivatemines");
			_canhidebodies=getNumber (configFile >> "CfgVehicles" >> skin_unit_unite >> "canhidebodies");
			_detectedaccuracy=getNumber (configFile >> "CfgVehicles" >> skin_unit_unite >> "_detectedaccuracy");
			_canrepair=getNumber (configFile >> "CfgVehicles" >> skin_unit_unite >> "engineer");
			_isattendant=getNumber (configFile >> "CfgVehicles" >> skin_unit_unite >> "attendant");
			_infotext="";
			_bodyarmor=getNumber (configFile >> "CfgVehicles" >> skin_unit_unite >> "HitPoints" >> "HitBody" >> "Armor");
			_legarmor=getNumber (configFile >> "CfgVehicles" >> skin_unit_unite >> "HitPoints" >> "HitLegs" >> "Armor");	
			//Add Arma 3 items armor value 
			if (vtsarmaversion>2) then
			{
				_equipments=getarray (configFile >> "CfgVehicles" >> skin_unit_unite >> "linkeditems");
				{
					_bodyarmor=_bodyarmor+getNumber (configFile >> "CfgWeapons" >> _x >> "ItemInfo" >> "armor");
				} foreach _equipments;
			};
			_infotext=_infotext+"Body armor : "+str(_bodyarmor+_legarmor);
			_infotext=_infotext+"<br/>Stealth : "+str(100-((_camouflage*100)/2.5))+" %";
			_infotext=_infotext+"<br/><br/>Special traits :";
			
			_infotraits="";
			if (_canhidebodies==1) then {_infotraits=_infotraits+"<br/>Special Force - can hide bodies";};
			if (_candisablemine==1) then {_infotraits=_infotraits+"<br/>Explosive expert - can disarm explosives";};
			if (_canrepair==1) then {_infotraits=_infotraits+"<br/>Engineer - can repair vehicles";};
			if (_isattendant==1) then {_infotraits=_infotraits+"<br/>Attendant - can fully heal others";};
			
			if (_infotraits=="") then {_infotraits="<br/>None";};
			_infotext=_infotext+_infotraits;
			
			//Weapons
			_weapons=getarray (configFile >> "CfgVehicles" >> skin_unit_unite >> "weapons"); 

			_weaponsname="";
			_weaponsicon="";
			for "_i" from 0 to (count _weapons)-1 do
			{
				_weapon=_weapons select _i;
				_wicon="";
				_wicon=gettext (configFile >> "CfgWeapons" >> _weapon >> "picture");
				if (_wicon !="") then {_weaponsicon=_weaponsicon+"<img size='2.5' image='"+_wicon+"'/>";};
				_wname="";
				_wname=gettext (configFile >> "CfgWeapons" >> _weapon >> "displayname");
				
				if ((_wname !="") && (getnumber (configFile >> "CfgWeapons" >> _weapon >>"scope")>1)) then {if (_weaponsname!="") then {_weaponsname=_weaponsname+" + ";};_weaponsname=_weaponsname+_wname;};
				
			};
			_infotext=_weaponsicon+"<br/>"+_weaponsname+"<br/>"+_infotext;

			((finddisplay 8003) displayctrl 10504) ctrlSetstructuredText (parsetext _infotext);
};

If (true) ExitWith {};
