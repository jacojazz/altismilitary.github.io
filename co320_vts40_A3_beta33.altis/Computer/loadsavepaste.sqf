disableserialization;
hint "Mission preset pasted from the clipboard";
private "_text";
if (vtsarmaversion<3) then
{
	_text=copyFromClipboard;
}
else
{
	_text="!!! ARMA 3 DISABLED THE PASTE FEATURE, PLEASE USE CTRL+V IN THIS FIELD TO PASTE YOUR DATA !!!";
};
ctrlsettext [20301,_text];
//(finddisplay 8002 (displayctrl 20301)) ctrlsettext "test";

