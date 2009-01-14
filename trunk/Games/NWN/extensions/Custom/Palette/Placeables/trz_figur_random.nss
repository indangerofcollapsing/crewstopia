// On Used event for a case of figurines
#include "nw_o2_coninclude"
#include "inc_faction"
#include "inc_debug_dac"
void main()
{
   //debugVarObject("trz_figur_random", OBJECT_SELF);

   guardMeAgainst(GetLastUsedBy());

   if (GetLocalInt(OBJECT_SELF, "TREASURE_GENERATED")) return;

   int nFigures;
   for (nFigures = Random(10); nFigures > 0; nFigures--)
   {
      int nRandom = Random(100) + GetWillSavingThrow(OBJECT_SELF) + GetHardness();
      string sResRef = "dac_figurine009";
      if (nRandom > 99) sResRef = "dac_figurine008"; // 10,000 GP value
      else if (nRandom > 95) sResRef = "dac_figurine007"; // 5,000
      else if (nRandom > 90) sResRef = "dac_figurine006"; // 1,000
      else if (nRandom > 85) sResRef = "dac_figurine005"; // 500
      else if (nRandom > 75) sResRef = "dac_figurine004"; // 100
      else if (nRandom > 60) sResRef = "dac_figurine003"; // 50
      else if (nRandom > 50) sResRef = "dac_figurine012"; // 30
      else if (nRandom > 40) sResRef = "dac_figurine011"; // 25
      else if (nRandom > 30) sResRef = "dac_figurine002"; // 20
      else if (nRandom > 20) sResRef = "dac_figurine010"; // 15
      else if (nRandom > 10) sResRef = "dac_figurine001"; // 10
      else sResRef = "dac_figurine009"; // 5

      object oItem = CreateItemOnObject(sResRef, OBJECT_SELF);
      SetStolenFlag(oItem, TRUE);
   }
   SetLocalInt(OBJECT_SELF, "TREASURE_GENERATED", TRUE);
}

