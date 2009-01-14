// On Death event for respawnable placeable
//::///////////////////////////////////////////////////
//:: Based on X0_O2_ANYLOW.NSS
//:: OnOpened/OnDeath script for a treasure container.
//:: Treasure type: Any, random selection from whatever is in base container
//:: Treasure level: TREASURE_TYPE_LOW
//::
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 11/21/2002
//::///////////////////////////////////////////////////

#include "inc_persistworld"

void main()
{
   CTG_CreateTreasure(getTreasureValueType(OBJECT_SELF), GetLastOpener(),
      OBJECT_SELF);

   respawnPlaceable();
}

