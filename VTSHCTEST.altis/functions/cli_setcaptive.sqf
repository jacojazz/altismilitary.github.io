disableSerialization;
if (local player) then
{

_display = finddisplay 8000;
_txt = _display displayctrl 200;
_bt = _display displayctrl 10603;
_code = {};

		if(player getvariable ["vts_gm_hidden",false]) then
		{

		  _code={
			_this allowDamage true;
			_this hideObject false;
			_this setCaptive false;
			};

			[_code,player] call vts_broadcastcommand;
			titletext ["Your are not invisible !","plain down"];
			hint "Your are not invisible !";
			player setvariable ["vts_gm_hidden",false,true];
				_txt CtrlSetText "Your are not invisible !";
				_txt CtrlSetTextColor [1,0,0,1];
				_bt CtrlSetTextColor [0.9,0.9,0.9,1];
			Ctrlshow [200,true];sleep 0.5; CtrlShow [200,false];sleep 0.5;Ctrlshow [200,true];
		}else{

		_code={
		  _this setdamage 0;
			_this allowDamage false;
			_this hideObject true;
			_this setCaptive true;
		};

		
		[_code,player] call vts_broadcastcommand;
			titletext ["Your are now invisible !","plain down"];
			player setvariable ["vts_gm_hidden",true,true];
			hint "Your are now invisible !";
				_txt CtrlSetText "Your are invisible !";
				_bt CtrlSetTextColor [1,0,0,1];
		};
};
