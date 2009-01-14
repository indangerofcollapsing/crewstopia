Intro
=====

The Customize Character Hak allows you to customize your character in-game:

Once the files are installed in the NWN override folder you're able to

- modify and dye your armor without being charged or making skill checks,
- modify and dye your helm,
- modify and dye your cloak, make cloaks invisible,
- modify and dye your weapon without being charged or making skill checks,
- modify your shield,
- choose a different portrait for your character,
- choose a different head for your character,
- choose a different phenotype,
- change your character's body (add/remove tattoos, add/remove bone arm, ...)
- add a new tail to your character or remove an existing one,
- add new wings to your character or remove existing ones,
- change your character's colors (skin, hair, tattoos),
- rename items,
- edit item description,
- edit character description,
- apply glowing eyes (or other visual effects).

All these feature should support custom content (new armor parts, robes, heads, custom portraits, ...).

Some of the scripts used in this HAK contain parts taken from Mandragon's Dye Kit (http://nwvault.ign.com/View.php?view=scripts.Detail&id=972) or the CEP crafting scripts.


Installation
============

The installation is very simple. Just copy all files from the included override folder into your NWN override folder. If you have installed an older version you may want to unstall that version first (to clean up the override folder).

If you play the German version you may want to copy the 2da files from '2da\German' into the override folder and replace the English versions of these files.


2DA files
=========

The Custom Character Override HAK contains a few custom 2da files:

mk_init.2da: Initializes the CC, some minor customization can be made here (changed in 4.02).
mk_portrait.2da: Similar to the official Portraits.2da but contains the custom portraits. For more information how to add custom portraits see below (new in 3.7). 
mk_colornames.2da: Contains the color names (new in 3.5).
mk_colorgroups.2da: Contains the color group names (new in 3.5).
mk_bodyparts.2da: Used for changing body parts. Valid body parts are read from this file (0=empty/invisible, 1=skin, 2=tattoo, 255=bone). Not every value is allowed for every body part.
mk_horses.2da: The valid horse numbers (the tails that are actually horses).
mk_ride_pheno.2da: Normal phenotypes - riding phenotype translation.
mk_heads.2da: The valid head numbers (official heads only).
mk_vfx.2da: The glowing eyes vfx numbers.


Usage
=====

To use the customize character hak right click your character and select the craft icon. If everything is installed properly should see the new options (unless you're playing a module which has overwritten the default bioware craft dialog). 

The HAK should be compatible with NWN patch 1.69 and any other module/hak that does not override the NWN craft dialog (x0_skill_ctrap.dlg).


Custom Portraits
================

If you have custom portraits in your NWN\Portraits folder and if want to choose a new portrait from these portraits you have add a new line to the MK_Portraits.2da file for every custom portrait you want to use.

Example: You've downloaded the Phaere's Nightwatch portrait and put it into your Portrait folder. The the portrait folder should contain these files:

po_hu_f_PH_20_H.TGA
po_hu_f_PH_20_L.TGA
po_hu_f_PH_20_N.TGA
po_hu_f_PH_20_S.TGA
po_hu_f_PH_20_T.TGA

The nightwatch is a human female. To use it with the Custom Character HAK you have to add this line to the MK_Portrait.2da file:

1       po_hu_f_PH_20_   1       6

If you've already added other portraits the line number might be different. The MK_Portrait.2da file should look like:


2DA V2.0

        BaseResRef       Sex     Race
0       ****             4       ****
1       po_hu_f_PH_20_   1       6


BaseResRef: 

The portrait filename without the trailing size letter (po_hu_f_PH_20_ instead of po_hu_f_PH_20_H).

Sex: 

The gender the portrait should be used with (0=male, 1=female).

Race: 

The racial type the portrait should be used with (0=dwarf, 1=elf, 2=gnome, 3=halfling, 4=half-elf, 5=half-orc, 6=human). Per default the racial type is ignored (can be changed in MK_Init.2da).


Rename Item / Edit Description
==============================

Both 'rename item' and 'edit description' use the new conversation based in-game text editor (IGTE), also avaliable as a separate download on nwvault. 


Customizing
===========

A lot of features of the CCOH can be customized by editing the 'mk_init.2da' file. Useful for example if you want to use the CCOH in a multiplayer environment and you don't want your players to use all the features.

- you can enable/disable the possibility to modify plot items (EnableModifyPlotItems=1/0).

- you can enable/disable the possibility to modify armors, helmets, cloaks, shields, weapons, portraits, heads, phenotypes, body parts, tails, wings, colors (DisableModifyArmor=0/1, DiableModifyHelmet=0/1, ...).

- you can enable/disable the possibility to save/restore a character appearance (portrait, head, ...)

- you can limit the choices for valid heads, horses, phenotypes, tails and wings (set 2DA_ValidHorses, 2DA_ValidHeads,... to a proper 2DA file. See the included MK_Horses, MK_Heads, MK_Tails, MK_Wings and MK_Phenotypes as examples. In the default setting only MK_Horses is used).


Glowing Eyes and Custom Races
=============================

When you try to add glowing eyes to a character that has a custom race (a race other than the official ones, for example one of the PRC races) it won't work and you will get a message like

   It seems there is no column '56_male' in 'mk_vfx.2da'.

Now all you have to do is

 - edit the mk_vfx.2da file (using one of the 2da editing tools, MS Excel or even notepad). 
   The mk_vfx.2da file is located in the override folder.
 - add a column '56_male' to the mk_vfx.2da file. 
 - find out the proper vfx numbers. If there is an official race of the same size most likely you can just copy the vfx numbers.


Other
=====

The included erf file MK_CRAFT.ERF can be used to import the hak files into the toolset (if you want to make modifications). Also the erf file contains the source code (necessary if you want to make modifications).

New in this version: Supports custom weapon types, choosing a new portrait (both official and custom). 

Works in multiplayer if installed on the server.

Some important informations:

1) NWN 1.68 only: In NWN 1.68 you can't change the cloak model. So changing the cloak model is done by creating a new cloak from resref and copying most properties. Unfortunately a few things (like description, local variables and item tag) are lost. So never change a cloak that is somehow quest relevant.

