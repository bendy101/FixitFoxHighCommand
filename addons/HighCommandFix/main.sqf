diag_log "                                                                                                "; 
diag_log "                                                                                                "; 
diag_log "                                                                                                "; 
diag_log "                                                                                                '"; 
diag_log "                                                                                                '"; 
diag_log "============================================================================================================='"; 
diag_log "============================================= FIXITFOX HC ==================================================='"; 
diag_log "============================================== main.sqf ====================================================='"; 
diag_log "============================================================================================================='"; 
diag_log "============================================================================================================='"; 
// Wait for mission to start

// More robust check for mission start - this will prevent execution at the main menu

//these 3 lines under testing for start protection. Comment out if problems

if (!hasInterface && !isServer) exitWith {
    diag_log "FixitFoxHC: Script not executing - !hasInterface && !isServer";
};

if (hasInterface && (isNil "bis_fnc_init" || {!bis_fnc_init}) ) then {
    waitUntil {
        (!isNil "bis_fnc_init")        
    }
};

// Wait for mission to start - different checks for client vs server
if (hasInterface) then {
    // Client-side wait - wait for player to be in game
    waitUntil {
        sleep 0.3;
        !isNull player && 
        {time > 0} && 
        {!isNull (findDisplay 46)} && 
        {alive player}
    };
    
    // Additional safety check to make sure we're in a mission
    if (isNull player || {missionName == ""}) exitWith {
        diag_log "FixitFoxHC: No active mission detected - exiting HC setup";
    };
} else {
    // Server-side wait - just wait for mission to start
    waitUntil {
        sleep 0.3;
        time > 0 && 
        {missionName != ""}
    };
    
    // Additional safety check for server
    if (missionName == "") exitWith {
        diag_log "FixitFoxHC: No active mission detected on server - exiting HC setup";
    };
};

diag_log "FixitFoxHC: Mission environment confirmed - proceeding with HC setup";


// if Platoon leader 1.3 or Platoon Leader Redux is detected, run the PL_hack.sqf
if (1 in FixitFox_Detected_Mods || 2 in FixitFox_Detected_Mods) then {
    [] spawn {
       if (FixitFox_debug) then {diag_log "++++++++++++++++++++++ PL MOD DETECTED - RUNNING PL_HACK.sqf";};
        sleep 10;
        [] execvm "HighCommandFix\PL_hack.sqf";
    };
} else {
    if (FixitFox_debug) then {diag_log "++++++++++++++++++++++ PL MOD NOT DETECTED - SKIPPING PL_HACK.sqf";};
};



if (FixitFox_antistasiLoaded && (((toLower missionName) find "antistasi") != -1) == true) then {
    diag_log "++++++++++++++++++++++ Antistasi mod detected - enabling waituntil Antistasi loaded";
    waitUntil {
        !isNil "theBoss" &&
        !isNil "A3A_Events_fnc_addEventListener" &&
        !isNil "A3A_fnc_initServer" &&
        !isNil "A3A_fnc_initClient" &&
        !isNil "A3A_fnc_patrolInit" &&
        !isNil "A3A_fnc_loadPlayer" &&
        !isNil "A3A_fnc_scheduler"
    };
    if (FixitFox_debug) then {diag_log "++++++++++++++++++++++ WAITUNTIL PASSED Antistasi mod detected - enabling compatibility mode";};
    sleep 5;
     if (FixitFox_debug) then {diag_log "++++++++++++++++++++++ SLEEP 5 PASSED Antistasi mod detected - enabling compatibility mode";};
};







FixitFox_inititial_run = false; // this trigger changes to true after the first run 
preExistingHC = false;


publicVariable "FixitFox_playerSides";

//detect Mission Respawn type
BI_RespawnDetected_ = getMissionConfigValue ["Respawn", 0]; 
// can be stored also as a string, convert to number if so.
if (typeName BI_RespawnDetected_ == "STRING") then { 
    if (BI_RespawnDetected_ == "NONE") exitWith {BI_RespawnDetected_ = 0}; 			 
    if (BI_RespawnDetected_ == "BIRD") exitWith {BI_RespawnDetected_ = 1}; 
    if (BI_RespawnDetected_ == "INSTANT") exitWith {BI_RespawnDetected_ = 2}; 
    if (BI_RespawnDetected_ == "BASE") exitWith {BI_RespawnDetected_ = 3}; 
    if (BI_RespawnDetected_ == "GROUP") exitWith {BI_RespawnDetected_ = 4}; 
    if (BI_RespawnDetected_ == "SIDE") exitWith {BI_RespawnDetected_ = 5}; 
}; 


// High Command Setup Script
// =================================================================================================
// ======= SERVER CONFIGURATION - These settings are used by the server-side HC setup =============
// =================================================================================================

/* _count = 5;
while {_count > -1} do {
    hint format ["cowndown %1", _count];
    _count = _count - 1;
    sleep 1;
}; */

if (hasInterface) then {
    // for remoteexec from server
    FixitFox_deleteGroupGUI = {
        params ["_groupstoDelete"];
        if (FixitFox_inititial_run == false) then {
            sleep 0.1;
        };
        //  if (FixitFox_debug) then {diag_log format ["++++++++++++++++++++++++++ DELETE GROUP GUI: %1", _groupstoDelete];};
         if (FixitFox_debug) then {diag_log format ["++++++++++++++++++++++++++ DELETE GROUP GUI: %1", _groupstoDelete];};
        {
            player hcRemoveGroup _x;
        } forEach _groupstoDelete;
    };
};

FixitFox_FNC_blufor_tracking = {
    // Only run on clients with interface
    if (!hasInterface) exitWith {};
    
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
    // Only run on clients with interface
    if (!hasInterface) exitWith {};
    
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
};

// Only call these functions on clients
if (hasInterface) then {
    [] call FixitFox_FNC_HC_icons;
    [] call FixitFox_FNC_blufor_tracking;
};


// Simple debug function for HC groups
FixitFox_HC_debug = {
    diag_log "=== HC GROUPS DEBUG - ALL GROUP LEADERS ===";   
    // Check all units for HC groups
    {
        if (_x == leader group _x) then {
            private _groups = hcAllGroups _x;
            private _isPlayer = isPlayer _x;
            
            diag_log format ["Leader: %1 | IsPlayer: %2 | HC Groups: %3", name _x, _isPlayer, _groups];
        };
    } forEach allUnits;    
    diag_log "HC groups for ALL leaders logged to RPT file";
}; 

FixitFox_debug2 = {
        // Log all High Command and High Command Subordinate modules with their sync relationships
        diag_log "========================================================";      
    {
        if (typeOf _x == "HighCommand") then {
            diag_log format ["HighCommand Module: %1", _x];
            private _syncedObjects = synchronizedObjects _x;
            if (count _syncedObjects > 0) then {
                diag_log format ["  Synced to %1 objects:", count _syncedObjects];
                {
                    diag_log format ["	- %1 (Type: %2) %3", _x, typeOf _x, if (isPlayer _x) then {"ISPLAYER"} else {""}];
                } forEach _syncedObjects;
            } else {
                diag_log "  No objects synced to this HighCommand module";
            };
        };
    } forEach (allMissionObjects "HighCommand");

    {
        if (typeOf _x == "HighCommandSubordinate") then {
            diag_log format ["HighCommandSubordinate Module: %1", _x];
            private _syncedObjects = synchronizedObjects _x;
            if (count _syncedObjects > 0) then {
                diag_log format ["  Synced to %1 objects:", count _syncedObjects];
                {
                    diag_log format ["	- %1 (Type: %2) %3", _x, typeOf _x, if (isPlayer _x) then {"ISPLAYER"} else {""}];
                } forEach _syncedObjects;
            } else {
                diag_log "  No objects synced to this HighCommandSubordinate module";
            };
        };
    } forEach (allMissionObjects "HighCommandSubordinate");

    systemChat "High Command module sync relationships logged to diag_log";
};


