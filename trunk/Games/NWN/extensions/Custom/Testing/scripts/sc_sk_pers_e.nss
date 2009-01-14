// Easy Persuade attempt
#include "inc_skill"
int StartingConditional()
{
   object oPC = GetPCSpeaker();
   return GetIsSkillSuccessful(oPC, SKILL_PERSUADE, skillDCEasy(oPC));
}
