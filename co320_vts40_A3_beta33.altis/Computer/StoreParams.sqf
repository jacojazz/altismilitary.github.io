
	_lightmode=false;
	if (count _this>0) then {_lightmode=_this select 0;};
	
        Sidesave=lbCurSel 10206;
        Campsave=lbCurSel 10203;
        Typesave=lbCurSel 10305;
        Unitsave=lbCurSel 10306;
	if !(_lightmode) then
	{
        Mouvsave=lbCurSel 10218;
        Formsave=lbCurSel 10307;
        Musicsave=lbCurSel 10605;
        Artysave=lbCurSel 10041;
        Ammosave=lbCurSel 10918;
		vtsWeaponsave=lbCurSel 10921;
		Customgroupsave=lbCurSel 10237;
		ShowTextTypeSave=lbCurSel 10932;
		zonepaintcolorSave=lbCurSel 10710;
		vtsspeedselected=lbCurSel 10214;
		vtsbehaviorselected=lbCurSel 10211;
	};