#include "inc_classes"
#include "x0_i0_common"
#include "inc_debug_dac"

int getPartyTotalLevel(object oPC, int bPCOnly = TRUE)
{
   //debugVarObject("getPartyTotalLevel()", OBJECT_SELF);
   int nTotalLevels = 0;
   object oMember = GetFirstFactionMember(oPC, bPCOnly);
   while (oMember != OBJECT_INVALID)
   {
      //debugVarObject("processing", oMember);
      nTotalLevels += getLevel(oMember);
      oMember = GetNextFactionMember(oPC, bPCOnly);
   }
   //debugVarInt("returning", nTotalLevels);
   return nTotalLevels;
}

//void main() {} // testing/compiling purposes
