// On Used event for a large tapestry
#include "nw_o2_coninclude"
#include "inc_faction"
#include "inc_persistworld"
#include "inc_debug_dac"
void main()
{
   //debugVarObject("trz_tap_s_random", OBJECT_SELF);

   guardMeAgainst(GetLastUsedBy());

   int nRandom = Random(100) + GetWillSavingThrow(OBJECT_SELF) + GetHardness();
   string sResRef = GetLocalString(OBJECT_SELF, "CREATE_ITEM");

   if (sResRef == "")
   {
      if (nRandom > 99) sResRef = "dac_tapestrys008"; // 50,000 GP value
      else if (nRandom > 95) sResRef = "dac_tapestrys007"; // 25,000
      else if (nRandom > 90) sResRef = "dac_tapestrys006"; // 5,000
      else if (nRandom > 85) sResRef = "dac_tapestrys005"; // 2500
      else if (nRandom > 75) sResRef = "dac_tapestrys004"; // 500
      else if (nRandom > 60) sResRef = "dac_tapestrys003"; // 250
      else if (nRandom > 50) sResRef = "dac_tapestrys012"; // 150
      else if (nRandom > 40) sResRef = "dac_tapestrys011"; // 125
      else if (nRandom > 30) sResRef = "dac_tapestrys002"; // 100
      else if (nRandom > 20) sResRef = "dac_tapestrys010"; // 75
      else if (nRandom > 10) sResRef = "dac_tapestrys001"; // 50
      else sResRef = "dac_tapestrys009"; // 25
   }
   //debugVarString("sResRef", sResRef);
   //debugVarObject("last used by", GetLastUsedBy());
   placeableToItem(OBJECT_SELF, sResRef, GetLastUsedBy());
}

