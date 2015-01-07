disableSerialization;
if  (breakclic <= 1 ) then
{
	clic1 = false;

	_display = finddisplay 8000;
	_txt = _display displayctrl 200;

	_txt CtrlSetText "Left click on the map";
	_txt CtrlSetTextColor [0.9,0.9,0.9,1];

	Ctrlshow [200,true];sleep 0.2; CtrlShow [200,false];sleep 0.2;Ctrlshow [200,true];

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
				_marker_Take = createMarkerLocal ["Takemarker",[spawn_x,spawn_y,spawn_z]];
				_marker_Take setMarkerShapeLocal "ELLIPSE";
				//		_marker_Take setMarkerTypeLocal "mil_Dot";
				_marker_Take setMarkerSizeLocal [radius, radius];
				_marker_Take setMarkerDirLocal 0;
				_marker_Take setMarkerColorLocal "Colorgreen";
				_marker_Take setMarkerAlphaLocal 0.5;
				
				/// ***************************************
				/// *********** CODE HERE *****************
				/// ***************************************
				private "_class";
				_list = nearestObjects  [[spawn_x,spawn_y,spawn_z],["CAManBase"],radius];
				if (count _list>0) then
				{
					//Some men found, let's build the weapons array
					_weapons=[];
					_vests=[];
					{
						call compile format ["_class=(ConfigFile >> %1);",_x];
						
						if (((getnumber (_class >> "scope"))>1) &&  ((getnumber (_class >> "type"))==1)) then
						{							
							_weapons set [count _weapons,(configname _class)];

						};
										
					}
					foreach ShopWeaponList;
					{
						call compile format ["_class=(ConfigFile >> %1);",_x];
						if (((getnumber (_class >> "scope"))>1) &&  ((getnumber (_class >> "ItemInfo" >> "Type"))==701)) then
						{
							if ([(configname _class)] call vts_islandequipment) then
							{
							_vests set [count _vests,(configname _class)];
							};
						};	
					}
					foreach ShopGearList;
					//player sidechat format["%1",_weapons];
					_num=0;
					_weaponsadded=[];
					for "_i" from 0 to ((count _list)-1) do
					{
						_unit=_list select _i;
						_side=false;
						call compile format["_side=(side _unit==%1);",var_console_valid_side];
						if (_side) then
						{
							_num=_num+1;
						};
					};
					if (_num>0) then 
					{
						//Lets add the same weapon for everyone in the area
						if (weaponvalid=="Random") then
						{
							_weapons=[_weapons select (floor(random (count _weapons)))];
						}
						else
						{
							_weapons=[weaponvalid];
						};
						_vests=[_vests select (floor(random (count _vests)))];
						//Arma 2 compatibility (no vests in A2)
						if (vtsarmaversion<3) then {_vests=[];};						
						_newweapon=_weapons select 0;
						_weaponsadded set [count _weaponsadded,gettext (Configfile >> "CfgWeapons" >> _newweapon >> "displayname")];
						//Then launching the broadcast addweapon	
						_code={};
						call compile format["
						_code={[%1,%2,%3,%4,%5] call vts_randomizeweapon;};
						",[spawn_x,spawn_y,spawn_z],_weapons,_vests,var_console_valid_side,radius];
						[_code] call vts_broadcastcommand;
						hint format["%1 Unit(s) modified with random primary weapon : %2",_num,_weaponsadded];
					}
					else
					{
						hint "!!! No units found from the selected Side !!!";
					};
				}
				else
				{
					hint "!!! No units found !!!";
				};
				
				sleep 0.25;
				deletemarker "Takemarker";
			};
			

		}; 
		sleep 0.5;
		clic1 = false;
		//"" spawn vts_gmmessage;
		breakclic = 0; 
		//	waitUntil {(clic1)};
};
If (true) ExitWith {};
