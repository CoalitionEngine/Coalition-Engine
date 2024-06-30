<img src="https://avatars.githubusercontent.com/u/170119669" width="25%" style="display: block; margin: auto;" />
<p align="center"><h2 align="center">Coalition Engine</h2></p>
<p align="center">A <span style="color:red">modern</span> Undertale engine developed by <span style="color:yellow"><a href="https://gamejolt.com/@Edens_studio" target="_blank">Eden</a></span>, <span style="color:cyan"><a href="https://gamejolt.com/@Panthervention" target="_blank">Panthervention</a></span>, <span style="color:green"><a href="https://gamejolt.com/@RTFTR" target="_blank">RTF</span></a></p>

<p align="center"><a href="https://github.com/CoalitionEngine/Coalition-Engine/releases">Download the .yymps here.</a></p>
</p>

---

Coalition Engine is an Undertale engine that aims to create the most optimized environment to maximize player experience.

This engine features:

- Existing documentation (how is this even a feature, it's supposed to be a basic thing)
- Potential cross platform support
- Safe data saving
- Optimized polygon board
- Anti-UTMT support (kind of)

## What platforms does this engine support?

Potentially every, although some platforms are not fully tested due to the lack of use (such as HTML) and platforms we don't do test on a regular basis.

## Which Game Maker version should I use to use this engine?

Since this engine is developed in 2023.11.1.129 as of now, this will be the minimal version of GM required, note that this engine is rather dependant on external libraries so you may need to update GM to match their minimal versions.

## I encountered a bug on XXX, how do I fix it?

You can file a bug report on Github using 'Issues', or use the bug report channel on the [official Discord server](https://discord.gg/VyYghseRHf), both are acceptable!

## You didn't add a feature that was in Undertale!/There is a feature that would be cool to add!

Good! You proved that we are idiots! Go put your suggestion on the suggestions channel in our server!

# Need to know

You should not edit anything in the 'Internal' folder unless you have some degree of GML knowledge.
Folders marked with '()' i.e. (Camera) can be removed if you do not need them as these functions
only acts as easy access to the static functions for lesser experienced users.
'(System)' is an exception, this group of functions **should not be modified**.

## Engine updating

Even if some precautions have been made to prevent your code to be overwritten from engine updates,
you should create backups of your project before updating the engine version.

There are two ways to update the engine, by pseudo-clean install using the .yymps file or clean installing
by pulling from the Github page. Obviously pulling the from the Github page would be cleaner than importing
the .yymps file, however some of your codes may get overwritten. As of version 0.7.1, assets that may
be modified by the user are now seperated into  the 'External' subfolder within the main engine folder, 
**everything inside is not included in the .yymps file**.

If you intend to update the engine via the .yymps file, you should read the update log to check for any
removed assets that are needed to be deleted after importing the file.
If you intend to update the engine via pulling from Github, you should delete the entire 'Coalition Engine'
folder before pulling.

!> By clean installing through Github pulling, references to core objects like `oEnemyParent` and 
overworld collision tiles/objects in rooms may be lost.
You are required to manually set them again after updating it this way.

If you have little to no GML knowledge, you should look up the Game Maker Manual or at least Google before asking questions like "How do I make an object" or "I don't know how to use this Game Maker function".

## Naming convection

There is a general naming convection in this engine.
Variables that begin with '__' are for internal use and should not be called directly to prevent incompatibllity for future updates.
Variables with any other naming convection are for calling by users.