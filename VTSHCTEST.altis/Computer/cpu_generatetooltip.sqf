disableSerialization;

_array=_this select 0;

_ninfo=(count vtscpucontrollist)-1;
_cpudisp=finddisplay 8000;
for "_i" from 0 to _ninfo do
{
  _ctrlinfo=vtscpucontrollist select _i;
  _ctrl=_cpudisp displayCtrl (_ctrlinfo select 0);
  _ctrl ctrlSetTooltip (_ctrlinfo select 1);
};

