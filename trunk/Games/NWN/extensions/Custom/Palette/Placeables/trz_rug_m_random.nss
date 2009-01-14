// On Used event for a medium rug or carpet
#include "nw_o2_coninclude"
#include "inc_faction"
#include "inc_persistworld"
#include "inc_debug_dac"
void main()
{
   //debugVarObject("trz_rug_m_random", OBJECT_SELF);

   guardMeAgainst(GetLastUsedBy());

   string sResRef = GetLocalString(OBJECT_SELF, "CREATE_ITEM");
   if (sResRef == "")
   {
      int nRandom = Random(100) + GetWillSavingThrow(OBJECT_SELF) + GetHardness();
      if (nRandom > 95) sResRef = "dac_carpet011"; // 10,000 GP value
      else if (nRandom > 75) sResRef = "dac_carpet008"; // 1000
      else if (nRandom > 50) sResRef = "dac_carpet005"; // 100
      else sResRef = "dac_carpet002"; // 10
   }

   placeableToItem(OBJECT_SELF, sResRef, GetLastUsedBy());
}

