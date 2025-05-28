 diag_log "                                                                                 				           "; 
 diag_log "                                                                                  			               "; 
 diag_log "                                                                                    			               "; 
 diag_log "                                                                                   		   	               "; 
diag_log "                                                                                   			               '"; 
diag_log "============================================================================================================='";
diag_log "==================================================== MOD ===================================================='";
diag_log "============================================= XEH_postInit.sqf =============================================='";
diag_log "============================================================================================================='";
diag_log "============================================================================================================='";

if !(FixitFox_HC_enable) exitWith {
    systemChat 'Fixit Fox: High Command Bypassed';    
    diag_log "XEH_postInit !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! Fixit Fox: High Command Bypassed";
};

// Check if Antistasi mod is loaded
FixitFox_antistasiLoaded = false;

// Method 1: Check for a specific class from Antistasi
if (isClass (configFile >> "CfgPatches" >> "A3A_core")) then {
    FixitFox_antistasiLoaded = true;
};

// Method 2: Alternative check for Antistasi
if (!FixitFox_antistasiLoaded && {isClass (configFile >> "A3A" >> "Events")}) then {
    FixitFox_antistasiLoaded = true;
};

// Method 3: Check for Antistasi functions
if (!FixitFox_antistasiLoaded && {!isNil "A3A_fnc_initServer"}) then {
    FixitFox_antistasiLoaded = true;
};

if (FixitFox_antistasiLoaded) then {
    diag_log "[FixitFox] Antistasi mod detected - enabling compatibility mode";
    // Your Antistasi compatibility code here
} else {
    diag_log "[FixitFox] Antistasi mod not detected - using standard initialization";
    // Regular initialization code
};

FixitFox_Detected_Mods = [];

if (isClass (configFile >> "cfgPatches" >> "Pl_Mod")) then {
    systemChat "DETECTED: Platoon Leader 1.3";
    FixitFox_Detected_Mods pushBack 1;
};
if (isClass (configFile >> "cfgPatches" >> "Komodo_PlatoonLeader")) then {
    systemChat "DETECTED: Platoon Leader Redux";
    FixitFox_Detected_Mods pushBack 2;
};  
if (isClass (configFile >> "cfgPatches" >> "HCC155")) then {
    systemChat "DETECTED: HCC - Hich Command Converter";
    FixitFox_Detected_Mods pushBack 3;
};
if (isClass (configFile >> "cfgPatches" >> "AIO_AIMENU")) then {
    systemChat "DETECTED: All-in-One Command Menu (Deluxe)";
    FixitFox_Detected_Mods pushBack 4;
};
if (isClass (configFile >> "cfgPatches" >> "HCE_Mod")) then {
    systemChat "DETECTED: High Command Enhanced";
    FixitFox_Detected_Mods pushBack 5;
};
if (isClass (configFile >> "cfgPatches" >> "Addon_PC")) then {
    systemChat "DETECTED: Platoon Commander 2";
    FixitFox_Detected_Mods pushBack 6;
};
if (isClass (configFile >> "cfgPatches" >> "AICommand")) then {
    systemChat "DETECTED: Advanced AI Command";
    FixitFox_Detected_Mods pushBack 7;
};
if (isClass (configFile >> "cfgPatches" >> "DrongosCommandEnhancement")) then {
    systemChat "DETECTED: Drongos Command Enhancement";
    FixitFox_Detected_Mods pushBack 8;
};


// [] execvm "HighCommandFix\init.sqf";
// [] execvm "HighCommandFix\initserver.sqf";

