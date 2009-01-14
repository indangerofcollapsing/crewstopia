// On Used event for a museum painting
#include "nw_o2_coninclude"
#include "inc_faction"
#include "inc_persistworld"
#include "inc_debug_dac"
void main()
{
   //debugVarObject("trz_paint_random", OBJECT_SELF);

   guardMeAgainst(GetLastUsedBy());

   string sResRef = GetLocalString(OBJECT_SELF, "CREATE_ITEM");
   if (sResRef == "")
   {
      int nRandom = Random(100) + GetWillSavingThrow(OBJECT_SELF) + GetHardness();
      if (nRandom > 99) sResRef = "dac_painting008"; // 10,000 GP value
      else if (nRandom > 95) sResRef = "dac_painting007"; // 5,000
      else if (nRandom > 90) sResRef = "dac_painting006"; // 1,000
      else if (nRandom > 85) sResRef = "dac_painting005"; // 500
      else if (nRandom > 75) sResRef = "dac_painting004"; // 100
      else if (nRandom > 60) sResRef = "dac_painting003"; // 50
      else if (nRandom > 50) sResRef = "dac_painting012"; // 30
      else if (nRandom > 40) sResRef = "dac_painting011"; // 25
      else if (nRandom > 30) sResRef = "dac_painting002"; // 20
      else if (nRandom > 20) sResRef = "dac_painting010"; // 15
      else if (nRandom > 10) sResRef = "dac_painting001"; // 10
      else sResRef = "dac_painting009"; // 5
   }

   placeableToItem(OBJECT_SELF, sResRef, GetLastUsedBy());
}

