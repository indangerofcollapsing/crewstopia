// Attempt an easy difficulty Lore
#include "inc_dialog"
#include "inc_skill"
void main()
{
   object oPC = GetPCSpeaker();
   object oNPC = getNPCSpeaker();
   int nDC = skillDCEasy(oPC);
   attemptSkill(SKILL_LORE, nDC);
}
