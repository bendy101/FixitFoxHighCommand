# My Awesome Mod

A template for an Arma 3 mod.

## Structure

This mod template follows the standard Arma 3 mod structure:

```
MyAwesomeMod/
├── addons/           # Main folder containing PBO-ready content
│   └── my_component/ # A component of your mod (will be packed to my_component.pbo)
│       ├── config.cpp        # Main config file
│       ├── functions/        # For your SQF function scripts
│       │   ├── fn_myFunc.sqf
│       │   └── CfgFunctions.hpp
│       ├── data/             # For any data/assets
│       ├── ui/               # UI elements
│       ├── models/           # 3D models
│       └── textures/         # Textures
├── keys/             # Public keys for your mod
│   └── MyAwesomeMod.bikey
├── logo.paa          # Mod logo (PAA format)
├── mod.cpp           # Mod metadata file
├── README.md         # Documentation
└── LICENSE           # License information
```

## Build Instructions

1. Edit the files according to your mod's needs
2. Use Arma 3 Tools to pack the PBO files:
   - Pack the `my_component` folder into `my_component.pbo`
   - Place the PBO file in the `addons` folder
3. Generate a key using the Arma 3 Tools DSCreateKey utility
4. Sign your PBOs with the DSSignFile utility 
5. Place your public key in the `keys` folder

## Usage

1. Install the mod via the Arma 3 Launcher or manually place it in your Arma 3 mods folder
2. Enable the mod in the launcher before starting the game

## License

See the LICENSE file for details. 