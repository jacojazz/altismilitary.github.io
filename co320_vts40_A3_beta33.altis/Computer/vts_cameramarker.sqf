
if !(isnil "vts_cameramarker") then {deleteMarkerLocal vts_cameramarker;};

vts_cameramarker=createMarkerLocal ["vtscammarker",positionCameraToWorld [0,0,0]];
vts_cameramarker setMarkerColorLocal "ColorYellow";
vts_cameramarker setMarkerDirLocal (direction VTS_FreeCam);
vts_cameramarker setMarkerShapeLocal "icon";
vts_cameramarker setMarkerTypeLocal "mil_Start";
vts_cameramarker setMarkerSizeLocal [1,1];
vts_cameramarker setMarkerTextLocal "Camera";

while {!isnull VTS_FreeCam} do
{
	vts_cameramarker setmarkerposlocal positionCameraToWorld [0,0,0];
	vts_cameramarker setMarkerDirLocal (direction VTS_FreeCam);
};
deleteMarkerLocal vts_cameramarker;
vts_cameramarker=nil;