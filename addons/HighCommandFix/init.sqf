// waitUntil {time > 0}; //this pauses until actual game starts.
 diag_log "                                                                                 				           "; 
 diag_log "                                                                                  			               "; 
 diag_log "                                                                                    			               "; 
 diag_log "                                                                                   		   	               "; 
diag_log "                                                                                   			               '"; 
diag_log "============================================================================================================='";
diag_log "==================================================== MOD ===================================================='";
diag_log "================================================== init.sqf ================================================='";
diag_log "============================================================================================================='";
diag_log "============================================================================================================='";

if !(FixitFox_HC_enable) exitWith {
    systemChat 'Fixit Fox: High Command Bypassed';    
    diag_log "init. sqf !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! Fixit Fox: High Command Bypassed";
};


if (FixitFox_debug_start_method and isServer and hasInterface) then {
    lauchFixitFox = {
        [] execvm "HighCommandFix\main.sqf";
        player removeAction actionFixitFoxID1;
    };
    actionFixitFoxID1 = player addAction [format ["<t size='1.5' color='#DAF7A6'>Start HC: Fixit Fox</t>","nuddin"], {hint "..initializing";[] call lauchFixitFox}];
} else {
    [] execvm "HighCommandFix\main.sqf";
};





