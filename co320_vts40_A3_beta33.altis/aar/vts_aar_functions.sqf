if (isnil "vts_aar_init") then
{
	vts_aar_init=true;
	if (hasinterface) then
	{
		"vts_aar_broadcastedframe" addPublicVariableEventHandler {_this spawn vts_aar_broadcastplay};
	};
};

vts_aar_broadcastplay=
{
	private ["_var","_frame","_data","_markers","_time"];
	if (isnil "vts_aar_broadcastplaylastframe") then {vts_aar_broadcastplaylastframe=-1;};
	if (isnil "vts_aar_showmarker") then {vts_aar_showmarker=true;};
	_var=_this select 1;
	_frame=_var select 0;
	_data=_var select 1;
	if (_frame!=vts_aar_broadcastplaylastframe) then
	{
		vts_aar_broadcastplaylastframe=_frame;
		if (_frame>-1 && vts_aar_showmarker) then
		{
			_time=[_frame] call vts_aar_convert_secondintostring;
			hintsilent ("AAR : Playback time - "+_time);
			
			_markers=[_data] call vts_aar_drawframe;
			waituntil {sleep 0.01;((vts_aar_broadcastplaylastframe!=_frame) or !vts_aar_showmarker)};
			[_markers] call vts_aar_cleanmarkers;
		}
		else
		{
			hintsilent ("AAR : Playback has been stopped");
		};		
	};
	
};

vts_aar_getcolorfromside=
{
	private ["_side","_mcolor"];
	_side=_this select 0;
	_mcolor="ColorBlack";
	switch  (_side) do
	{
		case 0: {_mcolor="ColorRed";};
		case 1: {_mcolor="ColorBlue";}; 		
		case 2: {_mcolor="ColorGreen";};
		case 3: {_mcolor="ColorOrange";};
		case 7: {_mcolor="ColorYellow";};
	};
	_mcolor;
};

vts_aar_fireevent=
{
	private ["_o","_weapon","_dir"];
	_o=_this select 0;
	_weapon=_this select 1;
	_dir=_o weaponDirection _weapon;
	_dir=((_dir select 0) atan2 (_dir select 1));
	if (_dir<0) then {_dir=_dir+360;};
	_dir=round _dir;
	//systemchat str _dir;
	_o setvariable ["vts_aar_fired",_dir];	
};

vts_aar_captureframe=
{
	//[] call vts_perfstart;
	private ["_array","_type","_pos","_name","_dir","_side","_engage","_typeof","_count"];
	_array=[];
	{
		if (vehicle _x==_x) then
		{
			_name="";
			if (isplayer _x) then {_name=name _x;};
			_side=([side group _x] call vts_GetNumberFromSide)*100;
			if (captive _x) then {_side=300;};
			_type=_side+1;
			_pos=getposasl _x;
			_pos=[round (_pos select 0),round (_pos select 1)];
			_dir=round direction _x;
			_engage=_x getvariable ["vts_aar_fired",nil];
			if (isnil "_engage") then 
			{
				_x addeventhandler ["fired",{_this call vts_aar_fireevent;}];
				_x setvariable ["vts_aar_fired",-1];
				_engage=-1;
			};
			if (_engage>-1) then 
			{
				_x setvariable ["vts_aar_fired",-1];
			};
			_count=(count _array);
			_array set [_count,_name];
			_array set [_count+1,_type];
			_array set [_count+2,_pos];
			_array set [_count+3,_dir];
			_array set [_count+4,_engage];
		};
		
	} forEach allunits;
	{
		if (vehicle _x==_x) then
		{
			_name="";
			if (isplayer _x) then {_name=name _x;};
			_side=400;
			_type=_side+1;
			_pos=getposasl _x;
			_pos=[round (_pos select 0),round (_pos select 1)];
			_dir=round (direction _x);
			_engage=-1;
			_count=(count _array);
			_array set [_count,_name];
			_array set [_count+1,_type];
			_array set [_count+2,_pos];
			_array set [_count+3,_dir];
			_array set [_count+4,_engage];
		};
		
	} forEach alldeadmen;	
	{

		if !(_x iskindof "WeaponHolderSimulated") then
		{
			_name="";
			if (isplayer _x) then {_name=name _x;};
			if !(alive _x) then 
			{
				_side=400;
			} 
			else
			{
				_side=([side group _x] call vts_GetNumberFromSide)*100;
			};
			switch (true) do
			{
				case (_x iskindof "Car"):{_type=2;};
				case (_x iskindof "Tank"):{_type=3;};
				case (_x iskindof "StaticWeapon"):{_type=4;};
				case (_x iskindof "Helicopter"):{_type=5;};
				case (_x iskindof "Plane"):{_type=6;};
				case (_x iskindof "Ship"):{_type=7;};
				default {_type=2;};
			};
			_type=_side+_type;
			_pos=getposasl _x;
			_pos=[round (_pos select 0),round (_pos select 1)];
			_dir=round (direction _x);
			_engage=_x getvariable ["vts_aar_fired",nil];
			if (isnil "_engage") then 
			{
				_x addeventhandler ["fired",{_this call vts_aar_fireevent;}];
				_x setvariable ["vts_aar_fired",-1];
				_engage=-1;
			};
			if (_engage>-1) then 
			{
				_x setvariable ["vts_aar_fired",-1];
			};
			_count=(count _array);
			_array set [_count,_name];
			_array set [_count+1,_type];
			_array set [_count+2,_pos];
			_array set [_count+3,_dir];
			_array set [_count+4,_engage];
		};
		
		
	} forEach vehicles;	
	//[] call vts_perfstop;
	_array;
};

