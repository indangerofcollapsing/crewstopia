// On Used event for a small tapestry
#include "nw_o2_coninclude"
#include "inc_faction"
#include "inc_persistworld"
#include "inc_classes"
#include "inc_debug_dac"
void main()
{
   //debugVarObject("trz_tap_s_random", OBJECT_SELF);

   object oUser = GetLastUsedBy();
   guardMeAgainst(oUser);

   int nRandom = Random(100) + GetWillSavingThrow(OBJECT_SELF) + GetHardness();
   string sResRef = GetLocalString(OBJECT_SELF, "CREATE_ITEM");

   if (sResRef == "")
   {
      if (nRandom > 99) sResRef = "dac_tapestrys008"; // 10,000 GP value
      else if (nRandom > 95) sResRef = "dac_tapestrys007"; // 5,000
      else if (nRandom > 90) sResRef = "dac_tapestrys006"; // 1,000
      else if (nRandom > 85) sResRef = "dac_tapestrys005"; // 500
      else if (nRandom > 75) sResRef = "dac_tapestrys004"; // 100
      else if (nRandom > 60) sResRef = "dac_tapestrys003"; // 50
      else if (nRandom > 50) sResRef = "dac_tapestrys012"; // 30
      else if (nRandom > 40) sResRef = "dac_tapestrys011"; // 25
      else if (nRandom > 30) sResRef = "dac_tapestrys002"; // 20
      else if (nRandom > 20) sResRef = "dac_tapestrys010"; // 15
      else if (nRandom > 10) sResRef = "dac_tapestrys001"; // 10
      else sResRef = "dac_tapestrys009"; // 5
   }
   //debugVarString("sResRef", sResRef);
   //debugVarObject("last used by", GetLastUsedBy());
   placeableToItem(OBJECT_SELF, sResRef, GetLastUsedBy());
}

