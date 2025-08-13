<img src="https://avatars.githubusercontent.com/u/170119669" width="25%" style="display: block; margin: auto;" />
<p align="center"><h2 align="center">Coalition Engine</h2></p>
<p align="center">A <span style="color:red">modern</span> Undertale engine developed by <span style="color:yellow"><a href="https://gamejolt.com/@Edens_studio" target="_blank">Eden</a></span>, <span style="color:cyan"><a href="https://gamejolt.com/@Panthervention" target="_blank">Panthervention</a></span>, <span style="color:green"><a href="https://gamejolt.com/@RTFTR" target="_blank">RTF</span></a></p>

<p align="center"><a href="https://github.com/CoalitionEngine/Coalition-Engine/releases">Download the .yymps here.</a></p>
</p>

---

Coalition Engine is an Undertale engine that aims to create the most optimized environment to maximize player experience.

This engine features:

- Existing documentation (You are reading it now.)
- Complete battle and overworld mechanics
- Active support on troubleshooting
- Potential cross platform support

## Engine updating

Even if some precautions have been made to prevent your code to be overwritten from engine updates via importing the .yymps,
you should create backups of your project before updating the engine version. Additionally, it is
**strongly recommended** that you create a seperate group within your GM project specifically for you to
update the engine more easily.

There are two ways to update the engine, by just importing the .yymps file or clean installing
by pulling from the Github page. Obviously pulling the from the Github page would be cleaner than importing
the .yymps file, however some of your codes may get overwritten. As of version 0.7.1, assets that may
be modified by the user are now seperated into  the 'External' subfolder within the main engine folder, 
**everything inside is not included in the .yymps file**.

**If you intend to update the engine via the .yymps file, you should read the update log to check for any
removed assets that need to be deleted after importing the file.**
If you intend to update the engine via pulling from Github, you should delete the entire 'Coalition Engine'
folder before pulling.

!> By clean installing through Github pulling, references to core objects like `oEnemyParent`, 
overworld collision tiles/objects in rooms, and audio groups may be lost.
You are required to manually set them again after updating it this way.

!> Sometimes it is required to clean install the engine for updating, you should read the update logs carefully
to be notified whether you must clean install or not.

?> If you have little to no GML knowledge, you should look up the Game Maker Manual or at least Google before
asking questions like "How do I make an object" or "I don't know how to use this Game Maker function".<br>
**Questions like that will not be answered.**

## Naming convention

There is a general naming convention in this engine.<br>
Variables that begin with '__' are for internal use and should not be called directly as they are internal variables.<br>
Variables that uses `camelCase` or `PascalCase` are for public use, they can be modified by users as they are
meant for editing to accommodate to individual settings.

Assets in the engine follow a general naming convection of:<br>
Objects: oName<br>
Scripts: __* are internal functions, others generally follow `PascalCase` or `Pascal_Snake_Case`<br>
Shader: shdName<br>
Sprites: sprName<br>
Audio: snd_name<br>