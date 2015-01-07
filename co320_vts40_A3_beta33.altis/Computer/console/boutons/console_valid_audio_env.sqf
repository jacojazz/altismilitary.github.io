
disableSerialization;

_n = _this select 0;       
 
console_valid_envsound = lbCurSel 10609;

//hint format["%1",console_valid_music];


if (_n == 0) then
{

 
  Envsoundvalid=lbData [10609, console_valid_envsound];
  
  
/*
	vtstriggerpreviewsound=createTrigger["EmptyDetector",getPos player]; 
	player sidechat format ["%1",vtstriggerpreviewsound];
 
  //vtstriggerpreviewsound=createTrigger["EmptyDetector",getPos player]; 
  vtstriggerpreviewsound setsoundeffect ["Info","","",Envsoundvalid];
  vtstriggerpreviewsound setTriggerActivation ["VEHICLE","PRESENT",true];
  vtstriggerpreviewsound setTriggerStatements ["this","",""];
  vtstriggerpreviewsound triggerAttachVehicle [player];
 */
  //publicvariable "Envsoundvalid";

}
else
{
	if (isnil "GlobalSoundList") then {GlobalSoundList=[];};
	
  //Musiques Maestro !!!
  _MydualList2=[];

  _MydualList2=_MydualList2+GlobalSoundList;
 
  
  [10609, _MydualList2] call Dlg_FillListBoxLists;


  
};