vts_aar_drawelemet=
{
	private ["_frame","_name","_color","_marker","_markertype","_dir","_msize","_pos2","_marker_line","_dist"];
	
	_name=_this select 0;
	_type=_this select 1;
	_pos=_this select 2;
	_dir=_this select 3;
	_engage=_this select 4;
	
	
	_msize=[0.75,0.75];
	
	_color=[floor (_type/100)] call vts_aar_getcolorfromside;
	
	_markertype="mil_dot";
	switch (_type mod 100) do
	{
		case 1 : {_markertype="mil_triangle";_msize=[0.6,1.0];};
		case 2 : {_markertype="n_inf";_msize=[0.75,1.25];};
		case 3 : {_markertype="n_armor";_msize=[0.75,1.25];};
		case 4 : {_markertype="n_mortar";_msize=[0.75,0.75];};
		case 5 : {_markertype="n_air";_msize=[0.75,1.25];};
		case 6 : {_markertype="n_plane";_msize=[0.75,1.25];};
		case 7 : {_markertype="n_unknown";_msize=[0.75,1.25];};
		default {_markertype="n_unknown";_msize=[0.75,0.75];};
	};
	_marker=createmarkerlocal ["aar"+(str diag_frameno)+(str _pos)+(str _dir),_pos];
	_marker setMarkerColorlocal _color;
	_marker setmarkertypelocal _markertype;
	if (_name!="") then 
	{
		_marker setmarkertextlocal _name;
	};
	_marker setMarkerSizelocal _msize;
	_marker setmarkerdirlocal _dir;
	
	if (_engage>-1) then
	{	
		_dist=1000;
		_pos2=[(_pos select 0) + (_dist * sin(_engage)), (_pos select 1) + (_dist * cos(_engage))];
		_marker_line = createMarkerLocal [(_marker+"fired"),_pos];
		_marker_line setMarkerShapeLocal "RECTANGLE";
		_marker_line setMarkerColorLocal _color;
		_marker_line setMarkerAlphaLocal 0.5;
		_marker_line setmarkerposlocal [((_pos select 0) + (_pos2 select 0)) / 2, ((_pos select 1) + (_pos2 select 1)) / 2];
		_marker_line setmarkerdirlocal ((_pos select 0) - (_pos2 select 0)) atan2 ((_pos select 1) - (_pos2 select 1));
		_marker_line setmarkersizelocal [2.5, (_pos distance _pos2) / 2];
		_marker_line setmarkerbrushlocal "SolidBorder";
		_marker=[_marker,_marker_line];
	};
	
	_marker;
};

vts_aar_drawframe=
{
	private ["_frame","_marker","_markersarray","_i","_element","_numofdata"];
	_frame=_this select 0;
	_markersarray=[];
	_numofdata=5;
	
	for "_i" from 0 to (count _frame)-_numofdata step _numofdata  do
	{	
		(_frame select _i);
		_marker=[_frame select (_i),_frame select (_i+1),_frame select (_i+2),_frame select (_i+3),_frame select (_i+4)] call vts_aar_drawelemet;
		if (typename _marker=="STRING") then
		{
			_markersarray set [count _markersarray,_marker];	
		}
		else
		{
			_markersarray=_markersarray+_marker;
		};
	};
	_markersarray;
};

