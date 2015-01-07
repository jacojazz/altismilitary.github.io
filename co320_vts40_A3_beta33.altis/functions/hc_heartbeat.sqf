//Only run on HC
_hb=0;
while {true} do
{

	//Event every 5 seconds
	if (_hb mod 5==0) then
	{
		vts_hclient_fps=round(diag_fps);
		publicvariable "vts_hclient_fps";
		//Update variable overnetwork in case of the HC dead (var is not valid anymore after death, only vehiclevarname stay the same, but its too clumsy to sync vehiclevarname on MP)
		if (VTS_HC_AI!=player) then
		{
			VTS_HC_AI=player;
			publicVariable "VTS_HC_AI";
		};
	};
	_hb=_hb+1;
	sleep 1;  
};