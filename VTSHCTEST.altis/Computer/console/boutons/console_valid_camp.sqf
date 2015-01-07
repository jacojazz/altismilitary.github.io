disableSerialization;
// camp

_n = _this select 0;

private "_MydualList";

console_valid_camp = lbCurSel 10203;

_campname=lbtext [10203, console_valid_camp]; 
_camp=lbdata [10203, console_valid_camp]; 
		
//private ["var_console_valid_camp"];

if (_n == 0) then
{

		nom_console_valid_camp =  _campname;
		var_console_valid_camp =  _camp;
		local_var_console_valid_camp =  _camp;
		
		_MydualList = globalcamp_types;
		//player sidechat str globalcamp_types;
		
		_Newlist=[];
		for "_i" from 0 to (count _MydualList)-1 do
		{
			_CurItem=_MydualList select _i;
			if (typename _CurItem=="STRING") then
			{				
				_Newlist set [count _Newlist,[_CurItem,_CurItem]];
			};
		};
		_MydualList=_Newlist;
		
		if (isnil "Typesave") then {Typesave=0;};
		[10305, _MydualList,Typesave] call Dlg_FillTypeListBoxLists;	  
		
		// On montre l'attitude
		ctrlShow [10211,true];
		ctrlShow [10212,true];
		ctrlShow [10213,true];
		
		// On montre la vitesse
		ctrlShow [10214,true];
		ctrlShow [10215,true];
		ctrlShow [10216,true];
		
		// On montre le mouvement
		ctrlShow [10217,true];
		ctrlShow [10218,true];
		ctrlShow [10219,true];
		
		// On montre le moral
		ctrlShow [10220,true];
		
		ctrlShow [10225,true];
		ctrlShow [10226,true];

	
};




if (true) exitWith {};
