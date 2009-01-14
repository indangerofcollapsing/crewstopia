// On Death event for respawnable placeable
//::///////////////////////////////////////////////////
//:: Based on X0_O2_GOLDHIGH.NSS
//:: OnOpened/OnDeath script for a treasure container.
//:: Treasure type: Gold only
//:: Treasure level: TREASURE_TYPE_HIGH
//::
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 11/21/2002
//::///////////////////////////////////////////////////

#include "inc_persistworld"

void main()
{
   CTG_CreateGoldTreasure(getTreasureValueType(OBJECT_SELF), GetLastOpener(),
      OBJECT_SELF);

   respawnPlaceable();
}