vts_aar_ui_recordinglight=
{
	private ["_display","_ctrl"];
};

vts_aar_ui_playpauselight=
{
	private ["_display","_ctrl"];
};

vts_aar_open=
{
	vts_aar_version=1;
	createDialog "vts_aar_ui";
	if (isnil "vts_aar_recording") then {vts_aar_recording=false;};
	if (isnil "vts_aar_playing") then {vts_aar_playing=false;};
	if (isnil "vts_aar_paused") then {vts_aar_paused=false;};
	if (isnil "vts_aar_numframes") then {vts_aar_numframes=0;};
	if (isnil "vts_aar_currentframe") then {vts_aar_currentframe=0;};
	if (isnil "vts_aar_playlastframe") then {vts_aar_playlastframe=-1;};
	if (isnil "vts_aar_drawready") then {vts_aar_drawready=0 spawn {};};
	if (isnil "vts_aar_showmarker") then {vts_aar_showmarker=false;publicvariable "vts_aar_showmarker";};
	
	((finddisplay 8008) displayctrl 1611) ctrlAddEventHandler  ["MouseButtonDown","['Importing : Please wait, it may take a few minutes (game may look like to be frozen while working, it is not)'] call vts_aar_message;"];
	((finddisplay 8008) displayctrl 1610) ctrlAddEventHandler  ["MouseButtonDown","['Exporting : Please wait, it may take a few minutes (game may look like to be frozen while working, it is not)'] call vts_aar_message;"];
	
	if (vts_aar_recording) then 
	{
		ctrlSetText  [1603,"Stop recording"];
		((finddisplay 8008) displayctrl 1603) ctrlSetTextColor [1,0,0,1]; 
	};
	if (vts_aar_playing) then 
	{	
		ctrlSetText  [1601,"Pause"];
		((finddisplay 8008) displayctrl 1601) ctrlSetTextColor [0,1,0,1]; 
	};
	
	if (vts_aar_numframes>0) then
	{
		[] spawn vts_aar_update_ui_duration;
		[] spawn vts_aar_update_ui_timepos;
		[] spawn vts_aar_updatesliderpos;
	};
};

vts_aar_closedialog=
{
	closeDialog 8008;
};

vts_aar_displayframe=
{
	private ["_frame","_data","_markers"];
	_frame=_this select 0;
	_data=_this select 1;
	if (_frame!=vts_aar_playlastframe) then
	{
		vts_aar_playlastframe=_frame;
		if (_frame>-1 && vts_aar_showmarker) then
		{
			_markers=[_data] call vts_aar_drawframe;
			//systemchat ("display "+str _frame);
			waituntil {sleep 0.01;((vts_aar_playlastframe!=_frame) or !vts_aar_showmarker)};
			[_markers] call vts_aar_cleanmarkers;
		};
	};
};

vts_aar_setframe=
{
	private ["_slider","_framepos","_drawit"];
	_slider=(_this select 1);
	_slider=_slider/10;
	_framepos=floor ((vts_aar_numframes-1)*_slider);
	vts_aar_currentframe=_framepos;
	//systemchat str _framepos;
	//systemchat ((str _framepos)+" "+(str vts_aar_currentframe));
	if (!vts_aar_playing && !vts_aar_paused) then {vts_aar_paused=true;};
	if (vts_aar_playlastframe!=_framepos) then 
	{
		if !(vts_aar_showmarker) then {vts_aar_showmarker=true;publicvariable "vts_aar_showmarker";};
		if !(scriptdone vts_aar_drawready) then {vts_aar_playlastframe=-1;};
		waituntil {scriptdone vts_aar_drawready};
		//systemchat ((str _framepos)+" "+(str vts_aar_currentframe));
		
		if ((vts_aar_currentframe==_framepos) && !(!vts_aar_playing && !vts_aar_paused)) then
		{
			call compile ("if !(isnil 'vts_aar_frame_"+(str _framepos)+"') then {vts_aar_drawready=[_framepos,vts_aar_frame_"+(str _framepos)+"] spawn vts_aar_displayframe;[] spawn vts_aar_update_ui_timepos;[_framepos] spawn vts_aar_broadcastframe;};");
		};
	};
};

