moveOut player; 
sleep 0.5;
if (ACEMOD) then
{
  [player] execVM "x\ace\addons\sys_eject\jumpout_cord.sqf";
}
else
{
  [player] exec "ca\air2\halo\data\Scripts\Halo_init.sqs";
}; 
