//::///////////////////////////////////////////////////
//:: Based on X0_O2_POTNLOW.NSS
//:: OnOpened/OnDeath script for a treasure container.
//:: Treasure type: Potions only
//:: Treasure level: TREASURE_TYPE_LOW
//::
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 11/21/2002
//::///////////////////////////////////////////////////

#include "x0_i0_treasure"

void main()
{
   int nRandom = Random(100) + GetWillSavingThrow(OBJECT_SELF) + GetHardness();
   int nTreasureType = TREASURE_TYPE_LOW;
   if (nRandom > 90) nTreasureType = TREASURE_TYPE_UNIQUE;
   else if (nRandom > 75) nTreasureType = TREASURE_TYPE_HIGH;
   else if (nRandom > 50) nTreasureType = TREASURE_TYPE_MED;
   else nTreasureType = TREASURE_TYPE_LOW;

   CTG_CreateSpecificBaseTypeTreasure(nTreasureType, GetLastOpener(),
      OBJECT_SELF, BASE_ITEM_POTIONS, BASE_ITEM_SCROLL, BASE_ITEM_HEALERSKIT);
}

