// le serveur accelere le temps

go_acctime = false;
//if (local server) then 
//{
	while {true} do
	{
	sleep 0.1;
// **********  accelerate time **************
		if (go_acctime) then
		{
		skiptime 0.00333
		};
	};
//};
