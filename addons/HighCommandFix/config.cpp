class CfgPatches
{
    class HighCommandFix
    {
        name="High Command Fixit Fox";
        units[] = {};
        weapons[] = {};
        requiredVersion = 0.1;
		requiredAddons[]=
		{
			"cba_xeh",
			"cba_settings",
		};
        author = "Bendy";
        authorUrl = "";
        version = "0.1";
        versionStr = "0.1";
        versionAr[] = {0, 1, 0};
    };
};

class cfgFunctions
{
    class HighCommandFix
    {
        class Functions
        {
            class init
            {
                postInit = 1;
                // preInit = 1; 
                file = "HighCommandFix\init.sqf";
            };
        };
    };
};


class Extended_PreInit_EventHandlers {
    class My_pre_init_highcommandfix {
        init = "call compile preprocessFileLineNumbers '\HighCommandFix\XEH_preInit.sqf'";
    };
};



class Extended_PostInit_EventHandlers
{
	class My_post_init_highcommandfix
	{
		clientInit="call compile preProcessFileLineNumbers '\HighCommandFix\XEH_postInit.sqf'";
	};
};

// hack for platoon leader
class RscHCWPRootMenu
    {
        class Items
        {
            class Type
            {
                shortcuts[] = {2};
                title = "Type";
                shortcutsAction = "CommandingMenu1";
                menu = "RscHCWPType";
                show = "1";
                enable = "1";
                speechId = 0;
            };
            class CombatMode
            {
                shortcuts[] = {3};
                title = "Combat Mode";
                shortcutsAction = "CommandingMenu2";
                menu = "RscHCWPCombatMode";
                show = "1";
                enable = "1";
                speechId = 0;
            };
            class Formations
            {
                shortcuts[] = {4};
                title = "Formation";
                shortcutsAction = "CommandingMenu3";
                menu = "RscHCWPFormations";
                show = "1";
                enable = "1";
                speechId = 0;
            };
            class Speed
            {
                shortcuts[] = {5};
                title = "Speed";
                shortcutsAction = "CommandingMenu4";
                menu = "RscHCWPSpeedMode";
                show = "1";
                enable = "1";
                speechId = 0;
            };
            class Wait
            {
                shortcuts[] = {6};
                title = "Timeout";
                shortcutsAction = "CommandingMenu5";
                menu = "RscHCWPWait";
                show = "1";
                enable = "1";
                speechId = 0;
            };
            class WaitUntil
            {
                shortcuts[] = {7};
                title = "Wait until";
                shortcutsAction = "CommandingMenu6";
                menu = "#USER:HCWPWaitUntil";
                show = "1";
                enable = "1";
                speechId = 0;
            };
            class WaitRadio
            {
                shortcuts[] = {8};
                title = "Radio";
                shortcutsAction = "CommandingMenu7";
                menu = "#USER:HCWPWaitRadio";
                show = "1";
                enable = "1";
                speechId = 0;
            };
            class Separator1
            {
                shortcuts[] = {0};
                title = "";
                command = -1;
            };
            class CreateTask
            {
                shortcuts[] = {9};
                class Params
                {
                    expression = "'WP_CREATETASK' call BIS_HC_path_menu";
                };
                title = "Create Task";
                shortcutsAction = "CommandingMenu8";
                command = -5;
                show = "1";
                enable = "1";
                speechId = 0;
            };
            class Separator2
            {
                shortcuts[] = {0};
                title = "";
                command = -1;
            };
            class CancelWP
            {
                shortcuts[] = {1};
                class Params
                {
                    expression = "'WP_CANCELWP' call BIS_HC_path_menu";
                };
                title = "<img color='#b20000' image='\A3\ui_f\data\igui\cfg\simpleTasks\types\move_ca.paa'/><t> Cancel Waypoint</t>";
                shortcutsAction = "CommandingMenu1";
                command = -5;
                show = "";
                enable = "";
                speechId = 0;
            };
            class Back
            {
                shortcuts[] = {14};
                shortcutsAction = "NavigateMenu";
                title = "";
                command = -4;
                speechId = 0;
            };
        };
        access = 0;
        title = "";
        atomic = 0;
        vocabulary = "";
    };


