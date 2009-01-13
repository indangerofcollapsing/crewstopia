// Attempt an easy difficulty Persuade
#include "inc_dialog"
#include "inc_skill"
void main()
{
   attemptSkill(SKILL_PERSUADE, skillDCEasy(GetPCSpeaker()));
}
