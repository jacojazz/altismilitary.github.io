_dist = 10;
vts_3dpreview=true;
//if ((var_console_valid_type == "Statique") or (var_console_valid_type == "Groupe")) then
//{
//}else{

			//Detecting if the camera is still active
			if (!vts_stopcam) then
			{
				vts_fromfreecam=true;
				_pos=screenToWorld[0.5,0.5];
				spawn_x=position VTS_Freecam select 0;
				spawn_y=position VTS_Freecam select 1;
				vts_cameraheight=position VTS_Freecam select 2;
				rot_y=direction VTS_Freecam;
				vts_cameravectorup=[VectorDir VTS_FreeCam,VectorUp VTS_FreeCam];
				vts_stopcam=true;
				cutText ["","BLACK FADED",0.02]
			};			
			sleep 0.1;
			
			_preview_unit = local_console_unit_unite createVehicleLocal [100,100,0];
			_preview_unit setpos [getPos _preview_unit select 0, getPos _preview_unit select 1, 10000];
			
			_distX=(((boundingBox _preview_unit) select 1) select 0)-(((boundingBox _preview_unit) select 0) select 0)+1;
			_distY=(((boundingBox _preview_unit) select 1) select 1)-(((boundingBox _preview_unit) select 0) select 1)+1;
			_distZ=(((boundingBox _preview_unit) select 1) select 2)-(((boundingBox _preview_unit) select 0) select 2)+1;
			_dist=_distZ;
			if (_distY>_dist) then {_dist=_distY};
			if (_distX>_dist) then {_distX=_distY};
			
			_cam_target = _preview_unit;
			preview_cam = "camera" CamCreate [(getPos _cam_target select 0)+_dist, (getPos _cam_target select 1)+_dist, (getPos _cam_target select 2)+_dist/2];
			preview_cam CamSetTarget _cam_target;
			preview_cam CameraEffect ["INTERNAL","Back"];
			preview_cam CamCommit 2;
			showcinemaborder false;			
			if (daytime<7 or daytime>19) then
			{
				camUseNVG true;
			}else 
			{
				camUseNVG false;
			};
			titleText ["Press any key to leave","PLAIN DOWN",0.25];
			_keydown_any = (finddisplay 46) displayaddeventhandler ["keydown", "vts_3dpreview=false;"];
			//_mouse_any = (finddisplay 46) displayaddeventhandler ["MouseButtonDown", "vts_3dpreview=false;"];
			_preview_unit enablesimulation false;
			sleep 0.5;
			if (_preview_unit iskindof "Man") then {_preview_unit switchmove "aidlpercmstpsraswrfldnon_idlesteady01n";};
			_time=time+10;
			waituntil {!vts_3dpreview or _time<time};
			camUseNVG false;
			player switchCamera "INTERNAL";
			preview_cam CameraEffect ["Terminate","Back"];
			CamDestroy preview_cam;
			deleteVehicle _preview_unit;
			(finddisplay 46) displayRemoveEventHandler ["keydown",_keydown_any];
			//(finddisplay 46) displayRemoveEventHandler ["MouseButtonDown",_mouse_any];
			
//};
//restoring freecam
if (vts_fromfreecam) then 
{
	vts_fromfreecam=false;
	cutText ["","BLACK FADED",0.02]	;
	["VTScamtarget",objnull] call vts_checkvar;
	[VTScamtarget, [spawn_x, spawn_y ,0]] execVM "Computer\VTS_FreeCam.sqf";
};
[] execVM "Computer\cpu_dialog.sqf";
