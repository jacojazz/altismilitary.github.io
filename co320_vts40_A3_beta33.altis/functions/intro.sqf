//hcShowBar true;
//sleep 3;

//No music when JIP
if !(T_JIP) then 
{
	playmusic ["Track04_Underwater1",7];
	0 fademusic 0;2 fademusic 0.6;
};

//sleep 1;
TitleRsc ["vtsimg","PLAIN"];

sleep 3;

//titleText ["Welcome to VTS 3.5", "PLAIN"];


sleep 5;

titleText ["Welcome to the Virtual Training space : A Live mission sandbox", "PLAIN"];
sleep 5;
titleFadeOut 1;
sleep 1;


titleFadeOut 1;

sleep 1;

if !(T_JIP) then 
{
5 fademusic 0;
};
