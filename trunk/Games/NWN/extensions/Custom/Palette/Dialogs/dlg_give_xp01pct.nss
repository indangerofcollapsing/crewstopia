#include "inc_xp"
void main()
{
   object oPC = GetPCSpeaker();
   if (! GetIsPC(oPC)) return;

   giveScaledPartyXP(oPC, 1);
}
