Custom Mindblades for the PrC
Douglas Crews (NOMRNHRXSJLG@spammotel.com)

This is an override package for the PrC (http://nwn2prc.com) Soulknife base class for Neverwinter Nights.  I created it for my own amusement, so it's not packaged as yet for public consumption.  Use at your own risk.

===========
Why use it?
===========

If you're bored with the short sword/long sword/bastard sword/dual short sword options for your badass Soulknife, and you want to use a scythe (for example), this lets you do it.  This mod modifies the standard Shape Mindblade feat to one you can use immediately, but the ways you can shape your Mindblade are limited by your Soulknife level and your weapon profiencies:

My thinking is, as a beginning Soulknife, you barely control your supernatural ability, so putting a sharp edge on it is beyond your control.  You can make a club or, if you're trained in martial weapons, a light hammer.  Later you can refine it into better and larger weapons.

Soulknife    Required (1)
  Level     Proficiencies  Mindblade Shape
---------   -------------  ----------------------------
    1       S/D/Mo/R/W     Club
    1       M              Light Hammer
    2       S/D/Mo/R/W     Dagger
    2       S/D/R/W        Dart
    2       E              Shuriken
    3       M/R            Shortsword
    4       S/D/Mo/R/W     Quarterstaff
    4       M              Ranged (the default "throwing axe")
    4       M/R            Dual Shortswords
    5       M/Mo           Handaxe
    5       E/Mo           Kama
    5       D              Sickle
    6       S/R            Light Mace
    7       M              Longsword
    7       S/D            Spear
    7       M              Light Flail
    8       S/R            Morning Star
    8       E              Kukri
    9       M/D            Scimitar
    10      M              Battleaxe
    11      M/R            Rapier
    12      M              Warhammer
    13      M              Bastard Sword
    14      M              Halberd
    15      M              Heavy Flail
    15      E              Katana
    16      M              Greataxe
    17      M              Greatsword
    18      E              Dwarven Waraxe
    19      E              Scythe
    20      E              Dire Mace
    20      E              Double Axe
    20      E              Two-bladed Sword
    21      E              Whip
(CEP Weapons are also available, albeit without some Feats available)
    2       M              Light Pick
    2       E/Mo           Tonfa
    2       S/D/Mo/R/W     Assassin Dagger
    3       E/Mo           Wind Fire Wheel
    3       S/D/Mo/R/W     Katar
    5       M              Chakram
    6       M              Goad
    6       E/Mo           Nunchukau
    7       E/Mo           Sai
    7       M/R            Sap
    8       M              Falchion
    9       M              Trident
    11      S/R            Heavy Mace
    12      M              Heavy Pick
    15      M              Maul
    20      E              Double Scimitar
    21      E              Mercurial Longsword
    21      E              Mercurial Greatsword
    22      E              Weighted Chain (2)
    22      E              Spiked Chain (2)

(1) Any one of the listed proficiences will suffice.
    S=Simple, M=Martial, E=Exotic, R=Rogue, W=Wiz/Sorc, Mo=Monk, D=Druid
(2) CEP calls these something else.

Remember that Soulknives get Simple Weapon Proficiency by default.

So, a level 5 Soulknife (regardless of other classes) trained in Exotic Weapons can manifest the following shapes:  Club, Dagger, Dart, Shuriken, Quarterstaff, Kama, Tonfa, Assassin Dagger, Wind Fire Wheel, or Katar.

Any of the one-handed Mindblade shapes can be wielded as dual wield weapons (as long as the game engine allows it).  If you try to do that with a two-handed weapon, the second weapon will be destroyed and you'll just end up with a single two-handed weapon with a -1 penalty To Hit from what you could have made.

===========
Limitations
===========

Limitation 1:  Override of PrC content (*THIS IS A BIGGIE*)

The implementation for this customization modifies several PrC scripts, so if and when the PrC modifies these files, either this package or the PrC will be broken unless you choose to merge the modifications.  All of my modifications are tagged with a "@DUG" comment, as follows:

someNewMethod(); // @DUG         <-- this is a line I added
// @DUG someOldMethod();         <-- this is a line a removed
/* @DUG                          \
   oldMethod1();                  \
   oldMethod2();                   > <-- this is a block I removed
   oldMethod3();                  /
@DUG */                          /

Also modified is the Soulknife Feat list, cls_feat_soulkn.2da.  This one is fairly easy to merge if the PrC changes it -- just look at cls_feat_soulkn.txt to see the modifications I've made, make them to the new PrC version, and stuff the modified cls_feat_soulkn.2da back into the dac_soulknife.hak file or into {NWN}/override.

The Soulknife codebase has been stable for the last few releases, but that's no guarantee for the future.  Again, use at your own risk.

Limitation 2:  CEP weapons lack the really cool Feats.

Not so much a limitation of my code as much as a limitation of the base engine, but the nifty CEP weapons like nunchuks and mauls and double scimitars (oh, my!) do not have Feats available for Improved Critical, Overwhelming/Devastating Critical, [Epic] Weapon Specialization, [Epic] Weapon Focus, or Weapon of Choice.  This severely limits their usefulness to a combat-centered character.  They still look cool, though.

Limitation 3:  Custom thrown weapons have some debugging issues.

The darts, shurikens, and chakrams have some issues with character behavior after they're thrown.  I seem to recall that they throw the Mindblade, then decide to attack the same target with bare hands.  Not smart.  Anyway, it's not a Soulknife feature I use much, so it's never been really important enought to me to fix.  Your mileage may vary.

Limitation 4:  Epic level Soulknives can use Bastard Swords one-handed.

No real reason for this, except I wanted to.  Normally, you'd have to spend a Feat on Exotic Weapon Proficiency to get this ability, but I think by the time you're 21st level as a Soulknife you should be able to do it.

Limitation 5:  Soulknives can now add Martial and/or Exotic Proficiency.

I don't know why this *isn't* an option for normal Soulknives, but I have added the option to take Martial or Exotic Weapon Proficiency as chosen Feats.

============
Installation
============

1.  Either add the dac_soulknife.hak hakpack to the module's Custom Content list (above the PrC haks), or use {NWN}\utils\nwhak.exe to "Extract All" into your {NWN}\override folder.
2.  Set an Integer variable, "SOULKNIFE_CUSTOM_MINDBLADE_SHAPES", on the module variables list.  Any nonzero number will do.  Without this variable set on the module, the Soulknife will revert to normal PrC behavior.  Adding this to the "module on load" event script will do it:
   SetLocalInt(GetModule(), "SOULKNIFE_CUSTOM_MINDBLADE_SHAPES", TRUE);
3.  Create a new Soulknife character (or at least one that has no Soulknife levels).  Your first-level Soulknife should now have the Shape Mindblade feat.

=====
Usage
=====
Normally, "Shape Mindblade" is a Feat granted at 5th level.  A Soulknife created using this customization is granted that Feat at 1st level, but unless you have Martial Weapon Proficiency, your only choice of shape will be "Club".  At second level and every level up to 21 you will have more choices.
Choosing the "Short Sword", "Long Sword", or "Bastard Sword" sub-Feats will open a dialog listing your one-handed weapon choices.  Choosing the "Dual Short Sword" sub-Feat will list your dual-wield weapon choices.  Note that choosing "Short Sword" is completely equivalent to choosing "Long Sword" or "Bastard Sword" -- they are both just entry points into the dialog where you select the shape you want.  This was done to minimize the impact to the existing PrC feat structure.  The other Mindblade feats are unchanged.
Note that you won't get Longsword until level 7 (and you'll also have to have Martial Proficiency) instead of at level 5, and you'll have to wait for level 13 (and have Martial and/or Exotic Proficiency) to get Bastard Sword.  There's a bit of give and take to your new power.

==============
Uninstallation
==============
Remove dac_soulknife.hak from the module's Custom Content list, or delete the following from {NWN}\override:

dac_*.n?s
inc_debug_dac.nss
dac_sk_focus_cry.*
prc_sk_mblade_*.uti
psi_sk_event.n?s
psi_sk_manifmbld.n?s
psi_sk_manifshld.n?s
psi_sk_onhit.n?s
psi_sk_shmbld.n?s
psi_sk_throwmbld.n?s
cls_feat_soulkn.2da
cls_feat_soulkn.txt

That's it.  Problems?  E-mail me at the address listed above and I'll see what I can do, but I make no promises.  Good luck.
