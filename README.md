# High Command Fixit Fox: A High Command Patch (Arma 3 mod)

[Here on Steam](https://steamcommunity.com/sharedfiles/filedetails/?id=3453561688)

This is a patch that the Arma 3 devs should have already implemented.

- Arma's High Command now works after teamswitch and respawn
- Designed to work with other HC mods: Platoon Leader, High Command Enhanced, High Command Converter, and any mods that use HC
- Adds a High Command module to any mission in the Workshop
- Option to work with other Blufor trackers, like ACE Blufor tracker
- Option to hide allied and enemy markers (which vanilla does not)
- Option to turn off 3D markers and only use map
- Detects when new groups are spawned in-game
- Filters out groups according to user settings
- Can enable multiple commanders, same side or opposing sides
- Works on both SP and MP
- Key commands to select groups you look at and center map on selected group

This fixes the Arma vanilla High Command system, which is the framework for most other High Command mods, making this mod compatible with those mods. It enhances mods such as Platoon Leader 1.3, Platoon Leader Redux, High Command Enhanced, High Command Converter, or any mod that uses the High Command module.

None of those mods work after teamswitch due to vanilla High Command limitations. Now that's fixed. They also require a High Command module in the mission to function. If the mission maker didn't include it, these mods are useless. High Command Fixit Fox can automatically add High Command to any mission.

If you want to use another Blufor tracker (NATO symbols on the map for your side), High Command's own NATO symbols can clash, making the map messy with two layers of marker symbols. This mod has an option to hide the vanilla NATO symbols and only show the selection rings and waypoints, so you can use other Blufor trackers.

If a High Command module and its subordinate modules are already present in a mission, High Command Fixit Fox will use those modules and add all the extra functionality.

The script version should work on dedicated servers, saving mission makers time so they don’t have to deal with teamswitch or respawn issues.

> **Note**: 
> - High Command mods that don’t use the vanilla High Command module, like Advanced AI Command 1 & 2 and Platoon Commander 1 & 2, will clash with this mod as they use their own system, not the HC module.
> - For missions with High Command already set up, like Antistasi, it’s best to turn off the "Add Spawned Groups" option and let the mission control which groups are added to High Command. This option automatically adds spawned groups.
> - To make a helicopter land, use the "unload" waypoint type and enable the option.

# Known Issues
- Platoon Leader (and versions derived from it) uses its own enemy marker system (though it still uses High Command markers for friendlies), so settings affecting enemy markers in High Command Fixit Fox do not affect Platoon Leader’s enemy markers. A fix is in progress.

# *Update 2025.05.27*
- Now signed

# *Update 2025.04.13*
- New option: Turn off spawned groups. Disable this if you want missions like Antistasi to control which new groups are added to High Command, as intended by mission makers.
- Group colors now transfer after teamswitch

# *Update 2025.04.12*
- CBA key shortcut added: Select group you are aiming at (default is "T" like Arma’s target feature)
- CBA key shortcut added: Center map on selected group
- Bug fixes

# *Update 2025.04.10*
- Platoon Leader hack: Right-click on waypoints now restores the menus (PL had removed these menus)
- Option to convert the "UNLOAD" waypoint type into "TR UNLOAD" to make a helicopter land