// Function to get HC groups remotely and continue assignment process
FixitFox_HC_getGroupsAndAssign = {
    params ["_commander", "_groupsToAdd", "_responseID"];
    

    // This runs on the commander's machine
    private _currentHCGroups = hcAllGroups _commander;

    if (FixitFox_debug) then {diag_log format ["[0217] ========FixitFox_HC_getGroupsAndAssign: _commander: %1, isPlayer: %4 _groupsToAdd: %2, _currentHCGroups: %3", name _commander, _groupsToAdd, _currentHCGroups, isPlayer _commander];};
    // if (FixitFox_debug) then {call FixitFox_HC_debug;};
    
    // Send back to server with the groups to actually add
    [_commander, _groupsToAdd, _currentHCGroups, _responseID] remoteExec ["FixitFox_HC_completeAssignment", 2];
};

// Function to complete the assignment process on the server
FixitFox_HC_completeAssignment = {
    params ["_commander", "_groupsToAdd", "_currentHCGroups", "_responseID"];

    if (FixitFox_debug) then {diag_log format ["[0227] ========FixitFox_HC_completeAssignment: _commander: %1, isPlayer: %5 _groupsToAdd: %2, _currentHCGroups: %3, _responseID: %4, FixitFox_inititial_run: %6", name _commander, _groupsToAdd, _currentHCGroups, _responseID, isPlayer _commander, FixitFox_inititial_run];};
    
    // Sort the groups alphabetically by their name/ID only during initial setup
    if (FixitFox_inititial_run) then {
        _groupsToAdd = [_groupsToAdd, [], {groupId _x}, "ASCEND"] call BIS_fnc_sortBy;
        diag_log format ["[0231] ========SORTED_groupsToAdd: %1",  _groupsToAdd];
    };
    
    // Now on the server, process the groups that need to be added
    {
        if !(_x in _currentHCGroups) then {
            // Use remoteExec to ensure hcSetGroup runs on the commander's machine
            [_commander, [_x]] remoteExec ["hcSetGroup", owner _commander];
            if (FixitFox_debug) then {diag_log format ["[0247]++++++++++++++++++ hcSetGroup: Assigned group %1 to commander %2 isPlayer: %3", _x, name _commander, isPlayer _commander];};
        };
    } forEach _groupsToAdd;
    // if (FixitFox_debug) then {call FixitFox_HC_debug;};
};


// =================================================================================================
// ================ SERVER-ONLY CODE - High Command module setup ==================================
// =================================================================================================

