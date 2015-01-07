
/*-----------------------------------------------------------
TimeToString function -=- by snYpir

Returns a 24-hour time as a string from a decimal.

This is meant to be used with the 'daytime' command, for
example if 'daytime' was 7.36, '[daytime] call TimeToString'
would return 07:21:36

No rounding of the time is done - ie time is returned as per
a clock

The second array element passed in is the return time format.
It can be:

"HH"          - Hour
"HH:MM"       - Hour:Minute
"HH:MM:SS"    - Hour:Minute:Seconds
"HH:MM:SS:MM" - Hour:Minute:Seconds:Milliseconds
"ARRAY"       - [Hour,Minute,Seconds,Milliseconds]

If the second parameter is not passed in, it defaults to
"HH:MM:SS"

Called with:

[<decimal time>,<format>] call TimeToString

Thanks to CoC mod for the inspiration and some code!
------------------------------------------------------------*/

private ["_in", "_format", "_min", "_hour", "_sec", "_msec", "_return"];

_in = _this select 0;

if (count _this > 1) then { _format = _this select 1 } else { _format = "HH:MM:SS" };

_min = _in mod 1;
_hour = _in - _min;
_sec = (60 * _min) mod 1;
_msec = (60 * _sec) mod 1;

if (_hour <= 9) then {_hour = format ["0%1", _hour]} else {_hour = format ["%1", _hour]};

_min = (60 * _min) - ((60 * _min) mod 1);
if (_min <= 9) then {_min = format ["0%1", _min]} else {_min = format ["%1", _min]};

_sec = (60 * _sec) - ((60 * _sec) mod 1);
if (_sec <= 9) then {_sec = format ["0%1", _sec]} else {_sec = format ["%1", _sec]};

_msec = (60 * _msec) - ((60 * _msec) mod 1);
if (_msec <= 9) then {_msec = format ["0%1", _msec]} else {_msec = format ["%1", _msec]};

if ( _format == "HH" ) then { _return = format["%1",_hour] };

if ( _format == "HH:MM" ) then { _return = format["%1:%2",_hour,_min] };

if ( _format == "HH:MM:SS" ) then { _return = format["Summary : ENI area %4 m/side | %5 ENI groups | AI mode %6 | Rain %7 | Fog %8 | %1:%2:%3 ",_hour,_min,_sec,concentration_affiche,grps_affiche,typeia_affiche,pluie_affiche,brume_affiche] };

if ( _format == "HH:MM:SS:MM" ) then { _return = format["%1:%2:%3:%4",_hour,_min,_sec,_msec] };

if ( _format == "ARRAY" ) then { _return = [_hour,_min,_sec,_msec] };

_return

