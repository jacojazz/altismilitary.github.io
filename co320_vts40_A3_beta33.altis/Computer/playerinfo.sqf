//Handle: spawned, when the resource "HUD" is loaded
hOnLoadHUD =
{
	// root display
	_dspl = _this;
	// map control
	_ctrlMap = _dspl displayCtrl 515201;
	// text control
	_ctrlText = _dspl displayCtrl 515202;

	// initializing local marker
	_ctrlMarker = createMarkerLocal[format["Marker%1%2",name player,round(random 1000)],getpos player];
	_ctrlMarker setMarkerShapeLocal "ICON";
	_ctrlMarker setMarkerTypeLocal "mil_ARROW";
	_ctrlMarker setMarkerSizeLocal [.4,.5];
	_ctrlMarker setMarkerColorLocal "ColorBlack";

	// while display is active
	while{!isnull _dspl}do
	{
		// initializing text for text control
		_text = "";
		_text = _text + format ["Name: %1",name player] + "<br />";
		_text = _text + format ["AnimationState: %1",AnimationState vehicle player] + "<br />";
		_text = _text + format ["Damage: %1",getdammage vehicle player] + "<br />";
		_text = _text + format ["Position: %1",getpos vehicle player] + "<br />";
		_text = _text + format ["Direction: %1",getdir vehicle player] + "<br />";
		_text = _text + format ["NearestBuilding: %1",nearestbuilding vehicle player] + "<br />";
		_text = _text + format ["NearestObjects: %1",nearestobjects [player,[],1]] + "<br />";
		_text = _text + format ["NearTargets: %1",player nearTargets 100] + "<br />";
		_text = _text + format ["Speed: %1",speed vehicle player] + "<br />";
		_text = _text + format ["SizeOf: %1",sizeof (typeof vehicle player)] + "<br />";
		_text = _text + format ["SurfaceType: %1",surfaceType (getpos vehicle player)] + "<br />";
		_text = _text + format ["VectorDir: %1",VectorDir vehicle player] + "<br />";
		_text = _text + format ["VectorUp: %1",VectorUp vehicle player] + "<br />";
		_text = _text + format ["Velocity: %1",Velocity vehicle player] + "<br />";
		_text = _text + format ["Weapons: %1",weapons vehicle player] + "<br />";
		_text = _text + format ["WeaponDirection: %1",(vehicle player)weapondirection((weapons (vehicle player))select 0)] + "<br />";

		// parse text and set it to the text control
		_ctrlText ctrlSetStructuredText parseText _text;

		// map control animation
		_ctrlMap ctrlMapAnimAdd [0,(speed vehicle player)/200,getpos vehicle player];
		ctrlMapAnimCommit _ctrlMap;
		_ctrlMarker setmarkerpos getpos vehicle player;
		_ctrlMarker setmarkerdir getdir vehicle player;

		// pause
		sleep .05;
	};

	// when display is not active anymore, delete local marker
	deletemarkerlocal _ctrlMarker;

	// reload the resource "HUD" (= automaticly restarting this handle)
	titleRSC["HUD","PLAIN"];
};

// first load of resource "HUD"
titleRSC["HUD","PLAIN"];
if (true) exitWith {};