// Attempt a very easy difficulty Track
#include "inc_dialog"
#include "inc_skill"
void main()
{
   // @TODO: incorporate PrC's Ranger-ish prestige classes
   //        Foe Hunter, Vigilant, more?
   attemptSkill(SKILL_SEARCH, skillDCVeryEasy(GetPCSpeaker()) -
      GetLevelByClass(CLASS_TYPE_RANGER, GetPCSpeaker()));
}
