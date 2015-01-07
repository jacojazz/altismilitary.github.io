
_loadouttype=lbCurSel 133038;
vts_shoploadouttype=parseNumber (lbdata [133038,_loadouttype]);
//player sidechat str vts_shoploadouttype;
if (vts_shoploadouttype==0) then
{

	[] spawn vts_shopdisplayloadouts;
	ctrlShow [133035,true];
	ctrlShow [133043,true];
	ctrlShow [133042,true];
	ctrlShow [133030,true];
};
if (vts_shoploadouttype==1) then
{

	[] spawn vts_shopdisplayloadouts;
	ctrlShow [133035,false];
	ctrlShow [133043,false];
	ctrlShow [133042,false];
	ctrlShow [133030,false];
};
if (vts_shoploadouttype==2) then
{
	[] spawn vts_shopdisplayloadouts;
	if ([player] call vts_getisgm) then
	{
		ctrlShow [133035,true];
		ctrlShow [133043,true];
		ctrlShow [133042,true];
		ctrlShow [133030,false];
	}
	else
	{
		ctrlShow [133035,false];
		ctrlShow [133043,false];
		ctrlShow [133042,false];
		ctrlShow [133030,false];
	};
	
};