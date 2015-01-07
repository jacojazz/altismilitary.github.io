// -----------------------------------------------------------------------------
// SPON_formatNumber
//
// Author: Spooner [RGG] (bil.bagpuss@gmail.com)
//
// Last Modified: $Date: 2007/11/07 16:48:31 $
//
// Version: 0.1.0
//
// Beta thread: http://www.ofpec.com/index.php?option=com_smf&Itemid=36&topic=30561.0
//
// Description:
//   Formats a number to a minimum integer width and to a specific number of
//   decimal places (including padding with 0s and correct rounding). Numbers
//   are always displayed fully, never being condensed using an exponent (e.g.
//   the number 1.234e9 would be given as "1234000000").
//
//   Additionally, if required, it will separate the integer part of the number
//   with the appropriate localized seperators as, for example,
//   "21,002" or "1,000,000".
//
//   example stringtable.csv:
//     LANGUAGE,"English","Czech","German","Polish","Russian","French","Spanish","Italian"
//     STR_SPON_FORMAT_NUMBER_THOUSANDS_SEPARATOR, ",", ".", ".", " ", ".", " ", ".", "."
//     STR_SPON_FORMAT_NUMBER_DECIMAL_POINT, ".", ",", ",", ",", ",", ",", ",", ","
//
// Limitations:
//   Although the function works up to a point and will display the passed
//   number correctly, due to the extremely limited accuracy of floating point
//   values used within ArmA (presumably just single-precision / 32 bit), the
//   output might not be as _expected_ after about eight significant figures.
//
// Parameters:
//   0: _number - Number to format [Number]
//   1: _integerWidth - Minimum width of integer part of number, padded with 0s, 
//        [Number: >= 0, defaults to 1]
//   1: _decimalPlaces - Number of decimal places, padded with trailing 0s,
//        if necessary[Number: >= 0, defaults to 0]
//   2: _separateThousands - True to separate each three digits with a comma,
//        space or full stop, based on localization region [Boolean, defaults
//        to false]
//
// Returns:
//   The number formatted into a string.
//
// Usage:
//   SPON_formatNumber = compile preprocessFileLineNumbers "SPON_formatNumber.sqf";
//
//   // Assumes English formatting.
//   [0.0001, 1, 3] call SPON_formatNumber;               // => "0.000"
//   [0.0005, 1, 3] call SPON_formatNumber;               // => "0.001"
//
//   [12345, 1, 0, true] call SPON_formatNumber;          // => "12,345"
//   [1234567, 1, 0, true] call SPON_formatNumber;        // => "1,234,567"
//
//   [12345.67, 1, 1, true] call SPON_formatNumber;       // => "12,345.7"
//   [1234, 1, 3, true] call SPON_formatNumber;           // => "1,234.000"
//
//   [0.1, 1] call SPON_formatNumber;                     // => "0"
//   [0.1, 3, 1] call SPON_formatNumber;                  // => "000.1"
//   [0.1, 0, 2] call SPON_formatNumber;                  // => ".10"
//   [12, 0] call SPON_formatNumber;                      // => "12"
//   [12, 3] call SPON_formatNumber;                      // => "012"
//
//   [-12] call SPON_formatNumber;                        // => "-12"
//
// -----------------------------------------------------------------------------

#define DEFAULT_INTEGER_WIDTH 1
#define DEFAULT_DECIMAL_PLACES 0
#define DEFAULT_SEPARATE_THOUSANDS false

private ["_number", "_integerWidth", "_decimalPlaces", "_separateThousands"];
_number = _this select 0;

if ((count _this) < 2) then
{
	_integerWidth = DEFAULT_INTEGER_WIDTH;
}
else
{
	_integerWidth = _this select 1;
};

if ((count _this) < 3) then
{
	_decimalPlaces = DEFAULT_DECIMAL_PLACES;
}
else
{
	_decimalPlaces = _this select 2;
};

if ((count _this) < 4) then
{
	_separateThousands = DEFAULT_SEPARATE_THOUSANDS;
}
else
{
	_separateThousands = _this select 3;
};

private ["_integerPart", "_string", "_numIntegerDigits"];

// Start by working out how to display the integer part of the number.
if (_decimalPlaces > 0) then
{
	_integerPart = floor (abs _number);
}
else
{
	_integerPart = round (abs _number);
};

_string = "";
_numIntegerDigits = 0;

while {_integerPart > 0} do
{
	if ((_numIntegerDigits > 0) and ((_numIntegerDigits mod 3) == 0) and _separateThousands) then
	{
		_string = (localize "STR_SPON_FORMAT_NUMBER_THOUSANDS_SEPARATOR") + _string;
	};
	
	_string =  (str (_integerPart mod 10)) + _string;
	_numIntegerDigits = _numIntegerDigits + 1;
	
	_integerPart = floor (_integerPart / 10);
};

// Pad integer with 0s
while {_numIntegerDigits < _integerWidth} do
{
	if ((_numIntegerDigits > 0) and ((_numIntegerDigits mod 3) == 0) and _separateThousands) then
	{
		_string = (localize "STR_SPON_FORMAT_NUMBER_THOUSANDS_SEPARATOR") + _string;
	};
	
	_string = "0" + _string;
	
	_numIntegerDigits = _numIntegerDigits + 1;
};

// Add a - sign if needed.
if (_number < 0) then
{
	_string = "-" + _string;
};

// Add decimal digits, if necessary.
if (_decimalPlaces > 0) then
{
	private ["_digit", "_multiplyer", "_i"];
	
	_string = _string + localize "STR_SPON_FORMAT_NUMBER_DECIMAL_POINT";
	
	_multiplyer = 10;
	
	for "_i" from 1 to _decimalPlaces do
	{
		if (_i == _decimalPlaces) then
		{
			_digit = round ((_number * _multiplyer) mod 10);
		}
		else
		{
			_digit = floor ((_number * _multiplyer) mod 10);
		};

		// If the digit has become infintesimal, pad to the end with zeroes.
		if (not (finite _digit)) exitWith
		{
			private "_j";
			
			for "_j" from _i to _decimalPlaces do
			{
				_string = _string + "0";
			};
		};
		
		_string = _string + (str _digit);
		
		_multiplyer = _multiplyer * 10;
	};
};

_string; // Return.
