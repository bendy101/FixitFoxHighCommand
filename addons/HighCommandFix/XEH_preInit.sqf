FixitFoxHC_Version = "Fixit Fox: High Command";

// Initialize Platoon Leader mod variables to prevent errors when loading together
if (isNil "pl_additional_ammoBearer") then { pl_additional_ammoBearer = "[]"; };
if (isNil "pl_ammoBearer_cls_names") then { pl_ammoBearer_cls_names = []; };

diag_log "                                                                                 				               "; 
diag_log "                                                                                  			               "; 
diag_log "                                                                                    			               "; 
diag_log "                                                                                   		   	               "; 
diag_log "                                                                                   			               '"; 
diag_log "============================================================================================================='";
diag_log "==================================================== MOD ===================================================='";
diag_log "============================================== XEH_preInit.sqf =============================================='";
diag_log "============================================================================================================='";
diag_log "============================================================================================================='";


["FixitFox_HC_enable", "CHECKBOX", ["ENABLE "+FixitFoxHC_Version, "On or Off.\n\n"], "Fixit Fox: High Command", true,true,{},true] call CBA_fnc_addSetting;

/* if !(FixitFox_HC_enable) exitWith {
    systemChat 'Fixit Fox: High Command Bypassed';    
    diag_log "XEH_preInit !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! Fixit Fox: High Command Bypassed";
}; */



