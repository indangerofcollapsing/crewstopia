// On Used event for a cup or goblet
#include "nw_o2_coninclude"
#include "inc_faction"
#include "inc_persistworld"
#include "inc_debug_dac"
void main()
{
   //debugVarObject("trz_cup_random", OBJECT_SELF);

   guardMeAgainst(GetLastUsedBy());

   int nRandom = Random(100) + GetWillSavingThrow(OBJECT_SELF) + GetHardness();
   string sResRef = "dac_goblet001";
   if (nRandom > 95) sResRef = "dac_goblet006"; // 100
   else if (nRandom > 85) sResRef = "dac_goblet005"; // 50
   else if (nRandom > 75) sResRef = "dac_goblet004"; // 25
   else if (nRandom > 60) sResRef = "dac_goblet003"; // 15
   else if (nRandom > 40) sResRef = "dac_goblet002"; // 10
   else sResRef = "dac_goblet001"; // 5

   placeableToItem(OBJECT_SELF, sResRef, GetLastUsedBy());
}

