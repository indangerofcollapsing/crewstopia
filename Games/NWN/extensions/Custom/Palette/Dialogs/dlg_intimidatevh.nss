// Attempt a very hard difficulty Intimidate
#include "inc_dialog"
#include "inc_skill"
void main()
{
   object oPC = GetPCSpeaker();
   object oNPC = getNPCSpeaker();
   int nDC = skillDCVeryHard(oPC);
   // adjust for size difference
   nDC += GetCreatureSize(oPC) - GetCreatureSize(oNPC);
   attemptSkill(SKILL_INTIMIDATE, nDC);
}
