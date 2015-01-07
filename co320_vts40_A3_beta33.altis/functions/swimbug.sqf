if (vehicle player != player) exitWith {hint "You must be on foot"};

_anim=animationState player;

if (
	([_anim,"abdv"] call KRON_StrInStr) or
	([_anim,"absw"] call KRON_StrInStr) or
	([_anim,"adve"] call KRON_StrInStr) or
	([_anim,"asdv"] call KRON_StrInStr) or
	([_anim,"assw"] call KRON_StrInStr) or
	([_anim,"aswm"] call KRON_StrInStr) or
	([_anim,"Halo"] call KRON_StrInStr)
	) then
{
	player switchmove "";
};
