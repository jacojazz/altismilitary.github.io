
// ******************************************************************************************

// buildingPosCount.sqf

// Returns number of indexed positions in a building.
// These positions can be used with the buildingPos function.
// When using indexed positions from a script,
// take in notice that 1st position has index number 0,
// 2nd has index number 1 and so on. So if a building
// has 8 positions, you can use them as 0...7 from a script
// with the buildingPos function.

// USAGE:

// init:	buildingPosCount = preprocessFile "buildingPosCount.sqf"

// calling:	<building> call buildingPosCount

// returns:	<integer>

// example:	_posses = nearestBuilding player call buildingPosCount

// Baddo 2005
// You can contact me through www.ofpec.com

// ******************************************************************************************

private "_i";

_i = 0;

while { format ["%1", _this buildingPos _i] != "[0,0,0]" } do
{
	_i = _i + 1;
};
_i