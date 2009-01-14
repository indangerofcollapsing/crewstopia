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

#include "x0_i0_treasure"

void main()
{
   int nRandom = Random(100) + GetWillSavingThrow(OBJECT_SELF) + GetHardness();
   int nTreasureType = TREASURE_TYPE_LOW;
   if (nRandom > 75) nTreasureType = TREASURE_TYPE_HIGH;
   else if (nRandom > 50) nTreasureType = TREASURE_TYPE_MED;
   else nTreasureType = TREASURE_TYPE_LOW;

   CTG_CreateGoldTreasure(nTreasureType, GetLastOpener(), OBJECT_SELF);
}

