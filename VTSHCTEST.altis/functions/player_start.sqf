//this setpos [getpos this select 0, getpos this select 1,(getpos this select 2)+10000];
_player=_this select 0;

if (_player==player) then 
{
	//Anti drowning security for A3 (player long to connect could have their character drowning even if they are not ingame...)
	_player enablesimulation false;
	//More rating to avoid AI to Friendly fire on one player TK.
	_player addrating 10000;
};