if (isServer) then {


    // Function to determine the designated High Commander for a side if more than one player is in game and multiple player option is true
    FixitFox_who_HighCommander = {
        params ["_side"];
        private _potentialCommanders = [];
        private _selectedCommander = objNull;
        
        // Gather all player group leaders on this side
        {
            private _leader = leader _x;
            if (side _x == _side && isPlayer _leader) then {
                _potentialCommanders pushBack _leader;
            };
        } forEach allGroups;
        
        if (count _potentialCommanders == 0) exitWith {
            if (FixitFox_debug) then {diag_log format ["No potential commanders found for side %1", _side];};
            objNull
        };
        
        // Try method based on FixitFox_who_method, with cascading fallbacks
        private _methodsToTry = [];
        
        // Build array of methods to try in order, starting with the chosen method
        if (FixitFox_who_method == 0) then {
            _methodsToTry = [0, 1, 2]; // Rank → First Leader → Local Host
        } else {
            if (FixitFox_who_method == 1) then {
                _methodsToTry = [1, 0, 2]; // First Leader → Rank → Local Host
            } else {
                _methodsToTry = [2, 0, 1]; // Local Host → Rank → First Leader
            };
        };
        
        // Try each method in sequence until one succeeds
        {
            private _currentMethod = _x;
            
            switch (_currentMethod) do {
                // Method 0: Highest rank
                case 0: {
                    // Find player(s) with highest rank
                    private _highestRank = -1;
                    private _highestRankPlayers = [];
                    
                    // Find the highest rank
                    {
                        private _rank = rankId _x;
                        if (_rank > _highestRank) then {
                            _highestRank = _rank;
                            _highestRankPlayers = [_x];
                        } else {
                            if (_rank == _highestRank) then {
                                _highestRankPlayers pushBack _x;
                            };
                        };
                    } forEach _potentialCommanders;
                    
                    // If only one player has highest rank, use them
                    if (count _highestRankPlayers == 1) then {
                        _selectedCommander = _highestRankPlayers select 0;
                        if (FixitFox_debug) then {diag_log format ["Selected commander by rank: %1 (Rank: %2)", _selectedCommander, rank _selectedCommander];};
                    } else {
                        if (FixitFox_debug) then {diag_log format ["Multiple players with same rank (%1), trying next method", rank (_highestRankPlayers select 0)];};
                    };
                };
                
                // Method 1: First player group leader found
                case 1: {
                    _selectedCommander = _potentialCommanders select 0;
                    if (FixitFox_debug) then {diag_log format ["Selected first player group leader: %1", _selectedCommander];};
                };
                
                // Method 2: Local host
                case 2: {
                    private _foundHost = false;
                    {
                        if (isServer && {local _x}) exitWith {
                            _selectedCommander = _x;
                            _foundHost = true;
                            if (FixitFox_debug) then {diag_log format ["Selected local host as commander: %1", _selectedCommander];};
                        };
                    } forEach _potentialCommanders;
                    
                    // If no local host found, don't set a commander - will cascade to next method
                    if (!_foundHost) then {
                        if (FixitFox_debug) then {diag_log "No local host found, trying next method";};
                    };
                };
                
                default {
                    // Should never reach here due to the _methodsToTry array setup
                    if (FixitFox_debug) then {diag_log "Invalid method in cascade";};
                };
            };
            
            // If we found a commander, exit the loop
            if (!isNull _selectedCommander) exitWith {
                if (FixitFox_debug) then {diag_log format ["Successfully found commander using method %1", _currentMethod];};
            };
        } forEach _methodsToTry;
        
        // Final fallback if all methods failed
        if (isNull _selectedCommander && count _potentialCommanders > 0) then {
            _selectedCommander = _potentialCommanders select 0;
            if (FixitFox_debug) then {diag_log format ["All methods failed, defaulting to first commander: %1", _selectedCommander];};
        };
        
        _selectedCommander
    };



    // Function to patch HC module scripts to avoid errors
    FixitFox_HC_patchModuleScripts = {
        params ["_hcModule"];
        
        _hcModule setVariable ["enemyGroups", [], true];
        _hcModule setVariable ["hc_groups", [], true];
        _hcModule setVariable ["HC_patched", true, true];
    };



    // Filter groups based on user settings and also any groups with NPCs (simulationEnabled = false)
    FixitFox_Filter_Groups = {
        params ["_selectedGroups", "_currentSide"];

         if (FixitFox_debug) then {diag_log format ["FNC FixitFox_Filter_Groups| ===================HC Filter: _selectedGroups: %1", _selectedGroups];}; 

                switch (FixitFox_HighCommandScope) do {
                    case 1: { // All groups
                        _selectedGroups = _selectedGroups select {!isNull _x && side _x == _currentSide};
                        if (FixitFox_debug) then {diag_log format ["HC Filter: All groups - _selectedGroups combined %1 for side %2", _selectedGroups, _currentSide];};
                    };
                    case 2: { // Groups without mission waypoints
                        _selectedGroups = _selectedGroups select {!isNull _x && side _x == _currentSide && count (waypoints _x) == 1};
                        if (FixitFox_debug) then {diag_log format ["HC Filter: All groups - _selectedGroups combined %1 for side %2", _selectedGroups, _currentSide];};
                    };
                    case 3: { // Playable groups only
                        _checkplayable = playableUnits + switchableUnits; //will work for both MP and SP    
                        _selectedGroups = (_checkplayable apply {group _x}) arrayIntersect (_checkplayable apply {group _x}) select {
                            !isNull _x && side _x == _currentSide && {private _units = units _x;
                            (_units findIf {_x in _checkplayable} != -1)}
                        };                   
                        if (FixitFox_debug) then {diag_log format ["HC Filter: All groups - _selectedGroups combined %1 for side %2", _selectedGroups, _currentSide];};
                    };
                };

                //Fallback if there is only one group or less.
                if (count _selectedGroups <= 1) then {
                    _selectedGroups = _selectedGroups select {!isNull _x && side _x == _currentSide};
                    if (FixitFox_debug) then {diag_log format ["HC Filter: Fallback - Selected %1 groups for side %2", count _selectedGroups, _currentSide];};
                    diag_log format ["HC Filter: Fallback - Selected %1 groups for side %2", count _selectedGroups, _currentSide];
                };

                // Filter out groups like logic groups, system groups, empty groups and groups with NPCs
                _filteredGroups = _selectedGroups select {
                    private _side = side _x;
                    private _leader = leader _x;
                    // Check valid combat group conditions:
                    _side != sideLogic &&              // Not a logic group
                    _side != sideEmpty &&              // Not an empty group
                    !isNull _leader &&                 // Has a valid leader
                    !((_leader isKindOf "Logic") ||    // Leader is not a logic unit
                    (_leader isKindOf "VirtualMan_F")) && // Not a virtual entity
                    {count units _x > 0} &&              // Group has units
                    {(units _x) findIf {
                        !simulationEnabled _x ||  // Check unit simulation
                        !(_x checkAIFeature "MOVE") ||  // Check if unit has MOVE feature disabled
                        (!isNull vehicle _x && vehicle _x != _x && !simulationEnabled vehicle _x) ||  // Check vehicle unit is in
                        (_x isKindOf "AllVehicles" && !(_x isKindOf "Man") && !simulationEnabled _x)  // Check if unit is a vehicle that is not disabled
                    } == -1}
                };

            if (FixitFox_debug) then {diag_log format ["FNC FixitFox_Filter_Groups| ===================HC Filter: Filtered groups RETURN: %1", _filteredGroups];};  

     _filteredGroups

    };

        // Function to create and setup subordinate module from event handler
    FixitFox_createSubModule = {
        params ["_group", "_hcModule"];

        if (FixitFox_debug) then {diag_log format ["FixitFox_createSubModule| FNC START Group %1", _group];}; 
        
        private _leader = leader _group;
        
        // Check if group already has a subordinate module
        private _existingSubModules = synchronizedObjects _leader select {typeOf _x == "HighCommandSubordinate"};
        if (count _existingSubModules > 0) exitWith {
            if (FixitFox_debug) then {diag_log format ["FixitFox_createSubModule| Group %1 already has subordinate module, skipping creation", _group];};
            _existingSubModules select 0  // Return the existing module
        };
        
        
        private _logicGroup = group _hcModule;
        
        private _subModule = _logicGroup createUnit ["HighCommandSubordinate", [0,0,0], [], 0, "NONE"];
        _leader synchronizeObjectsAdd [_subModule];
        _subModule synchronizeObjectsAdd [_hcModule];
        _hcModule synchronizeObjectsAdd [_subModule];
        
        _subModule
    };


    FixitFox_deleteGroup = {
        params ["_group"];

        // Get side of the group
        private _side = side _group;
        
        if (FixitFox_debug) then {diag_log format ["+++++++++++++++++++++++++++++++++++ FNC FixitFox_deleteGroup: %1 (INPUT)", _group];};
        // Skip if this is a system/logic group
        private _leader = leader _group;
        // if (!isNull _leader && {_leader isKindOf "Logic" || _leader isKindOf "VirtualMan_F"}) exitWith {
        //     if (FixitFox_debug) then {diag_log format ["!!!!!!!!!!!!!!!!!!!!!!!!!!!!! GroupDeleted EH: Skipping system/logic group: %1", _group];};
        // };
        
        if (isNull (leader _leader)) exitWith {
            if (FixitFox_debug) then {diag_log format ["GroupDeleted FNC: Skipping group with null leader: %1", _group];};
        };

        if !(_side in FixitFox_playerSides) exitWith { if (FixitFox_debug) then {diag_log format ["GroupDeleted %1 - side %2 with no HC, skipping", _group, _side];}; };
        
        // Get the leader and directly find the subordinate module
        private _leader = leader _group;
        if (!isNull _leader) then {
            // Find any HighCommandSubordinate module synced to the leader
            private _syncedSubordinate = synchronizedObjects _leader select {typeOf _x == "HighCommandSubordinate"} param [0, objNull];
            
            if (!isNull _syncedSubordinate) then {
                if (FixitFox_debug) then {diag_log format ["Deleting subordinate module for deleted group: %1", _group];};
                
                // Find the HC module it's synced to
                private _syncedHC = synchronizedObjects _syncedSubordinate select {typeOf _x == "HighCommand"} param [0, objNull];
                
                // Remove the sync relationship if HC module exists
                if (!isNull _syncedHC) then {
                    _syncedHC synchronizeObjectsRemove [_syncedSubordinate];
                    _syncedSubordinate synchronizeObjectsRemove [_syncedHC];
                };
                
                // Delete the subordinate module
                deleteVehicle _syncedSubordinate;
            };
        };

        _currentgroups = missionNamespace getVariable [format ["HC_FilteredGroups_%1", _side], []];
        missionNamespace setVariable [format ["HC_FilteredGroups_%1", _side], _currentgroups - [_group], true];

    };

    // Main HC setup function
    FixitFox_HC_update = {
        // Get all existing groups
        private _allGroups = allGroups;
        private _playerSides = [];
        private _playerGroups = [];
        private _aiGroups = [];

        // Separate player groups and AI groups, track unique sides
        {
            if (leader _x in allPlayers) then {
                // Add to player groups array
                _playerGroups pushBackUnique _x;
                
                // Track unique player sides
                _playerSides pushBackUnique (side _x);
            } else {
                _aiGroups pushBackUnique _x;
            };
        } forEach _allGroups;

        if (_playerGroups isEqualTo []) exitWith { diag_log "Error: No player group found"; };

        if (FixitFox_debug) then {diag_log format ["Setting up HC for %1 player sides: %2", count _playerSides, _playerSides];};
        if (FixitFox_debug) then {diag_log format ["Multiple HC Commanders: %1, Selection Method: %2", FixitFox_multipleHC, FixitFox_who_method];};

        FixitFox_playerSides = _playerSides;


        // Loop through each player side
        {
            private _currentSide = _x;
            if (FixitFox_debug) then {diag_log format ["Creating/updating HC for side: %1", _currentSide];};
            
            // Get player groups for this side
            private _sidePlayerGroups = _playerGroups select {side _x == _currentSide};
            if (_sidePlayerGroups isEqualTo []) then {
                if (FixitFox_debug) then {diag_log format ["Warning: No player groups found for side %1, skipping", _currentSide];} ;
                continue;
            };
            
            // Get AI groups for this side
            private _sideAIGroups = _aiGroups select {side _x == _currentSide};


            
            // Get or create HC module for this side
            private _hcModule = missionNamespace getVariable [format ["HC_Module_%1", _currentSide], objNull];
            private _logicGroup = grpNull;


            
            // If module doesn't exist, create it
            if (isNull _hcModule) then {

                //check if a high command module is in the mission already
                {
                    if (typeOf _x == "HighCommand") exitWith {
                        _hcModule = _x; // Assign the found module to the variable
                    };
                } forEach (allMissionObjects "HighCommand");

                if (!isNull _hcModule) exitWith {
                    _logicGroup = group _hcModule; 
                     // Store HC module for this side
                    missionNamespace setVariable [format ["HC_Module_%1", _currentSide], _hcModule, true];
                    preExistingHC = true;
                    if (FixitFox_debug) then {diag_log format ["Using existing MISSION HC module for side: %1 module: %2", _currentSide, _hcModule];};
                };

                private _logicCenter = createCenter sideLogic;
                if (isNil "_logicCenter") exitWith { diag_log "Error: Failed to create logic center"; };
                _logicGroup = createGroup _logicCenter;
                if (isNull _logicGroup) exitWith { diag_log "Error: Failed to create logic group"; };

                _hcModule = _logicGroup createUnit ["HighCommand", [0,0,0], [], 0, "NONE"];
                if (isNull _hcModule) exitWith { diag_log "Error: Failed to create HC module"; };
                
                // Store HC module for this side
                missionNamespace setVariable [format ["HC_Module_%1", _currentSide], _hcModule, true];
                if (FixitFox_debug) then {diag_log format ["Created new HC module for side: %1", _currentSide];};



            } else {
                if (FixitFox_debug) then {diag_log format ["Using existing HC module for side: %1", _currentSide];};
                _logicGroup = group _hcModule;
            };

            // Function to create and setup subordinate module
            private _fnc_createSubModule = {
                params ["_group"];
                if (isNull _group) exitWith { diag_log "_fnc_createSubModule| Error: Null group passed to _fnc_createSubModule"; objNull };
                
                private _leader = leader _group;
                if (isNull _leader) exitWith { diag_log format ["_fnc_createSubModule| Error: Group %1 has no leader", _group]; objNull };
                
                // Check if group already has a subordinate module
                private _existingSubModules = synchronizedObjects _leader select {typeOf _x == "HighCommandSubordinate"};
                if (count _existingSubModules > 0) exitWith {
                    if (FixitFox_debug) then {diag_log format ["_fnc_createSubModule| Group %1 already has subordinate module", _group];};
                    _existingSubModules select 0
                };
                
                private _subModule = _logicGroup createUnit ["HighCommandSubordinate", [0,0,0], [], 0, "NONE"];
                if (isNull _subModule) exitWith { diag_log "_fnc_createSubModule| Error: Failed to create subordinate module"; objNull };

                _leader synchronizeObjectsAdd [_subModule];
                _subModule synchronizeObjectsAdd [_hcModule];
                _hcModule synchronizeObjectsAdd [_subModule];
                if (FixitFox_debug) then {diag_log format ["_fnc_createSubModule| Created new subordinate module for group: %1", _group];};
                _subModule
            };


            private _hcSUBModule = missionNamespace getVariable [format ["HC_FilteredGroups_%1", _currentSide], []];
                        
            private _existingSubordinates = [];
            private _existingSyncedGroups = [];
            private _filteredGroups = [];

             //check is subordinate modules exist in the mission already   
            if (_hcSUBModule isEqualTo []) then {    
                {
                    if (typeOf _x == "HighCommandSubordinate") then {
                        if (count (synchronizedObjects _x select {_x == _hcModule}) > 0) then {
                            _existingSubordinates pushBack _x;
                            // Get groups synced to this subordinate module
                            {
                                if (_x isKindOf "CAManBase" && {_x == leader group _x}) then {
                                    _existingSyncedGroups pushBack (group _x);
                                    if (FixitFox_debug) then {diag_log format ["Found existing synced group: %1", group _x];};
                                };
                            } forEach (synchronizedObjects _x);
                            if (FixitFox_debug) then {diag_log format ["Found existing subordinate module: %1", _x];};
                        };
                    };
                } forEach (allMissionObjects "HighCommandSubordinate");
            };

            diag_log format ["+++++++++++++++++++++++++++++++++++ _existingSyncedGroups: %1 FixitFox_inititial_run: %2", _existingSyncedGroups, FixitFox_inititial_run];

            // FILTERING GROUPS based on user settings
            if (_existingSyncedGroups isEqualTo [] || FixitFox_inititial_run == true) then {
                diag_log "+++++++++++++++++++++++ GATE 1 ++++++++++++++++++++++++++++++++";
                private _selectedGroups = _sideAIGroups + _sidePlayerGroups;
                _filteredGroups = [_selectedGroups, _currentSide] call FixitFox_Filter_Groups; 
            };
            if (!(_existingSyncedGroups isEqualTo []) && FixitFox_inititial_run == false) then {
                diag_log "+++++++++++++++++++++++ GATE 2 ++++++++++++++++++++++++++++++++";
                _filteredGroups = _existingSyncedGroups;
            };   

            _toDelete = _hcSUBModule - _filteredGroups;



            if (count _toDelete > 0) then {
                diag_log format ["+++++++++++++++++++++++++++++++++++ _toDelete: %1", _toDelete];
                {
                    if (FixitFox_debug) then {diag_log format ["Deleting groups during update w forEach _toDelete: %1", _x];};
                    [_x] call FixitFox_deleteGroup;
                } forEach _toDelete;
            };

  
            // Store the filtered groups in missionNamespace for later use
            // Sort the groups alphabetically by their name/ID
            _filteredGroups = [_filteredGroups, [], {groupId _x}, "ASCEND"] call BIS_fnc_sortBy;
            missionNamespace setVariable [format ["HC_FilteredGroups_%1", _currentSide], _filteredGroups, true];
            if (FixitFox_debug) then {diag_log format ["Stored %1 filtered groups for side %2 in HC_FilteredGroups_%2", _filteredGroups, _currentSide];};

            // Process all filtered groups
            {
                private _subModule = [_x] call _fnc_createSubModule;
                if (isNull _subModule) then { 
                    if (FixitFox_debug) then {diag_log format ["Warning: Failed to create submodule for group %1", _x];};
                };
            } forEach _filteredGroups;

            if (FixitFox_debug) then {diag_log format ["[507]Creating submodules for %1 total filtered groups", _filteredGroups];};

            // Handle commanders
            if (FixitFox_multipleHC) then {
                // If multiple HC enabled, all player group leaders become commanders
                if (FixitFox_debug) then {diag_log format ["Setting up all players as HC commanders for side %1", _currentSide];};
                
                // Get current commanders
                private _currentCommanders = _hcModule getVariable ["commanders", []];
                
                // Process player leaders
                {
                    private _playerLeader = leader _x;
                    if (isPlayer _playerLeader && !(_playerLeader in _currentCommanders)) then {
                        // Sync with HC module if not already synced
                        if (count (synchronizedObjects _playerLeader select {_x == _hcModule}) == 0) then {
                            _playerLeader synchronizeObjectsAdd [_hcModule];
                            _hcModule synchronizeObjectsAdd [_playerLeader];
                            if (FixitFox_debug) then {diag_log format ["Synchronized new commander %1 with HC module", _playerLeader];};
                        };
                        
                        // Add to commanders array
                        _currentCommanders pushBack _playerLeader;
                    };
                } forEach _sidePlayerGroups;
                
                // Update commanders array
                _hcModule setVariable ["commanders", _currentCommanders, true];
                {
                    if (FixitFox_debug) then {diag_log format ["[379] kkkkkkkkkkkkkk Updated HC commanders array with %1 units for side %2 isPlayer: %3", name _x, _currentSide, isPlayer _x];};
                } forEach _currentCommanders;
            } else {
                // Single commander mode - only update if no commander exists
                private _commanders = _hcModule getVariable ["commanders", []];
                
                if (_commanders isEqualTo []) then {
                    private _designatedCommander = [_currentSide] call FixitFox_who_HighCommander;
                    if (!isNull _designatedCommander) then {
                        // Sync with HC module if not already synced
                        if (count (synchronizedObjects _designatedCommander select {_x == _hcModule}) == 0) then {
                            _designatedCommander synchronizeObjectsAdd [_hcModule];
                            _hcModule synchronizeObjectsAdd [_designatedCommander];
                            if (FixitFox_debug) then {diag_log format ["Synchronized new commander %1 with HC module", _designatedCommander];};
                        };
                        
                        // Add to commanders array
                        _hcModule setVariable ["commanders", [_designatedCommander], true];
                        if (FixitFox_debug) then {diag_log format ["[396] kkkkkkkkkkkkkk Updated HC commanders array with %1 units for side %2 isPlayer: %3", name _designatedCommander, _currentSide, isPlayer _designatedCommander];};
                    } else {
                        if (FixitFox_debug) then {diag_log format ["Warning: Could not determine HC commander for side %1", _currentSide];};
                    };
                } else {
                    if (FixitFox_debug) then {diag_log format ["Keeping existing commander for side %1", _currentSide];};
                };
            };

            if (FixitFox_ignorePlayerGroups) then { 
                _toDelete = _toDelete + _sidePlayerGroups;                    
                _filteredGroups = _filteredGroups select {!isPlayer leader _x};
            };

            if (FixitFox_debug) then {
            diag_log format ["++++++++++++++ _sidePlayerGroups: %1 _filteredGroups: %2 toDelete: %3", _sidePlayerGroups, _filteredGroups, _toDelete];
            };

            // Assign groups to current commanders GUI Group Bar for this side
            private _commanders = _hcModule getVariable ["commanders", []];
            if (count _commanders > 0) then {
                {
                    private _commander = _x;                    
                    // Add groups to commander's HC GUI to group bar that aren't already there
                    private _responseID = format ["HC_assignment_%1_%2", _commander, serverTime];
                    // [_commander, _filteredGroups, _responseID] remoteExec ["FixitFox_HC_getGroupsAndAssign", owner _commander];
                        //method 
                      //  [_commander] remoteExec ["hcRemoveAllGroups", _commander];
                        //method 2
                    if !(_toDelete isEqualTo []) then {[_toDelete] remoteExec ["FixitFox_deleteGroupGUI", _commander];} ;
                    [_commander, _filteredGroups, _responseID] remoteExec ["FixitFox_HC_getGroupsAndAssign", _commander];
                   if (FixitFox_debug) then {diag_log format ["TWO +++++++++++++++++++++++++++++++++++ _toDelete: %1", _toDelete];} ;
                } forEach _commanders;
            };
        } forEach _playerSides;

        if (FixitFox_debug) then {diag_log "High Command update completed";};
    };


    // Execute the HC setup
    call FixitFox_HC_update;


// ========================== FOR LATER USE ==========================

   /*  // Add event handler to monitor new modules
    addMissionEventHandler ["EntityCreated", {
        params ["_entity"];
        
        if (typeOf _entity == "HighCommand") then {
            if (FixitFox_debug) then {diag_log format ["New High Command module created: %1", _entity];};
            
            // Patch the new module
            [_entity] call FixitFox_HC_patchModuleScripts;
            
            // Get the side this module is for
            private _side = side group _entity;
            if (FixitFox_debug) then {diag_log format ["New HC module is for side: %1", _side];};
            
            // Store the module in missionNamespace
            missionNamespace setVariable [format ["HC_Module_%1", _side], _entity, true];
            
            // Update HC setup
            [] call FixitFox_HC_update;
        };
        
        if (typeOf _entity == "HighCommandSubordinate") then {
            if (FixitFox_debug) then {diag_log format ["New High Command Subordinate module created: %1", _entity];};
            
            // Get the synced objects
            private _syncedObjects = synchronizedObjects _entity;
            if (FixitFox_debug) then {diag_log format ["Subordinate module synced to: %1", _syncedObjects];};
            
            // Find the HC module it's synced to
            private _hcModule = _syncedObjects select {typeOf _x == "HighCommand"} param [0, objNull];
            if (!isNull _hcModule) then {
                if (FixitFox_debug) then {diag_log format ["Found synced HC module: %1", _hcModule];};
                
                // Get the side
                private _side = side group _hcModule;
                
                // Update HC setup
                [] call FixitFox_HC_update;
            } else {
                if (FixitFox_debug) then {diag_log "Warning: New subordinate module not synced to any HC module";};
            };
        };
    }]; */

// =======================================================================


    // Add event handler to monitor new groups
    addMissionEventHandler ["GroupCreated", {
        params ["_group"];

        if (FixitFox_debug) then {diag_log format ["NEWGroupCreated EH triggered: %1", _group];};
        
        // Small delay to ensure the group is fully initialized
        [_group] spawn {
            params ["_group"];
            // sleep 1;

            // Skip if group no longer exists or option is off
            if (isNull _group && !FixitFox_addspawned && !preExistingHC) exitWith {};
            
            // Get side of the group
            private _side = side _group;
            _subOrdExists = false;

            if (FixitFox_debug) then {diag_log format ["NEWGroupCreated EH triggered: %1 (Side: %2)", _group, _side];};

            // Skip if this is a system/logic group
            if (_side == sideLogic || {leader _group isKindOf "Logic"} || {leader _group isKindOf "VirtualMan_F"}) exitWith {
                if (FixitFox_debug) then {diag_log format ["GroupCreated EH: Skipping system/logic group: %1", _group];};
            };


            if !(_side in FixitFox_playerSides) exitWith { if (FixitFox_debug) then {diag_log format ["GroupCreated %1 - side %2 with no HC, SKIPPING", _group, _side];}; };


            _groupfiltered = [[_group], _side] call FixitFox_Filter_Groups;
            if (_groupfiltered isEqualTo []) exitWith {
                _exit = true;
                if (FixitFox_debug) then {diag_log format ["GroupCreated EH: REJECTED group: %1 (Side: %2)", _group, _side];};
            };


            //get HC module
            private _hcModule = missionNamespace getVariable [format ["HC_Module_%1", _side], objNull];
            if (isNull _hcModule) exitWith {
                if (FixitFox_debug) then {diag_log format ["FixitFox_createSubModule| No HC module found for group's side: %1", _side];};
                objNull
            };


            // for missions that already have a HC module setup, check if the new group was created by the mission script and is added to HC groups already
            if (preExistingHC) then {
                diag_log "++++++ preExisting setup, checking if new group has a subordinate module";
                sleep 2;
                private _leader = leader _group;
                private _existingSubModules = synchronizedObjects _leader select {typeOf _x == "HighCommandSubordinate"};
                if (count _existingSubModules > 0) then {
                    _subOrdExists = true;
                    if (FixitFox_debug) then {diag_log format ["GroupCreated EH: Already has a subordinate module", _group, _side];};
                };
            };

            // add subordinate modules if not existing already            
            if (FixitFox_addspawned && !_subOrdExists) then {
                [_group, _hcModule] call FixitFox_createSubModule;         

                // Assign groups to current commanders GUI Group Bar for this side
                private _commanders = _hcModule getVariable ["commanders", []];
                if (count _commanders > 0) then {
                    {
                        private _commander = _x;            
                                        
                        // Add groups to commander's HC GUI to group bar that aren't already there
                        private _responseID = format ["HC_assignment_%1_%2", _commander, serverTime];
                        [_commander, [_group], _responseID] remoteExec ["FixitFox_HC_getGroupsAndAssign", _commander];
                    } forEach _commanders;
                };

            };

            // add group to my custom variable for the side
            if (FixitFox_addspawned || _subOrdExists) then {
                _currentgroups = missionNamespace getVariable [format ["HC_FilteredGroups_%1", _side], []];
                missionNamespace setVariable [format ["HC_FilteredGroups_%1", _side], _currentgroups + [_group], true];
            };

            // if (FixitFox_debug) then {call FixitFox_HC_debug;} ;
        };
    }];
    
    // Add event handler to clean up when groups are deleted
    addMissionEventHandler ["GroupDeleted", {
        params ["_group"];

        if (FixitFox_debug) then {diag_log format ["GroupDeleted EH triggered: %1 side: %2", _group, _side];};

        [_group] call FixitFox_deleteGroup;
        
    }];
    
    if (FixitFox_debug) then {diag_log "SERVER-SIDE HC SETUP COMPLETE";};

    

    // =======================================================================
    // The vanilla waypoint type UNLOAD does not make halicopters land. This function converts UNLOAD to TR UNLOAD
    // Just use "UNLOAD" in the menu for helicopters.

    // Modified function with termination support
    FixitFox_fnc_updateAirUnloadWaypoints = {
        FixitFox_airUnloadLoop = true;
        
        while {FixitFox_airUnloadLoop && {FixitFox_autoConvertAirUnload}} do {
            try {
                {
                    private _side = _x;
                    private _groups = missionNamespace getVariable [format ["HC_FilteredGroups_%1", _side], []];
                    
                    {
                        private _group = _x;
                        if (isNull _group) then { continue };
                        
                        private _leader = leader _group;
                        private _vehicle = vehicle _leader;
                        
                        if (_vehicle != _leader && {_vehicle isKindOf "Air"}) then {
                            private _wpCount = count (waypoints _group);
                            for "_i" from 0 to (_wpCount - 1) do {
                                private _wp = [_group, _i];
                                if (waypointType _wp == "UNLOAD") then {
                                    _wp setWaypointType "TR UNLOAD";
                                    if (FixitFox_debug) then {
                                        diag_log format ["++++++++++++++++++ FixitFox HC: Changed waypoint type from UNLOAD to TR UNLOAD for group %1", _group];
                                    };
                                };
                            };
                        };
                    } forEach _groups;
                } forEach [west, east, resistance, civilian];
            } catch {
                if (FixitFox_debug) then {
                    diag_log format ["FixitFox HC: Error in updateAirUnloadWaypoints: %1", _exception];
                };
            };
            
            sleep 3;
        };
    };

    // Function to start the loop
    FixitFox_fnc_startAirUnloadCheck = {
        if (isNil "FixitFox_airUnloadHandle") then {
            FixitFox_airUnloadHandle = [] spawn FixitFox_fnc_updateAirUnloadWaypoints;
        };
    };

    // Function to stop the loop
    FixitFox_fnc_stopAirUnloadCheck = {
        FixitFox_airUnloadLoop = false;
        if (!isNil "FixitFox_airUnloadHandle") then {
            terminate FixitFox_airUnloadHandle;
            FixitFox_airUnloadHandle = nil;
        };
    };

    [] spawn FixitFox_fnc_startAirUnloadCheck;

}; //if (isServer) then {


