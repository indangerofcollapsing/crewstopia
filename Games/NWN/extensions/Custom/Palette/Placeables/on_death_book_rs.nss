// On Death event for respawnable placeable
//::///////////////////////////////////////////////////
//:: Based on X0_O2_BOOKLOW.NSS
//:: OnOpened/OnDeath script for a treasure container.
//:: Treasure type: Books or scrolls
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
      GetLastOpener(), OBJECT_SELF, BASE_ITEM_BOOK, BASE_ITEM_SPELLSCROLL);

   respawnPlaceable();
}

