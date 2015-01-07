
disableSerialization;

_n = _this select 0;       
 
console_valid_music = lbCurSel 10605;

//hint format["%1",console_valid_music];

if (isnil "vts_launchmusic") then {vts_launchmusic=1;};

if (_n == 0) then
{
  if (vts_launchmusic==1) then
  {
  //hint format["%1",console_valid_music];
  if (console_valid_music > 0) then 
  {
  Musicvalid=lbData [10605, console_valid_music];
  publicvariable "Musicvalid";
  hint format["Now playing : %1",lbText[10605,console_valid_music]];
  };
 
  if (console_valid_music == 1) then 
  {
	0.5 fademusic 0;sleep 0.5;playmusic [format["%1",Musicvalid],0]; 3 fademusic 1;hint "Music stop : only on GM";
  };
  if (console_valid_music > 1) then 
  {
	if ([Musicvalid,"vtsloop"] call KRON_StrInStr) then
	{
		hint format["Now loop playing : %1 only on GM",Musicvalid];
		[false,Musicvalid] call vts_playtensionmusic;
	}
	else
	{
		playmusic [format["%1",Musicvalid],0];
		0 fademusic 0;
		3 fademusic 1;
		hint format["Now playing : %1 only on GM",Musicvalid];
	};
	
  };
 
  //player sidechat "launch";
  
  }
  else
  {
  vts_launchmusic=vts_launchmusic-1;
  if (vts_launchmusic<1) then {vts_launchmusic=1};
  //player sidechat "dontlaunch";
  //player sidechat format["%1",vts_launchmusic];
  };
  

}
else
{
  //Musiques Maestro !!!
  _MydualList2=
      [
        ["Play music",""],
        ["Stop music",""]
      ];
  
  if (isnil "GlobalMusicList") then {GlobalMusicList=[];};
  
  //Arma 3 loop ability
  _vtsloop=[];
  if (vtsarmaversion>2) then 
  {
	  _vtsloop=[
	  ["VTS Loop Explore01","vtsloopexplore01"]

	  ];
  };
	  
  _MydualList2=_MydualList2+_vtsloop+GlobalMusicList;
 
  
  [10605, _MydualList2] call Dlg_FillListBoxLists;

  
  vts_launchmusic=3;
  ["Musicsave",0] call vts_checkvar;
  lbSetCurSel [10605,Musicsave];
  
};


