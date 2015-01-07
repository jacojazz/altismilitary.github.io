if !(hasinterface) exitWith {};
if (!(isnil "vts_gesture_keydown") or !(isnil "vts_gesture_keyup")) exitwith {};

//sleep 1.0;
waitUntil {!(isnull (findDisplay 46))};

VTS_GESTURE_KEY_BIND=41;
VTS_GESTURE_SHIFT_BIND=false;
VTS_GESTURE_CTRL_BIND=false;
VTS_GESTURE_ALT_BIND=false;

VTS_GESTURE_DIALOG="vts_m_gesture_rose";

vts_gesture_play=
{
	_gesture=_this select 0;
	player playactionnow _gesture;
	if ((leader group player)==player) then
	{
		switch (true) do
		{
			case (_gesture=="gestureFreeze"):
			{		
				{dostop _x} foreach units group player;	
			};
			case (_gesture=="gestureFollow"):
			{		
				{_x dofollow player} foreach units group player;	
			};		
			case (_gesture=="gestureCeaseFire"):
			{		
				{_x setbehaviour "aware"} foreach units group player;	
			};	
			case (_gesture=="gestureCover"):
			{		
				{_x setbehaviour "combat"} foreach units group player;	
			};	
			case (_gesture=="gestureGo"):
			{		
				{
					_x domove (player modelToWorld [-25+(random(50)),50+(random 10),0]);
				} foreach units group player;	
			};		
			case (_gesture=="gesturePoint"):
			{
				//Make half the group look at the direction, the other behind and side looking
				_units=units group player;
				_unitscount=count _units;
				_look=0;
				for "_i" from 0 to (_unitscount-1) do
				{
					if ((_i+1)<=(round(_unitscount/2))) then 
					{
						(_units select _i) dowatch (player modelToWorld [0,100,0]);
					}
					else
					{
						
						if (_look==0) then {(_units select _i) dowatch (player modelToWorld [-100,0,0]);};
						if (_look==1) then {(_units select _i) dowatch (player modelToWorld [100,0,0]);};
						if (_look==2) then {(_units select _i) dowatch (player modelToWorld [0,-100,0]);};
						_look=_look+1;
						if (_look>2) then {_look=0;};
						
					};	
				};
			};			
		};
	};
};

vts_gesture_keydown=(findDisplay 46) displayAddEventHandler ["KeyDown","
if ((_this select 1)==VTS_GESTURE_KEY_BIND && (isnil 'vts_gesture_rose_open')) then 
{
	_shift=true;
	_ctrl=true;
	_alt=true;
	if (_this select 2) then
	{
		if !(VTS_GESTURE_SHIFT_BIND) then {_shift=false;};
	}
	else
	{
		if (VTS_GESTURE_SHIFT_BIND) then {_shift=false;};
	};
	if (_this select 3) then
	{
		if !(VTS_GESTURE_CTRL_BIND) then {_ctrl=false;};
	}
	else
	{
		if (VTS_GESTURE_CTRL_BIND) then {_ctrl=false;};
	};
	if (_this select 4) then
	{
		if !(VTS_GESTURE_ALT_BIND) then {_alt=false;};
	}
	else
	{
		if (VTS_GESTURE_ALT_BIND) then {_alt=false;};
	};
	if (_shift && _ctrl && _alt) then
	{
		vts_gesture_rose_open=true;
		vts_selected_gesture='';
		_dialog=createdialog VTS_GESTURE_DIALOG;
		setMousePosition [0.5,0.5];
	};
};"
];
vts_gesture_keyup=(findDisplay 46) displayAddEventHandler ["KeyUp","
if ((_this select 1)==VTS_GESTURE_KEY_BIND) then 
{
	_shift=true;
	_ctrl=true;
	_alt=true;
	if (_this select 2) then
	{
		if !(VTS_GESTURE_SHIFT_BIND) then {_shift=false;};
	}
	else
	{
		if (VTS_GESTURE_SHIFT_BIND) then {_shift=false;};
	};
	if (_this select 3) then
	{
		if !(VTS_GESTURE_CTRL_BIND) then {_ctrl=false;};
	}
	else
	{
		if (VTS_GESTURE_CTRL_BIND) then {_ctrl=false;};
	};
	if (_this select 4) then
	{
		if !(VTS_GESTURE_ALT_BIND) then {_alt=false;};
	}
	else
	{
		if (VTS_GESTURE_ALT_BIND) then {_alt=false;};
	};
	if (_shift && _ctrl && _alt) then
	{
		vts_gesture_rose_open=nil;
		closeDialog 1337001;
		if (vts_selected_gesture!='') then 
		{
			[vts_selected_gesture] call vts_gesture_play;
		};
	};
};
"];