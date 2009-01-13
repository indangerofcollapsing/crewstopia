void giveScaledPartyXP(object oPC, int nPercent);

#include "nw_i0_tool"

// Give (nPercent)% of the XP required for next level to party
void giveScaledPartyXP(object oPC, int nPercent)
{
   // Give (nPercent)% of XP required for next level
   int nLevel = GetHitDice(oPC);
   int nXP = 0;
   int nn;
   for (nn = 1; nn <= nLevel; nn++) nXP += (1000 / nPercent);
   // ...scaled by module XP scale
   nXP = (nXP * GetModuleXPScale()) / 100;

   // Assume no XP leeching (i.e., large difference in party levels)
   RewardPartyXP(nXP, oPC);
}

//void main() {} // Testing/compiling purposes

