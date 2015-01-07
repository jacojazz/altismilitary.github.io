private ["_txt","_help"];
_txt=("Hello, this is the commandline help. Here you can copy (ctrl+c) to paste (ctrl+v) code in the VTS commandline. 
   
Please note : Commandline inputs and scripts are executed on all machines (ie if you do a ""removeweapons player"" all player will be naked).  
  
If you seek help about commands you could run in the command line, check the website : https://community.bistudio.com/wiki/Category:Scripting_Commands  
 
  
******************************** VTS Section *********************************
   
");
((findDisplay 8001) displayCtrl 10301) ctrlSetText "Loading help message . . .";
 _help=[([] call vts_gethelptext),"<br/>",""] call KRON_Replace;
 ((findDisplay 8001) displayCtrl 10301) ctrlSetText (_txt+_help);
