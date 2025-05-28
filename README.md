[h1]A High Command patch. [/h1]

This is a patch that the Arma devs should of already done.


1. Arma's High Command now works after teamswitch and respawn
2. Designed to work with other HC mods: Platoon Leader, High Command Enhanced, High Command Converter, etc any mods that use HC
3. Adds a High Command module to any mission in the Workshop
4. Option to work with other Blufor trackers, like ACE Blufor tracker etc 
5. Option to hide allied and enemy markers  (which vanilla does not)
6. Option to turn off 3D markers and only use map
7. Detects when new groups are spawned in game
8. Filters out groups according to user settings
9. Can enable multiple commanders, same side or opposing sides
10. Works on both SP and MP 
11. Key commands to select groups you look at and centre map on selected group

This fixes the Arma vanilla high command system, which is the framework for most other high command mods, so this mod is compatible with those mods.
It enhances other mods such as Platoon Leader 1.3,  Platoon Leader Redux, High Command Enhanced, High Command Converter, or any mod that uses the High Command module.

None of those mods work after teamswitch, this is due to vanilla high command limitation. Now thats fixed. They also need a high command module in the mission already present to work. So if the mission maker didnt include it, these mods are useless. Not anymore, High Command Fixit Fox can automatically add High Command to any mission.

Also if you want to use another Blufor tracker (NATO symbols on map for your side), then high command's own NATO symbols clash with it making the map very messy, as there are two layers of marker symbols over the top of each other. This has an option to hide the vanilla NATO symbols and only show the selection rings and waypoints, so you can use other Blufor trackers.

If high command module and its subordinate modules are already present in a mission, then High Command Fixit Fox will just use those modules and add all the extra functionality.

Script version should work on dedicated servers, saving mission makers time so they dont have to deal with teamswitch or respawn issues.

*High command mods that dont use the vanilla High Command module will clash wirth this, like Advanced AI Command 1 & 2 and Platood Commander 1 & 2. They use their own system, they dont use the HC module.
*If you are using missions with High Command already set up, ilike Antisasi, ts best to turn off  the option "Add Spawned Groups" and let the mission control which groups are added to High Command. This option is an automatic add of spawned groups. 
*If you want a helicopter to land, use the "unload" waypoint type and have the option on

[h1]KNOWN ISSUES[/h1]
- Platoon Leader (and versions from the original) uses its own enemy marker system (however for friendlies it still uses high command markers) so settings affecting enemy markers in High Command Fixit Fox do not affect Platoon Leaders enemy markers. Working on a fix.

[h1][i]*Update 2025.05.27[/i][/h1]
[list]
    [*]  Now signed
[/list]
[h1][i]*Update 2025.04.13[/i][/h1]
[list]
    [*]  New option: Turn off spawned groups. Turn this off if you want a missions like Antistasi to only decide which new groups to add to High Command. As mission makers intended.
    [*]  Group colours now transfer after teamswitch
[/list]
[h1][i]*Update 2025.04.12[/i][/h1]
[list]
    [*]  CBA key shortcut added: select group you are aiming at (default is "T" like Arma target feature)
    [*]  CBA key shortcut added: centre map on selected group 
    [*]  Bug fixes
[/list]
[h1][i]*Update 2025.04.10[/i][/h1]
[list]
    [*]  Platoon Leader hack: now the right click on waypoints has the menus back (PL deleted these menus)
    [*]  Option to make the "UNLOAD" waypoint type convert into "TR UNLOAD" so that it will make a helicopter land.
[/list]