vts_aar_broadcastframe=
{
	private ["_curf","_frame"];
	_curf=_this select 0;
	if (isnil "vts_aar_broadcastedframe") then {vts_aar_broadcastedframe=[-1,[]];};
	if (_curf!=(vts_aar_broadcastedframe select 0)) then
	{
		call compile ("if !(isnil 'vts_aar_frame_"+(str _curf)+"') then {_frame=vts_aar_frame_"+(str _curf)+"};");
		if !(isnil "_frame") then
		{
			vts_aar_broadcastedframe=[_curf,_frame];
			publicvariable "vts_aar_broadcastedframe";
			//systemchat ("broadcast frame "+str _curf);
		};
	};
};

vts_aar_stop=
{
	["Playback broadcasting has stopped and map cleaned"] call vts_aar_message;
	vts_aar_paused=false;
	vts_aar_playing=false;
	vts_aar_playlastframe=-1;
	if (vts_aar_showmarker) then {vts_aar_showmarker=false;publicvariable "vts_aar_showmarker";};
	[] spawn vts_aar_update_ui_timepos;
	vts_aar_broadcastedframe=[-1,[]];
	publicvariable "vts_aar_broadcastedframe";
	ctrlSetText  [1601,"Play"];
	((finddisplay 8008) displayctrl 1601) ctrlSetTextColor [1,1,1,1]; 

};

vts_aar_play=
{
	private ["_sliderpos","_framepos"];
	//sliderSetPosition [1900,0];
	if (vts_aar_playing) then 
	{
		vts_aar_playing=false;
		vts_aar_paused=true;
		["Playback broadcasting has paused"] call vts_aar_message;
		ctrlSetText  [1601,"Play"];
		((finddisplay 8008) displayctrl 1601) ctrlSetTextColor [1,1,1,1]; 
	}
	else
	{
		vts_aar_playing=true;
		vts_aar_paused=false;
		if !(vts_aar_showmarker) then {vts_aar_showmarker=true;publicvariable "vts_aar_showmarker";};
		["Playback broadcasting has started"] call vts_aar_message;
		ctrlSetText  [1601,"Pause"];
		((finddisplay 8008) displayctrl 1601) ctrlSetTextColor [0,1,0,1]; 
		_sliderpos=(sliderPosition 1900)/10;	
		_framepos=floor (vts_aar_numframes*_sliderpos);
		vts_aar_currentframe=_framepos;
		if (isnil "vts_aar_playback_script") then
		{
			vts_aar_playback_script=[] spawn vts_arr_playbackloop;
		};		
		
	};	
};

vts_aar_message=
{
	private ["_txt"];
	_txt=_this select 0;
	//_txt=_txt+"\n"+(ctrltext 1006);
	hint _txt;
	ctrlSetText  [1006,_txt];	
	playsound ["computer",true];
};

vts_aar_recordbutton=
{
	if (vts_aar_recording) then 
	{
		vts_aar_recording=false;
		["Local Recording has stopped"] call vts_aar_message;
		ctrlSetText  [1603,"Start recording"];
		((finddisplay 8008) displayctrl 1603) ctrlSetTextColor [1,1,1,1]; 
	}
	else
	{
		vts_aar_recording=true;
		["Local Recording has started"] call vts_aar_message;
		ctrlSetText  [1603,"Stop recording"];
		((finddisplay 8008) displayctrl 1603) ctrlSetTextColor [1,0,0,1]; 
		if (isnil "vts_aar_recordloop_script") then
		{
			vts_aar_recordloop_script=[] spawn vts_arr_recordloop;
		};
	};
	
};

vts_aar_cleanmarkers=
{
	private ["_markers","_x"];
	_markers=_this select 0;
	{
		deleteMarkerLocal _x;
	} forEach _markers;
};

vts_aar_updatesliderpos=
{
	private ["_tpos"];
	_tpos=vts_aar_currentframe*10/(vts_aar_numframes-1);
	slidersetPosition [1900,_tpos];
};

