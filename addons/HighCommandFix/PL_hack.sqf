diag_log "                                                                                                "; 
diag_log "                                                                                                "; 
diag_log "                                                                                                "; 
diag_log "                                                                                                '"; 
diag_log "                                                                                                '"; 
diag_log "============================================================================================================='"; 
diag_log "============================================================================================================='"; 
diag_log "============================================== PL_hack.sqf =================================================='"; 
diag_log "============================================================================================================='"; 
diag_log "============================================================================================================='"; 


// Platoon Leader overrides some HC functions that are useful. This returns them to normal.


///////////////////////////////////////////////////////////////////////////////////
///// Mouse over ON
///////////////////////////////////////////////////////////////////////////////////
onGroupIconOverEnter {scriptname "HC: onGroupIconOverEnter";
//if (name player == "Str") then {hint str [_this,time]};

	//--- HC mod inactive - EXIT
	if !(hcshownbar) exitwith {};

	_is3D = _this select 0;
	_group = _this select 1;
	_wpID = _this select 2;
	_posx = _this select 3;
	_posy = _this select 4;
	_logic = player getvariable "BIS_HC_scope";

	if (_wpID < 0) then {
		_logic setvariable ["groupover",_group];
		_logic setvariable ["wpover",[grpnull]];
	} else {
		if (_group in hcallgroups player && !(_logic getvariable "LMB_hold")) then {
			_logic setvariable ["groupover",grpnull];
			_logic setvariable ["wpover",[_group,_wpID]];
		};
	};

	//--- Not commanded - EXIT
	if !(_group in hcallgroups player) exitwith {};

	//--- Set delay
	_timestart = _logic getvariable "tooltip_timestart";
	if (isnil "_timestart") then {_timestart = time; _logic setvariable ["tooltip_timestart",_timestart]};

	//--- How many second we will wait before tooltip is dispayed
	if (time - _timestart < 0.25) exitwith {};

	_logic setvariable ["tooltip",_group];

	//--- Display statistics
	_this spawn (_logic getvariable "path_stat");
};


///////////////////////////////////////////////////////////////////////////////////
///// Mouse over OFF
///////////////////////////////////////////////////////////////////////////////////
onGroupIconOverLeave {scriptname "HC: onGroupIconOverLeave";

	//--- HC mod inactive - EXIT
	if !(hcshownbar) exitwith {};

	_is3D = _this select 0;
	_group = _this select 1;
	_logic = player getvariable "BIS_HC_scope";

	//--- Hide WP menus
	if (commandingmenu in ["RscHCWPRootMenu","RscHCWPType","RscHCWPCombatMode","RscHCWPFormations","RscHCWPSpeedMode","RscHCWPWait","#USER:HCWPWaitUntil","#USER:HCWPWaitRadio"]) then {showcommandingmenu ""};

	_logic setvariable ["groupover",grpnull];
	_logic setvariable ["wpover",[grpnull]];

	//--- Not commanded - EXIT
	if !(_group in hcallgroups player) exitwith {};

	_logic setvariable ["tooltip_timestart",nil];

	//--- Disable custom cursor
	[] spawn {scriptname "HC: Hide Tooltip";

		sleep 0.01;
		((uinamespace getvariable "_display") displayctrl 1124) ctrlsetposition [0,0,0,0];
		((uinamespace getvariable "_display") displayctrl 1124) ctrlcommit 0;
		((uinamespace getvariable "_display") displayctrl 1125) ctrlsetposition [0,0,0,0];
		((uinamespace getvariable "_display") displayctrl 1125) ctrlcommit 0;
	};
};