// =================================================================================================
// ===== CLIENT-SIDE EVENT HANDLER - This runs on EVERY client (including server if player) ========
// =================================================================================================
if (hasInterface) then {


    if (BI_RespawnDetected_ != 4) then { //teamswitches that are not "GROUP" respawn method
        // TeamSwitch event handler - runs on the client where TeamSwitch occurs
        addMissionEventHandler ["TeamSwitch", {
            params ["_previousUnit", "_newUnit"];
            if (FixitFox_make_leader_TS) then {
                if (_newUnit != leader group _newUnit) then {
                    // _newUnit setGroupId [groupId group _newUnit];
                    group _newUnit selectLeader _newUnit;
                    [group _newUnit, _newUnit] remoteExec ["selectLeader", 0];
                    if (FixitFox_debug) then {
                        diag_log format ["FixitFox HC: Made %1 leader of group %2", name _newUnit, groupId group _newUnit];
                    };
                };
            };  
            if (FixitFox_debug) then {diag_log format ["TeamSwitch: %1 to %2", _previousUnit, _newUnit];};
            // [_previousUnit, _newUnit] remoteExec ["FixitFox_FNC_TeamSwitch", 2];
            [_previousUnit, _newUnit] call FixitFox_FNC_TeamSwitch;
        }];
    };

    if (BI_RespawnDetected_ == 4) then { //teamswitch type into "GROUP". The normal EH is broken for this, so we have to use this method      
        addMissionEventHandler ["PlayerViewChanged", {
            params [
                "_previousUnit", "_newUnit", "_vehicleIn",
                "_oldCameraOn", "_newCameraOn", "_uav"
            ];
            if (FixitFox_debug) then {diag_log "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!TRIGGERED PLAYERVIEW";};
            if (_previousUnit != _newUnit && !alive _previousUnit && alive _newUnit) then {
                if (FixitFox_make_leader_TS) then {
                    if (_newUnit != leader group _newUnit) then {
                        // _newUnit setGroupId [groupId group _newUnit];
                        group _newUnit selectLeader _newUnit;
                        [group _newUnit, _newUnit] remoteExec ["selectLeader", 0];
                        if (FixitFox_debug) then {
                            diag_log format ["FixitFox HC: Made %1 leader of group %2", name _newUnit, groupId group _newUnit];
                        };
                    };
                };  
                [_previousUnit, _newUnit] call FixitFox_FNC_TeamSwitch;
                if (FixitFox_debug) then {diag_log format ["!!!!!!!!!!!!!!!! PlayerViewChanged: _previousUnit %1 | _newUnit %2 | _vehicleIn %3 | _oldCameraOn %4 | _newCameraOn %5 | _uav %6", _previousUnit, _newUnit,_vehicleIn,_oldCameraOn,_newCameraOn,_uav];};
            };
        }];
    };



    addMissionEventHandler ["CommandModeChanged", {
        params ["_isHighCommand", "_isForced"];

        if (_isHighCommand) then {

            if (player == leader group player) then {
                setGroupIconsVisible FixitFox_HC_iconsapply;

                if (visibleMap && FixitFox_blufor_3rd_party) then {
                    setGroupIconsVisible [false, false];
                    [] spawn {
                        // Code to execute when map is opened
                        {_x setVariable ["MARTA_customicon", ["Empty"], true]} count allGroups;
                        sleep 0.4;
                        setGroupIconsVisible FixitFox_HC_iconsapply;
                    };
                };

            } else {              
                hcShowBar false;
            };

        } else {

            if (FixitFox_blufor_tracking) then {
                setGroupIconsVisible [true, false];
            } else {
                setGroupIconsVisible [false, false];
            };
        };


    }];

    
    addMissionEventHandler ["Map", {
        params ["_mapOpen", "_mapForced"]; 
        if (FixitFox_blufor_3rd_party) then {
                if (_mapOpen && hcShownBar) then {
                    setGroupIconsVisible [false, false];
                    [] spawn {
                        // Code to execute when map is opened
                        {_x setVariable ["MARTA_customicon", ["Empty"], true]} count allGroups;
                        sleep 0.4;
                        setGroupIconsVisible FixitFox_HC_iconsapply;
                    };
                } else {
                    // Code to execute when map is closed
                    {_x setVariable ["MARTA_customicon", nil, true]} count allGroups;
                };
        };
    }];

    // Add this in your player-side initialization
    player addEventHandler ["Respawn", {
        params ["_unit", "_corpse"];

        if (FixitFox_debug) then {diag_log format ["=== Respawn: %1 Corpse: %2", _unit, _corpse];};
        
        // Re-establish HC relationships if needed
        private _side = side group _unit;
        private _hcModule = missionNamespace getVariable [format ["HC_Module_%1", _side], objNull];
        
        if (!isNull _hcModule) then {
            // Make sure BIS_HC_scope is set
            _unit setVariable ["BIS_HC_scope", _hcModule, true];
            
            // Update commanders array
            private _commanders = _hcModule getVariable ["commanders", []];
            if !(_unit in _commanders) then {
                _commanders pushBack _unit;
                _hcModule setVariable ["commanders", _commanders, true];
            };
        };
    }];


    FixitFox_SymbolSides = {

        waitUntil {!(isNil "BIS_marta_mainscope")};

        if (FixitFox_inititial_run) then { // if this function is called a second time, reset all groups and reveal groups     
            _resetGroups = allGroups select {side _x != playerSide};
            {_x setVariable ["MARTA_customicon", nil, true]} count _resetGroups;
            if (FixitFox_debug) then {diag_log format ["===================================== RESET ICONS _resetGroups: %1", _resetGroups]};
            player setVariable [ "MARTA_reveal", []];
        };

        FixitFox_inititial_run = true; //triggered on first run 

        FixitFox_enemySides = [side player] call BIS_fnc_enemySides;
        FixitFox_friendlySides = [side player] call BIS_fnc_friendlySides;
        FixitFox_friendlySides = FixitFox_friendlySides - [side player];

        if (FixitFox_debug) then {diag_log format ["===================================== FixitFox_enemySides: %1", FixitFox_enemySides];};
        if (FixitFox_debug) then {diag_log format ["===================================== FixitFox_friendlySides: %1", FixitFox_friendlySides];};
        
        _OPFOR = 0;
        _BLUFOR = 0;
        _INDEPENDENT = 0;
        _CIVILIAN = 0;
        _hidegroups = [];
        _revealgroups = []; // only if you want to initialise with all non same side freindlies as visible at start

        if (side player == WEST) then {       
            _BLUFOR = 1;
        };
        if (side player == EAST) then {
            _OPFOR = 1;
        };
        if (side player == INDEPENDENT) then {
            _INDEPENDENT = 1;
        };
        if (side player == CIVILIAN) then {
            _CIVILIAN = 1;
        };

            
        if (FixitFox_blufor_scope == 0) then { //SIDE ONLY
            _hidegroups = allGroups select {side _x != playerSide};       
        };

        if (FixitFox_blufor_scope >= 1) then { //SIDE + ALLIES, and also SIDE + ALLIES + ENEMIES
                if (INDEPENDENT in FixitFox_friendlySides) then {
                    _INDEPENDENT = 1;
                    _hidegroups = allGroups select {side _x != playerSide && side _x != INDEPENDENT}; 
                    if (FixitFox_friendlies_init) then {                       
                        _revealgroups = allGroups select {side _x == playerSide || side _x == INDEPENDENT}; 
                    };
                };
                if (WEST in FixitFox_friendlySides) then {
                    _BLUFOR = 1;
                    _hidegroups = allGroups select {side _x != playerSide && side _x != WEST}; 
                    if (FixitFox_friendlies_init) then {
                        _revealgroups = allGroups select {side _x == playerSide || side _x == WEST}; 
                    };
                };
                if (EAST in FixitFox_friendlySides) then {
                    _OPFOR = 1;
                    _hidegroups = allGroups select {side _x != playerSide && side _x != EAST}; 
                    if (FixitFox_friendlies_init) then {
                        _revealgroups = allGroups select {side _x == playerSide || side _x == EAST}; 
                    };
                };
                if (_hidegroups isEqualTo []) then {
                    _hidegroups = allGroups select {side _x != playerSide};
                };
        }; 
        if (FixitFox_blufor_scope == 2) then { //SIDE + ALLIES + ENEMIES
                if (FixitFox_non_blufor_marker == 0) then {
                    if (INDEPENDENT in FixitFox_enemySides) then {
                        _INDEPENDENT = 1;
                    };
                    if (WEST in FixitFox_enemySides) then {
                        _BLUFOR = 1;
                    };
                    if (EAST in FixitFox_enemySides) then {
                        _OPFOR = 1;
                    };
                    
                };
             _hidegroups = allGroups select {side _x == CIVILIAN}; 
        };   

        if (FixitFox_debug) then {diag_log format ["===================================== _hidegroups: %1", _hidegroups];};
        if (FixitFox_debug) then {diag_log format ["===================================== _revealgroups: %1", _revealgroups];};

     
        {_x setVariable ["MARTA_customicon", ["Empty"], true]} count _hidegroups;

     
        if (FixitFox_friendlies_init && _revealgroups isNotEqualTo []) then {
            player setVariable [ "MARTA_reveal", _revealgroups];
        };

        BIS_marta_mainscope setvariable ["rules",[["o_",[0.5,0,0,_OPFOR]],["b_",[0,0.3,0.6,_BLUFOR]],["n_",[0,0.5,0,_INDEPENDENT]],["n_",[0.4,0,0.5,_CIVILIAN]]], true];

    };

    [] call FixitFox_SymbolSides;

    // Function to store group colors for a commander
    FixitFox_storeGroupColors = {
        params ["_commander", ["_storeID", ""]];
        
        private _storedColors = [];
        private _hcGroups = hcAllGroups _commander;
        
        {
            private _group = _x;
            private _params = _commander hcGroupParams _group;
            
            if (count _params > 0) then {
                _storedColors pushBack [_group, _params select 1]; // Store [group, teamColor]
                if (FixitFox_debug) then {diag_log format ["Stored color for group %1: %2", _group, _params select 1];};
            };
        } forEach _hcGroups;
        
        // If storeID is provided, store in global variable for network transfer
        if (_storeID != "") then {
            missionNamespace setVariable [format ["FixitFox_TeamColors_%1", _storeID], _storedColors, true];
        };
        
        _storedColors
    };
    
    // Function for remote execution to store group colors before teamswitch
    FixitFox_remoteStoreGroupColors = {
        params ["_commander", "_playerID"];
        private _storeID = format ["%1_%2", name _commander, _playerID];
        [_commander, _storeID] call FixitFox_storeGroupColors;
    };

    // Function to apply stored colors to groups for a new commander
    FixitFox_applyGroupColors = {
        params ["_commander", "_storedColors", "_ownerID"];
        
        {
            _x params ["_group", "_teamColor"];
            
            if (!isNull _group) then {
                [_commander, [_group, groupId _group, _teamColor]] remoteExec ["hcSetGroup", _ownerID];
                if (FixitFox_debug) then {diag_log format ["Applied color %2 to group %1", _group, _teamColor];};
            };
        } forEach _storedColors;
    };

    FixitFox_FNC_TeamSwitch = {
        params ["_previousUnit", "_newUnit"];
        if (FixitFox_debug) then {diag_log format ["=== TeamSwitch: %1 to %2", _previousUnit, _newUnit];};

        [_previousUnit, _newUnit] spawn {
            params ["_previousUnit", "_newUnit"];

            // Get basic info about the units involved
            private _previousUnitSide = side group _previousUnit;
            private _newUnitSide = side group _newUnit;
            private _playerID = getPlayerUID _newUnit;
            
            // Store color information - different method depending on if local or remote
            private _storeID = format ["%1_%2", name _previousUnit, _playerID];
            private _storedGroupColors = [];
            private _ownerID = owner _newUnit;
            
            // if (local _previousUnit) then {
                // Local unit - can get colors directly
                // _storedGroupColors = [_previousUnit, _storeID] call FixitFox_storeGroupColors;
            // } else {
                // Remote unit - need to use remoteExec to store colors
                missionNamespace setVariable [format ["FixitFox_TeamColors_%1", _storeID], nil, true];
                [_previousUnit, _playerID] remoteExec ["FixitFox_remoteStoreGroupColors", owner _previousUnit];
                // 
                _time = time;
                waitUntil {
                    !isNil {missionNamespace getVariable format ["FixitFox_TeamColors_%1", _storeID]} || 
                    (time > _time + 3)
                };
                // sleep 0.1;
                _storedGroupColors = missionNamespace getVariable [format ["FixitFox_TeamColors_%1", _storeID], []];
            // };
            
            if (FixitFox_debug) then {diag_log format ["TeamSwitch sides: Previous=%1, New=%2", _previousUnitSide, _newUnitSide];};

            // Get the HC modules for both sides
            private _previousSideModule = missionNamespace getVariable [format ["HC_Module_%1", _previousUnitSide], objNull];
            private _newSideModule = missionNamespace getVariable [format ["HC_Module_%1", _newUnitSide], objNull];
            
            // Update commanders array for previous unit's module
            if (!isNull _previousSideModule) then {
                // Get current commanders array and remove the previous unit
                private _commanders = _previousSideModule getVariable ["commanders", []];
                _commanders = _commanders - [_previousUnit];
                _previousSideModule setVariable ["commanders", _commanders, true];
                if (FixitFox_debug) then {diag_log format ["TeamSwitch: Removed %1 from commanders array for side %2", _previousUnit, _previousUnitSide];};
                
                // Remove synchronization
                if (FixitFox_debug) then {diag_log format ["Removing sync between previous unit and module: %1 <-> %2", _previousUnit, _previousSideModule];};
                _previousUnit synchronizeObjectsRemove [_previousSideModule];
                _previousSideModule synchronizeObjectsRemove [_previousUnit];
            } else {
                if (FixitFox_debug) then {diag_log format ["No previous HC module found for side %1", _previousUnitSide];};
            };
            
            
            // hcRemoveAllGroups _previousUnit;
            [_previousUnit] remoteExec ["hcRemoveAllGroups", 2];
            
            // Reset previous group icon
            (group _previousUnit) setVariable ["MARTA_customicon", nil, true];
            
            _previousUnit disableAI "all";
            _previousUnit enableAI "all";

            // Set up new unit as commander
            if (!isNull _newSideModule) then {
                // Update the commanders array to include the new unit
                private _commanders = _newSideModule getVariable ["commanders", []];
                if !(_newUnit in _commanders) then {
                    _commanders pushBack _newUnit;
                    _newSideModule setVariable ["commanders", _commanders, true];
                    if (FixitFox_debug) then {diag_log format ["TeamSwitch: Added %1 to commanders array for side %2", _newUnit, _newUnitSide];};
                };
                
                // Set BIS_HC_scope if needed
                if (isNil {_newUnit getVariable "BIS_HC_scope"}) then {
                    _newUnit setVariable ["BIS_HC_scope", _newSideModule, true];
                    
                    // Initialize HC GUI variables
                    _newSideModule setVariable ["LMB_hold", false, true];
                    _newSideModule setVariable ["RMB_hold", false, true];
                    _newSideModule setVariable ["ALT_hold", false, true];
                    _newSideModule setVariable ["SHIFT_hold", false, true];
                    _newSideModule setVariable ["CTRL_hold", false, true];
                    
                    if (FixitFox_debug) then {diag_log format ["Initialized BIS_HC_scope for %1", _newUnit];};
                };
            
                // Only sync if not already done
                if (count (synchronizedObjects _newUnit select {_x == _newSideModule}) == 0) then {
                    if (FixitFox_debug) then {diag_log format ["Adding sync between new unit and module: %1 <-> %2", _newUnit, _newSideModule];};
                    _newUnit synchronizeObjectsAdd [_newSideModule];
                    _newSideModule synchronizeObjectsAdd [_newUnit];
                } else {
                    if (FixitFox_debug) then {diag_log format ["New unit already synced to module: %1 <-> %2", _newUnit, _newSideModule];};
                };
                
                // Get groups for the new unit's side
                private _allSideGroups = allGroups select {side _x == _newUnitSide};
                
                // Retrieve the filtered groups for this side (these are the groups that should be in HC)
                private _filteredGroups = missionNamespace getVariable [format ["HC_FilteredGroups_%1", _newUnitSide], []];
                
                // If we have no stored filtered groups, apply default filtering
                if (_filteredGroups isEqualTo []) then {
                    if (FixitFox_debug) then {diag_log "TeamSwitch: No stored filtered groups found, applying default filtering";};
                    _filteredGroups = _allSideGroups select {(units _x) findIf {!simulationEnabled _x} == -1};
                };
                
                // Check what groups the new unit already has
                private _currentHCGroups = hcAllGroups _newUnit;
                
                if (FixitFox_debug) then {diag_log format ["TeamSwitch: Found %1 total side groups, %2 filtered groups, %3 current HC groups", 
                    count _allSideGroups, count _filteredGroups, count _currentHCGroups];};

                if (FixitFox_ignorePlayerGroups) then { _filteredGroups = _filteredGroups - [(group player)]};
                
                
                // First add all the groups
                {
                    if !(_x in _currentHCGroups) then {
                        // Use remoteExec to ensure hcSetGroup runs on the client machine where _newUnit is local
                        [_newUnit, [_x]] remoteExec ["hcSetGroup", _ownerID];
                        if (FixitFox_debug) then {diag_log format ["[TS]++++++++++++++++++ hcSetGroup: Assigned group %1 to commander %2 via remoteExec to owner %3", 
                            _x, name _newUnit, _ownerID];};
                    };
                } forEach _filteredGroups;
                
                // Now apply the stored colors (we do this after adding all groups to ensure colors are transferred correctly)
                if (count _storedGroupColors > 0) then {
                    [_newUnit, _storedGroupColors, _ownerID] call FixitFox_applyGroupColors;
                };
     
            } else {
                if (FixitFox_debug) then {diag_log format ["Error: No HC module found for side %1", _newUnitSide];};
            };

            if (FixitFox_debug) then {diag_log "TeamSwitch HC transfer complete";};
        }; //end of spawn
    }; // END OF FNC_TeamSwitch

    



    if (1 in FixitFox_Detected_Mods || 2 in FixitFox_Detected_Mods) then {

        FixitFox_targetGroupHandler = {};

    } else {

        FixitFox_targetGroupHandler = {
            params ["_display", "_key", "_shift", "_ctrl", "_alt"];
            
            // Check if HC is enabled and interface is shown
            if (!FixitFox_HC_enable || !hcShownBar || {isNull (player getVariable ["BIS_HC_scope", objNull])}) exitWith {false};
            
            // Get what player is looking at
            private _target = cursorTarget;
            if (isNull _target) exitWith {false};
            
            // Get the group
            private _targetGroup = switch (true) do {
                case (_target isKindOf "CAManBase"): {
                    group _target
                };
                case (_target isKindOf "AllVehicles"): {
                    if (count crew _target > 0) then {
                        group (driver _target)
                    } else {
                        grpNull
                    };
                };
                default {grpNull};
            };
            
            // Check if valid group and on player's side
            if (!isNull _targetGroup && {side _targetGroup == playerSide}) then {
                // Sound feedback
                playSound "beep";
                        
                // Select the group
                player hcSelectGroup [_targetGroup];
                
                // if (FixitFox_debug) then {
                //     systemChat format ["Selected group: %1", groupId _targetGroup];
                // };
                
                true
            } else {
                false
            };
        };

    };

    FixitFox_centerMapOnSelectedGroups = {
        params ["_display", "_key", "_shift", "_ctrl", "_alt"];
        
        // Check if HC is enabled and interface is shown
        if (!FixitFox_HC_enable || !hcShownBar) exitWith {false};
        
        // Get selected groups
        private _selectedGroups = hcSelected player;
        private _count = count _selectedGroups;
        
        // Check if we have selected groups
        if (_count == 0) exitWith {
            // if (FixitFox_debug) then {
                // systemChat "No HC groups selected to center on";
            // };
            false
        };
        
        // If more than one group is selected, show hint
        if (_count > 1) exitWith {
            hint "Cannot center map on multiple groups";
            false
        };
        
        // Open map if it's not already open
        if (!visibleMap) then {
            openMap true;
        };
        
        // Center on the selected group
        private _selectedGroup = _selectedGroups select 0;
        private _leaderPos = getPos (leader _selectedGroup);
        
        if (_leaderPos distance [0,0,0] > 10) then {
            mapAnimAdd [0.5, 0.1, _leaderPos]; 
            mapAnimCommit;
            
            // if (FixitFox_debug) then {
                // systemChat format ["Centered map on group: %1", groupId _selectedGroup];
            // };
        };
        
        true
    };



}; // if (hasInterface) then {



// =================================================================================================
// ======================================= END OF SCRIPT ==========================================
// ================================================================================================= 
