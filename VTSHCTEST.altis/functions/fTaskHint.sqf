_colorWHITE =[1,1,1,1];
_colorGREY =[0.75,0.75,0.75,1];
_colorGREEN =[0.6,0.8,0.4,1];
_colorRED =[1,0.1,0,1];

private["_task", "_taskDescription", "_taskStatus", "_taskParams"];

_task 			 = _this select 0;
_taskDescription = (taskDescription _task) select 1;
_taskStatus		 = toUpper(taskState _task);

//player sidechat str _this;
_taskParams = switch (_taskStatus) do
{
	case "CREATED":
	{
		[format["NEW TASK ASSIGNED: %1", _taskDescription], _colorWHITE, "taskNew"]
	};

	case "ASSIGNED":
	{
		[format["ASSIGNED TASK: %1", _taskDescription], _colorWHITE, "taskCurrent"]
	};

	case "SUCCEEDED":
	{
		[format["TASK ACCOMPLISHED: %1", _taskDescription], _colorGREEN, "taskDone"]
	};

	case "FAILED":
	{
		[format["TASK FAILED: %1", _taskDescription], _colorGREEN, "taskFAILED"]
	};

	case "CANCELED":
	{
		[format["TASK CANCELED: %1", _taskDescription], _colorGREY, "taskDone"]
	};

};

_taskParams call vts_taskhint;