// On Death event for respawnable placeable
//::///////////////////////////////////////////////////
//:: Based on X0_O2_RANGLOW.NSS
//:: OnOpened/OnDeath script for a treasure container.
//:: Treasure type: Any melee weapon
//:: Treasure level: TREASURE_TYPE_LOW
//::
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 11/21/2002
//::///////////////////////////////////////////////////

#include "inc_persistworld"

void main()
{
   CTG_CreateSpecificBaseTypeTreasure(getTreasureValueType(OBJECT_SELF),
      GetLastOpener(), OBJECT_SELF, TREASURE_BASE_TYPE_WEAPON_RANGED);

   respawnPlaceable();
}

