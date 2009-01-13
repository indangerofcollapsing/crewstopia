// Attempt a very hard difficulty Lore
#include "inc_dialog"
#include "inc_skill"
void main()
{
   object oPC = GetPCSpeaker();
   object oNPC = getNPCSpeaker();
   int nDC = skillDCVeryHard(oPC);
   attemptSkill(SKILL_LORE, nDC);
}