["FixitFox_who_method", "LIST", ["Who is commander?", "1. Highest Rank\n2. First Group Leader\n3. Hoster \n\n"], "Fixit Fox: High Command", [[1, 2, 3], ["Highest Rank","First Group Leader", "Host"], 0],true] call CBA_fnc_addSetting;
["FixitFox_HC_icons", "LIST", ["NATO Symbols", "0 = no icons
1 = map icons + 3D icons
2 = map icons only \n\n"], "Fixit Fox: High Command", [[0, 1, 2], ["No Icons","Map + 3D", "Map Only"], 2],true,{[] call FixitFox_FNC_HC_icons}] call CBA_fnc_addSetting;
// ["FixitFox_HC_icons", "LIST", ["NATO Symbols", "0 = no icons, 1 = map icons + 3D icons, 2 = map icons only \n\n"], "Fixit Fox: High Command", [[0, 1, 2], ["No Icons","Map + 3D", "Map Only"], 2],true,{}] call CBA_fnc_addSetting;
// ["FixitFox_blufor_trackingall", "LIST", ["Blufor Tracking", "0 = off, 1 = vanilla, 3 = 3rd party \n\n"], "Fixit Fox: High Command", [[0, 1, 2], ["Off","Vanilla", "3rd Party"], 0],true] call CBA_fnc_addSetting;
["FixitFox_HighCommandScope", "LIST", ["Which groups to add to High Command?", "1 = all groups
2 = groups without waypoints
3 = playable slot groups only. 

Any groups with NPCs are ignored (units for decoration that cannot move) \n\n"], "Fixit Fox: High Command", [[1, 2, 3], ["All Groups","Groups without Waypoints", "Playable Slot Groups"], 0],true,{[] call FixitFox_HC_update}] call CBA_fnc_addSetting;
["FixitFox_addspawned", "CHECKBOX", ["Add Spawned Groups", "Turn this off if you don't want spawned groups to be added to High Command.\n\n"], "Fixit Fox: High Command", true,true] call CBA_fnc_addSetting;
["FixitFox_ignorePlayerGroups", "CHECKBOX", ["Ignore Player Groups", "You cannot control groups with a player leader anyway.
However, you can still put waypoints down, and when that player leader
teamswitches or dies, that group will then follow waypoints\n\n"], "Fixit Fox: High Command", false,true] call CBA_fnc_addSetting;
["FixitFox_multipleHC", "CHECKBOX", ["Multiple commanders on same side?", "Allow multiple commanders on same side.\n\n"], "Fixit Fox: High Command", false,true] call CBA_fnc_addSetting;

["FixitFox_blufor_trackingall", "LIST",   ["Blufor Tracking", "
When High Command Group Bar is not enabled, you can still have Blufor Tracking on the map.
0 = off
1 = vanilla
2 = 3rd party e.g ACE blufor tracking

The last option is useful if you use another mods bluefor tracking.\n\n"], "Fixit Fox: High Command", [[0, 1, 2], ["Off","Vanilla", "3rd Party (e.g. ACE Blufor Tracking)"], 1],true,{[] call FixitFox_FNC_blufor_tracking}] call CBA_fnc_addSetting;
["FixitFox_blufor_scope", "LIST",   ["NATO Symbol Scope", "0 = side only, 1 side + allies, 2 side + allies + enemies \n\n"], "Fixit Fox: High Command", [[0, 1, 2], ["Blufor Tracking Only","Include Allies", "Include Allies + Enemies"], 0],true,{[] call FixitFox_SymbolSides}] call CBA_fnc_addSetting;
["FixitFox_non_blufor_marker", "LIST",   ["Enemy NATO Symbol Duration", "Only if setting above includes enemies. After enemy is spotted, you can have either a constant marker or momentary hint.\n\n"], "Fixit Fox: High Command", [[0, 1], ["Constant / Solid","Momentary Hint"], 0],true,{[] call FixitFox_SymbolSides}] call CBA_fnc_addSetting;
["FixitFox_friendlies_init", "CHECKBOX", ["All Allies NATO Symbols Appear at Start", "Allies' nato symbols appear at start of mission\ninstead of only when spotted.\nEssentially like blufor tracking.\n\n"], "Fixit Fox: High Command", true,true,{[] call FixitFox_SymbolSides}] call CBA_fnc_addSetting;
["FixitFox_autoConvertAirUnload", "CHECKBOX", ["UNLOAD WP to TR UNLOAD WP", "Convert UNLOAD waypoints to TR UNLOAD for air vehicles.\nNow you can use the UNLOAD WP to make helicopters land\n\n"], "Fixit Fox: High Command", true, true] call CBA_fnc_addSetting;
["FixitFox_make_leader_TS", "CHECKBOX", ["Make Group Leader on Team Switch", "If you teamswitch and the unit is not the group leader: make leader\n\n"], "Fixit Fox: High Command", false, true] call CBA_fnc_addSetting;
["FixitFox_debug", "CHECKBOX", ["Debug", "Just diag_logs for Degugging\n\n"], "Fixit Fox: High Command", false,true] call CBA_fnc_addSetting;
["FixitFox_debug_start_method", "CHECKBOX", ["Debug: manual start", "Start manually with action menun\n"], "Fixit Fox: High Command", false,true] call CBA_fnc_addSetting;

// Add our keybinds using CBA
["Fixit Fox: High Command", "Select HC Group that player is aiming at", "Selects the HC Group of the unit the player aims at", 
    // {_this call FixitFox_targetGroupHandler}, "", [DIK_T, [false, false, false]]] call CBA_fnc_addKeybind;
    {_this call FixitFox_targetGroupHandler}, "", [DIK_T, [false, false, false]], false] call CBA_fnc_addKeybind;
["Fixit Fox: High Command", "Center Map on Selected Group", "Centers the map on the currently selected HC group", 
    {_this call FixitFox_centerMapOnSelectedGroups}, "", [DIK_T, [false, true, false]], false] call CBA_fnc_addKeybind;  // ALT+Tas example

if !(FixitFox_HC_enable) exitWith {
    systemChat 'Fixit Fox: High Command Bypassed';    
    diag_log "XEH_preInit !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! Fixit Fox: High Command Bypassed";
    FixitFox_HC_enable = nil;
    FixitFox_who_method = nil;
    FixitFox_HC_icons = nil;   
    FixitFox_HighCommandScope = nil;     
    FixitFox_multipleHC = nil;
    FixitFox_blufor_trackingall = nil;
    FixitFox_blufor_scope = nil;        
    FixitFox_non_blufor_marker = nil;
    FixitFox_friendlies_init = nil; 
    FixitFox_debug = nil;
    FixitFox_debug_start_method = nil;
};


/* 
FixitFox_FNC_blufor_tracking = {
	
	if (FixitFox_blufor_trackingall == 0) then {
		FixitFox_blufor_tracking = false;
		FixitFox_blufor_3rd_party = false;
	};
	if (FixitFox_blufor_trackingall == 1) then {
		FixitFox_blufor_tracking = true;
		FixitFox_blufor_3rd_party = false;
	};
	if (FixitFox_blufor_trackingall == 2) then {
		FixitFox_blufor_tracking = false;
		FixitFox_blufor_3rd_party = true;
	};
    if (FixitFox_blufor_tracking) then {
        setGroupIconsVisible [true, false];
    } else {
        setGroupIconsVisible [false, false];
    };
};

FixitFox_FNC_HC_icons = {
    if (FixitFox_HC_icons == 0) then {
        FixitFox_HC_iconsapply = [false, false];
    };

    if (FixitFox_HC_icons == 1) then {
        FixitFox_HC_iconsapply = [true, true];
    };

    if (FixitFox_HC_icons == 2) then {
        FixitFox_HC_iconsapply = [true, false];
    };
	setGroupIconsVisible FixitFox_HC_iconsapply;
}; */