vts_arr_playbackloop=
{
	private ["_time"];
	while {true} do
	{
		_time=floor time;
		if (vts_aar_playing) then
		{
			call compile ("if !(isnil 'vts_aar_frame_"+(str vts_aar_currentframe)+"') then {[vts_aar_currentframe,vts_aar_frame_"+(str vts_aar_currentframe)+"] spawn vts_aar_displayframe;[] spawn vts_aar_updatesliderpos;[] spawn vts_aar_update_ui_timepos;[vts_aar_currentframe] spawn vts_aar_broadcastframe;};");
			vts_aar_currentframe=vts_aar_currentframe+1;
			if (vts_aar_currentframe>(vts_aar_numframes-1)) then
			{
				vts_aar_currentframe=vts_aar_numframes;
				vts_aar_playing=false;
				ctrlSetText  [1601,"Play"];
			};
		};
		waituntil {sleep 0.1;((floor time)>_time)};
	};
};

vts_arr_recordloop=
{
	private ["_time"];
	while {true} do
	{
		_time=floor time;
		if (vts_aar_recording) then
		{
			call compile ("vts_aar_frame_"+(str vts_aar_numframes)+"=[] call vts_aar_captureframe;");
			vts_aar_numframes=vts_aar_numframes+1;
			[] spawn vts_aar_update_ui_duration;
		};
		waituntil {sleep 0.1;((floor time)>_time)};
	};
};


vts_aar_convert_secondintostring=
{
	["_time","_hour","_minute","_second","_result"];
	_time=_this select 0;
	_hour=floor(_time/3600);
	//systemchat str _hour;
	_minute=floor ((_time-(_hour*3600))/60);
	//systemchat str _minute;
	_second=(_time-(_hour*3600)-(_minute*60));
	//systemchat str _second;
	_hour=str _hour;
	_minute=str _minute;
	_second=str _second;
	
	if (count toarray _hour<2) then {_hour="0"+_hour;};
	if (count toarray _minute<2) then {_minute="0"+_minute;};
	if (count toarray _second<2) then {_second="0"+_second;};
	_result=_hour+":"+_minute+":"+_second;
	_result;
};

vts_aar_update_ui_duration=
{
	private ["_text"];
	_text=[vts_aar_numframes] call vts_aar_convert_secondintostring;
	ctrlSetText [1938,_text];
};

vts_aar_update_ui_timepos=
{
	private ["_text"];
	_text=[vts_aar_currentframe] call vts_aar_convert_secondintostring;
	ctrlSetText [1937,_text];
};

vts_aar_cleanspacefromstring=
{
	private ["_txt","_array"];
	_txt=_this select 0;
	_array=toarray _txt;
	_array=_array-[32];
	_txt=tostring _array;
	_txt;
};