2) When modifying a shield you will see lots of bag-looking shields. This is because NWN creates a shield even if you use an invalid model number. The created shield will use a default model and a default icon (the default icon for most items is a bag). The original NWN uses model 11-13,21-23,31-33 and 41-43 but custom content haks (like CEP) may add a lot of more models. By editing baseitem.2da and changing the default icon of the three shield types to '****' you can remove the bag-looking shields.


Content
=======

Files in this HAK:

1) Folder 'override':

x0_skill_ctrap.dlg: Overwritten NWN craft dialog,
mk_*.ncs/nss: other script files,
mk_*.2da: 2da files, see paragraph '2da files' for more information.

2) Folder 'erf':

mk_craft.erf: erf file

3) Folder '2da':

Contains different sets of 2da files (other languages for example).


Credit
======

Parts of this hak are taken from Mandragon's Dye Kit, from the CEP and from a script posted by John 'Gestalt' Bye. Information about colored dialog is taken from gaoneng's 'The Hitchhiker's Guide to Color Tokens'.


History
=======

Version 1.00 (29.12.05): First version released.
Version 2.00 (28.07.06): works with custom content now, allows to use the full palette for dyeing armor, allows to change head.
Version 3.00 (31.08.06): Supports cloaks, allows to change phenotype, tail, tattoos, wings.
Version 3.10 (10.09.06): Supports modifying of cloaks, helmets and shields. allows to add/remove the pale master bone arm.
Version 3.50 (01.10.06): A lot of polishing, German translation added, minor bug-fixing, item appearance/colors can be copied from other items, color groups/names are read from 2da files now, dialog uses colors to make navigation easier.
Version 3.60 (04.10.06): Weapons can dyed now, allows to modify left and right arm/leg armor parts simultaneously.
Version 3.70 (07.10.06): Custom weapon types can be modified now, allows to change your character's portrait (both official and custom portraits can be used), some internal modifications and bug fixing.
Version 3.71 (11.10.06): Some bugfixing (helmet crafting/dyeing, reading of custom wingmodel/tailmodel/phenotype 2da files).
Version 3.80 (02.11.06): Removed Toggle tattoos/bone arm and added a more universal Change Body (see description of mk_bodyparts.2da in the 2da section of this readme file).
Version 3.90 (12.11.06): Added save/restore body appearance (allows to save up to 10 different body appearances).
Version 4.00 (12.12.07): Made the CCOH compatible with patch 1.69b1, added riding, modify cloak work-around removed.
Version 4.01 (21.12.07): Made the CCOH compatible with patch 1.69b2, improved riding, added change skin/hair/tattoo color, German dialog added, some bug fixing.
Version 4.02 (27.01.08): Added rename item.
Version 4.03 (19.03.08): Added edit description (items, character), rename item and edit description are using the conversation based in-game text editor (IGTE), many internal changes.
Version 4.04 (03.04.08): Added glowing eyes.
Version 4.10 (11.07.08): Added custom race support for glowing eyes, bug fixes, CCOH rebuild with 1.69 toolset.