vts_aar_export=
{
	private ["_filename","_i","_numframes","_l","_elements","_strnum","_curdbsize","_elementsize","_curelements","_curitem","_curframe","_numofdata","_count","_name","_type","_pos","_dir","_engage"];
	if (isnil "iniDB_version") exitwith 
	{
		["Error : iniDBI is not running, If you want to export your AAR into a file, you will need to use @iniDBI mod"] call vts_aar_message;
	};
	_filename="";
	_filename=ctrlText 1400;
	_elementsize=32;
	_dbmaxsize=8000;
	_numofdata=5;
	
	if (count _this>0) then {_filename=_this select 0;};
	if (_filename=="") exitwith 
	{
		["Error : Filename field is empty"] call vts_aar_message;
	};
	_filename=[_filename] call vts_aar_cleanspacefromstring;
	if ([_filename] call iniDB_exists) then {[_filename] call iniDB_delete;};
	["Exporting : Please wait, it may take a few minutes"] call vts_aar_message;
	_numframes=vts_aar_numframes;
	[_filename,"aar","vts_aar_numframes",_numframes] call iniDB_write;	
	[_filename,"aar","vts_aar_worldname",worldname] call iniDB_write;	
	[_filename,"aar","vts_aar_version",vts_aar_version] call iniDB_write;	
	
	for "_i" from 0 to (_numframes-1) do
	{		
		_strnum=(str _i);
		call compile ("_curframe=vts_aar_frame_"+_strnum+";");
		_elements=(count _curframe);
		
		_pnum=0;
		_curdbsize=0;
		_dbelement=0;
		_curelements=[];
		_loop=true;
		while {_loop} do
		{
			_curdbsize=_curdbsize+_elementsize;
			
			_name=_curframe select (_pnum);
			_type=_curframe select (_pnum+1);
			_pos=_curframe select (_pnum+2);
			_dir=_curframe select (_pnum+3);
			_engage=_curframe select (_pnum+4);
			
			if (_name!="") then {_curdbsize=_curdbsize+64;};
			
			if (_curdbsize>=_dbmaxsize) then
			{
				//Write current data and reinit the array
				call compile ("[_filename,'aar_frame_"+_strnum+"','vts_aar_element_"+(str _dbelement)+"',_curelements] call iniDB_write;");
				_dbelement=_dbelement+1;
				_curelements=[];
				_curdbsize=0;
			};

			_count=(count _curelements);
			
			_curelements set [(_count),_name];
			_curelements set [(_count+1),_type];
			_curelements set [(_count+2),_pos];
			_curelements set [(_count+3),_dir];
			_curelements set [(_count+4),_engage];			
			
			_pnum=_pnum+_numofdata;
			
			if (_pnum>=_elements) then 
			{
				_loop=false;
				call compile ("[_filename,'aar_frame_"+_strnum+"','vts_aar_element_"+(str _dbelement)+"',_curelements] call iniDB_write;");
				_dbelement=_dbelement+1;
			};
		};
		[_filename,("aar_frame_"+_strnum),"vts_aar_frame_elements",(_dbelement)] call iniDB_write;
		

	};
	["Success : AAR data has been exported to "+_filename+" in your @iniDBI DB folder"] call vts_aar_message;
};

vts_aar_import=
{
	private ["_filename","_numframes","_i","_worldname","_elements","_strnum","_l","_buildframe","_version"];
	if (isnil "iniDB_version") exitwith 
	{
		["Error : iniDBI is not running, If you want to Import AAR file, you will need to use @iniDBI mod"] call vts_aar_message;
	};
	_filename="";
	_filename=ctrlText 1400;
	if (_filename=="") exitwith 
	{
		["Error : Filename field is empty"] call vts_aar_message;
	};
	_filename=[_filename] call vts_aar_cleanspacefromstring;
	if !(_filename call iniDB_exists) exitwith 
	{
		["Error : No AAR data found with this Filename"] call vts_aar_message;
	};
	_version=[_filename,"aar","vts_aar_version","SCALAR"] call inidb_read;
	if (_version!=vts_aar_version) exitwith 
	{
		["Error : AAR version mismatch, or Data is corrupted"] call vts_aar_message;
	};
	["Importing : Please wait, it may takes a few minutes"] call vts_aar_message;
	_numframes=0;
	_numframes=[_filename,"aar","vts_aar_numframes","SCALAR"] call inidb_read;
	if (_numframes<1) exitwith 
	{
		["Error : Invalid AAR data found with this Filename"] call vts_aar_message;
	};
	_worldname="";
	_worldname=[_filename,"aar","vts_aar_worldname","STRING"] call inidb_read;
	if (_worldname!=worldname) exitwith 
	{
		[("Error : AAR data found has been recorded for : "+_worldname+" world, not "+worldname)] call vts_aar_message;
	};	
	for "_i" from 0 to (_numframes-1) do
	{
		_strnum=(str _i);
		_buildframe=[];
		call compile ("_elements=[_filename,'aar_frame_"+_strnum+"','vts_aar_frame_elements','SCALAR'] call inidb_read;");
		for "_l" from 0 to (_elements-1) do
		{
			//_buildframe set [count _buildframe,([_filename,("aar_frame_"+_strnum),("vts_aar_element_"+(str _l)),"ARRAY"] call inidb_read)];
			_buildframe=_buildframe+([_filename,("aar_frame_"+_strnum),("vts_aar_element_"+(str _l)),"ARRAY"] call inidb_read);
		};		
		call compile ("vts_aar_frame_"+_strnum+"=_buildframe;");
	};
	if (_numframes>vts_aar_numframes) then 
	{
		vts_aar_numframes=_numframes;
	};
	["Success : AAR data has been imported from "+_filename+" to the VTS"] call vts_aar_message;
	[] spawn vts_aar_update_ui_duration;
	[] spawn vts_aar_update_ui_timepos;
};